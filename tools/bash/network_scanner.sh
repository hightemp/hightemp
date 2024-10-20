#!/bin/bash

# Функция для получения списка сетевых интерфейсов
get_interfaces() {
    ip link show | grep -E '^[0-9]+:' | cut -d: -f2 | tr -d ' ' | grep -v '^lo$'
}

# Функция для получения подсети для интерфейса
get_subnet() {
    local interface=$1
    ip -4 addr show $interface | grep inet | awk '{print $2}' | cut -d/ -f1 | awk -F. '{print $1"."$2"."$3"."}'
}

# Функция для сканирования конкретного интерфейса
scan_interface() {
    local interface=$1
    local subnet=$(get_subnet $interface)
    
    if [ -z "$subnet" ]; then
        echo "Не удалось получить подсеть для интерфейса $interface"
        return 1
    fi

    echo "Сканирование сети для интерфейса $interface (подсеть: ${subnet}0/24)"
    echo "-------------------------"

    for i in {1..254}; do
        ip="${subnet}${i}"
        # Отправляем ping и проверяем hostname параллельно
        (ping -c 1 -W 1 $ip >/dev/null 2>&1 && {
            hostname=$(host $ip 2>/dev/null | awk '{print $NF}' | sed 's/\.$//')
            if [ $? -ne 0 ] || [ -z "$hostname" ]; then
                hostname="[не определено]"
            fi
            echo "IP: $ip - Hostname: $hostname"
        }) &
    done
    wait
    echo "-------------------------"
}

# Основная логика
main() {
    if [ "$#" -eq 1 ]; then
        # Если указан конкретный интерфейс
        if ip link show "$1" >/dev/null 2>&1; then
            scan_interface "$1"
        else
            echo "Ошибка: Интерфейс $1 не найден"
            exit 1
        fi
    else
        # Сканируем все интерфейсы
        echo "Сканирование всех сетевых интерфейсов..."
        for interface in $(get_interfaces); do
            scan_interface "$interface"
        done
    fi
}

main "$@"