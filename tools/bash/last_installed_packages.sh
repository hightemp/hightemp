#!/bin/bash

# Выводим заголовок
echo "Последние 10 установленных пакетов:"

# Используем команду grep для поиска строк с "install" в логах dpkg
# Затем обрабатываем вывод с помощью awk, извлекая имя пакета и дату установки
# Сортируем по дате в обратном порядке и выводим только первые 10 строк
grep " install " /var/log/dpkg.log | 
awk '{print $4, $1, $2}' | 
sort -r | 
head -n 10 |
while read package date time; do
    echo "- $package (установлен $date в $time)"
done
