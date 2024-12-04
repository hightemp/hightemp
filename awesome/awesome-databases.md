### Коллекцмм

- https://github.com/dbos-inc/awesome-dbos
- https://dhamaniasad.github.io/awesome-postgres/

### Сайты для упражнений

- https://sqltest.online/

### Репозитории

- https://github.com/nuno-faria/tetris-sql
- Это стартовое приложение на базе Next.js, использующее OpenAI API и векторную базу данных Supabase для создания специализированного чат-бота, который, в отличие от обычного ChatGPT, работает с конкретной предметной областью и предоставляет достоверные ответы на основе заданных документов. https://github.com/gannonh/chatgpt-pgvector

### Операционные системы

- DBOS - это серверлесс-платформа, которая радикально упрощает разработку бэкенда, позволяя создавать приложения в 10 раз быстрее и масштабировать их до миллионов пользователей одним кликом. https://www.dbos.dev/  https://github.com/dbos-inc/

### Полезные ссылки

- Are You Qualified To Use Null in SQL? (Тест) https://agentm.github.io/project-m36/posts/2024-07-16-are-you-qualified-to-use-null.html

### Мониторинг

- PostgreSQL
    - Это форк замороженного проекта lesovsky/pgscv Алексея Лесовского, ныне сотрудника Postgres Professional. pgSCV это агент-собиратель метрик pgSCV, совместим с Prometheus и Grafana, умеет экспортировать метрики в системное окружение PostgreSQL. Есть доки на русском. https://github.com/CHERTS/pgscv/releases/tag/v0.9.5

### Гайды

- MySQL 8.0. Полное руководство https://www.rldp.ru/mysql/mysql80/

### Книги

- https://postgrespro.ru/education/books
- PostgreSQL изнутри. Егор Рогов https://edu.postgrespro.ru/postgresql_internals-15.pdf

### Статьи

- Основное
    - SQL databases https://www.karanpratapsingh.com/courses/system-design/sql-databases
    - NoSQL databases https://www.karanpratapsingh.com/courses/system-design/nosql-databases
    - SQL vs NoSQL databases https://www.karanpratapsingh.com/courses/system-design/sql-vs-nosql-databases
    - SQL vs NoSQL: Which Database to Choose in System Design? https://www.geeksforgeeks.org/which-database-to-choose-while-designing-a-system-sql-or-nosql/
