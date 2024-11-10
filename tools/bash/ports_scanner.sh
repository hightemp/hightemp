#!/bin/bash

# Проверка наличия параметра домена
if [ -z "$1" ]; then
    echo "Использование: $0 <домен>"
    exit 1
fi

DOMAIN=$1
IP=$(dig +short $DOMAIN)

# Проверка что IP получен
if [ -z "$IP" ]; then
    echo "Не удалось получить IP для домена $DOMAIN"
    exit 1
fi

# Функция для конвертации hex в decimal
hex2dec() {
    printf "%d\n" "0x$1"
}

echo "Сканирование портов для $DOMAIN ($IP)"
echo "----------------------------------------"

# Функция проверки открытых портов через /proc/net/tcp
scan_proc_ports() {
    # Массив для хранения найденных портов
    declare -A found_ports

    # Читаем /proc/net/tcp и /proc/net/tcp6
    for proto in tcp tcp6; do
        while read -r line; do
            # Пропускаем заголовок
            [[ $line =~ ^[[:space:]]*sl ]] && continue
            
            # Получаем локальный и удаленный адреса
            local_addr=$(echo $line | awk '{print $2}')
            remote_addr=$(echo $line | awk '{print $3}')
            
            # Получаем порт (последние 4 символа в hex)
            port_hex=$(echo $local_addr | cut -d':' -f2)
            port=$(hex2dec $port_hex)
            
            # Сохраняем порт в массив
            found_ports[$port]=1
            
        done < /proc/net/$proto
    done

    # Выводим найденные порты
    for port in "${!found_ports[@]}"; do
        echo "Порт $port открыт (найден в /proc)"
    done
}

# Функция сканирования диапазона портов через /dev/tcp
scan_range_ports() {
    local start_port=$1
    local end_port=$2
    local timeout=1

    for port in $(seq $start_port $end_port); do
        # Прогресс
        if [ $((port % 1000)) -eq 0 ]; then
            echo -ne "Сканирование порта $port из $end_port\r"
        fi

        # Пытаемся установить соединение
        (timeout $timeout bash -c "echo >/dev/tcp/$IP/$port") >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "Порт $port открыт (прямое подключение)"
        fi
    done
}

echo "Начинаем полное сканирование портов..."
echo "Это может занять некоторое время..."

# Проверяем является ли пользователь root
if [ "$(id -u)" -eq 0 ]; then
    echo -e "\nСканирование через /proc/net/tcp:"
    scan_proc_ports
else
    echo -e "\nПредупреждение: Сканирование через /proc/net/tcp доступно только для root пользователя"
    echo "Продолжаем сканирование только методом прямого подключения..."
fi

# Сканируем все возможные порты
echo -e "\nПрямое сканирование портов:"
scan_range_ports 1 65535

echo -e "\nСканирование завершено"

exit 0
