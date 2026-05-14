## Что выведет $data['key']?

$data = ['key' => 'original'];
$ref = &$data['key'];
$copy = $data;
$copy['key'] = 'modified';
 
echo $data['key']; // Выведет 'modified'!

### Почему &$data['key'] меняет поведение копирования

#### Как PHP хранит значения: zval

Каждое значение в PHP хранится в структуре `zval`. У каждого `zval` есть счётчик ссылок `refcount` — сколько переменных "смотрят" на эти данные. Пока `refcount > 1`, данные не копируются при изменении (это и есть CoW). [php](https://www.php.net/manual/ru/language.variables.basics.php)

Но у `zval` есть ещё один флаг — **`is_ref`** (0 или 1). Он означает: "этот zval участвует в явной ссылочной группе `&`".

#### Что происходит шаг за шагом

```php
$data = ['key' => 'original'];
```
Элемент `$data['key']` — обычный zval: `refcount=1`, `is_ref=0`.

***

```php
$ref = &$data['key'];
```
Теперь PHP **помечает** zval элемента `$data['key']` флагом `is_ref=1` и `refcount=2`. `$ref` и `$data['key']` — это один и тот же zval. [php](https://www.php.net/manual/ru/language.references.whatdo.php)

***

```php
$copy = $data;
```
Здесь начинается самое интересное. PHP пытается применить CoW и скопировать массив лениво. Но при обходе элементов массива он видит элемент с флагом `is_ref=1`. [mngb](https://mngb.ru/informatsiya/9/kak-ustroeni-ssilki-v-php)

PHP **не может** просто сделать shallow copy элемента с `is_ref=1` — иначе он нарушит ссылочную семантику. Поэтому он копирует сам массив, но **элемент `key` в копии добавляется в ту же refcount-группу**:

```
До копирования:          После $copy = $data:
$data['key'] ──┐         $data['key'] ──┐
$ref          ──┘ zval   $copy['key'] ──┤ тот же zval
is_ref=1                 $ref          ──┘ is_ref=1, refcount=3
```

***

```php
$copy['key'] = 'modified';
```
Так как zval имеет `is_ref=1`, PHP **не делает CoW** — он изменяет значение напрямую в существующем zval. Результат виден через все три "имени". [php](https://php.ru/manual/language.operators.assignment.html)

#### Ключевое правило

`is_ref=1` **отключает Copy-on-Write** для этого конкретного zval. CoW работает только когда `is_ref=0`. Это принципиальное противоречие двух механизмов: [mngb](https://mngb.ru/informatsiya/9/kak-ustroeni-ssilki-v-php)

| Механизм | Флаг | Поведение при записи |
|---|---|---|
| Copy-on-Write | `is_ref=0`, `refcount>1` | Создаёт новый zval (копию) |
| Ссылочная группа | `is_ref=1` | Изменяет существующий zval напрямую |

#### Почему PHP ведёт себя именно так

Это **осознанное архитектурное решение**: ссылка `&` должна гарантировать, что все участники группы всегда видят актуальное значение. CoW же гарантирует обратное — независимость копий. Совместить оба гарантии для одного zval невозможно, поэтому приоритет отдаётся `is_ref=1`. [php](https://www.php.net/manual/ru/language.references.whatdo.php)

Именно поэтому смешивание `&` и копирования массивов — потенциально опасный паттерн, и PHP-статанализаторы (например, PHPStan) умеют предупреждать об этом.