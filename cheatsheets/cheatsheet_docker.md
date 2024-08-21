### MySQL 8 docker-compose

#### Вариант 1

```yaml
version: '3.8'
services:
  db:
    image: mysql:8.0
    cap_add:
      - SYS_NICE
    restart: always
    environment:
      - MYSQL_DATABASE=quotes
      - MYSQL_ROOT_PASSWORD=mauFJcuf5dhRMQrjj
    ports:
      - '3306:3306'
    volumes:
      - db:/var/lib/mysql
      - ./db/init.sql:/docker-entrypoint-initdb.d/init.sql
volumes:
  db:
    driver: local
```

#### Вариант 2

```yaml
version: '3'

services:
  # MySQL
  db:
    container_name: mysql8
    image: mysql:8.0
    command: mysqld --default-authentication-plugin=mysql_native_password --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: sandbox
#      MYSQL_USER: sandbox_user
#      MYSQL_PASSWORD: passpass
      MYSQL_ALLOW_EMPTY_PASSWORD: "yes"
    ports:
      - '3306:3306'
    volumes:
      - './docker/db/data:/var/lib/mysql'
      - './docker/db/my.cnf:/etc/mysql/conf.d/my.cnf'
      - './docker/db/sql:/docker-entrypoint-initdb.d'
```

### Приведи пример docker-compose файла для PHP с nginx, mysql

```yaml
version: '3'

services:
  php:
    image: php:8.1-fpm
    volumes:
      - ./:/var/www/html
    depends_on:
      - db

  nginx:
    image: nginx:latest
    ports:
      - 80:80
    volumes:
      - ./:/var/www/html
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - php

  db:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: mydb
      MYSQL_USER: myuser
      MYSQL_PASSWORD: mypassword
      MYSQL_ROOT_PASSWORD: myrootpassword
    volumes:
      - ./db-data:/var/lib/mysql

volumes:
  db-data:
```

### Как в docker узнать в из какой папки запущен контейнер docker-compose?

Чтобы узнать, из какой папки был запущен контейнер с помощью `docker-compose`, вы можете использовать следующие шаги:

1. Запустите команду `docker ps`, чтобы получить список запущенных контейнеров и их идентификаторы (CONTAINER ID):

```bash
docker ps
```

2. Найдите в списке нужный контейнер и скопируйте его идентификатор (CONTAINER ID).

3. Выполните команду `docker inspect` с идентификатором контейнера и используйте `grep` для поиска переменной окружения `PWD`:

```bash
docker inspect <CONTAINER ID> | grep PWD
```

Вывод будет содержать переменную окружения `PWD`, которая указывает на папку, из которой был запущен `docker-compose`:

```
"PWD=/path/to/directory"
```

Здесь `/path/to/directory` - это путь к папке, из которой был запущен `docker-compose`.

Альтернативно, если вы используете `docker-compose` версии 1.28.0 или выше, вы можете выполнить следующую команду:

```bash
docker inspect -f '{{ .Config.Labels }}' <CONTAINER ID>
```

Эта команда выведет метки (labels) контейнера, среди которых будет метка `com.docker.compose.project.working_dir`, указывающая на папку, из которой был запущен `docker-compose`.

Пример вывода:

```
map[com.docker.compose.project.working_dir:/path/to/directory ...]
```

Таким образом, вы можете легко определить, из какой папки был запущен контейнер с помощью `docker-compose`.
