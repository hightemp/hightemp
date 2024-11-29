### Посмотреть последние запросы

```sql
SELECT pid, query, state FROM pg_stat_activity ORDER BY xact_start DESC LIMIT 60;
```