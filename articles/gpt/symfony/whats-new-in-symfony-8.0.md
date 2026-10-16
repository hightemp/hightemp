# Что нового в Symfony 8.0: PHP 8.4, native lazy objects и новые контракты компонентов

Symfony 8.0 вышел в ноябре 2025 года и требует **PHP 8.4+**. Вместе с Symfony 7.4 он получил form flows, подпись Messenger-сообщений, новый формат PHP-конфигурации и другие функции релизной пары. Главное отличие 8.0 — удаление deprecated API 7.x и возможность опираться на PHP 8.4 как на минимальную платформу. [Страница версии](https://symfony.com/releases/8.0)

На **16 октября 2026 года** ветка 8.0 уже не поддерживается: обычная поддержка закончилась в июле 2026 года. Для обновления на актуальную 8.x целевой веткой служит поддерживаемая 8.1. Для долгосрочного цикла отдельно рассматривают 7.4 LTS. [Календарь Symfony](https://symfony.com/releases), [оглавление серии](symfony-release-overviews.md)

## Что общее у 7.4 и 8.0

| Возможность | Что даёт |
| --- | --- |
| Form flows | Многошаговые формы с навигацией и validation groups |
| `App::config()` | PHP-массивы конфигурации с генерируемыми array shapes |
| Signed messages | Контроль подписи Messenger-сообщений |
| Caching HttpClient | HTTP-кеш на tag-aware pool по RFC 9111 |
| ControllerHelper | Helpers контроллера через DI |
| Console `MapInput` | Аргументы и опции команды в DTO |
| Metadata extension attributes | Дополнение правил сторонних классов |

Примеры настройки этих возможностей — в [обзоре Symfony 7.4](whats-new-in-symfony-7.4.md). Они не требуют новой major-ветки сами по себе. Дальше разберём, какие изменения нужно учесть именно при переходе на 8.0.

## PHP 8.4 становится обязательным

Сверяют версию PHP не только у web-процесса, но и в CLI, consumers, cron и образах сборки. Composer разрешает зависимости под ту платформу, которую ему показывает окружение или `config.platform`; это не доказывает, что на сервере действительно установлен нужный PHP.

```json
{
    "require": {
        "php": ">=8.4",
        "symfony/framework-bundle": "8.0.*"
    },
    "extra": {
        "symfony": {
            "require": "8.0.*"
        }
    }
}
```

Это фрагмент исторического ограничения для изучения 8.0, а не рекомендация зафиксировать неподдерживаемую ветку в новом проекте. В действующем Composer-файле ограничения согласуют у всех явно требуемых Symfony-компонентов и сторонних bundles.

## Native lazy objects вместо старых VarExporter traits

В VarExporter удалены `LazyGhostTrait`, `LazyProxyTrait` и генерация старых lazy ghosts через `ProxyHelper::generateLazyGhost()`. Для обычных ленивых объектов используется механизм PHP 8.4. [Переход VarExporter](https://github.com/symfony/symfony/blob/8.0/UPGRADE-8.0.md#varexporter)

Упрощённый пример механики PHP, без Doctrine и контейнера:

```php
final class Profile
{
    public string $name;
}

$reflection = new \ReflectionClass(Profile::class);
$profile = $reflection->newLazyGhost(static function (Profile $profile): void {
    // Здесь могла бы быть дорогая загрузка данных.
    $profile->name = 'Ada';
});

echo $profile->name; // Инициализация происходит при обращении к свойству.
```

`newLazyGhost()` принимает initializer, который заполняет этот же объект при необходимости. Он не создаёт автоматически запрос к БД. Doctrine ORM, DoctrineBundle и Symfony DI подключают собственные политики инициализации.

Практический вывод: если код напрямую использовал удалённый trait, его нужно переписать. Если lazy-сервисы создаёт контейнер или ORM, проверяют совместимость соответствующих пакетов. Нельзя только заменить Symfony и считать все расширения отладчика совместимыми с новым механизмом PHP. [PHP: lazy objects](https://www.php.net/manual/en/language.oop5.lazy-objects.php)

## Конфигурация: отказаться от удалённых форматов

В 7.4 XML-конфигурация DI и маршрутов и generated fluent builders получили предупреждения. В 8.0 нужно перейти на поддерживаемые YAML/PHP-форматы:

```php
// config/packages/framework.php
namespace Symfony\Component\DependencyInjection\Loader\Configurator;

return App::config([
    'framework' => [
        'secret' => env('APP_SECRET'),
        'http_method_override' => false,
    ],
]);
```

Обычный PHP services DSL через `ContainerConfigurator` остаётся отдельной поддерживаемой возможностью. У bundle extensions удалены XML-ориентированные `getNamespace()`/`getXsdValidationBasePath()`. Также меняют ссылки на стандартные routing resources вроде `profiler.xml` на предусмотренные PHP-эквиваленты.

Это изменение конфигурационных загрузчиков. Поддержка XML как формата внешних данных, например у Serializer, — другой вопрос. [Config и DI в руководстве миграции](https://github.com/symfony/symfony/blob/8.0/UPGRADE-8.0.md#dependencyinjection)

## `TaggedIterator` и `TaggedLocator`: новые имена обязательны

Старые атрибуты заменены на `AutowireIterator` и `AutowireLocator`:

```php
use Symfony\Component\DependencyInjection\Attribute\AutowireIterator;

final class ReportPipeline
{
    public function __construct(
        #[AutowireIterator('app.report_processor')]
        private iterable $processors,
    ) {
    }
}
```

Сервисы должны быть помечены указанным тегом. Для lazy-доступа по ключу используют `AutowireLocator`. В YAML удалён старый `!tagged`; предусмотрен `!tagged_iterator`. [Изменения DI](https://github.com/symfony/symfony/blob/8.0/src/Symfony/Component/DependencyInjection/CHANGELOG.md)

## Doctrine resolver больше не угадывает mapping

Нельзя полагаться на старое автоматическое использование route-параметров как критериев сущности. Поиск описывают явно:

```php
use App\Entity\Article;
use Symfony\Bridge\Doctrine\Attribute\MapEntity;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/articles/{id}')]
public function show(#[MapEntity(id: 'id')] Article $article): Response
{
    return new Response($article->getTitle());
}
```

Для другого поля используют `mapping`, для нескольких сущностей — явные настройки каждого аргумента или синтаксис route mapping. Также удалены aliases маршрутизации из `Routing\Annotation`: импортируют `Routing\Attribute\Route`. [Doctrine Bridge](https://github.com/symfony/symfony/blob/8.0/src/Symfony/Bridge/Doctrine/CHANGELOG.md), [Routing](https://github.com/symfony/symfony/blob/8.0/src/Symfony/Component/Routing/CHANGELOG.md)

## `Request::get()` удалён

Старый вызов смешивал источники значения. Теперь выбор отражён в коде:

```php
$slug = $request->attributes->get('slug');
$search = $request->query->getString('q');
$message = $request->request->getString('message');
$payload = $request->getPayload()->all();
```

При переносе нужно восстановить первоначальный смысл параметра, а не заменить все вызовы на `$request->request->get()`. Иначе query-параметры внезапно перестанут читаться, либо поменяется приоритет данных.

Из HTTP method override убраны значения GET/HEAD/CONNECT/TRACE. Устаревшие настройки `NativeSessionStorage`, включая управление длиной session ID, также удалены. [HttpFoundation 8.0](https://github.com/symfony/symfony/blob/8.0/src/Symfony/Component/HttpFoundation/CHANGELOG.md)

## PropertyInfo переходит на TypeInfo

Удалён `PropertyInfo\Type`. Методы `getTypes()`/`getTypesFromConstructor()` заменяются на возвращающие новый объект типа `getType()`/`getTypeFromConstructor()`:

```php
// Было:
$types = $extractor->getTypes(Product::class, 'name');

// Стало:
$type = $extractor->getType(Product::class, 'name');
```

Изменилось не только имя метода. Раньше возвращался массив старых типов, теперь — `TypeInfo\Type` либо `null`. Union, nullable и generics описываются новым деревом типов; перебор старого массива нужно пересмотреть.

Самостоятельные реализации type extractor должны обновить интерфейс и сигнатуру. [PropertyInfo migration](https://github.com/symfony/symfony/blob/8.0/UPGRADE-8.0.md#propertyinfo)

## Validator: конструкторы constraints нужно обновить

Прекращено использование старой автоматической интерпретации массива опций в базовом `Constraint`. Встроенные constraints вызывают через явные аргументы:

```php
use Symfony\Component\Validator\Constraints as Assert;

$constraint = new Assert\Choice(
    choices: ['draft', 'published'],
    message: 'Неизвестный статус',
);
```

Собственный constraint должен инициализировать свои свойства и вызвать родительский конструктор для общих параметров:

```php
use Symfony\Component\Validator\Constraint;

#[\Attribute(\Attribute::TARGET_PROPERTY)]
final class StartsWith extends Constraint
{
    public function __construct(
        public string $prefix,
        public string $message = 'Недопустимый префикс',
        ?array $groups = null,
        mixed $payload = null,
    ) {
        parent::__construct(groups: $groups, payload: $payload);
    }
}
```

Для этого класса требуется отдельный `StartsWithValidator`; сам constraint только описывает правило. У `Url` значение `requireTld` по умолчанию стало `true`, что может повлиять на локальные имена хостов. [Validator 8.0](https://github.com/symfony/symfony/blob/8.0/src/Symfony/Component/Validator/CHANGELOG.md)

## Security и сериализация пользователя

Удалены `UserInterface::eraseCredentials()` и `TokenInterface::eraseCredentials()`. Если приложение рассчитывало, что этот callback очистит временные поля, нужно пересмотреть жизненный цикл секретов. Для сессионной сериализации пользователя определяют контролируемый `__serialize()`, исключающий временный открытый пароль; password hash и поля, необходимые механизму refresh/equality пользователя, обрабатывают согласно контракту приложения.

Пустой идентификатор в `UserBadge` теперь отклоняется. Собственным voters/strategies/user checkers потребуются новые параметры методов: `Vote`, `AccessDecision` и token там, где это предусмотрено интерфейсом. [Security migration](https://github.com/symfony/symfony/blob/8.0/UPGRADE-8.0.md#security)

## Что ещё проверить

| Область | Важная замена или изменение |
| --- | --- |
| RateLimiter | DI по `RateLimiterFactoryInterface`, а не старому concrete alias |
| HttpClient | `CachingHttpClient` принимает tag-aware cache вместо старого HttpCache Store |
| Console | `Application::addCommand()` вместо удалённого `add()`; новые требования к callbacks |
| BrowserKit/DomCrawler | Нативный HTML5-парсер, без старого переключателя Masterminds |
| Serializer | Импорты `Attribute` вместо удалённых `Annotation` aliases, новый контракт name converter |
| Workflow | Получать workflow через DI вместо удалённого `Event::getWorkflow()` |
| Bundles | Часть классов стала `final`; вместо наследования может потребоваться decoration |

Полный список, включая дополнительные параметры методов и изменения отдельных bridges, — в [UPGRADE-8.0](https://github.com/symfony/symfony/blob/8.0/UPGRADE-8.0.md).

## Практический порядок обновления

Рабочая отправная точка — последняя подходящая 7.4 с устранёнными deprecations. Затем сверяют PHP всех процессов, Composer-ограничения, bundles, конфигурационные загрузчики и собственные реализации интерфейсов. После перехода перезапускают workers уже в рамках процедуры развёртывания, чтобы старые процессы не остались с предыдущим кодом.

Для нового кода ветки 8.x далее полезен [обзор Symfony 8.1](whats-new-in-symfony-8.1.md).
