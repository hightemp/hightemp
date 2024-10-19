#!/bin/bash

# ./install_deb.sh https://example.com/path/to/package.deb

# Проверяем, передан ли URL в качестве аргумента
if [ $# -eq 0 ]; then
    echo "Пожалуйста, укажите URL для .deb пакета"
    exit 1
fi

# URL пакета
URL=$1

# Имя файла из URL
FILENAME=$(basename "$URL")

# Скачиваем пакет
echo "Скачивание $FILENAME..."
wget "$URL"

# Проверяем успешность скачивания
if [ $? -ne 0 ]; then
    echo "Ошибка при скачивании пакета"
    exit 1
fi

# Устанавливаем пакет
echo "Установка $FILENAME..."
sudo dpkg -i "$FILENAME"

# Если есть неудовлетворенные зависимости, пытаемся их разрешить
if [ $? -ne 0 ]; then
    echo "Попытка разрешить зависимости..."
    sudo apt-get install -f -y
    
    # Повторная попытка установки пакета
    sudo dpkg -i "$FILENAME"
    
    if [ $? -ne 0 ]; then
        echo "Ошибка при установке пакета"
        exit 1
    fi
fi

# Удаляем скачанный файл
echo "Удаление $FILENAME..."
rm "$FILENAME"

echo "Пакет успешно установлен"
