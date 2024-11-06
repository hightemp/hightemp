#!/bin/bash

# Проверка наличия аргумента
if [ $# -ne 2 ]; then
    echo "Usage: $0 <domain> <expected_txt_value>"
    echo "Example: $0 _acme-challenge.example.com AbCdEf123456"
    exit 1
fi

DOMAIN="$1"
EXPECTED_VALUE="$2"

# Функция для проверки TXT записи
check_txt_record() {
    # Используем dig для получения TXT записи
    TXT_VALUE=$(dig +short -t TXT "$DOMAIN" | tr -d '"')

    echo "Checking TXT record for: $DOMAIN"
    echo "Expected value: $EXPECTED_VALUE"
    echo "Found value: $TXT_VALUE"

    # Проверка существования записи
    if [ -z "$TXT_VALUE" ]; then
        echo "❌ TXT record not found!"
        return 1
    fi

    # Проверка соответствия значения
    if [ "$TXT_VALUE" == "$EXPECTED_VALUE" ]; then
        echo "✅ TXT record matches expected value!"
        return 0
    else
        echo "❌ TXT record does not match expected value!"
        return 1
    fi
}

# Основной цикл проверки
MAX_ATTEMPTS=12
ATTEMPT=1
WAIT_TIME=10

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    echo "Attempt $ATTEMPT of $MAX_ATTEMPTS"

    if check_txt_record; then
        exit 0
    fi

    if [ $ATTEMPT -lt $MAX_ATTEMPTS ]; then
        echo "Waiting ${WAIT_TIME} seconds before next attempt..."
        sleep $WAIT_TIME
    fi

    ATTEMPT=$((ATTEMPT + 1))
done

echo "Maximum attempts reached. DNS TXT record verification failed!"
exit 1
