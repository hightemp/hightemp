# Что нового в Symfony 6.3: DTO из запроса, Scheduler, AssetMapper и webhooks

Symfony 6.3 вышел в мае 2023 года, сохранив требование PHP 8.1+. Это один из самых насыщенных релизов периода: появились Scheduler, AssetMapper, Webhook и RemoteEvent, а входные данные HTTP-запроса стало проще превращать в типизированные объекты. [Страница версии](https://symfony.com/releases/6.3)

Материал сверён **16 октября 2026 года**. Ветка 6.3 уже не поддерживается; статья объясняет происхождение возможностей, которые затем развивались в следующих версиях. [Оглавление серии](symfony-release-overviews.md)

## DTO вместо ручного разбора JSON

Раньше контроллер часто сам декодировал JSON, собирал DTO, запускал Validator и превращал ошибки в HTTP-ответ. Атрибут `MapRequestPayload` связывает эти шаги:

```php
// src/Dto/CreateArticle.php
namespace App\Dto;

use Symfony\Component\Validator\Constraints as Assert;

final class CreateArticle
{
    public function __construct(
        #[Assert\NotBlank]
        #[Assert\Length(max: 160)]
        public readonly string $title,

        #[Assert\Positive]
        public readonly int $categoryId,
    ) {
    }
}
```

```php
// Фрагмент контроллера: сохранение в БД опущено.
use App\Dto\CreateArticle;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Annotation\Route;

#[Route('/api/articles', methods: ['POST'], format: 'json')]
public function create(
    #[MapRequestPayload(acceptFormat: 'json')] CreateArticle $input,
): JsonResponse {
    return new JsonResponse(['title' => $input->title], 201);
}
```

Клиент отправляет `Content-Type: application/json` и тело `{"title":"Symfony","categoryId":7}`. До вызова метода Symfony десериализует тело и проверит ограничения DTO. `format: 'json'` задаёт формат маршрута и помогает возвращать ошибки в JSON; заголовок `Content-Type` описывает формат **входного тела**.

В API Symfony 6.3 у `MapRequestPayload` есть следующие параметры:

| Параметр | Назначение |
| --- | --- |
| `acceptFormat` | Допустимый формат или список форматов; `null` не задаёт дополнительного ограничения |
| `serializationContext` | Контекст десериализации, например группы или правила дополнительных полей |
| `validationGroups` | Группы Validator; без указания используется обычная валидация |
| `resolver` | Класс или идентификатор специализированного resolver вместо стандартного |

Ошибки ограничений DTO и обнаруженные при mapping несовпадения типов по умолчанию дают **422**, синтаксически некорректный JSON — **400**, неподдерживаемый формат — **415**. Типизация DTO не заменяет бизнес-проверки: существование категории и право пользователя создать запись проверяет приложение. Нужны компоненты Serializer и Validator с соответствующими нормализаторами. [Введение request mapping](https://symfony.com/blog/new-in-symfony-6-3-mapping-request-data-to-typed-objects)

## Query string: весь объект или отдельный параметр

Для объекта поиска используется `MapQueryString`:

```php
use Symfony\Component\Validator\Constraints as Assert;

final class SearchArticles
{
    public function __construct(
        #[Assert\Range(min: 1, max: 100)]
        public readonly int $limit = 20,
        public readonly string $query = '',
    ) {
    }
}
```

```php
use Symfony\Component\HttpKernel\Attribute\MapQueryString;

public function search(#[MapQueryString] SearchArticles $filter = new SearchArticles()): JsonResponse
{
    return new JsonResponse(['limit' => $filter->limit]);
}
```

Так `?limit=50&query=cache` превращается в аргумент `$filter`. При пустой query string используется default аргумента action. Без него обязательный non-nullable аргумент в 6.3 приводит к 404, даже если конструктор DTO имеет собственные defaults. Атрибут 6.3 принимает `serializationContext`, `validationGroups` и `resolver`.

У этой возможности есть важная особенность: **в 6.3 ошибка валидации query DTO по умолчанию даёт 404**, а не 422. Для payload используется другой код. Точное поведение видно в [RequestPayloadValueResolver ветки 6.3](https://github.com/symfony/symfony/blob/6.3/src/Symfony/Component/HttpKernel/Controller/ArgumentResolver/RequestPayloadValueResolver.php). Параметры настройки статуса из более новых руководств нельзя переносить в 6.3 без сверки API.

Если объект избыточен, можно связать отдельный query-параметр с аргументом:

```php
use Symfony\Component\HttpKernel\Attribute\MapQueryParameter;

public function list(
    #[MapQueryParameter] int $page = 1,
    #[MapQueryParameter(filter: \FILTER_VALIDATE_INT)] array $ids = [],
): JsonResponse {
    return new JsonResponse(['page' => $page, 'ids' => $ids]);
}
```

`name` позволяет переопределить имя параметра, `filter` и `options` задают фильтрацию. Query string состоит из строк: не стоит ожидать от произвольной непустой строки автоматического бизнес-смысла `true`. [MapQueryParameter](https://symfony.com/blog/new-in-symfony-6-3-query-parameters-mapper)

## `Request::getPayload()`: единая точка доступа к данным тела

Метод возвращает `InputBag`: данные формы, если они уже есть в `$request->request`, либо декодированное JSON-тело:

```php
$payload = $request->getPayload();
$title = $payload->getString('title');
$allData = $payload->all();
```

Это удобно для небольших обработчиков, где DTO пока не нужен. Метод не объединяет query string, файлы и JSON в один массив. Загруженные файлы остаются в `$request->files`; некорректное JSON-содержимое не становится автоматически пустым массивом. [Новый Request payload API](https://symfony.com/blog/new-in-symfony-6-3-request-payload)

## Scheduler: повторяющиеся сообщения через Messenger

Scheduler задаёт, какие сообщения должны появляться по расписанию:

```php
namespace App\Scheduler;

use App\Message\CheckPendingOrders;
use Symfony\Component\Scheduler\Attribute\AsSchedule;
use Symfony\Component\Scheduler\RecurringMessage;
use Symfony\Component\Scheduler\Schedule;
use Symfony\Component\Scheduler\ScheduleProviderInterface;

#[AsSchedule('orders')]
final class OrdersSchedule implements ScheduleProviderInterface
{
    public function getSchedule(): Schedule
    {
        return (new Schedule())->add(
            RecurringMessage::every('10 minutes', new CheckPendingOrders()),
        );
    }
}
```

`CheckPendingOrders` и его Messenger-handler — обычные классы приложения. Чтобы расписание выполнялось, нужен работающий consumer:

```bash
php bin/console messenger:consume scheduler_orders -v
```

`orders` берётся из `AsSchedule`. `every()` принимает частоту и сообщение, а `from` и `until` ограничивают период действия. Для cron-выражений есть `RecurringMessage::cron()` и соответствующая зависимость парсера.

Scheduler не устанавливает системный cron и не запускает daemon сам. Его transport генерирует сообщения, а worker обрабатывает их; жизненным циклом worker управляет окружение развёртывания. В нескольких репликах отдельно продумывают блокировки, состояние расписания и идемпотентность обработчика. [Как устроен Scheduler](https://symfony.com/blog/new-in-symfony-6-3-scheduler-component)

## AssetMapper: import maps и адреса ассетов с версией

AssetMapper связывает исходные CSS/JS/изображения с публичными адресами, включающими хеш содержимого. Import map объясняет браузеру, где брать JavaScript-модули:

```yaml
# config/packages/asset_mapper.yaml
framework:
    asset_mapper:
        paths: ['assets/']
```

```twig
{# templates/base.html.twig: внутри head #}
{{ importmap('app') }}
```

```bash
php bin/console importmap:require @hotwired/stimulus
php bin/console asset-map:compile --env=prod
```

Первая команда регистрирует зависимость в `importmap.php`. Вторая готовит файлы и manifest в `public/assets` для production. Браузер получает ES-модули; наличие `importmap()` не компилирует TypeScript, JSX или Sass. Для таких исходников нужен отдельный подходящий инструмент.

В начальной версии 6.3 внешние import-map зависимости могли ссылаться на CDN. Локальное скачивание vendor-ассетов и расширенная работа с CSS развиваются в 6.4. [Обзор AssetMapper 6.3](https://symfony.com/blog/new-in-symfony-6-3-assetmapper-component)

## Webhook и RemoteEvent: отделить HTTP от обработки события

Новые компоненты разделяют интеграцию с внешним сервисом на два этапа:

1. Parser распознаёт запрос, проверяет его формат и подлинность, создаёт `RemoteEvent`.
2. Consumer получает нормализованное событие и выполняет действие приложения.

Например, разные поставщики почты могут сообщать о доставке письма разными JSON-структурами. Parser конкретного поставщика преобразует их в понятный приложению event. Интеграции с Mailer и Notifier дают готовые связующие части.

Проверка подписи и защита от повторной обработки остаются существенной частью интеграции. Наличие нужного поля в JSON не доказывает, что webhook прислал доверенный сервис. [Webhook и RemoteEvent](https://symfony.com/blog/new-in-symfony-6-3-webhook-and-remoteevent-components)

## Другие изменения, которые стоит знать

| Область | Новшество |
| --- | --- |
| Security | OIDC token handler, развитие login/logout, `PasswordStrength` |
| Validator | `NoSuspiciousCharacters` для обнаружения подозрительных Unicode-символов |
| HttpKernel | Targeted value resolvers, атрибуты для HTTP-статуса и уровня логирования исключений |
| HttpClient | Улучшения клиента и ранние подсказки HTTP 103 Early Hints |
| DI | Новые варианты autowiring и настройка контейнера |
| Serializer | Команда `debug:serializer` для просмотра metadata |
| Остальное | Доработки Form, Clock, enum, profiler, emoji и производительности |

Ограничение силы пароля и проверка Unicode не заменяют общую политику аутентификации и нормализации пользовательских имён. Подробности отдельных возможностей и интеграций — в [официальной серии релиза](https://symfony.com/blog/category/living-on-the-edge/6.3).

## Переход с 6.2

Практические кандидаты на перенос — контроллеры с ручным `json_decode()` и Validator, повторяющиеся задания и интеграционные HTTP-callbacks. Сначала фиксируют текущие HTTP-коды и формат ошибок API, затем заменяют ручной код resolver-атрибутами. Ручную валидацию нельзя просто удалить, если в ней были бизнес-правила, которых нет в DTO.

Изменения интерфейсов, предупреждения об устаревании и частные несовместимости перечислены в [UPGRADE-6.3](https://github.com/symfony/symfony/blob/6.3/UPGRADE-6.3.md). Следующий обзор — [Symfony 6.4](whats-new-in-symfony-6.4.md).
