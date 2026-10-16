# Что нового в Symfony 7.3: ObjectMapper, JsonStreamer, SSE и команды из обычных классов

Symfony 7.3 вышел в мае 2025 года и требует PHP 8.2+. Релиз добавил три компонента — ObjectMapper, JsonStreamer и JsonPath — и заметно сократил служебный код вокруг Console, SSE и Twig. [Страница версии](https://symfony.com/releases/7.3)

На **16 октября 2026 года** ветка 7.3 уже не поддерживается. В статье показано, что появилось именно в ней; продолжение развития этих API разобрано в следующих обзорах. [Оглавление серии](symfony-release-overviews.md)

## ObjectMapper: перенос данных между объектами

Serializer переводит данные в транспортное представление и обратно. ObjectMapper решает другую практическую задачу: перенести значения из одного объекта в другой, например из входного DTO в модель приложения.

```php
use Symfony\Component\ObjectMapper\Attribute\Map;

final class Product
{
    public string $title = '';
    public string $sku = '';
}

#[Map(target: Product::class)]
final class ProductInput
{
    #[Map(target: 'title')]
    public string $name = '';

    #[Map(transform: 'strtoupper')]
    public string $sku = '';
}
```

```php
use Symfony\Component\ObjectMapper\ObjectMapperInterface;

// $mapper — внедрённый ObjectMapperInterface.
$input = new ProductInput();
$input->name = 'Клавиатура';
$input->sku = 'kbd-01';

$product = $mapper->map($input);
// $product->title === 'Клавиатура'; $product->sku === 'KBD-01'.
```

`map($source, Product::class)` явно задаёт создаваемый тип. `map($source, $existingProduct)` обновляет существующий объект. `Map::target` на свойстве меняет имя назначения, `transform` преобразует значение, `if` управляет условным переносом.

Mapping не выполняет авторизацию и не сохраняет сущность в БД. Входной DTO должен содержать только разрешённые к изменению поля: перенос `roles`, `ownerId` или цены из произвольного объекта требует отдельной проверки.

В 7.3 ObjectMapper появился как **экспериментальный компонент**. При обновлении его API сверяют отдельно. [Введение ObjectMapper](https://symfony.com/blog/new-in-symfony-7-3-objectmapper-component)

## JsonPath: выборки из JSON по RFC 9535

Для вложенного JSON можно описать путь к данным вместо нескольких циклов:

```php
use Symfony\Component\JsonPath\JsonCrawler;

$json = '{"products":[{"name":"Book","price":12},{"name":"Pen","price":3}]}';
$crawler = new JsonCrawler($json);

$names = $crawler->find('$.products[*].name');
// ['Book', 'Pen']

$cheapNames = $crawler->find('$.products[?(@.price < 10)].name');
// ['Pen']
```

`$` обозначает корень, `[*]` — элементы коллекции, `@` — текущий элемент фильтра. `find()` возвращает **список совпадений**, даже если найдено одно значение. Для построения запроса кодом есть объект `JsonPath` с методами `key()`, `index()` и другими операциями.

Компонент следует [RFC 9535](https://www.rfc-editor.org/rfc/rfc9535): стандарту языка выборок из JSON. Он определяет пути, фильтры и результаты выборки; выполнение такого пути не изменяет исходный документ. [Обзор JsonPath](https://symfony.com/blog/new-in-symfony-7-3-jsonpath-component)

## JsonStreamer: читать и писать большие JSON-последовательности

Полный Serializer гибок, но иногда задача проще: последовательно записать множество однотипных DTO. JsonStreamer использует явное описание типов и потоковую обработку:

```php
use Symfony\Component\JsonStreamer\Attribute\JsonStreamable;

#[JsonStreamable]
final class ProductView
{
    public string $name = '';
    public int $stock = 0;
}
```

```php
use Symfony\Component\HttpFoundation\StreamedResponse;
use Symfony\Component\JsonStreamer\StreamWriterInterface;
use Symfony\Component\TypeInfo\Type;

// Фрагмент action: $rows — список подготовленных ProductView.
public function export(StreamWriterInterface $writer): StreamedResponse
{
    $row = new ProductView();
    $row->name = 'Book';
    $row->stock = 7;
    $rows = [$row];

    $chunks = $writer->write($rows, Type::list(Type::object(ProductView::class)));

    return new StreamedResponse($chunks, headers: [
        'Content-Type' => 'application/json',
    ]);
}
```

Writer возвращает перебираемые строковые фрагменты. Для чтения используется `StreamReaderInterface`: входом может быть JSON-строка или ресурс, а ожидаемый тип задают через TypeInfo. `Type::iterable(...)` позволяет обрабатывать декодируемые элементы последовательно.

Экономия памяти исчезает на других этапах, если сначала загрузить всю БД через `findAll()` или собрать весь результат через `iterator_to_array()`. Также нужно учитывать HTTP-буферизацию. В 7.3 JsonStreamer экспериментален; он не повторяет весь API normalizers/groups обычного Serializer. [Введение JsonStreamer](https://symfony.com/blog/new-in-symfony-7-3-jsonstreamer-component)

## SSE: `EventStreamResponse` и `ServerEvent`

Для небольшого потока уведомлений больше не обязательно вручную собирать строки `event:`/`data:`:

```php
use Symfony\Component\HttpFoundation\EventStreamResponse;
use Symfony\Component\HttpFoundation\ServerEvent;

public function progress(): EventStreamResponse
{
    return new EventStreamResponse(static function (): \Generator {
        foreach ([25, 50, 100] as $percent) {
            yield new ServerEvent(
                json_encode(['percent' => $percent], JSON_THROW_ON_ERROR),
                type: 'progress',
                id: (string) $percent,
            );
        }
    });
}
```

`ServerEvent` описывает `data`, `type`, `id`, `retry` и комментарий. `EventStreamResponse` задаёт SSE-заголовки и отправляет события callback/generator. Указание `id` помогает клиенту сообщить `Last-Event-ID` после reconnect, но хранение истории и повтор пропущенных событий нужно реализовать отдельно.

SSE — однонаправленный HTTP-поток от сервера. Авторизация, предел числа подключений, тайм-ауты и буферизация proxy остаются задачами приложения и окружения. Для fan-out и масштабирования полезен отдельный hub, например Mercure. [Новое API SSE](https://symfony.com/blog/new-in-symfony-7-3-simpler-server-event-streaming), [подробный пример в этой папке](symfony-sse-event-stream-example.md)

## Invokable-команды и атрибуты входных данных

Класс команды теперь может обходиться без наследования от `Command`:

```php
namespace App\Command;

use Symfony\Component\Console\Attribute\Argument;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Attribute\Option;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(name: 'app:greet', description: 'Вывести приветствие')]
final class GreetCommand
{
    public function __invoke(
        SymfonyStyle $io,
        #[Argument(description: 'Имя получателя')] string $name,
        #[Option(description: 'Число повторений')] int $times = 1,
    ): int {
        if ($times < 1 || $times > 10) {
            $io->error('Укажите от 1 до 10 повторений');
            return Command::INVALID;
        }

        for ($i = 0; $i < $times; ++$i) {
            $io->writeln('Привет, '.$name);
        }

        return Command::SUCCESS;
    }
}
```

Запуск: `php bin/console app:greet Ada --times=2`. Имя аргумента/опции выводится из PHP-параметра; default делает аргумент необязательным. У опций должен быть default. Доступны имя, описание, shortcut и подсказки значений. SymfonyStyle внедряется как инфраструктурный аргумент.

Старый API `configure()`/`execute()` продолжает работать. [Invokable commands и input attributes](https://symfony.com/blog/new-in-symfony-7-3-invokable-commands-and-input-attributes)

## Namespace кеша: один ключ в разных контекстах

`NamespacedPoolInterface::withSubNamespace()` создаёт представление кеша с дополнительным namespace:

```php
use Symfony\Component\Cache\Adapter\FilesystemAdapter;
use Symfony\Contracts\Cache\ItemInterface;

$cache = new FilesystemAdapter();
$tenantCache = $cache->withSubNamespace('tenant-42-v1');

$value = $tenantCache->get('dashboard', static function (ItemInterface $item): array {
    $item->expiresAfter(600);
    return ['orders' => 12];
});
```

`dashboard` другого tenant не пересекается с этим ключом. Namespace должен отражать все значимые отличия данных, включая права или версию представления, если они влияют на результат.

Сам вызов `withSubNamespace()` не удаляет предыдущие записи. Для смены версии набора можно использовать новый namespace; старые записи живут до очистки/TTL. [Namespaced caches](https://symfony.com/blog/new-in-symfony-7-3-namespaced-caches)

## Messenger: дедупликация и управление соединениями

Появился `DeduplicateStamp`:

```php
use Symfony\Component\Messenger\Stamp\DeduplicateStamp;

$bus->dispatch(new RefreshProductIndex(42), [
    new DeduplicateStamp('refresh-product-42', ttl: 300),
]);
```

`RefreshProductIndex` — сообщение приложения. Ключ задаёт **сам разработчик**; middleware использует Lock, чтобы не поставить дубликат с тем же ключом, пока действует блокировка. Нужен подходящий общий lock store. Настройка TTL должна соответствовать времени ожидания и обработки; это не вечная запись об уже выполненной операции.

Дополнительно появились keepalive у Doctrine transport, закрытие соединений через `CloseableTransportInterface`, фильтрация failed messages при удалении и запуск shell-команд через `RunProcessMessage::fromShellCommandline()`. Shell-вариант требует отдельно учитывать экранирование пользовательских данных. [Изменения Messenger](https://symfony.com/blog/new-in-symfony-7-3-messenger-improvements), [реализация дедупликации](https://github.com/symfony/symfony/blob/7.3/src/Symfony/Component/Messenger/Middleware/DeduplicateMiddleware.php)

## Voters объясняют причину решения

В `voteOnAttribute()` можно принять дополнительный `?Vote $vote = null` и вызвать `$vote?->addReason('Заказ уже закрыт')`. Причины помогают читать profiler, логи и страницы исключений. Сообщения должны быть пригодны для соответствующего уровня видимости: не включайте в них секреты или данные, которые нельзя раскрывать пользователю. [Объяснения voters](https://symfony.com/blog/new-in-symfony-7-3-explaining-security-voter-decisions)

## Остальные изменения

| Область | Что появилось |
| --- | --- |
| Twig Bridge | Регистрация фильтров и функций через `AsTwigFilter`/`AsTwigFunction` в совместимой версии Twig |
| Validator | `When::otherwise`, `Slug`, `Twig`, расширения File/Image/Unique; устаревание массивов опций constraints |
| RateLimiter | Настройка составного limiter |
| AssetMapper | Предварительное сжатие ассетов |
| HttpKernel | Генерация статических страниц ошибок |
| Security/Mailer | Дополнительные проверки пользователя и доработки безопасности почтовых интеграций |
| Translation/DI/Yaml | Глобальные параметры переводов и новые варианты конфигурации |

Статические closures непосредственно в PHP-атрибутах требуют PHP 8.5: поддержка callback в компоненте не отменяет ограничений синтаксиса самого PHP. [Validator 7.3](https://symfony.com/blog/new-in-symfony-7-3-validator-improvements)

## Подготовка к обновлению

Проверяют experimental ObjectMapper/JsonStreamer, собственные voter-сигнатуры, контракты transport и новые deprecations constraints. Не стоит переносить обещание «minor без несовместимостей» на экспериментальные компоненты. [UPGRADE-7.3](https://github.com/symfony/symfony/blob/7.3/UPGRADE-7.3.md) и [полная серия релиза](https://symfony.com/blog/category/living-on-the-edge/7.3) дают дополнительные детали. Далее — [Symfony 7.4](whats-new-in-symfony-7.4.md).
