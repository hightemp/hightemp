# Напиши мне о всех ньюансах в php о которых должен знать очень опытный разработчик

Ниже — концентрированный «список памяти» для действительно опытного PHP-разработчика.  
Пользуйтесь им как чек-листом: тематические блоки → частые «тонкие места».

---

## 1. Типы, сравнения, строгий режим
* `declare(strict_types=1)` — включайте везде, иначе сигнатуры функций дают ложное чувство безопасности.  
* `===` против `==`: «магическое» приведение `'0e123' == 0`, `'' == 0` и т. п.  
* Булевы ловушки: `(int)'false' == 0`, но `(bool)'false' == true`.  
* Float ≈ IEEE-754: `0.1 + 0.2 != 0.3`; `bcmath`/`gmp` для финансов.  
* Целые 32/64-bit: `PHP_INT_SIZE`; касты из string на 32-битных Windows.  
* Null-safe-оператор `?->` (8.0) — не путать с `??`: короткое-замыкание происходит позже.  
* Новые самостоятельные типы `true` / `false` / `null` (8.2); `scalar` всё ещё удобен в атрибутах.  
* Union, intersection (8.1), stand-alone `null|Foo`, `never`, `mixed`.  
* Динамические свойства deprecated (8.2) — `__get`/`__set` или атрибут `#[AllowDynamicProperties]`.

---

## 2. Ошибки и исключения
* `Throwable` объединяет `Error` и `Exception`; fatal ≠ `Error`.  
* `try { … } finally` всегда выполняется; даже при fatal внутри генератора отмена `yield` может «проглотить» исключение.  
* `error_reporting` + `set_error_handler` + `ErrorException` = единый стек ошибок.  
* При `@`-супрессии ошибка всё равно попадает в `error_get_last()`.  
* Memory limit и shutdown-функция: может вызываться уже после fatal OOM, в `$last_error` нет стектрейса.

---

## 3. Управление памятью, ZVAL и производительность
* «Copy-on-write»: `$b = $a` копирует zval, но не буфер; модификация «отцепляет» (актуально для больших массивов).  
* `unset()` не всегда освобождает сразу — пока refcount > 0 (особенно внутри замыканий).  
* GC циклов: `gc_enable` / `gc_collect_cycles`; контур-утечки в `SplObjectStorage`.  
* OPcache: обязательные флаги `opcache.validate_timestamps`, `revalidate_freq`, `memory_consumption`.  
* Preloading (7.4+) — определяйте immutable-классы; при deploy надо перезагружать FPM.  
* JIT (8.0+) ускоряет математику и плечо FFI, но почти не влияет на IO-heavy веб.

---

## 4. Объектная модель
* `self` / `parent` / `static` (LSB). `static` внутри замыканий до 8.1 не работал в типах.  
* `__clone` и объектные свойства-ссылки (`SplObjectStorage` внутри).  
* `readonly`-свойства (8.1) и `readonly`-классы (8.2) — не путать: первый вариант до клонирования.  
* Traits: конфликт имён, `insteadof`, `as` visibility, private-alias для DI.  
* Enum (Backed/Unit) 8.1: `value` нельзя переопределить, `switch` (exhaustive) + `instanceof UnitEnum`.  
* Новые атрибуты `#[Attribute]` (8.0) — резолвятся рантайм-рефлексией, не во время компиляции.  
* `WeakMap` / `WeakRef` (7.4) — кэши без утечек, но держатся пока есть хотя бы одна strong-ref.

---

## 5. Функциональные возможности
* Замыкания: `$this` внутри функций с 7.1 при `bindTo(null, 'Class')`.  
* Arrow-fn `fn($x) => $x * $y;` захватывают переменные по value, но вложенные объекты всё равно по ссылке.  
* Generators + `yield from`; `send()` в middleware-стеке.  
* Fibers (8.1) — низкоуровневые корутины; ReactPHP/Amp 3 уже используют.  
* First-class callable `Foo::bar(...)` (8.1) возвращает `Closure`.  
* `throw` как expression (8.0); `match` вместо `switch` без падения.

---

## 6. Стандартная библиотека и SPL
* Streams: `php://memory`, `php://filter`; контекст, таймауты, `ssl://`, обёртка `ftps://` (отличается от `ftp+tls`).  
* SPL-итераторы: `RecursiveDirectoryIterator` с `RegexIterator`, `CallbackFilterIterator`.  
* `SplFixedArray` / `SplPriorityQueue` — экономят память, но не совместимы с `[]`.  
* `DateTimeImmutable` + timezone — не доверять `default_timezone` ini при CLI-кронах.

---

## 7. Современный async-/high-performance стек
* Swoole/FPM conflict: Swoole CLI или `ext-swoole` без FPM, помнить про coroutine-hook.  
* RoadRunner (Go-worker) — shared-nothing, объекты остаются между запросами; помнить про state-reset.  
* ReactPHP/Amp: event-loop, cancellation token, back-pressure через promises.  
* `parallel` / `pthreads` для CPU-bound в CLI; fork-менеджмент через `pcntl`.

