#!/bin/bash

# Проверяем, запущен ли скрипт с правами root
if [[ $EUID -ne 0 ]]; then
  echo "Этот скрипт необходимо запускать с правами root"
  exit 1
fi

# Функция для вывода красивой таблицы
print_table_header() {
  printf "+---------------+--------+----------------------+\n"
  printf "| Файл. деск-ры | PID    | Процесс              |\n"
  printf "+---------------+--------+----------------------+\n"
}

print_table_footer() {
  printf "+---------------+--------+----------------------+\n"
}

print_table_row() {
  printf "| %-13s | %-6s | %-20s |\n" "$1" "$2" "$3"
}

# Функция для получения списка процессов с открытыми файловыми дескрипторами
get_top_processes() {
  # Подавляем предупреждения и фильтруем только числовые PID
  lsof -n -P 2>/dev/null | grep -E '^[^ ]+\s+[0-9]+' | awk '{print $2}' | sort | uniq -c | sort -nr | head -n 10
}

# Основной вывод
echo "Топ-10 процессов с наибольшим количеством открытых файловых дескрипторов:"
print_table_header

get_top_processes | while read count pid; do
  # Более надежное получение имени процесса
  process_name=$(ps -o comm= -p "$pid" 2>/dev/null | head -n 1 || echo "Unknown")
  # Обрезаем имя процесса до 20 символов
  process_name=$(echo "$process_name" | cut -c1-20)
  print_table_row "$count" "$pid" "$process_name"
done

print_table_footer