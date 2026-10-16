# Что нового в Symfony 8.1: HTTP-less приложения, RateLimit, Serialize и Tui

Symfony 8.1 вышел в мае 2026 года и требует PHP 8.4+. На **16 октября 2026 года** это актуальная стабильная ветка; её обычная поддержка запланирована до января 2027 года. Долгосрочной альтернативой остаётся 7.4 LTS. [Страница версии](https://symfony.com/releases/8.1)

В 8.1 есть крупные архитектурные изменения — отделение ядра сервисного контейнера от HTTP — и прикладные удобства: ограничение частоты запросов атрибутом, автоматическая сериализация результата action, команды на методах и полноэкранные терминальные интерфейсы. [Оглавление серии](symfony-release-overviews.md)

## HTTP-less: Symfony-приложение без web-ядра

Worker или CLI-инструмент может нуждаться в DI, bundles и конфигурации, но не обслуживать HTTP. В 8.1 соответствующая инфраструктура выделена в DependencyInjection:

```php
// src/Kernel.php
namespace App;

use Symfony\Component\DependencyInjection\Kernel\AbstractKernel;
use Symfony\Component\DependencyInjection\Kernel\KernelTrait;

final class Kernel extends AbstractKernel
{
    use KernelTrait;
}
```

Для консольного приложения можно зарегистрировать ConsoleBundle:

```php
// config/bundles.php
return [
    Symfony\Component\Console\ConsoleBundle::class => ['all' => true],
];
```

Он подтягивает `ServicesBundle`, содержащий базовые сервисы. Сохраняются знакомые соглашения `config/bundles.php`, `config/packages/` и `config/services.yaml`/`.php`. Для объявления зависимостей bundles появился `RequiredBundle`.

Это фрагменты архитектуры, а не полный дистрибутив CLI-приложения: точка входа и нужные пакеты всё равно настраиваются. Обычное HTTP-приложение не нужно переводить на новый kernel ради самого обновления. Старое HTTP-ядро использует выделенную инфраструктуру совместимым образом. [HTTP-less applications](https://symfony.com/blog/new-in-symfony-8-1-http-less-symfony-applications)

## `RateLimit`: ограничение частоты на контроллере

Сначала описывается обычный limiter:

```yaml
# config/packages/rate_limiter.yaml
framework:
    rate_limiter:
        public_api:
            policy: fixed_window
            limit: 30
            interval: '1 minute'
```

Затем action связывается с ним:

```php
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Attribute\RateLimit;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/api/status', methods: ['GET'], format: 'json')]
#[RateLimit('public_api')]
public function status(): JsonResponse
{
    return new JsonResponse(['status' => 'ok']);
}
```

По умолчанию ключ включает IP клиента, метод HTTP и путь. При превышении лимита Symfony формирует **429 Too Many Requests** с `Retry-After`.

| Настройка атрибута | Назначение |
| --- | --- |
| Первый аргумент | Имя настроенного limiter |
| `key` | Собственный ключ через выражение или callback |
| `methods` | Ограничение применения указанными HTTP-методами |
| `tokens` | Сколько токенов расходует запрос; default — 1 |

Атрибут повторяемый: все применимые ограничения должны разрешить запрос. На классе он применяется к его actions. Выражения требуют ExpressionLanguage, а closure непосредственно внутри атрибута — PHP 8.5.

За proxy корректность IP зависит от trusted proxies. Для нескольких реплик нужно общее хранилище состояния limiter. Ограничение в PHP-контроллере не заменяет защиту на уровне reverse proxy от перегрузки самого приложения. [RateLimiter 8.1](https://symfony.com/blog/new-in-symfony-8-1-ratelimiter-improvements)

У `fixed_window` также появился `anchor_at` для календарного начала окон. В 8.1 этот режим рассчитан на интервалы не короче месяца: например, квота с обнулением каждого 5-го числа, а не через месяц после первого запроса. [Руководство RateLimiter 8.1](https://symfony.com/doc/8.1/rate_limiter.html)

## `Serialize`: вернуть DTO из action

Для API больше не обязательно вручную вызывать Serializer и собирать Response:

```php
final readonly class ProductCreated
{
    public function __construct(public int $id)
    {
    }
}
```

```php
use Symfony\Component\HttpKernel\Attribute\Serialize;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/api/products', methods: ['POST'], format: 'json')]
#[Serialize(code: 201, headers: ['X-API-Version' => '1'])]
public function create(): ProductCreated
{
    // В реальном action ID возвращает операция создания товара.
    return new ProductCreated(101);
}
```

Результат — JSON вида `{"id":101}` со статусом 201 при установленном и настроенном Serializer. Атрибут принимает код ответа, заголовки и `context`, например serialization groups или формат даты. Формат определяется запросом/маршрутом, JSON используется по умолчанию; неподдерживаемый формат приводит к 415.

Возвращать отдельный output DTO безопаснее, чем произвольную ORM-сущность с открытыми связями и техническими полями. `Serialize` не придумывает правила видимости данных и не создаёт API-схему. [Новый атрибут Serialize](https://symfony.com/blog/new-in-symfony-8-1-serialize-attribute)

## Request mapping: файлы внутри DTO, массивы и пустой ввод

`MapRequestPayload` теперь объединяет поля multipart-формы и загруженные файлы перед десериализацией:

```php
use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Component\Validator\Constraints as Assert;

final class ProductUpload
{
    #[Assert\NotBlank]
    public string $name = '';

    #[Assert\File(maxSize: '5M', extensions: ['png', 'jpg', 'jpeg'])]
    public ?UploadedFile $image = null;
}
```

```php
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/products/upload', methods: ['POST'])]
public function upload(#[MapRequestPayload] ProductUpload $data): Response
{
    // $data->name и $data->image подготовлены для бизнес-операции.
    return new Response(status: 204);
}
```

Поддерживаются вложенные структуры. Сохранение файла и выбор имени остаются задачей приложения.

Другие дополнения:

- Вариадические DTO: `#[MapRequestPayload] Price ...$prices` для массива объектов во входном JSON.
- `mapWhenEmpty: true` запускает mapping даже при пустом вводе, позволяя denormalizer заполнить DTO.
- `validationGroups` принимает динамические выражения/callbacks с доступом к resolved arguments.

Не следует смешивать HTTP payload mapping и проверку права изменять конкретные поля. [Request payload mapping 8.1](https://symfony.com/blog/new-in-symfony-8-1-improved-request-payload-mapping)

Для отдельных HTTP-заголовков добавлен `MapRequestHeader`:

```php
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Attribute\MapRequestHeader;

public function info(
    #[MapRequestHeader(name: 'X-Request-Id')] ?string $requestId = null,
): JsonResponse {
    return new JsonResponse(['requestId' => $requestId]);
}
```

Без `name` имя выводится из аргумента: `$acceptLanguage` → `Accept-Language`. Для обязательного отсутствующего заголовка default-ошибка — 400; `validationFailedStatusCode` позволяет её изменить. Тип `array` получает значения заголовка, `AcceptHeader` — разобранное представление. [Новые DX-возможности](https://symfony.com/blog/new-in-symfony-8-1-dx-improvements-part-2)

## Console: несколько команд в одном сервисе

`AsCommand` можно ставить на отдельные методы:

```php
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Style\SymfonyStyle;

final class CatalogCommands
{
    #[AsCommand('app:catalog:status')]
    public function status(SymfonyStyle $io): int
    {
        $io->writeln('Каталог доступен');
        return Command::SUCCESS;
    }

    #[AsCommand('app:catalog:version')]
    public function version(SymfonyStyle $io): int
    {
        $io->writeln('v1');
        return Command::SUCCESS;
    }
}
```

При autoconfiguration каждый метод становится отдельной командой, а конструктор и зависимости класса общие. Standalone Console позволяет зарегистрировать first-class callable через `addCommand($instance->status(...))`. [Method-based commands](https://symfony.com/blog/new-in-symfony-8-1-method-based-commands)

Появились и полноценные Console argument resolvers: `MapDateTime`, Doctrine `MapEntity`, преобразование enum/UUID/ULID, а также DI сервисов прямо в метод команды. Например, дата из `--date=2026-05-08` может сразу стать `DateTimeInterface`, если аргумент описан соответствующими `Option`/`MapDateTime`. [Console argument resolvers](https://symfony.com/blog/new-in-symfony-8-1-console-argument-resolvers)

## Tui: полноэкранный интерфейс в терминале

Console подходит для команд с аргументами и выводом. Новый компонент Tui предоставляет widgets, фокус, события клавиатуры, layout и перерисовку экрана. Пример отдельного скрипта после подключения Composer autoload:

```php
use Symfony\Component\Tui\Event\InputEvent;
use Symfony\Component\Tui\Input\Keybindings;
use Symfony\Component\Tui\Tui;
use Symfony\Component\Tui\Widget\InputWidget;
use Symfony\Component\Tui\Widget\TextWidget;

$tui = new Tui();
$input = new InputWidget();
$input->setPrompt('Имя: ');
$input->onSubmit(static fn () => $tui->stop());

$tui->add(new TextWidget('Введите имя и нажмите Enter'));
$tui->add($input);
$tui->setFocus($input);

$keys = new Keybindings(['quit' => ['ctrl+c']]);
$tui->addListener(static function (InputEvent $event) use ($tui, $keys): void {
    if ($keys->matches($event->getData(), 'quit')) {
        $tui->stop();
    }
});

$tui->run();
echo 'Привет, '.$input->getValue().PHP_EOL;
```

Компонент нужно установить отдельно. Цикл работает с Fibers и Revolt; интерфейс сохраняет отзывчивость при корректно организованных асинхронных операциях. Обычный блокирующий вызов внутри callback не становится асинхронным автоматически.

Есть списки, текстовые редакторы, Markdown, progress/spinner widgets и стилизация. Полноэкранный интерфейс требует подходящего интерактивного терминала; для CI обычно оставляют обычную Console-команду. [Знакомство с Tui](https://symfony.com/blog/new-in-symfony-8-1-tui-component)

## DeepCloner: копирование графа объектов

Обычный `clone` копирует внешний объект, но вложенные изменяемые объекты могут остаться общими. `DeepCloner` из VarExporter строит отдельный граф:

```php
use Symfony\Component\VarExporter\DeepCloner;

$original = (object) ['address' => (object) ['city' => 'Moscow']];
$copy = DeepCloner::deepClone($original);
$copy->address->city = 'Kazan';

echo $original->address->city; // Moscow
echo $copy->address->city;     // Kazan
```

Для многократного копирования прототипа можно один раз создать `new DeepCloner($prototype)` и вызывать `clone()`. Есть `cloneAs()` для совместимого корневого класса и экспорт/восстановление через `toArray()`/`fromArray()`.

Необязательное расширение `symfony/php-ext-deepclone` ускоряет низкоуровневые операции; предусмотрен userland-вариант. Реальные ресурсы вроде подключения к БД требуют отдельной политики жизненного цикла, поэтому глубокое клонирование модели не заменяет архитектуру работы с инфраструктурой. [DeepCloner](https://symfony.com/blog/new-in-symfony-8-1-deep-cloner)

## HttpClient: тайм-аут подключения, DNS и совместимость

```php
$response = $client->request('GET', 'https://api.example.com/catalog', [
    'max_connect_duration' => 0.5,
    'timeout' => 10,
    'max_duration' => 30,
]);
```

Это три разных ограничения: установление соединения, ожидание активности и общая длительность запроса. Соединение включает DNS, TCP и TLS.

| Изменение | Практический смысл |
| --- | --- |
| `GuzzleHttpHandler` | Использовать Symfony HttpClient в SDK на Guzzle |
| `DnsResolvingHttpClient` | Своя логика разрешения hostname в IP |
| Allow-list `NoPrivateNetworkHttpClient` | Разрешить выбранные внутренние адреса, сохранив остальные ограничения |
| Persistent cURL connections | Повторно использовать данные соединений; требуется **PHP 8.5+** |
| `mock_response_factory` у scoped client | Отдельные ответы-заглушки для отдельных интеграций |
| Default `CachingHttpClient::max_ttl` | Ограничение 86400 секундами; `null` deprecated |

Allow-list — осознанное ослабление конкретного ограничения, а не универсальная защита от SSRF. [Изменения HttpClient](https://symfony.com/blog/new-in-symfony-8-1-httpclient-improvements)

## Messenger: batch fetching и обработка ошибок декодирования

```bash
php bin/console messenger:consume async --fetch-size=8
php bin/console messenger:consume async --no-reset=100
```

`fetch-size` просит transport получать сообщения пачкой; это не параллельный запуск восьми handlers. Поддержка зависит от transport. Числовой `no-reset` сбрасывает сервисы через N сообщений вместо default-сброса после каждого. Увеличение интервала требует контроля утечек состояния между сообщениями.

Ошибки декодирования теперь проходят через обычный retry/failure pipeline. Это важно после переименования классов: сообщение можно сохранить для диагностики и повторить после исправления декодера. Собственные serializers/receivers нужно сверить с изменёнными контрактами.

Также появились `AsMessage::serializedTypeName`, AMQP priority stamp, idle timeout batch handlers, просмотр Redis messages, доработки PostgreSQL LISTEN/NOTIFY и освобождение deduplication lock при окончательной ошибке. [Messenger 8.1](https://symfony.com/blog/new-in-symfony-8-1-messenger-improvements)

## Другие существенные изменения

| Область | Что важно |
| --- | --- |
| ObjectMapper | Mapping на target-классе, `IsNotNull`, target класса коллекции, более ясные ошибки callable |
| JsonStreamer/JsonPath | Value object transformers, DateInterval/DateTimeZone, default options, пользовательские JSONPath-функции |
| Cache attribute | `request`/`args` в выражениях, условия `if`, повторяемость; closures требуют подходящего PHP |
| HttpKernel | Динамические controller attributes и отдельные события атрибутов |
| Form | Доработки flows, daisyUI theme, управление UID-форматом, исправление unchecked checkbox; PATCH сохраняет отдельную семантику |
| Validator | `Xml` с необязательным XSD, Clock-aware относительные даты, проверка property metadata, `validateInContext()` |
| DI | `AsTagDecorator`, service stacks как decorators, явный `Target`, env closures |
| Translation | XLIFF 2.1/2.2 и PGS, locale fallback provider, env в enabled locales |
| DX/Lock/Webhook | cURL из profiler, CSP-aware dump, отдельные marshallers pool, изоляция системных locks по проекту, настройка webhook headers/HMAC |

У `IsNotNull` есть предметное ограничение: `null` теперь означает «пропустить присваивание». Если API должен отличать отсутствие поля от явного запроса очистить его, нужна отдельная модель PATCH. [ObjectMapper 8.1](https://symfony.com/blog/new-in-symfony-8-1-objectmapper-improvements)

Для собственного validator, наследующего `ConstraintValidator`, базовый класс помогает перейти на reentrant-вызовы. При прямой реализации `ConstraintValidatorInterface` нужен новый `validateInContext()`. [Validator 8.1](https://symfony.com/blog/new-in-symfony-8-1-validator-improvements)

## Что проверить при обновлении

В 8.1 появились deprecations неявного named autowiring по имени аргумента без `Target`, прямого присваивания public bags Request/Response и некоторых старых HttpKernel-классов. Для listeners, которые заменяют controller, важно сохранить применимые атрибуты: проверки безопасности и кеширования теперь иначе упорядочены в событиях.

Полный список сигнатур, совместимых замен и помеченных `[BC BREAK]` случаев — в [UPGRADE-8.1](https://github.com/symfony/symfony/blob/8.1/UPGRADE-8.1.md). Все тематические публикации, включая дополнительные небольшие изменения, — в [официальной серии 8.1](https://symfony.com/blog/category/living-on-the-edge/8.1).
