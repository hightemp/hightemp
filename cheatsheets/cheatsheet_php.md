### Последний день месяца

```php
$month_start = strtotime('first day of this month', time());
$month_end = strtotime('last day of this month', time());

$year_start = strtotime('first day of January', time());
$year_end = strtotime('last day of December', time());
```

```php
$date = new DateTime('now');
$date->modify('last day of this month');
echo $date->format('Y-m-d');
```

For example, on a 32-bit system, this code will echo 1970-01-31:

```php
$a_date = "2040-11-23";
echo date("Y-m-t", strtotime($a_date));
```

If you need your code to support 32-bit systems, then you should instead use the DateTime function:

```php
$d = new DateTime('2040-11-23'); 
echo $d->format('Y-m-t');
```
