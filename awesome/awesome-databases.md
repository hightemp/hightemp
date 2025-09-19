### Коллекцмм

- https://github.com/dbos-inc/awesome-dbos
- https://dhamaniasad.github.io/awesome-postgres/

### Сайты для упражнений

- https://sqltest.online/

### Репозитории

- https://github.com/nuno-faria/tetris-sql
- Это стартовое приложение на базе Next.js, использующее OpenAI API и векторную базу данных Supabase для создания специализированного чат-бота, который, в отличие от обычного ChatGPT, работает с конкретной предметной областью и предоставляет достоверные ответы на основе заданных документов. https://github.com/gannonh/chatgpt-pgvector
- pgsearch
    - Docker image with pg_search extension https://github.com/stephane-klein/pg_search_docker

### Операционные системы

- DBOS - это серверлесс-платформа, которая радикально упрощает разработку бэкенда, позволяя создавать приложения в 10 раз быстрее и масштабировать их до миллионов пользователей одним кликом. https://www.dbos.dev/  https://github.com/dbos-inc/

### Полезные ссылки

- Are You Qualified To Use Null in SQL? (Тест) https://agentm.github.io/project-m36/posts/2024-07-16-are-you-qualified-to-use-null.html
- ресурс, посвященный индексированию SQL для разработчиков. Он объясняет основы индексирования и не ограничивается рассмотрением ORM-инструментов, таких как Hibernate. Сайт предоставляет информацию об индексировании в различных СУБД, таких как MySQL, Oracle, SQL Server и другие. Он также содержит множество статей и глав, посвященных различным аспектам индексирования, таким как структура индекса, использование индексов для улучшения производительности поиска, работа с различными операторами и функциями, а также влияние индексирования на операции вставки, удаления и обновления данных. Сайт является бесплатной веб-версией книги "SQL Performance Explained". https://use-the-index-luke.com/
- Визуализатор плана запросов для PostgreSQL https://explain.tensor.ru/plan/

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
    - Индексы
        - PostgreSQL Deep Dive Part 12 — Advanced Indexing Strategies and Optimization https://abheist.com/blogs/postgres-indexing-advanced
    - subtransactions; Подтранзакции
        - Why we spent the last month eliminating PostgreSQL subtransactions https://about.gitlab.com/blog/2021/09/29/why-we-spent-the-last-month-eliminating-postgresql-subtransactions/
    - PgBouncer
        - Управление пулом подключений https://docs.arenadata.io/ru/ADPG/current/concept/architecture/pgbouncer.html
        - PgBouncer https://evtuhovich.ru/blog/2012/02/12/pgbouncer/
    - WAL
        - Внутренности PostgreSQL: журнал предзаписи (WAL) https://eax.me/postgresql-wal/
        - Write Ahead Logging (WAL) https://www.interdb.jp/pg/pgsql09.html
    - EXPLAIN
        - Оптимизация запросов. Основы EXPLAIN в PostgreSQL https://habr.com/ru/articles/203320/
        - Оптимизация запросов. Основы EXPLAIN в PostgreSQL (часть 2) https://habr.com/ru/articles/203386/
        - Оптимизация запросов. Основы EXPLAIN в PostgreSQL (часть 3) https://habr.com/ru/articles/203484/
        - POSTGRES EXPLAIN https://habr.com/ru/companies/spectr/articles/869472/
        - Анализ запросов https://docs.arenadata.io/ru/ADPG/current/how-to/queries/analize-queries.html
        - Understanding EXPLAIN https://public.dalibo.com/exports/conferences/_archives/_2012/201211_explain/understanding_explain.pdf
    - pgvector
        - Оптимизируй свой AI: разоблачение 6 мифов о работе с векторами в Pgvector https://proglib.io/p/optimiziruy-svoy-ai-razoblachenie-6-mifov-o-rabote-s-vektorami-v-pgvector-2024-10-22
        - Практический пример использования pgvector https://eax.me/pgvector/
        - Использование pgvector для поиска сходств в корпоративных данных https://hackernoon.com/lang/ru/использование-pgvector-для-обнаружения-сходств-в-корпоративных-данных
        - Создание эффективного поиска на основе ИИ в Greenplum с помощью pgvector и OpenAI https://datafinder.ru/products/sozdanie-effektivnogo-poiska-na-osnove-ii-v-greenplum-s-pomoshchyu-pgvector-i-openai
        - Unleashing the power of vector embeddings with PostgreSQL https://tembo.io/blog/pgvector-and-embedding-solutions-with-postgres
        - Vector Similarity Search with PostgreSQL’s pgvector – A Deep Dive https://severalnines.com/blog/vector-similarity-search-with-postgresqls-pgvector-a-deep-dive/
    - BM25
        - VectorChord-BM25: Revolutionize PostgreSQL Search with BM25 Ranking — 3x Faster Than ElasticSearch https://blog.vectorchord.ai/vectorchord-bm25-revolutionize-postgresql-search-with-bm25-ranking-3x-faster-than-elasticsearch
    - Нейросети
        - Нейронные оптимизаторы запросов в реляционных БД (Часть 3): Погружение в ранжирование https://habr.com/ru/companies/postgrespro/articles/857998/
    - Kubernetes
        - Mastering high availability: PostgreSQL meets Kubernetes(En) https://weng-albert.medium.com/mastering-high-availability-postgresql-meets-kubernetes-929846f6cc88
    - Репликация
        - Основное
        - Слоты репликации
            - Question: What are PostgreSQL replication slots and how do they work? https://www.dragonflydb.io/faq/postgresql-replication-slots
            - About replication slot https://docs.byteplus.com/en/docs/RDS_for_PG/about_replication_slot
        - Физическая репликация
            - Физическая репликация в PostgreSQL https://www.dbserv.ru/blog/fizicheskaya-replikaciya-v-postgresql
            - Как настроить физическую потоковую репликацию с PostgreSQL на Ubuntu https://timeweb.cloud/tutorials/postgresql/kak-nastroit-fizicheskuyu-potokovuyu-replikatsiyu-s-postgresql-12-na-ubuntu-2004
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
            - How to use streaming replication with PostgreSQL https://tech.codeyellow.nl/blog/pg-replication/
            - Настройка потоковой репликации PostgreSQL https://www.dmosk.ru/miniinstruktions.php?mini=postgresql-replication&ysclid=m48bnxegz2534231408
            - Потоковая репликация в PostgreSQL – короткое введение https://prudnitskiy.pro/post/2018-01-05-pgsql-replica/
            - Потоковая репликация PostgreSQL https://kuzevanov.ru/linux/потоковая-репликация-postgresql.html
            - Потоковая репликация в PostgreSQL https://itproffi.ru/potokovaya-replikatsiya-v-postgresql/
            - Потоковая репликация в PostgreSQL и пример фейловера https://eax.me/postgresql-replication/
            - Setting Up PostgreSQL Replication with Docker https://dev.to/wallacefreitas/setting-up-postgresql-replication-with-docker-26fi
        - Разрешение конфликтов
            - How to handle logical replication conflicts in PostgreSQL https://www.postgresql.fastware.com/blog/how-to-handle-logical-replication-conflicts-in-postgresql
        - Проблемы
            - Возможные причины разрастания pg_wal в PostgreSQL. https://edu.fors.ru/ugolok-professora/vozmozhnye-prichiny-razrastaniya-pg-wal-v-postgresql/
        - Остальное
            - Failover Replication Slots with Postgres 17 https://www.decodable.co/blog/failover-replication-slots-with-postgres-17
            - Как настроить репликацию в PostgreSQL https://selectel.ru/blog/tutorials/how-to-set-up-replication-in-postgresql/
            - Репликации в PostgreSQL https://habr.com/ru/companies/otus/articles/710956/
            - PostgreSQL Multi-Active Replication - Part 1: An Introduction https://dimitrij-pankratz.medium.com/postgresql-multi-active-replication-part-1-an-introduction-ff7052eb9fd0
            - PostgreSQL Multi-Active Replication - Part 2: Native Replication in PostgreSQL 15 and 16 https://medium.com/@olira/postgresql-multi-active-replication-part-2-native-replication-in-postgresql-15-and-16-42cc3496c46b
            - Установка postgres-9.6. Настройка репликации master-slave https://sidmid.ru/установка-postgres-9-6-настройка-репликации-master-slave/?ysclid=m48bs2crdz754774365
            - Репликация в PostgreSQL при помощи repmgr https://wtfm.info/репликация-в-postgresql-при-помощи-repmgr/
            - How to Setup PostgreSQL Replication https://www.opensourcelisting.com/how-to-setup-postgresql-replication/
            - How to Set Up Multi-Master PostgreSQL Replication on Ubuntu 22.04 https://www.howtoforge.com/how-to-set-up-multi-master-postgresql-replication-on-ubuntu-22-04/
            - Setting Up PostgreSQL Replication: A Step-by-Step Guide https://medium.com/@umairhassan27/setting-up-postgresql-replication-on-slave-server-a-step-by-step-guide-1ff36bb9a47f
    - Кэш
        - SLRU (Simple Least Recently Used) - это специальный механизм кеширования в PostgreSQL, который хранит в памяти важную служебную информацию (например, состояние транзакций), используя алгоритм вытеснения наименее недавно использованных данных при заполнении кеша
            - Scalability Limits From SLRU & Lock Manager | Scaling Postgres 306 https://scaling-postgres-1.castos.com/episodes/scalability-limits-from-slru-lock-manager-scaling-postgres-306
        - Остальное
            - An Overview of Caching for PostgreSQL https://severalnines.com/blog/overview-caching-postgresql/
            - Database Scaling: PostgreSQL Caching Explained https://www.timescale.com/blog/database-scaling-postgresql-caching-explained/            
    - UUID
        - PostgreSQL and UUID as primary key https://maciejwalkowiak.com/blog/postgres-uuid-primary-key/
        - PostgreSQL Primary Key Dilemma: UUID vs. BIGINT https://medium.com/@sjksingh/postgresql-primary-key-dilemma-uuid-vs-bigint-52008685b744
        - A Complete Guide to UUIDs in PostgreSQL https://www.commandprompt.com/education/a-complete-guide-to-uuids-in-postgresql/
    - Оптимизация
        - Как оптимизировать PostgreSQL и не лишиться сна: разбор для разработчиков https://habr.com/ru/companies/selectel/articles/913572/
    - Остальное
        - 7 Best Practice Tips for PostgreSQL Bulk Data Loading https://www.enterprisedb.com/blog/7-best-practice-tips-postgresql-bulk-data-loading
        - Exploring Postgres's arena allocator by writing an HTTP server from scratch https://www.enterprisedb.com/blog/exploring-postgress-arena-allocator-writing-http-server-scratch
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
- MariaDB
    - Основное
    - Остальное
