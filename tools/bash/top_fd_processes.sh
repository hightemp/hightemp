#!/bin/bash  

# Проверяем, есть ли доступ к /proc  
if [ ! -d /proc ]; then  
    echo "Директория /proc недоступна."  
    exit 1  
fi  

# Используем ассоциативный массив для хранения информации о процессах  
declare -A process_fd_count  

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
        # Сохраняем информацию в массиве  
        process_fd_count["$pid:$process_name"]=$fd_count  
    fi  
done  

# Выводим топ-10 процессов с наибольшим количеством FD  
echo -e "PID\tFD_COUNT\tProcess_Name"  
for entry in "${!process_fd_count[@]}"; do  
    echo -e "${entry//:/\t}${process_fd_count[$entry]}"  
done | sort -k2 -nr | head -n 10