- PostgreSQL
    - Основное
        - Изучаем PostgreSQL. Часть 1. Знакомимся с архитектурой https://habr.com/ru/companies/otus/articles/706346/
        - How to list tables in PostgreSQL https://www.illacloud.com/blog/list-tables-in-postgresql
    - WAL
        - Внутренности PostgreSQL: журнал предзаписи (WAL) https://eax.me/postgresql-wal/
        - Write Ahead Logging (WAL) https://www.interdb.jp/pg/pgsql09.html
    - pgvector
        - Оптимизируй свой AI: разоблачение 6 мифов о работе с векторами в Pgvector https://proglib.io/p/optimiziruy-svoy-ai-razoblachenie-6-mifov-o-rabote-s-vektorami-v-pgvector-2024-10-22
        - Практический пример использования pgvector https://eax.me/pgvector/
        - Использование pgvector для поиска сходств в корпоративных данных https://hackernoon.com/lang/ru/использование-pgvector-для-обнаружения-сходств-в-корпоративных-данных
        - Создание эффективного поиска на основе ИИ в Greenplum с помощью pgvector и OpenAI https://datafinder.ru/products/sozdanie-effektivnogo-poiska-na-osnove-ii-v-greenplum-s-pomoshchyu-pgvector-i-openai
        - Unleashing the power of vector embeddings with PostgreSQL https://tembo.io/blog/pgvector-and-embedding-solutions-with-postgres
        - Vector Similarity Search with PostgreSQL’s pgvector – A Deep Dive https://severalnines.com/blog/vector-similarity-search-with-postgresqls-pgvector-a-deep-dive/
    - Нейросети
        - Нейронные оптимизаторы запросов в реляционных БД (Часть 3): Погружение в ранжирование https://habr.com/ru/companies/postgrespro/articles/857998/
    - Репликация
        - Логическая репликация, logical replication
            - PostgreSQL Logical Replication: Easy steps to set up https://hevodata.com/learn/postgresql-logical-replication/
            - Subscription Chapter 29. Logical Replication https://www.postgresql.org/docs/current/logical-replication-subscription.html
            - Replication Between PostgreSQL Versions Using Logical Replication https://www.percona.com/blog/replication-between-postgresql-versions-using-logical-replication/
            - Practical PostgreSQL Logical Replication: Setting Up an Experimentation Environment Using Docker https://dev.to/ietxaniz/practical-postgresql-logical-replication-setting-up-an-experimentation-environment-using-docker-4h50
            - Postgres 17 highlight: Logical replication slots synchronization https://bdrouvot.github.io/2024/03/16/postgres-17-highlight-logical-replication-slots-synchronization/
            - Пример использования логической репликации PostgreSQL https://eax.me/postgresql-logical-replication/
            - Logical Replication: PubSub in PostgreSQL https://medium.com/hacktive-devs/logical-replication-pubsub-in-postgresql-bec70b286f3b
            - Setup Logical Replication using pglogical in PostgreSQL https://dbsguru.com/setup-logical-replication-using-pglogical-in-postgresql/
        - Потоковая репликация, WAL
            - Настройка потоковой репликации PostgreSQL https://www.dmosk.ru/miniinstruktions.php?mini=postgresql-replication&ysclid=m48bnxegz2534231408
            - Потоковая репликация в PostgreSQL – короткое введение https://prudnitskiy.pro/post/2018-01-05-pgsql-replica/
            - Потоковая репликация PostgreSQL https://kuzevanov.ru/linux/потоковая-репликация-postgresql.html
            - Потоковая репликация в PostgreSQL https://itproffi.ru/potokovaya-replikatsiya-v-postgresql/
            - Потоковая репликация в PostgreSQL и пример фейловера https://eax.me/postgresql-replication/
        - Остальное
            - Как настроить репликацию в PostgreSQL https://selectel.ru/blog/tutorials/how-to-set-up-replication-in-postgresql/
            - Репликации в PostgreSQL https://habr.com/ru/companies/otus/articles/710956/
            - PostgreSQL Multi-Active Replication - Part 1: An Introduction https://dimitrij-pankratz.medium.com/postgresql-multi-active-replication-part-1-an-introduction-ff7052eb9fd0
            - PostgreSQL Multi-Active Replication - Part 2: Native Replication in PostgreSQL 15 and 16 https://medium.com/@olira/postgresql-multi-active-replication-part-2-native-replication-in-postgresql-15-and-16-42cc3496c46b
            - Установка postgres-9.6. Настройка репликации master-slave https://sidmid.ru/установка-postgres-9-6-настройка-репликации-master-slave/?ysclid=m48bs2crdz754774365
            - Репликация в PostgreSQL при помощи repmgr https://wtfm.info/репликация-в-postgresql-при-помощи-repmgr/
            - How to Setup PostgreSQL Replication https://www.opensourcelisting.com/how-to-setup-postgresql-replication/
    - Кэш
        - SLRU (Simple Least Recently Used) - это специальный механизм кеширования в PostgreSQL, который хранит в памяти важную служебную информацию (например, состояние транзакций), используя алгоритм вытеснения наименее недавно использованных данных при заполнении кеша
            - Scalability Limits From SLRU & Lock Manager | Scaling Postgres 306 https://scaling-postgres-1.castos.com/episodes/scalability-limits-from-slru-lock-manager-scaling-postgres-306
        - Остальное
            - An Overview of Caching for PostgreSQL https://severalnines.com/blog/overview-caching-postgresql/
            - Database Scaling: PostgreSQL Caching Explained https://www.timescale.com/blog/database-scaling-postgresql-caching-explained/            
    - Остальное
        - PostgreSQL 17: Часть 5 или Коммитфест 2024-03 https://habr.com/ru/companies/postgrespro/articles/841408/
        - Неожиданная находка, которая освобождает 20 GB неиспользованного индексного пространства https://habr.com/ru/companies/otus/articles/672102/
        - PostgreSQL-триггеры: создание, удаление, примеры https://timeweb.cloud/tutorials/postgresql/postgresql-triggery-sozdanie-udalenie-primery
        - Установка и настройка PostgreSQL в Docker https://timeweb.cloud/tutorials/postgresql/postgresql-docker-setup
        - How to Get or Create in PostgreSQL And why it is so easy to get wrong... https://hakibenita.com/postgresql-get-or-create
        - How Postgres stores data on disk – this one's a page turner https://drew.silcock.dev/blog/how-postgres-stores-data-on-disk/
        - Postgres as a search engine https://anyblockers.com/posts/postgres-as-a-search-engine
        - PostgreSQL Logs Explained: Logging Configuration Tutorial https://sematext.com/blog/postgresql-logs/
        - Как включить журналы базы данных https://habr.com/ru/companies/otus/articles/691502/
        - Состояние PostgreSQL 2022: 13 инструментов, отличных от psql https://habr.com/ru/companies/otus/articles/690266/
        - Резервное копирование и восстановление СУБД PostgreSQL https://habr.com/ru/companies/otus/articles/710094/
- MySQL
    - Оптимизация
        - Optimizing your MySQL queries https://mauricio.github.io/2022/02/16/optimizing-your-mysql-queries.html
    - Индексы
        - Кластерные и «обычные» индексы MySQL (InnoDB) https://habr.com/ru/articles/141767/
        - Кластерные и некластерные индексы реляционных баз данных https://wp-yoda.com/bazy-dannyh/klasternye-i-neklasternye-indeksy/
    - Партицинирование
        - Партиционирование таблиц в MySql https://easy-code.ru/lesson/partitioning-mysql
    - Репликация
        - Как устроена MySQL-репликация https://highload.guide/blog/mysql_replication_2015.html
- Остальное
    - Управление качеством данных на основе алгоритмов нечеткого поиска https://blog.arbinada.com/ru/category/00020.html
    - 5 сайтов для оттачивания навыков написания SQL-запросов https://proglib.io/p/sql-practice-sites
    - Масштабирование базы данных через шардирование и партиционирование https://habr.com/ru/companies/oleg-bunin/articles/309330/

### Блоги

- MySQL
    - https://www.percona.com/blog/category/mysql/
- PostgreSQL
    - https://habr.com/ru/companies/postgrespro/articles/
    - https://devmark.ru/articles/tag/postgresql

### Видео

- 10 - Recovery Protocols (CMU Databases / Spring 2020) https://www.youtube.com/watch?v=r0qZKOVByi4