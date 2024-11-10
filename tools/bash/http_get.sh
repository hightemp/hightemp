#!/bin/bash

# Проверяем, передан ли URL
if [ $# -eq 0 ]; then
    echo "Usage: $0 <url>"
    echo "Example: $0 https://google.com/search"
    exit 1
fi

# Получаем URL из аргумента
URL="$1"

# Парсим URL
if [[ "$URL" =~ ^https?://([^/:]+)(:([0-9]+))?(/.*)$ ]]; then
    HOST="${BASH_REMATCH[1]}"
    PORT="${BASH_REMATCH[3]}"
    PATH_QUERY="${BASH_REMATCH[4]}"
    
    # Если порт не указан, используем стандартный порт в зависимости от протокола
    if [[ -z "$PORT" ]]; then
        if [[ "$URL" =~ ^https:// ]]; then
            PORT=443
        else
            PORT=80
        fi
    fi
else
    echo "Invalid URL format"
    exit 1
fi

# Проверяем, является ли протокол HTTPS
if [[ "$URL" =~ ^https:// ]]; then
    echo "Error: HTTPS protocol is not supported in this simple script"
    echo "Please use HTTP only"
    exit 1
fi

echo "Connecting to $HOST:$PORT$PATH_QUERY"

# Создаем TCP соединение
exec 3<>/dev/tcp/$HOST/$PORT

# Формируем HTTP GET запрос
echo -e "GET $PATH_QUERY HTTP/1.1\r\nHost: $HOST\r\nConnection: close\r\n\r\n" >&3

# Читаем ответ
while read line <&3; do
    echo "$line"
done

# Закрываем соединение
exec 3>&-