- MySQL
    - Основное
        - SOURCE
            - What is the purpose of the `source` command in MySQL? https://labex.io/questions/what-is-the-purpose-of-the-source-command-in-mysql-178581
        - Импорт
            - How to Import an SQL File in MySQL https://simplebackups.com/blog/how-to-import-sql-file-in-mysql/
    - Оптимизация
        - Optimizing your MySQL queries https://mauricio.github.io/2022/02/16/optimizing-your-mysql-queries.html
    - EXPLAIN
        - Читаем EXPLAIN на максималках https://habr.com/ru/companies/citymobil/articles/545004/
        - Основы индексирования и возможности EXPLAIN в MySQL https://habr.com/ru/companies/oleg-bunin/articles/309328/
    - Индексы
        - Кластерные и «обычные» индексы MySQL (InnoDB) https://habr.com/ru/articles/141767/
        - Кластерные и некластерные индексы реляционных баз данных https://wp-yoda.com/bazy-dannyh/klasternye-i-neklasternye-indeksy/
        - Anatomy of an SQL Index https://use-the-index-luke.com/sql/anatomy
        - Работа с индексами: лучшие практики для MySQL 5.6 (Пётр Зайцев) https://highload.ru/2015/abstracts/1560.html
    - The Left-Prefix Index Rule (правило левого префикса)
        - The Left-Prefix Index Rule https://www.solarwinds.com/blog/the-left-prefix-index-rule
    - Партицинирование
        - Партиционирование таблиц в MySql https://easy-code.ru/lesson/partitioning-mysql
    - Репликация
        - Как устроена MySQL-репликация https://highload.guide/blog/mysql_replication_2015.html
    - Остальное
        - Monitoring Multi-threaded Replication Lag With Performance Schema https://hackmysql.com/monitoring-replication-lag-with-performance-schema/
        - Материалы и ссылки по MySQL https://sqlinfo.ru/forum/viewtopic.php?pid=25919
