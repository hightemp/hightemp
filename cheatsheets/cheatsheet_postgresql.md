### Посмотреть последние запросы

```sql
SELECT pid, query, state FROM pg_stat_activity ORDER BY xact_start DESC LIMIT 60;
```

### Посотреть информацию о таблицах

#### Вариант 1

```
$\d table_name
```

Более детально

```
\d+ table_name
```

#### Вариант 2

```sql
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'your_table_name';
```