# Напиши мне о всех ньюансах в php о которых должен знать очень опытный разработчик

## 1. Типы, сравнения, строгий режим

* `declare(strict_types=1)` — включайте везде, иначе сигнатуры функций дают ложное чувство безопасности.  
* `===` vs `==`: «магические» приведения  
  * `'0e123' == 0`, `'' == 0`, `'false' == 0`  
* Булевы ловушки  
  * `(int)'false' == 0`, но `(bool)'false' == true`  
* Float ≈ IEEE-754: `0.1 + 0.2 != 0.3`; для денег используйте `bcmath`/`gmp`.  
* Целые 32/64-bit: `PHP_INT_SIZE`; каст string→int на 32-битных Windows.  
* Null-safe оператор `?->` (8.0) — не путать с `??`: короткое-замыкание позже.  
* Новые самостоятельные типы `true|false|null` (8.2); `scalar` ещё удобен в атрибутах.  
* Union, intersection (8.1), `never`, `mixed`.  
* Динамические свойства deprecated (8.2) — `__get/__set` или `#[AllowDynamicProperties]`.

---

## 2. Ошибки и исключения

* `Throwable` объединяет `Error` и `Exception`; fatal ≠ `Error`.  
* `try { … } finally` выполняется всегда, но генераторы могут «проглотить» исключение.  
* `set_error_handler` + `ErrorException` → единый стек ошибок.  
* При `@`-супрессии ошибка всё равно в `error_get_last()`.  
* Memory limit + `register_shutdown_function`: при OOM стектрейса нет.

---

## 3. Память, ZVAL, производительность

* Copy-on-write: `$b = $a` копирует zval, но не буфер; модификация «отцепляет».  
* `unset()` освобождает, только если `refcount==1` (замыкания!).  
* GC циклов: `gc_enable()` / `gc_collect_cycles()`.  
* OPcache: `validate_timestamps`, `revalidate_freq`, `memory_consumption`.  
* Preloading (7.4+) — immutable-классы; после deploy нужно перезапускать FPM.  
* JIT (8.0+) ускоряет математику, почти не влияет на IO-heavy веб.

---

## 4. Объектная модель

* `self` / `parent` / `static` (LSB).  
* `__clone` и ссылки на объекты внутри свойств.  
* `readonly`-свойства (8.1) и `readonly`-классы (8.2) — разные вещи.  
* Traits: `insteadof`, `as`, private-alias для DI.  
* Enum (8.1): `Backed`/`Unit`; `switch` без default — `exhaustive`.  
* Атрибуты `#[Attribute]` (8.0) — резолвятся рантаймом.  
* `WeakMap` / `WeakRef` (7.4) — кеши без утечек.

---

## 5. Функциональные возможности

* Замыкания: `$this` внутри `closure->bindTo()`.  
* Arrow fn: переменные по value, но объекты по ссылке.  
* Generators + `yield from`; `send()` для middleware.  
* Fibers (8.1) — корутины уровня ядра.  
* First-class callable `Foo::bar(...)` (8.1) возвращает `Closure`.  
* `throw` как expression (8.0); `match` вместо `switch`.

---

## 6. Стандартная библиотека и SPL

* Streams: `php://memory`, `php://filter`; контекст, таймауты, `ssl://`.  
* SPL-итераторы: `RecursiveDirectoryIterator` + `RegexIterator`.  
* `SplFixedArray`, `SplPriorityQueue` — экономят память, несовместимы с `[]`.  
* `DateTimeImmutable` + timezone — не доверять `date_default_timezone`.

---

## 7. Async / High-Performance стек

* Swoole CLI или ext-swoole без FPM; помнить про coroutine-hooks.  
* RoadRunner — объекты живут между запросами; нужен state-reset.  
* ReactPHP / Amp: event-loop, cancellation token, back-pressure.  
* `parallel` / `pthreads` для CPU-bound CLI; `pcntl_fork` для процессов.

---

## 8. Безопасность

* SQL — PDO prepared + правильный charset в DSN (`charset=utf8mb4`).  
* XSS — `htmlspecialchars($x, ENT_QUOTES|ENT_SUBSTITUTE,'UTF-8')`.  
* CSRF — SameSite=`Lax|Strict` + double-submit token / Origin-check.  
* Пароли: `password_hash()` (Argon2id), pepper, libsodium.  
* `random_bytes()` / `random_int()` — не `mt_rand()`.  
* Тайминг-атаки: `hash_equals()`.  
* Сессии: `session.cookie_secure`, `httponly`, `samesite`, custom store.

---

## 9. Composer и экосистема

* `composer.lock` — коммитим; `--prefer-dist` vs `--prefer-source`.  
* Semver: `^1.2 = >=1.2 <2.0.0`; `^0.x` — ломать API нельзя.  
* Автолоад: `composer dump-autoload -o`, `--classmap-authoritative`.  
* Плагины требуют `allow-plugins` (Composer 2.2+).  
* `repositories` path/vcs — не оставлять в production.

---

## 10. Тестирование и статический анализ

* PHPUnit 10: тест-классы `final`, `@dataProvider` → `static`.  
* Pest — BDD DSL, `beforeAll()`.  
* PhpStan / Psalm: уровни 8/9, generics через `@template`.  
* Infection (mutation testing) — 100 % прохождение тестов обязательно.

