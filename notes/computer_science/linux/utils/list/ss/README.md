# ss

## Описание

Утилита `ss` (сокращение от "socket statistics") в Linux - это мощный инструмент командной строки для исследования сетевых сокетов. Она предоставляет подробную информацию о сетевых соединениях и их состоянии, заменяя устаревшую команду `netstat`. `ss` позволяет пользователям просматривать активные соединения, прослушиваемые порты, статистику по протоколам и многое другое. Эта утилита особенно полезна для системных администраторов и сетевых инженеров при диагностике сетевых проблем, мониторинге сетевой активности и анализе производительности сети.

## Репозитории

- https://github.com/iproute2/iproute2/blob/main/misc/ss.c

## Примеры

1. Отображение всех TCP сокетов:
    ```
    ss -t
    ```

2. Показать все прослушиваемые и не прослушиваемые сокеты:
    ```
    ss -a
    ```

3. Отобразить статистику сокетов:
    ```
    ss -s
    ```

4. Фильтрация сокетов по порту:
    ```
    ss -tnlp '( dport = :80 or sport = :80 )'
    ```

## Документация

- https://man7.org/linux/man-pages/man8/ss.8.html