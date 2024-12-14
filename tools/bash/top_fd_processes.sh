#!/bin/bash  

# Проверка доступа к /proc  
if [ ! -d /proc ]; then  
    echo "Директория /proc недоступна."  
    exit 1  
fi  

# Массив для хранения данных о процессах  
processes=()  
total_fd=0  

# Итерация по всем PID в /proc  
for pid_dir in /proc/[0-9]*; do  
    pid=$(basename "$pid_dir")  

    # Получаем имя процесса из /proc/<pid>/comm  
    if [[ -r "$pid_dir/comm" ]]; then  
        process_name=$(cat "$pid_dir/comm")  
    else  
        process_name="Unknown"  
    fi  

    # Считаем количество открытых файловых дескрипторов  
    if [[ -d "$pid_dir/fd" ]]; then  
        fd_count=$(ls -1 "$pid_dir/fd" 2>/dev/null | wc -l)  
        processes+=("$fd_count $pid $process_name")  
        total_fd=$((total_fd + fd_count))  
    fi  
done  

# Сортируем процессы по количеству FD в порядке убывания и берем топ-10  
sorted=$(printf "%s\n" "${processes[@]}" | sort -nr | head -n 10)  

# Выводим заголовок таблицы  
printf "%-10s %-10s %-s\n" "PID" "FD_COUNT" "Process_Name"  
printf "%-10s %-10s %-s\n" "----------" "----------" "-------------------------"  

# Выводим отсортированные данные с форматированием  
while read -r fd pid name; do  
    printf "%-10s %-10s %-s\n" "$pid" "$fd" "$name"  
done <<< "$sorted"  

echo ""  
echo "----------------------------------------"  
echo "Общее количество открытых FD: $total_fd"  

# Получаем максимально допустимое количество файловых дескрипторов в системе  
if [[ -r /proc/sys/fs/file-max ]]; then  
    file_max=$(cat /proc/sys/fs/file-max)  
    echo "Максимально допустимое количество FD (fs.file-max): $file_max"  
else  
    echo "Не удалось получить fs.file-max."  
fi  

# Получаем лимит для текущей сессии  
session_limit=$(ulimit -n)  
echo "Лимит на FD для текущей сессии (ulimit -n): $session_limit"  

# Получаем системный лимит с помощью sysctl  
if command -v sysctl &> /dev/null; then  
    sysctl_limit=$(sysctl -n fs.file-max)  
    echo "Максимально допустимое количество FD (sysctl fs.file-max): $sysctl_limit"  
else  
    echo "Команда sysctl недоступна."  
fi