- Clickhouse
    - Основное
        - ClickHouse для продвинутых пользователей в вопросах и ответах https://habr.com/ru/companies/avito/articles/500678/
        - Возможности ClickHouse для продвинутых разработчиков. Алексей Миловидов (2018г) https://habr.com/ru/articles/519168/
    - Clickhouse-copier
        - Clickhouse-copier in practice https://altinity.com/blog/2018-8-22-clickhouse-copier-in-practice
        - How we transferred the Clickhouse database between geographically distant data centers https://maxilect-company.medium.com/how-we-transferred-the-clickhouse-database-between-geographically-distant-data-centers-ad3c853dce3f
    - Репликация
        - CLCK 11: Настройка репликации в ClickHouse https://learning.infoteam.msk.ru/Rebrain/Clickhouse/clck_11%20Настройка%20репликации%20в%20ClickHouse/CLCK%2011_%20Настройка%20репликации%20в%20ClickHouse.html
        - Clickhouse — шардинг и репликация https://datafinder.ru/products/clickhouse-sharding-i-replikaciya
        - Репликация ClickHouse без костылей: ожидание и реальность https://habr.com/ru/companies/tuturu/articles/576992/
        - Дом, милый дом: нюансы работы с ClickHouse. Часть 2, репликация https://habr.com/ru/companies/nixys/articles/826850/
        - Добавление и удаление реплик в кластер ClickHouse https://stupin.su/wiki/clickhouse_cluster_add_remove/
        - Clickhouse + репликация + шардинг http://iakovlev.org/index.html?p=1435
    - CDC
        - Совместное использование ClickHouse и PostgreSQL: CDC с PeerDB https://bigdataschool.ru/blog/news/clickhouse/cdc-etl-from-postgresql-to-clickhouse-with-peerdb.html
        - Миграция с PostgreSQL на ClickHouse https://clickhouse.com/docs/ru/migrations/postgresql/overview
    - Остальное
        - НАСТРОЙКА КЛАСТЕРА CLICKHOUSE STEB-BY-STEP — ЧАСТЬ 1 https://avamk.ru/nastrojka-klastera-clickhouse-steb-by-step-chast-1.html
