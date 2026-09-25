# Что нового в PHP 8.4: хуки свойств, ленивые объекты и HTML5 DOM

PHP 8.4 вышел 21 ноября 2024 года. Самые заметные изменения касаются объектной модели: свойства могут проверять и преобразовывать значения, а видимость чтения и записи можно задавать отдельно. В стандартной библиотеке появились нативные ленивые объекты, новый API для HTML5 DOM и несколько полезных функций для массивов, строк и дат. [Официальный анонс PHP 8.4](https://www.php.net/releases/8.4/ru.php)

Примеры ниже требуют PHP 8.4 или новее. В PHP 8.3 и более ранних версиях новый синтаксис не распознаётся.

## Хуки свойств: логика прямо у свойства

До PHP 8.4, если при чтении или записи свойства нужна была дополнительная логика, обычно приходилось создавать методы `getName()` и `setName()`. Хуки позволяют оставить привычный синтаксис `$user->name`, но определить, что происходит при чтении (`get`) или записи (`set`).

    final class User
    {
        public string $name {
            set {
                $value = trim($value);

                if ($value === '') {
                    throw new InvalidArgumentException('Имя не должно быть пустым');
                }

                $this->name = $value;
            }
        }
    }

    $user = new User();
    $user->name = ' Ada ';
    echo $user->name; // Ada

В хуке `set` значение, которое пытаются записать, доступно в `$value`. Присваивание `$this->name` внутри хука записывает его в хранилище свойства; оно не вызывает этот же хук повторно.

Хук `get` может вычислять значение без отдельного поля:

    final class Person
    {
        public string $firstName;
        public string $lastName;

        public string $fullName {
            get => $this->firstName . ' ' . $this->lastName;
        }
    }

    $person = new Person();
    $person->firstName = 'Ada';
    $person->lastName = 'Lovelace';

    echo $person->fullName; // Ada Lovelace

Такое свойство называется виртуальным: его значение вычисляется при чтении и отдельно не хранится. Хуки полезны для нормализации данных, проверки инвариантов и вычисляемых свойств. Они не заменяют обычные методы во всех случаях: сложные действия с побочными эффектами по-прежнему понятнее оформлять отдельными методами.

## Разная видимость для чтения и записи

PHP 8.4 позволяет открыть чтение свойства шире, чем его изменение. Например, `public private(set)` означает, что любой код может прочитать свойство, но записывать в него может только класс-владелец:

    final class User
    {
        public function __construct(
            public private(set) string $id,
        ) {}
    }

    $user = new User('u-42');

    echo $user->id; // u-42
    // $user->id = 'u-99'; // Ошибка: запись извне запрещена

Раньше этого добивались закрытым свойством и отдельным публичным методом или делали объект неизменяемым. Асимметричная видимость даёт более короткий способ выразить правило `читать можно, менять — только изнутри`. Её можно сочетать с хуками: видимость определяет, кто имеет право выполнить операцию, а хук — что происходит при допустимом чтении или записи.

Хуки также позволяют интерфейсам и абстрактным классам объявлять требования к свойствам, например требовать публичную операцию чтения без требования публичной записи.

## Ещё два изменения языка

PHP 8.4 разрешает обращаться к свойствам и методам сразу после `new`, без скобок вокруг создания объекта:

    $date = new DateTimeImmutable()->format('Y-m-d');

Прежде та же запись требовала бы `(new DateTimeImmutable())->format(...)`. Это небольшое изменение делает цепочки создания и вызова короче.

Новый атрибут `#[\Deprecated]` позволяет помечать собственные функции, методы и константы классов устаревшими. При их использовании PHP выдаёт `E_USER_DEPRECATED`. Это помогает разработчикам библиотек сообщить пользователям, что заменить, не удаляя API сразу.

    #[\Deprecated]
    function oldApi(): void
    {
        // Используйте новый API вместо этой функции.
    }

## Ленивые объекты для ORM и контейнеров

Ленивый объект создаётся до того, как загружены его данные или зависимости. PHP вызывает переданную функцию-инициализатор, когда код впервые обращается к состоянию объекта. Для создания используются методы Reflection:

    final class Product
    {
        public function __construct(
            public int $id,
            public string $title,
        ) {}
    }

    $reflection = new ReflectionClass(Product::class);

    $product = $reflection->newLazyGhost(
        static function (Product $product): void {
            // Например, получить строку из базы данных.
            $product->__construct(42, 'Книга');
        }
    );

    // Инициализатор сработает при первом обращении к свойству.
    echo $product->title; // Книга

Это низкоуровневый механизм прежде всего для ORM, контейнеров зависимостей и библиотек. Приложению не нужно вручную писать класс-прокси с `__get()` и `__set()` для каждого такого случая. PHP поддерживает два основных варианта: ghost-объект и proxy-объект; они отличаются тем, как инициализируется исходный экземпляр. Для обычного бизнес-кода ленивый объект полезен, когда его создаёт используемая библиотека.

## Новый DOM API понимает HTML5

Старые классы `DOMDocument` и `DOMNode` остаются доступными. PHP 8.4 добавил отдельный API в пространстве имён `Dom`, который соответствует современному HTML5-поведению браузеров и устраняет часть давних расхождений парсера.

    $html = <<<'HTML'
    <main>
        <article class="featured">Новая статья</article>
        <article>Архив</article>
    </main>
    HTML;

    $document = Dom\HTMLDocument::createFromString($html);
    $featured = $document->querySelector('article.featured');

    echo $featured?->textContent; // Новая статья

Новые классы, в том числе `Dom\HTMLDocument` и `Dom\XMLDocument`, не подменяют старый DOM API. Их можно выбирать там, где нужно более точное соответствие HTML5. CSS-селекторы `querySelector()` и `querySelectorAll()` упрощают поиск элементов.

## Новые функции для массивов и тела запроса

В PHP 8.4 появились четыре функции с общей моделью вызова. Каждая получает массив и callback; callback вызывается для элементов по порядку и принимает значение, затем ключ:

    callback(mixed $value, mixed $key): bool

| Функция | Сигнатура PHP | Результат и остановка перебора |
| --- | --- | --- |
| [`array_find`](https://www.php.net/manual/ru/function.array-find.php) | `array_find(array $array, callable $callback): mixed` | Значение первого совпавшего элемента; после совпадения callback больше не вызывается. Если совпадения нет, возвращается `null`. |
| [`array_find_key`](https://www.php.net/manual/ru/function.array-find-key.php) | `array_find_key(array $array, callable $callback): mixed` | Ключ первого совпавшего элемента; после совпадения перебор останавливается. Если совпадения нет, возвращается `null`. Ключ массива при этом всегда целое число или строка. |
| [`array_any`](https://www.php.net/manual/ru/function.array-any.php) | `array_any(array $array, callable $callback): bool` | `true`, если callback вернул `true` хотя бы для одного элемента; на первом совпадении перебор прекращается. |
| [`array_all`](https://www.php.net/manual/ru/function.array-all.php) | `array_all(array $array, callable $callback): bool` | `true`, только если callback вернул `true` для каждого элемента; на первом `false` перебор прекращается. |

Аргумент `$array` — проверяемый массив, `$callback` — условие, которое требуется проверить. Callback всегда получает оба аргумента — `$value` и `$key`. Если ключ не нужен, его можно не указывать в замыкании.

    $books = [
        'php' => ['title' => 'PHP', 'available' => false],
        'http' => ['title' => 'HTTP', 'available' => true],
    ];

    $isAvailable = static fn (array $book, mixed $key): bool =>
        $book['available'];

    $nextBook = array_find($books, $isAvailable);
    $nextBookKey = array_find_key($books, $isAvailable);
    $hasAvailable = array_any($books, $isAvailable);
    $allAvailable = array_all($books, $isAvailable);

    echo $nextBook['title']; // HTTP
    echo $nextBookKey;       // http
    var_dump($hasAvailable); // true
    var_dump($allAvailable); // false

Для пустого массива `array_any` возвращает `false`, а `array_all` — `true`: ни один элемент не нарушил условие. У `array_find` есть неоднозначный случай: если callback нашёл элемент со значением `null`, по одному результату нельзя отличить его от отсутствия совпадения. Используйте `array_find_key`, если это различие важно.

### Разбор тела запроса через `request_parse_body`

Функция нужна главным образом для разбора `multipart/form-data` у `PUT`, `PATCH` и других HTTP-методов, для которых PHP автоматически не заполняет `$_POST` и `$_FILES`. Она также поддерживает `application/x-www-form-urlencoded`. Обычные `POST`-формы обычно уже разобраны PHP до запуска кода.

Сигнатура:

    request_parse_body(?array $options = null): array

Единственный параметр `$options` необязателен. Это ассоциативный массив, который переопределяет лимиты `php.ini` только для этого разбора:

| Ключ | Что ограничивает |
| --- | --- |
| `max_file_uploads` | Количество файлов в запросе. |
| `max_input_vars` | Количество обычных полей формы. |
| `max_multipart_body_parts` | Общее количество частей multipart-тела. |
| `post_max_size` | Максимальный размер всего тела запроса. |
| `upload_max_filesize` | Максимальный размер одного загружаемого файла. |

Например, endpoint для авторизованной загрузки может разрешить больший файл, не поднимая глобальные лимиты для всех форм:

    [$formData, $files] = request_parse_body([
        'post_max_size' => '10M',
        'upload_max_filesize' => '10M',
        'max_file_uploads' => 3,
    ]);

Функция возвращает пару массивов: элемент `0` соответствует `$_POST`, элемент `1` — `$_FILES`. Если тело не соответствует `Content-Type`, выбрасывается `RequestParseBodyException`; неизвестные ключи или недопустимые значения в `$options` приводят к `ValueError`.

Сам поток `php://input` обычно буферизует тело запроса, поэтому его можно прочитать повторно. Исключение — `multipart/form-data`: для таких запросов поток может быть пустым, поскольку PHP разбирает POST-форму в `$_POST` и `$_FILES`.

`request_parse_body()` читает входной буфер SAPI напрямую и не сохраняет его в `php://input`. Поэтому функцию нельзя вызывать повторно, даже если первый вызов завершился исключением. Если приложение сначала прочитало тело через `php://input`, `request_parse_body()` вернёт пустые данные. [Руководство PHP](https://www.php.net/manual/ru/function.request-parse-body.php) · [RFC функции](https://wiki.php.net/rfc/rfc1867-non-post)

## Полезные дополнения стандартной библиотеки

- **Десятичная арифметика.** Новый `BcMath\Number` позволяет использовать обычные арифметические операторы с числами произвольной точности вместо набора функций `bcadd()`, `bcsub()` и подобных. Это удобнее для денег и других десятичных величин, где двоичный `float` может давать округление.

      use BcMath\Number;

      $total = new Number('0.10') + new Number('0.20');
      echo $total; // 0.30

- **Округление.** Перечисление `RoundingMode` даёт именованные режимы округления и добавляет четыре новых варианта. Например, `HalfEven` округляет половинное значение к ближайшему чётному:

      round(2.5, 0, RoundingMode::HalfEven); // 2
      round(3.5, 0, RoundingMode::HalfEven); // 4

- **Строки и даты.** Для `mbstring` добавлены `mb_trim()`, `mb_ltrim()`, `mb_rtrim()`, `mb_ucfirst()` и `mb_lcfirst()`. Классы `DateTime` и `DateTimeImmutable` получили `createFromTimestamp()`, `getMicrosecond()` и `setMicrosecond()`. В `intl` появилась `grapheme_str_split()` для разбиения строки на графемы, то есть видимые пользователю символы, которые могут состоять из нескольких кодовых точек.
- **PDO.** Появились классы отдельных драйверов, например `Pdo\Mysql` и `Pdo\Pgsql`, а также парсеры SQL с учётом синтаксиса соответствующей СУБД. Это помогает точнее обрабатывать запросы, в которых символ `?` или строковые литералы имеют особое значение.
- **JIT и PCRE2.** Реализацию JIT-компилятора переработали на основе промежуточного представления, а встроенную PCRE2 обновили. Это изменения внутренней реализации и возможностей; сами по себе они не гарантируют ускорение каждого приложения.

Среди других дополнений к расширениям: новые опции cURL, в том числе HTTP/3 и callbacks для контроля соединений; поддержка Curve25519 и Curve448 в OpenSSL; переменные lookbehind и другие обновления PCRE2; новые функции PCNTL и PostgreSQL; улучшения SOAP и XSL. Для интерактивной оболочки PHP можно задать путь к файлу истории переменной окружения `PHP_HISTFILE`. Официальный справочник ниже содержит полные списки функций, классов и изменений каждого расширения.

## Что проверить при переходе

Главная языковая депрекация — неявно nullable-параметры. Такая сигнатура теперь выдаёт предупреждение:

    function findUser(int $id = null): ?User {}

Укажите `null` явно в типе:

    function findUser(?int $id = null): ?User {}

Также передавайте параметр `escape` явно в функциях CSV, например `fgetcsv()` и `fputcsv()`. Если обратная косая черта не нужна как escape-символ, это можно указать явно: `escape: ''`.

Изменилось и поведение `exit`/`die`: они стали больше похожи на функции, их можно передавать как callable, а переданное значение обрабатывается по обычным правилам преобразования типов. Если старый код передаёт им неподходящее значение или использует неявное преобразование, проверьте его на `TypeError`.

Модули IMAP, Pspell, OCI8 и PDO_OCI больше не входят в сборку ядра PHP: при необходимости их устанавливают отдельно из PECL. Проверьте также системные требования обновлённых расширений, в частности версии OpenSSL и libcurl. Это особенно важно для сборки PHP и контейнерных образов.

В PHP 8.4 много менее заметных изменений в расширениях, новых функциях и несовместимом поведении. Перед обновлением сверяйтесь с полным [официальным руководством по миграции с PHP 8.3 на 8.4](https://www.php.net/manual/ru/migration84.php).

## Официальные источники

- [Анонс PHP 8.4](https://www.php.net/releases/8.4/ru.php)
- [Миграция с PHP 8.3 на PHP 8.4](https://www.php.net/manual/ru/migration84.php)
- [Новая функциональность в PHP 8.4](https://www.php.net/manual/ru/migration84.new-features.php)
- [Новые функции PHP 8.4](https://www.php.net/manual/ru/migration84.new-functions.php)
- [Новые классы PHP 8.4](https://www.php.net/manual/ru/migration84.new-classes.php)
- [array_find](https://www.php.net/manual/ru/function.array-find.php), [array_find_key](https://www.php.net/manual/ru/function.array-find-key.php), [array_any](https://www.php.net/manual/ru/function.array-any.php), [array_all](https://www.php.net/manual/ru/function.array-all.php)
- [request_parse_body](https://www.php.net/manual/ru/function.request-parse-body.php)
- [Несовместимые изменения](https://www.php.net/manual/ru/migration84.incompatible.php)
- [Устаревшая функциональность](https://www.php.net/manual/ru/migration84.deprecated.php)
