#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Проверяем, запущен ли скрипт от root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Этот скрипт должен быть запущен от root${NC}" 
   exit 1
fi

# Функция для проверки статуса Tor
check_tor_status() {
    if curl --socks5 127.0.0.1:9050 -s https://check.torproject.org > /dev/null; then
        echo -e "${GREEN}Tor работает корректно!${NC}"
        echo -e "Ваш IP адрес через Tor:"
        curl --socks5 127.0.0.1:9050 -s https://check.torproject.org/api/ip
        return 0
    else
        echo -e "${RED}Tor не работает или есть проблемы с подключением${NC}"
        return 1
    fi
}

# Функция для настройки мостов
# Для обновления списка мостов или получения новых приватных мостов можно использовать:
#    Email: bridges@torproject.org
#    Посетить https://bridges.torproject.org/
#    Использовать Telegram бот: @GetBridgesBot
configure_bridges() {
    echo -e "${YELLOW}Выберите тип моста:${NC}"
    echo "1) obfs4"
    echo "2) snowflake"
    echo "3) meek-azure"
    read -p "Введите номер (1-3): " bridge_choice

    # Создаем резервную копию конфигурационного файла
    cp /etc/tor/torrc /etc/tor/torrc.backup

    case $bridge_choice in
        1)
            # Настройка obfs4
            echo "UseBridges 1" >> /etc/tor/torrc
            echo "ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy" >> /etc/tor/torrc
            # Добавляем несколько публичных мостов obfs4
            echo "Bridge obfs4 192.95.36.142:443 CDF2E852BF539B82BD10E27E9115A31734E378C2 cert=qUVQ0srL1JI/vO6V6m/24anYXiJD3QP2HgzUKQtQ7GRqqUvs7P+tG43RtAqdhLOALP7DJQ iat-mode=1" >> /etc/tor/torrc
            echo "Bridge obfs4 38.229.1.78:80 C8CBDB2464FC9804A69531437BCF2BE31FDD2EE4 cert=Hmyfd2ev46gGY7NoVxA9ngrPF2zCZtzskRTzoWXbxNkzeVnGFPWmrTtILRyqCTjHR+s9dg iat-mode=1" >> /etc/tor/torrc
            ;;
        2)
            # Настройка snowflake
            echo "UseBridges 1" >> /etc/tor/torrc
            echo "ClientTransportPlugin snowflake exec /usr/bin/snowflake-client" >> /etc/tor/torrc
            echo "Bridge snowflake 192.0.2.3:1 2B280B23E1107BB62ABFC40DDCC8824814F80A72" >> /etc/tor/torrc
            ;;
        3)
            # Настройка meek-azure
            echo "UseBridges 1" >> /etc/tor/torrc
            echo "ClientTransportPlugin meek_lite exec /usr/bin/meek-client" >> /etc/tor/torrc
            echo "Bridge meek_lite 192.0.2.2:2 97700DFE9F483596DDA6264C4D7DF7641E1E39CE" >> /etc/tor/torrc
            ;;
        *)
            echo -e "${RED}Неверный выбор${NC}"
            return 1
            ;;
    esac

    # Установка необходимых пакетов для мостов
    apt-get install -y obfs4proxy

    # Перезапуск службы Tor
    systemctl restart tor
    echo -e "${GREEN}Мосты настроены. Перезапуск Tor...${NC}"
    sleep 5
}

# Основная установка
echo "Обновление списков пакетов..."
apt-get update

# Добавляем официальный репозиторий Tor
echo "Добавление официального репозитория Tor..."
echo "deb [arch=amd64] https://deb.torproject.org/torproject.org $(lsb_release -cs) main" > /etc/apt/sources.list.d/tor.list
echo "deb-src [arch=amd64] https://deb.torproject.org/torproject.org $(lsb_release -cs) main" >> /etc/apt/sources.list.d/tor.list

# Добавляем GPG ключ
echo "Добавление GPG ключа..."
wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee /usr/share/keyrings/tor-archive-keyring.gpg > /dev/null

# Обновляем списки пакетов
echo "Обновление списков пакетов..."
apt-get update

# Устанавливаем Tor и сопутствующие пакеты
echo "Установка Tor и сопутствующих пакетов..."
apt-get install -y tor tor-geoipdb

# Запускаем службу Tor
echo "Запуск службы Tor..."
systemctl start tor
systemctl enable tor

# Проверяем статус
echo "Проверка статуса Tor..."
systemctl status tor

# Ждем 30 секунд, чтобы Tor успел установить соединение
echo "Ожидание установки соединения..."
sleep 30

# Проверяем работу Tor
if ! check_tor_status; then
    echo -e "${YELLOW}Обнаружены проблемы с подключением к Tor. Хотите настроить мосты? (y/n)${NC}"
    read -r setup_bridges
    if [[ $setup_bridges == "y" ]]; then
        configure_bridges
        # Повторная проверка после настройки мостов
        sleep 30
        check_tor_status
    fi
fi

echo -e "${GREEN}Установка завершена!${NC}"
echo "Tor прослушивает SOCKS на 127.0.0.1:9050"
echo -e "${YELLOW}Для просмотра логов используйте: sudo journalctl -u tor@default.service${NC}"