- Остальное
    - Самоучитель SQL https://practicum.yandex.ru/blog/samouchitel-sql
    - Управление качеством данных на основе алгоритмов нечеткого поиска https://blog.arbinada.com/ru/category/00020.html
    - 5 сайтов для оттачивания навыков написания SQL-запросов https://proglib.io/p/sql-practice-sites
    - Масштабирование базы данных через шардирование и партиционирование https://habr.com/ru/companies/oleg-bunin/articles/309330/

### Блоги

- MySQL
    - https://www.percona.com/blog/category/mysql/
    - https://peter-zaitsev.livejournal.com/
    - https://hackmysql.com/tags/mysql/
- PostgreSQL
    - https://habr.com/ru/companies/postgrespro/articles/
    - https://devmark.ru/articles/tag/postgresql
    - https://www.commandprompt.com/education/category/postgres/
    - https://www.postgresonline.com/

### Видео

- PostreSQL
    - Типичные ошибки при разработке приложений, работащих с PostgreSQL / Иван Фролков https://www.youtube.com/watch?v=dDryrO8y82c
- Остальное
    - 10 - Recovery Protocols (CMU Databases / Spring 2020) https://www.youtube.com/watch?v=r0qZKOVByi4
    - Всё про изоляции транзакций БД. Тотальный гайд к подготовке к собесу IT transaction isolation levels https://www.youtube.com/watch?v=SMv5_-uVwRo
