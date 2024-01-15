## Изменить размер свопа `swap`

```bash
sudo swapoff -a
sudo dd if=/dev/zero of=/swapfile bs=1G count=8
sudo mkswap /swapfile
sudo swapon /swapfile
grep SwapTotal /proc/meminfo
```

## Примеры использования `ps`

### Просмотр всех запущенных процессов в различных форматах

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -A
    PID TTY          TIME CMD
      1 ?        00:01:25 systemd
      2 ?        00:00:02 kthreadd
      3 ?        00:00:00 rcu_gp
```

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -e | tail
 854266 ?        00:00:00 kworker/u40:2-events_unbound
 854320 ?        00:00:04 yandex_browser
 854444 ?        00:00:00 kworker/0:2
```

### Просмотр процессов, связанных с терминалом

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -T
    PID    SPID TTY          TIME CMD
 804620  804620 pts/8    00:00:00 bash
 854641  854641 pts/8    00:00:00 ps
```

### Просмотр процессов, не связанных с терминалом

```console
panov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -a
    PID TTY          TIME CMD
   2299 tty2     1-06:42:55 Xorg
   2465 tty2     00:00:00 gnome-session-b
   9583 pts/3    00:00:00 ssh
```

### Показать все текущие запущенные процессы

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -ax
    PID TTY      STAT   TIME COMMAND
      1 ?        Ss     1:25 /lib/systemd/systemd --system --deserialize 49 splash
      2 ?        S      0:02 [kthreadd]
      3 ?        I<     0:00 [rcu_gp]
```

### Отображать все процессы в формате BSD

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0 167364 11040 ?        Ss    2023   1:25 /lib/systemd/systemd --system --deserialize 49 splash
root           2  0.0  0.0      0     0 ?        S     2023   0:02 [kthreadd]
root           3  0.0  0.0      0     0 ?        I<    2023   0:00 [rcu_gp]
root           4  0.0  0.0      0     0 ?        I<    2023   0:00 [rcu_par_gp]
root           5  0.0  0.0      0     0 ?        I<    2023   0:00 [slub_flushwq]
root           6  0.0  0.0      0     0 ?        I<    2023   0:00 [netns]
```

### Для выполнения полноформатного листинга

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -eF
UID          PID    PPID  C    SZ   RSS PSR STIME TTY          TIME CMD
root           1       0  0 41841 11040  10  2023 ?        00:01:25 /lib/systemd/systemd --system --deserialize 49 splash
root           2       0  0     0     0   8  2023 ?        00:00:02 [kthreadd]
root           3       2  0     0     0   0  2023 ?        00:00:00 [rcu_gp]
```

### Фильтруйте процессы в соответствии с пользователем

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -u apanov
    PID TTY          TIME CMD
   2117 ?        00:00:08 systemd
   2118 ?        00:00:00 (sd-pam)
   2124 ?        00:00:00 pipewire
   2125 ?        00:00:02 pipewire-media-
```

### Фильтровать процесс по потоку

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -L 2117
    PID     LWP TTY      STAT   TIME COMMAND
   2117    2117 ?        Ss     0:08 /lib/systemd/systemd --user
```

### Показать каждый процесс, запущенный от имени root

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -U root -u root
    PID TTY          TIME CMD
      1 ?        00:01:25 systemd
      2 ?        00:00:02 kthreadd
```

### Групповые процессы отображения

Если вы хотите составить список всех процессов, связанных с определенной группой, запустите
`ps -fG group_name` Или `ps -fG groupID` Например `ps -fG root`

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -fG root
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0  2023 ?        00:01:25 /lib/systemd/systemd --system --deserialize 49 splash
root           2       0  0  2023 ?        00:00:02 [kthreadd]
root           3       2  0  2023 ?        00:00:00 [rcu_gp]
```

### PID процесса поиска

Скорее всего, вы обычно не знаете PID процесса. Вы можете выполнить поиск PID процесса, выполнив
`ps -C process_name` Например `ps -C bash`

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -C bash
    PID TTY          TIME CMD
   9200 pts/0    00:00:00 bash
   9384 pts/3    00:00:00 bash
```

### Список процессов по PID

Вы можете отображать процессы по их PID, как показано на рисунке
`ps -fp PID` Например `ps -fp 1294`

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -fp 9200
UID          PID    PPID  C STIME TTY          TIME CMD
apanov      9200    2913  0  2023 pts/0    00:00:00 /bin/bash
```

### Для отображения иерархии процессов в виде древовидной диаграммы

Обычно большинство процессов разветвляются на родительские процессы. Знакомство с этой родительско-дочерней связью может оказаться полезным. Приведенная ниже команда выполняет поиск процессов с именем apache2 `ps -f --forest -C bash`

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -f --forest -C bash
UID          PID    PPID  C STIME TTY          TIME CMD
apanov    800047  799773  0 янв11 pts/2 00:00:00 /bin/bash --rcfile /snap/phpstorm/368/plugins/terminal/shell-integrations/bash/bash-integration.bash -i
root      762660  762659  0 янв10 pts/1 00:00:00 -bash
apanov    804620    2913  0 янв11 pts/8 00:00:00 /bin/bash
apanov    445828    2913  0  2023 pts/22   00:00:00 /bin/bash
apanov    445059    2913  0  2023 pts/21   00:00:00 /bin/bash
```

### Отображение дочерних процессов родительского процесса

Например, если вы хотите отобразить все разветвленные процессы, принадлежащие apache, выполните
`ps -o pid,uname,comm -C bash`

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -o pid,uname,comm -C bash
    PID USER     COMMAND
   9200 apanov   bash
   9384 apanov   bash
   9585 apanov   bash
```

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps --ppid 9200
    PID TTY          TIME CMD
  26799 pts/0    1-09:04:02 htop
```

### Отображение потоков процесса

Команда ps может использоваться для просмотра потоков вместе с процессами. Приведенная ниже команда отображает все потоки, принадлежащие процессу, с идентификатором pid_no
`ps -p pid_no -L` Например `ps -p 1294 -L`

### Отображение выбранного списка столбцов

Вы можете использовать команду ps для отображения только необходимых вам столбцов. Например ,
`ps -e -o pid,uname,pcpu,pmem,comm`

### Переименование меток столбцов

Чтобы переименовать метки столбцов, выполните приведенную ниже команду
`ps -e -o pid=PID,uname=USERNAME,pcpu=CPU_USAGE,pmem=%MEM,comm=COMMAND`

### Отображение прошедшего времени процессов

Прошедшее время указывает на то, как долго выполнялся процесс
`ps -e -o pid,comm,etime`

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ ps -e -o pid,comm,etime
    PID COMMAND             ELAPSED
      1 systemd         56-02:04:02
      2 kthreadd        56-02:04:02
      3 rcu_gp          56-02:04:02
```

### Использование команды ps с grep

команда ps может использоваться вместе с командой grep для поиска определенного процесса, например
`ps -ef  | grep systemd`


