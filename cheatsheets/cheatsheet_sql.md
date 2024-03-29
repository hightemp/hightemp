
### Что делает в MySQL having?

Оператор `HAVING` в MySQL используется вместе с оператором `GROUP BY` для фильтрации значений, которые производят группировочные операции, такие как `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`.

В отличие от `WHERE`, команда `HAVING` фильтрует значения после выполнения групповых операций. 

Небольшой пример использования `HAVING`:

```sql
SELECT COUNT(id), country
FROM Customers
GROUP BY country
HAVING COUNT(id) > 5;
```

В этом примере мы выбираем страны, в которых больше 5 клиентов. Сначала, команда `GROUP BY` группирует клиентов по странам, затем команда `HAVING` фильтрует результаты, позволяя увидеть только те страны, в которых количество клиентов больше 5.

Заметьте, что `WHERE` не мог бы быть использован здесь, поскольку `WHERE` работает с исходными данными перед выполнением групповых операций.