---

## 11. Инфраструктура

* FPM: `pm=dynamic`, `request_terminate_timeout`, `process_control=1`.  
* Docker: `alpine` + `glibc` или `debian-slim`; слои с `pecl install`.  
* Приоритет `php.ini`: SAPI → pool → `.user.ini` → `ini_set()`.  
* OPcache + Docker: `opcache.file_cache_only=1` в RO-volume.  
* Preload: абсолютные пути; в k8s после нового Pod — reload.

---

## 12. Расширения и FFI

* ext-intl: `Collator` vs `strcmp`; `MessageFormatter` ICU-plural.  
* GD vs Imagick: 1 px = 4 байта; 100 Мп = 400 МБ RAM.  
* Redis: `pconnect` + AUTH в каждом worker.  
* FFI (7.4+) — не под FPM с preload+JIT до 8.1 (segfault).  
* `opcache.huge_code_pages` — +2 % перфоманса.

---

## 13. Локализация и кодировки

* UTF-8 everywhere; BOM ломает `header()`.  
* `mbstring.func_overload` устарел; используйте `mb_…`.  
* `grapheme_*` для emoji, иначе `substr()` рвёт surrogate-pair.

---

## 14. Дата/время

* `DateTimeImmutable` vs `DateTime` (мутабелен).  
* DST: `$tz->getTransitions()`; «прыгающий» час 02:30 не существует.  
* Carbon 2 уже на Immutable.

---

## 15. Разное, но полезное

* `foreach (&$value)` меняет массив; не забудьте `unset($value)` после цикла.  
* `list(,, $c)` + `array_is_list()` (8.1) оптимизирует JSON.  
* `glob()` не видит файлы внутри phar — используйте `RecursiveIteratorIterator`.  
* `json_encode(JSON_INVALID_UTF8_SUBSTITUTE)` вместо silent truncate.  
* `stream_select()` не работает с файлами на Windows.  
* «Headers already sent» — `var_dump` до `session_start()`.  
* `assert()` отключён в prod; используйте `webmozart/assert`.

---

## 16. Что читать/смотреть

* Архив RFC: <https://wiki.php.net/rfc>  
* Блоги Nikita Popov, Ilija Tovilo.  
* Sara Golemon «Extending and Embedding PHP».  
* OWASP PHP Cheat-Sheet.  
* PHP-FIG: PSR-1…20 (особенно 12, 18, 14).

# «Copy-on-write»: $b = $a копирует zval, но не буфер; модификация «отцепляет» (иметь в виду при больших массивах).

**Copy-on-write (COW)** в PHP — это механизм оптимизации памяти, который откладывает фактическое копирование данных до момента их изменения.

## Как это работает:

### 1. При присваивании `$b = $a`:
```php
$a = [1, 2, 3, 4, 5]; // Создается массив в памяти
$b = $a;              // НЕ копируется! Только ссылка на тот же буфер
```

**Что происходит:**
- Копируется только **zval** (структура переменной)
- **Буфер данных остается один** для обеих переменных
- Увеличивается счетчик ссылок (refcount)

### 2. При модификации происходит "отцепление":
```php
$a = [1, 2, 3, 4, 5];
$b = $a;              // Обе переменные указывают на один буфер
$b[0] = 999;          // ВОТ ЗДЕСЬ происходит копирование!
```

**Что происходит при изменении:**
- PHP видит, что буфер используется несколькими переменными
- Создается **новая копия** буфера для `$b`
- `$a` продолжает использовать оригинальный буфер

## Практический пример:

```php
// Большой массив
$bigArray = range(1, 1000000);

// Копирование zval, но НЕ данных
$copy1 = $bigArray;  // Быстро, памяти почти не тратится
$copy2 = $bigArray;  // Быстро, памяти почти не тратится
$copy3 = $bigArray;  // Быстро, памяти почти не тратится

echo memory_get_usage(); // Память почти не изменилась

// А теперь изменяем одну из копий
$copy1[0] = 'modified'; // ВОТ ЗДЕСЬ тратится память на полную копию!

echo memory_get_usage(); // Память значительно увеличилась
```

## Важность для больших массивов:

### ✅ **Хорошо:**
```php
function processArray($data) {
    // Только чтение - копирования НЕ происходит
    foreach ($data as $item) {
        echo $item;
    }
}

$bigArray = range(1, 1000000);
processArray($bigArray); // Эффективно по памяти
```

### ❌ **Плохо:**
```php
function modifyArray($data) {
    $data[0] = 'changed'; // Копируется ВСЯ структура данных!
    return $data;
}

$bigArray = range(1, 1000000);
$modified = modifyArray($bigArray); // Неэффективно - двойная память
```

### 🔧 **Решение для модификации:**
```php
function modifyArrayByReference(&$data) {
    $data[0] = 'changed'; // Изменяем оригинал, копирования нет
}

// Или явно работаем с оригиналом
$bigArray[0] = 'changed';
```

## Ключевые моменты:

1. **Присваивание дешево** — копируется только zval
2. **Первое изменение дорого** — копируется весь буфер
3. **Чтение безопасно** — никогда не вызывает копирования
4. **Для больших данных** — избегайте случайных модификаций копий

Этот механизм делает PHP эффективным по памяти, но требует понимания для работы с большими структурами данных.