---

## 8. Безопасность
* SQL — PDO prepared OK, но не забудьте charset при mysqlnd (`SET NAMES …` устарел, используйте DSN `;charset`).  
* XSS — `htmlspecialchars($x, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8')`.  
* CSRF — `SameSite=Lax/Strict` + double-submit token; в SPA — origin-header проверка.  
* Passwords: `password_hash()`, Argon2id, pepper + `libsodium_crypto_pwhash`.  
* `random_bytes()` / `random_int()` — не `mt_rand()`.  
* Timing attacks: `hash_equals`.  
* Session-cookie: `session.cookie_secure`/`httponly`/`samesite=Strict` + custom `session_set_save_handler`.

---

## 9. Composer и экосистема
* `composer.lock` — версионирование в CI; `--prefer-dist` vs `--prefer-source`.  
* SemVer: `^1.2` = `>=1.2 <2.0.0`; всё ещё недопустимо `^0.x` ломать API.  
* Autoload-optimization: `composer dump-autoload -o`, `classmap-authoritative`.  
* Scripts & Plugins: `post-install-cmd`, `composer-plugin-api`, требует `allow-plugins` в 2.2+.  
* Repositories `path`/`vcs` — локально патчите форки, не оставляйте в production.

---

## 10. Тестирование и статический анализ
* PHPUnit 10: тест-классы `final`, `dataProvider` → `static`.  
* Pest — BDD-DSL, shared `beforeAll()`; Doctrine-аннотации устарели, используйте атрибуты `#[CoversClass]`.  
* php-stan / Psalm: уровни 8/9, generics через `@template`/`@param-out`; baseline для legacy.  
* Infection (mutation testing): требует 100 % прохождения набора тестов.

---

## 11. Инфраструктура
* FPM: `pm = dynamic` / `request_terminate_timeout`; `process_control = 1` для graceful reload.  
* Docker: компоновка alpine + glibc или debian-slim; слои с `pecl-install` иначе кэш раздувается.  
* Приоритет `php.ini`: SAPI-global → `php-fpm.d/pool` → `.user.ini` → `ini_set()`.  
* OPcache + Docker: `opcache.file_cache_only = 1` в read-only volume.  
* Preloading требует absolute-path; в Kubernetes после нового Pod нужен reload-script.

---

## 12. Расширения и FFI
* ext-intl: `Collator` vs `strcmp`; `MessageFormatter` ICU-plural-rules.  
* ext-gd vs Imagick: память на 1 px = 4 байта, при 100 Мп ≈ 400 МБ.  
* Redis — `persistent` = `pconnect` + AUTH EACH WORKER; иначе `127.0.0.1: Connection lost`.  
* FFI (7.4+) — можно дергать C-библиотеки, но не под FPM с preload и JIT — segfault, фикшено 8.1.  
* `opcache.huge_code_pages` на Linux ≈ 2 % выигрыша; держать `vm.nr_hugepages`.

---

## 13. Локализация и кодировки
* UTF-8 everywhere; `declare(encoding='UTF-8')` не нужен, но BOM ломает `header()`.  
* `mbstring.func_overload` устарел; используйте строгие функции `mb_substr`, `iconv_substr`.  
* `grapheme_*` для emoji, иначе `substr()` рвёт surrogate-pair.

---

## 14. Дата/время
* `DateTimeImmutable` vs `DateTime` (мутабелен).  
* Zoned-intervals: `$tz->getTransitions()` на DST; «прыгающий» час 02:30 не существует.  
* Carbon/Luxon? Carbon 2 уже на Immutable.

---

## 15. Разное, но полезное вспомнить
* `foreach (&$value)` меняет проходной массив, следите за удержанной ссылкой после цикла.  
* `list(, , $c)` + `array_is_list` (8.1) — оптимизация сериализации JSON.  
* `glob()` невидим в phar, используйте `RecursiveIteratorIterator`.  
* `json_encode(JSON_INVALID_UTF8_SUBSTITUTE)` вместо silent truncate.  
* `stream_select` не работает с файловыми дескрипторами на Windows.  
* «Headers already sent» — `var_dump` в output-buffer до `session_start()`.  
* `assert()` отключён по умолчанию; в prod используйте polyfill `webmozart/assert`.

---

## 16. Что читать/смотреть
* RFC-архив php-internals — `wiki.php.net/rfc`.  
* Nikita Popov & Ilija Tovilo — блоги о новых фичах.  
* Sara Golemon «Extending and Embedding PHP» (для FFI/расширений).  
* OWASP-PHP-cheatsheet.  
* PHP-FIG PSR-1…PSR-20, особенно PSR-12, PSR-18, PSR-14.
