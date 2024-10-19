#!/bin/bash

# Выводим заголовок
echo "Последние 10 установленных пакетов:"

# Временный файл для хранения результатов
temp_file=$(mktemp)

# Получаем список всех установленных пакетов с датами установки
dpkg-query -l | grep '^ii' | awk '{print $2, $3}' | while read package version; do
    install_date=$(stat -c %Y /var/lib/dpkg/info/${package}.list 2>/dev/null)
    if [ ! -z "$install_date" ]; then
        echo "$install_date $package (версия $version)"
    fi
done | sort -rn > "$temp_file"

# Добавляем информацию из dpkg.log
grep " install " /var/log/dpkg.log | 
awk '{print $1 " " $2 " " $4 " (версия " $5 ")"}' >> "$temp_file"

# Выводим первые 10 уникальных записей
sort -ru "$temp_file" | head -n 10 | 
while read line; do
    if [[ $line =~ ^[0-9]{10} ]]; then
        # Это timestamp в формате Unix time
        timestamp=${line:0:10}
        package=${line:11}
        install_date=$(date -d @$timestamp '+%Y-%m-%d %H:%M:%S')
    else
        # Это дата в формате из dpkg.log
        install_date=$(echo $line | awk '{print $1, $2}')
        package=$(echo $line | cut -d' ' -f3-)
    fi
    echo "- $package (установлен $install_date)"
done

# Удаляем временный файл
rm "$temp_file"
