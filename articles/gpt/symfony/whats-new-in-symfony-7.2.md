# Что нового в Symfony 7.2: stateless CSRF, named serializers и живые очереди

Symfony 7.2 вышел в ноябре 2024 года и требует PHP 8.2+. Основные практические изменения касаются независимости от сессии, нескольких контрактов сериализации, крупных форм и долгих Messenger-задач. Новый TypeInfo после экспериментального этапа стал стабильным. [Страница версии](https://symfony.com/releases/7.2)

Состояние сведений — **16 октября 2026 года**. Ветка 7.2 уже не поддерживается; примеры объясняют изменения конкретного релиза. [Вся серия](symfony-release-overviews.md)

## Stateless CSRF: защита без хранения токена в серверной сессии

Традиционная CSRF-защита связывает токен с сессией пользователя. Это неудобно для кешируемых страниц и форм, которые открыты дольше жизни сессии. В 7.2 выбранные идентификаторы токенов можно обслуживать без такого серверного состояния:

```yaml
# config/packages/framework.yaml
framework:
    form:
        csrf_protection:
            token_id: submit
    csrf_protection:
        stateless_token_ids: ['submit', 'authenticate', 'logout']
```

`stateless_token_ids` — явный список ID, для которых используется новый механизм. Другие токены не переводятся в него автоматически. Проверка учитывает `Origin`/`Referer`; клиентская интеграция может дополнять её double-submit механизмом: согласованными значениями cookie и переданного токена.

| Опция | Назначение |
| --- | --- |
| `stateless_token_ids` | ID токенов, обслуживаемых stateless-механизмом |
| `cookie_name` | Имя cookie; default — `csrf-token` |
| `check_header` | Дополнительная проверка токена через HTTP-заголовок |

Нужно корректно определять origin приложения. За reverse proxy это зависит от trusted proxy/header-настроек. Если ваш вариант использует double-submit, необходима соответствующая клиентская логика; одну строку YAML нельзя считать заменой всей интеграции.

Новые рецепты Flex включили stateless CSRF для распространённых ID. Обновление Composer-зависимостей существующего приложения само по себе не гарантирует применение нового рецепта. [Объяснение механизма](https://symfony.com/blog/new-in-symfony-7-2-stateless-csrf)

## Named serializers: отдельный контракт для каждого API

Поставщик A ждёт `snake_case`, поставщик B — другой формат даты. Раньше приходилось передавать нужный контекст вручную в каждом вызове. В 7.2 можно создать несколько именованных serializer:

```yaml
# config/packages/serializer.yaml
framework:
    serializer:
        named_serializers:
            partner_api:
                name_converter: serializer.name_converter.camel_case_to_snake_case
                default_context:
                    datetime_format: 'Y-m-d\TH:i:sP'
            internal_api:
                default_context:
                    enable_max_depth: true
```

```php
use Symfony\Component\Serializer\SerializerInterface;

final class PartnerPayload
{
    public function __construct(
        private SerializerInterface $partnerApiSerializer,
    ) {
    }

    public function encode(object $data): string
    {
        return $this->partnerApiSerializer->serialize($data, 'json');
    }
}
```

Имя аргумента выбирает named autowiring alias: `partner_api` → `$partnerApiSerializer`. Для явного выбора доступен `Target`. Каждому экземпляру задают свой name converter и default context; можно управлять включением встроенных normalizers/encoders.

Собственный normalizer без специальной настройки применяется к default serializer. Чтобы включить его в named экземпляр, используют атрибут `serializer` соответствующего service tag; `'*'` означает все serializer. Поэтому после разделения экземпляров проверяют, куда попали пользовательские normalizers. [Named serializers](https://symfony.com/blog/new-in-symfony-7-2-named-serializers)

## `AsMessage`: transport рядом с классом сообщения

Новый атрибут описывает обычный маршрут сообщения:

```php
namespace App\Message;

use Symfony\Component\Messenger\Attribute\AsMessage;

#[AsMessage('async')]
final readonly class GenerateInvoice
{
    public function __construct(public int $orderId)
    {
    }
}
```

```yaml
# config/packages/messenger.yaml
framework:
    messenger:
        transports:
            async: '%env(MESSENGER_TRANSPORT_DSN)%'
```

Transport должен быть настроен, handler — зарегистрирован, consumer — запущен. Атрибут не создаёт очередь. Вместо строки он принимает список transport, например `['async', 'audit']`; это отправка в несколько transport, а не выбор резервного.

Если routing одновременно задан конфигурацией и атрибутом, конфигурация имеет приоритет. Это позволяет переопределить доставку для конкретного окружения. [AsMessage](https://symfony.com/blog/new-in-symfony-7-2-asmessage-attribute)

## Keepalive для долгих Messenger-задач

Некоторые очереди считают сообщение потерянным, если время обработки превысило reservation/visibility timeout. Другой worker может получить его, пока первый ещё работает. Новый keepalive уведомляет transport, что работа продолжается:

```bash
php bin/console messenger:consume async --keepalive=10
```

`10` — интервал уведомлений в секундах. Без указанного значения используется default-интервал команды. Transport должен поддерживать `KeepaliveReceiverInterface`; в реализации 7.2 используется механизм `SIGALRM`, поэтому также важна доступность соответствующей поддержки сигналов/PCNTL.

Keepalive уменьшает риск преждевременной повторной выдачи, но не обещает exactly-once выполнение. Если процесс упал после внешнего действия и до ack, повтор остаётся возможным. Дедупликация платежа или импорта всё равно проектируется в обработчике. [Keepalive и alarms](https://symfony.com/blog/new-in-symfony-7-2-keepalive-messenger-transports)

## LazyChoiceLoader: не загружать всю таблицу для select

У `EntityType` появился `choice_lazy`:

```php
use App\Entity\Customer;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;

$builder->add('customer', EntityType::class, [
    'class' => Customer::class,
    'choice_lazy' => true,
]);
```

Поле откладывает загрузку вариантов и получает необходимые значения для уже выбранных или отправленных данных. Это особенно полезно, если таблица содержит десятки тысяч клиентов.

При этом пользовательский интерфейс поиска и endpoint для autocomplete нужны отдельно, например через Symfony UX Autocomplete. `choice_lazy: true` не создаёт автоматически выпадающий список всех возможных значений. [Lazy choice loader](https://symfony.com/blog/new-in-symfony-7-2-lazy-choice-loader)

## TypeInfo стабилизирован после изменения API

В 7.1 компонент был экспериментальным. В 7.2 появились `CompositeTypeInterface`, `WrappingTypeInterface` и `NullableType`, изменились методы проверки типов и убран неявный forwarding через `__call()`.

Например, библиотека теперь может явно узнать, что тип оборачивает другой тип, и получить вложенную информацию. Это понятнее, чем надеяться, что неизвестный метод будет передан внутреннему объекту.

После переработки компонент стал стабильным. Если приложение уже использовало experimental API 7.1, переход на 7.2 требует отдельной сверки методов, несмотря на обычный minor-номер релиза. [Стабилизация TypeInfo](https://symfony.com/blog/new-in-symfony-7-2-redesigned-typeinfo-component)

## Новые ограничения `Week`, `WordCount` и `Yaml`

```php
use Symfony\Component\Validator\Constraints as Assert;

final class PublicationInput
{
    #[Assert\Week(min: '2025-W01', max: '2025-W52')]
    public string $publicationWeek = '';

    #[Assert\WordCount(min: 20, max: 200, locale: 'ru')]
    public string $summary = '';

    #[Assert\Yaml]
    public string $settings = '';
}
```

`Week` проверяет неделю ISO 8601, включая корректность недель конкретного года. `WordCount` использует правила разбиения слов ICU/Intl и позволяет указать locale; для него важна доступность `IntlBreakIterator`. `Yaml` проверяет синтаксис и поддерживает флаги парсера Symfony Yaml.

Эти ограничения обычно допускают пустые значения; обязательность задают `NotBlank`/`NotNull`. Синтаксически корректный YAML ещё нужно проверить по схеме вашего приложения. [Три новых constraints](https://symfony.com/blog/new-in-symfony-7-2-week-wordcount-and-yaml-constraints)

## Trusted proxies и диагностика окружения

Для доверенных proxy добавлены shortcut `PRIVATE_SUBNETS` и переменные:

- `SYMFONY_TRUSTED_PROXIES`;
- `SYMFONY_TRUSTED_HEADERS`;
- `SYMFONY_TRUSTED_HOSTS`;
- `SYMFONY_TRUST_X_SENDFILE_TYPE_HEADER`.

Доверие ко всем private subnets подходит только там, где вы контролируете такие источники запросов. Оно расширяет границу доверия, а не определяет настоящий reverse proxy автоматически. [Настройка proxy](https://symfony.com/blog/new-in-symfony-7-2-simpler-trusted-proxies-configuration)

Для CI и диагностики стали полезнее команды:

```bash
php bin/console lint:container --resolve-env-vars --env=prod
php bin/console messenger:stats --format=json
php bin/console debug:asset-map --ext=css --no-vendor
```

Первая проверяет также разрешение используемых env-переменных. Она читает окружение, в котором запущена: успешный локальный результат не подтверждает наличие переменных на другом сервере. [Новые опции команд](https://symfony.com/blog/new-in-symfony-7-2-new-command-options)

## Другие изменения и подготовка к обновлению

В релиз вошли `WhenNot` для регистрации сервисов по окружению, lint переводов, desktop notifications, улучшения String/ExpressionLanguage/Mime/Serializer, silent verbosity и упрощённые single-file приложения. `framework.secret` стал необязательным для приложений, которым не нужны зависящие от него механизмы. [Все тематические обзоры 7.2](https://symfony.com/blog/category/living-on-the-edge/7.2)

Началась подготовка к 8.0: deprecated старые настройки session ID, ряд опций PHP-сессии, пустые user identifiers и YAML-тег `!tagged`. Default вероятности session garbage collection перестал принудительно заменять значение PHP INI. [Разбор deprecations](https://symfony.com/blog/new-in-symfony-7-2-deprecations)

Перед обновлением сверяют CSRF/Flex recipe, нужный named serializer, capabilities transport и сторонний код на TypeInfo. Точные изменения контрактов — в [UPGRADE-7.2](https://github.com/symfony/symfony/blob/7.2/UPGRADE-7.2.md). Далее — [Symfony 7.3](whats-new-in-symfony-7.3.md).
