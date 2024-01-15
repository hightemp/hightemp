## Изменить размер свопа `swap`

```bash
sudo swapoff -a
sudo dd if=/dev/zero of=/swapfile bs=1G count=8
sudo mkswap /swapfile
sudo swapon /swapfile
grep SwapTotal /proc/meminfo
```

## Как настроить приоритеты процессов

Значения Nice могут варьироваться от -19 /-20 (наивысший приоритет) до 19/20 (низший приоритет) в зависимости от системы.

Чтобы запустить программу с определенным значением nice, вы можете использовать команду nice:

```
nice -n 15 command_to_execute
```

Это работает только при запуске новой программы.

Чтобы изменить значение nice в программе, которая уже выполняется, вы используете инструмент под названием renice:

```
renice 0 PID_to_prioritize
```

## Примеры использования `kill`

Если программа ведет себя неправильно и не завершает работу при указании термина signal, вы можете усилить сигнал, передав KILL signal:

```
kill -KILL PID_of_target_process
```

Например, многие процессы, предназначенные для постоянной работы в фоновом режиме (иногда называемые “демонами”), автоматически перезапускаются при получении сигнала HUP или зависания. Веб-сервер Apache обычно работает таким образом.

```
sudo kill -HUP pid_of_apache
```

Вы можете перечислить все сигналы , которые можно отправлять с помощью kill флага -l:

```
kill -l
```

```console
apanov@apanov-Legion-S7-16IAH7:~/Downloads$ kill -l
 1) SIGHUP       2) SIGINT       3) SIGQUIT      4) SIGILL       5) SIGTRAP
 6) SIGABRT      7) SIGBUS       8) SIGFPE       9) SIGKILL     10) SIGUSR1
11) SIGSEGV     12) SIGUSR2     13) SIGPIPE     14) SIGALRM     15) SIGTERM
16) SIGSTKFLT   17) SIGCHLD     18) SIGCONT     19) SIGSTOP     20) SIGTSTP
21) SIGTTIN     22) SIGTTOU     23) SIGURG      24) SIGXCPU     25) SIGXFSZ
26) SIGVTALRM   27) SIGPROF     28) SIGWINCH    29) SIGIO       30) SIGPWR
31) SIGSYS      34) SIGRTMIN    35) SIGRTMIN+1  36) SIGRTMIN+2  37) SIGRTMIN+3
38) SIGRTMIN+4  39) SIGRTMIN+5  40) SIGRTMIN+6  41) SIGRTMIN+7  42) SIGRTMIN+8
43) SIGRTMIN+9  44) SIGRTMIN+10 45) SIGRTMIN+11 46) SIGRTMIN+12 47) SIGRTMIN+13
48) SIGRTMIN+14 49) SIGRTMIN+15 50) SIGRTMAX-14 51) SIGRTMAX-13 52) SIGRTMAX-12
53) SIGRTMAX-11 54) SIGRTMAX-10 55) SIGRTMAX-9  56) SIGRTMAX-8  57) SIGRTMAX-7
58) SIGRTMAX-6  59) SIGRTMAX-5  60) SIGRTMAX-4  61) SIGRTMAX-3  62) SIGRTMAX-2
63) SIGRTMAX-1  64) SIGRTMAX
```

Команда pkill работает почти точно так же, как kill, но вместо этого она оперирует именем процесса:

```
pkill -9 ping
```

Приведенная выше команда эквивалентна:

```
kill -9 `pgrep ping` 
```

Если вы хотите отправить сигнал каждому экземпляру определенного процесса, вы можете использовать команду killall:

```
killall firefox
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


