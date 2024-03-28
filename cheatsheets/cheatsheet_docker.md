
### Приведи пример docker-compose файла для PHP

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
