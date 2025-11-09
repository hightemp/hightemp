#!/bin/bash

# Скрипт для увеличения лимитов файлов и inotify watches в Ubuntu
# Устраняет ошибку "too many open files" при работе с npm watch и другими file watchers

set -e

echo "=== Увеличение системных лимитов для Ubuntu ==="
echo ""

# Проверка прав root
if [[ $EUID -ne 0 ]]; then
   echo "Этот скрипт должен быть запущен с правами root (sudo)"
   exit 1
fi

# Цветной вывод
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Текущие лимиты:${NC}"
echo "  ulimit -n: $(sudo -u $SUDO_USER bash -c 'ulimit -n')"
echo "  inotify.max_user_watches: $(cat /proc/sys/fs/inotify/max_user_watches)"
echo "  inotify.max_user_instances: $(cat /proc/sys/fs/inotify/max_user_instances)"
echo "  file-max: $(cat /proc/sys/fs/file-max)"
echo ""

# Применяем изменения немедленно
echo -e "${YELLOW}Применение изменений...${NC}"
sysctl -w fs.inotify.max_user_watches=524288 >/dev/null 2>&1
sysctl -w fs.inotify.max_user_instances=512 >/dev/null 2>&1
sysctl -w fs.file-max=2097152 >/dev/null 2>&1

echo -e "${GREEN}✓${NC} Временные изменения применены"

# Функция для добавления строки в файл, если её там нет
add_if_not_exists() {
    local line="$1"
    local file="$2"
    
    if ! grep -qF "$line" "$file" 2>/dev/null; then
        echo "$line" >> "$file"
        echo -e "${GREEN}✓${NC} Добавлено в $file: $line"
    else
        echo -e "  Уже существует в $file: $line"
    fi
}

# Сохраняем в /etc/sysctl.conf
echo ""
echo -e "${YELLOW}Сохранение в /etc/sysctl.conf...${NC}"
add_if_not_exists "fs.inotify.max_user_watches=524288" "/etc/sysctl.conf"
add_if_not_exists "fs.inotify.max_user_instances=512" "/etc/sysctl.conf"
add_if_not_exists "fs.file-max=2097152" "/etc/sysctl.conf"

# Сохраняем в /etc/security/limits.conf
echo ""
echo -e "${YELLOW}Сохранение в /etc/security/limits.conf...${NC}"
add_if_not_exists "* soft nofile 524288" "/etc/security/limits.conf"
add_if_not_exists "* hard nofile 524288" "/etc/security/limits.conf"

# Проверка systemd
if systemctl --version >/dev/null 2>&1; then
    echo ""
    echo -e "${YELLOW}Настройка systemd лимитов...${NC}"
    
    # Для system.conf
    if [ -f /etc/systemd/system.conf ]; then
        if ! grep -qE "^DefaultLimitNOFILE=" /etc/systemd/system.conf; then
            echo "DefaultLimitNOFILE=524288" >> /etc/systemd/system.conf
            echo -e "${GREEN}✓${NC} Добавлено в /etc/systemd/system.conf"
        else
            # Обновляем существующее значение
            sed -i 's/^DefaultLimitNOFILE=.*/DefaultLimitNOFILE=524288/' /etc/systemd/system.conf
            echo -e "${GREEN}✓${NC} Обновлено в /etc/systemd/system.conf"
        fi
    fi
    
    # Для user.conf
    if [ -f /etc/systemd/user.conf ]; then
        if ! grep -qE "^DefaultLimitNOFILE=" /etc/systemd/user.conf; then
            echo "DefaultLimitNOFILE=524288" >> /etc/systemd/user.conf
            echo -e "${GREEN}✓${NC} Добавлено в /etc/systemd/user.conf"
        else
            # Обновляем существующее значение
            sed -i 's/^DefaultLimitNOFILE=.*/DefaultLimitNOFILE=524288/' /etc/systemd/user.conf
            echo -e "${GREEN}✓${NC} Обновлено в /etc/systemd/user.conf"
        fi
    fi
    
    systemctl daemon-reexec
    echo -e "${GREEN}✓${NC} systemd перезагружен"
fi

echo ""
echo -e "${GREEN}=== Новые лимиты: ===${NC}"
echo "  inotify.max_user_watches: $(cat /proc/sys/fs/inotify/max_user_watches)"
echo "  inotify.max_user_instances: $(cat /proc/sys/fs/inotify/max_user_instances)"
echo "  file-max: $(cat /proc/sys/fs/file-max)"
echo ""
echo -e "${GREEN}✓ Готово!${NC}"
echo ""
echo "Изменения применены немедленно и будут действовать после перезагрузки."
echo "Для полного применения user limits перезайдите в систему или откройте новый терминал."
