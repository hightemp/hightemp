### Создание резервной копии PostgreSQL в Docker

Существует несколько способов создания резервной копии базы данных PostgreSQL, запущенной в Docker-контейнере:

#### 1. Использование pg_dump внутри контейнера

Самый простой метод - использовать встроенную утилиту `pg_dump`:

```bash
# Создание бэкапа
docker exec -t postgres_container pg_dump -U postgres -d database_name > backup.sql

# Для сжатого бэкапа
docker exec -t postgres_container pg_dump -U postgres -d database_name | gzip > backup.sql.gz
```

#### 2. Бэкап с использованием внешней утилиты pg_dump

```bash
# Создание бэкапа из хост-машины
docker exec -t postgres_container pg_dump -U postgres -d database_name -F c -f /tmp/backup.dump
docker cp postgres_container:/tmp/backup.dump ./backup.dump
```

#### 3. Бэкап всех баз данных

```bash
docker exec -t postgres_container pg_dumpall -U postgres > full_backup.sql
```

#### 4. Резервное копирование Docker-тома

Если у вас настроен внешний том для данных PostgreSQL:

```bash
# Остановить контейнер для консистентного бэкапа
docker stop postgres_container

# Создать архив тома
tar -czvf postgres_data_backup.tar.gz /path/to/postgres/volume

# Запустить контейнер снова
docker start postgres_container
```

#### 5. Автоматизация бэкапов

Пример скрипта для автоматического бэкапа:

```bash
#!/bin/bash
BACKUP_DIR="/path/to/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CONTAINER="postgres_container"
DB_USER="postgres"
DB_NAME="database_name"

# Создаем директорию если не существует
mkdir -p $BACKUP_DIR

# Выполняем бэкап
docker exec -t $CONTAINER pg_dump -U $DB_USER -d $DB_NAME | gzip > $BACKUP_DIR/backup_$TIMESTAMP.sql.gz

# Удаляем старые бэкапы (оставляем только за последние 7 дней)
find $BACKUP_DIR -name "backup_*.sql.gz" -type f -mtime +7 -delete
```

#### 6. Восстановление из бэкапа

```bash
# Восстановление из SQL файла
cat backup.sql | docker exec -i postgres_container psql -U postgres -d database_name

# Восстановление из сжатого файла
gunzip -c backup.sql.gz | docker exec -i postgres_container psql -U postgres -d database_name
```
