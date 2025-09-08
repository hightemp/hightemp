#!/bin/bash

# Скрипт для копирования всех коммитов из одной ветки в другую

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Функция для вывода справки
show_help() {
    echo "Использование: $0 <source-branch> <target-branch> [--force] [--base-branch=main]"
    echo ""
    echo "Опции:"
    echo "  --force              Принудительно перезаписать целевую ветку"
    echo "  --base-branch=BRANCH Базовая ветка для ответвления (по умолчанию: main)"
    echo "  --help               Показать эту справку"
    echo ""
    echo "Примеры:"
    echo "  $0 dev dev-2"
    echo "  $0 feature/old feature/new --force"
    echo "  $0 dev dev-2 --base-branch=develop"
}

# Проверка аргументов
if [ $# -lt 2 ] || [ "$1" = "--help" ]; then
    show_help
    exit 1
fi

SOURCE_BRANCH="$1"
TARGET_BRANCH="$2"
FORCE_FLAG=""
BASE_BRANCH="main"

# Обработка дополнительных аргументов
shift 2
while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE_FLAG="--force"
            shift
            ;;
        --base-branch=*)
            BASE_BRANCH="${1#*=}"
            shift
            ;;
        *)
            echo -e "${RED}Неизвестный аргумент: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

echo -e "${YELLOW}Копирование коммитов из ветки '${SOURCE_BRANCH}' в '${TARGET_BRANCH}'${NC}"
echo -e "${YELLOW}Базовая ветка: '${BASE_BRANCH}'${NC}"

# Проверка существования базовой ветки
if ! git show-ref --verify --quiet "refs/heads/${BASE_BRANCH}"; then
    echo -e "${RED}Ошибка: Базовая ветка '${BASE_BRANCH}' не существует${NC}"
    exit 1
fi

# Проверка существования исходной ветки
if ! git show-ref --verify --quiet "refs/heads/${SOURCE_BRANCH}"; then
    echo -e "${RED}Ошибка: Ветка '${SOURCE_BRANCH}' не существует${NC}"
    exit 1
fi

# Сохранение текущей ветки
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Функция очистки при выходе
cleanup() {
    echo -e "${YELLOW}Возвращаемся к ветке '${CURRENT_BRANCH}'${NC}"
    git checkout "${CURRENT_BRANCH}" 2>/dev/null || true
}
trap cleanup EXIT

# Получение списка коммитов из исходной ветки
echo -e "${YELLOW}Получение списка коммитов...${NC}"
COMMITS=$(git log --reverse --pretty=format:"%H" "${SOURCE_BRANCH}")

if [ -z "$COMMITS" ]; then
    echo -e "${RED}В ветке '${SOURCE_BRANCH}' нет коммитов${NC}"
    exit 1
fi

COMMIT_COUNT=$(echo "$COMMITS" | wc -l)
echo -e "${GREEN}Найдено ${COMMIT_COUNT} коммитов для копирования${NC}"

# Создание или переключение на целевую ветку
if git show-ref --verify --quiet "refs/heads/${TARGET_BRANCH}"; then
    if [ -z "$FORCE_FLAG" ]; then
        echo -e "${RED}Ветка '${TARGET_BRANCH}' уже существует. Используйте --force для перезаписи${NC}"
        exit 1
    else
        echo -e "${YELLOW}Удаление существующей ветки '${TARGET_BRANCH}'${NC}"
        git branch -D "${TARGET_BRANCH}"
    fi
fi

# Создание новой ветки от базовой ветки
echo -e "${YELLOW}Создание новой ветки '${TARGET_BRANCH}' от '${BASE_BRANCH}'${NC}"
git checkout "${BASE_BRANCH}"
git checkout -b "${TARGET_BRANCH}"

# Применение коммитов по одному
echo -e "${YELLOW}Применение коммитов...${NC}"
COUNTER=1
APPLIED_COUNT=0

for commit in $COMMITS; do
    echo -e "${YELLOW}[${COUNTER}/${COMMIT_COUNT}] Применение коммита ${commit}${NC}"

    # Получение информации о коммите
    COMMIT_MESSAGE=$(git log -1 --pretty=format:"%s" "${commit}")
    COMMIT_AUTHOR=$(git log -1 --pretty=format:"%an <%ae>" "${commit}")
    COMMIT_DATE=$(git log -1 --pretty=format:"%ad" "${commit}")

    echo "  Сообщение: ${COMMIT_MESSAGE}"
    echo "  Автор: ${COMMIT_AUTHOR}"
    echo "  Дата: ${COMMIT_DATE}"

    # Попытка применить коммит через cherry-pick
    if git cherry-pick --no-commit "${commit}" 2>/dev/null; then
        # Cherry-pick прошел успешно
        echo -e "${GREEN}  ✓ Cherry-pick успешен${NC}"
    else
        # Cherry-pick не удался, применяем изменения вручную
        echo -e "${YELLOW}  ! Cherry-pick не удался, применяем изменения вручную${NC}"
        git reset --hard HEAD 2>/dev/null || true

        # Применение изменений из коммита
        git checkout "${commit}" -- . 2>/dev/null || {
            echo -e "${RED}  ✗ Не удалось применить коммит ${commit}${NC}"
            COUNTER=$((COUNTER + 1))
            continue
        }
    fi

    # Проверяем есть ли изменения для коммита
    if git diff --cached --quiet && git diff --quiet; then
        echo -e "${YELLOW}  - Нет изменений для коммита, пропускаем${NC}"
    else
        # Добавляем все изменения
        git add -A

        # Создание коммита с сохранением метаданных
        GIT_AUTHOR_NAME=$(git log -1 --pretty=format:"%an" "${commit}") \
        GIT_AUTHOR_EMAIL=$(git log -1 --pretty=format:"%ae" "${commit}") \
        GIT_AUTHOR_DATE=$(git log -1 --pretty=format:"%ad" "${commit}") \
        git commit -m "${COMMIT_MESSAGE}" 2>/dev/null && {
            echo -e "${GREEN}  ✓ Коммит создан${NC}"
            APPLIED_COUNT=$((APPLIED_COUNT + 1))
        } || {
            echo -e "${RED}  ✗ Не удалось создать коммит${NC}"
        }
    fi

    COUNTER=$((COUNTER + 1))
done

echo -e "\n${GREEN}✓ Обработано ${COMMIT_COUNT} коммитов${NC}"
echo -e "${GREEN}✓ Успешно применено ${APPLIED_COUNT} коммитов в ветку '${TARGET_BRANCH}'${NC}"
echo -e "${GREEN}✓ Ветка '${TARGET_BRANCH}' создана от '${BASE_BRANCH}'${NC}"
echo -e "${GREEN}✓ Текущая ветка: $(git rev-parse --abbrev-ref HEAD)${NC}"

# Показать краткую статистику
echo -e "\n${YELLOW}Статистика новой ветки:${NC}"
TOTAL_COMMITS=$(git rev-list --count HEAD)
if [ "$TOTAL_COMMITS" -gt 0 ]; then
    git log --oneline | head -10
    if [ "$TOTAL_COMMITS" -gt 10 ]; then
        echo "... и ещё $(( TOTAL_COMMITS - 10 )) коммитов"
    fi
    echo -e "${GREEN}Всего коммитов в ветке: ${TOTAL_COMMITS}${NC}"
else
    echo -e "${YELLOW}Ветка пуста (содержит только коммиты из ${BASE_BRANCH})${NC}"
fi

# Показать разность с базовой веткой
BASE_COMMITS=$(git rev-list --count "${BASE_BRANCH}")
NEW_COMMITS=$((TOTAL_COMMITS - BASE_COMMITS))
if [ "$NEW_COMMITS" -gt 0 ]; then
    echo -e "${GREEN}Новых коммитов относительно ${BASE_BRANCH}: ${NEW_COMMITS}${NC}"
fi