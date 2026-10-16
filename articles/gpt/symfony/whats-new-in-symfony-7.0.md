# Что нового в Symfony 7.0: PHP 8.2, строгие контракты и удаление устаревших API

Symfony 7.0 вышел в ноябре 2023 года и поднял минимальную версию PHP до **8.2**. Он выпущен одновременно с Symfony 6.4 и получил тот же основной набор новых функций, но без deprecated API предыдущей major-ветки. Поэтому обновление 6.4 → 7.0 прежде всего меняет требования и контракты. [Страница релиза](https://symfony.com/releases/7.0), [официальное руководство перехода](https://github.com/symfony/symfony/blob/7.0/UPGRADE-7.0.md)

На **16 октября 2026 года** ветка 7.0 не поддерживается. Эта статья полезна для понимания изменений 7.x и обновления старого приложения; целевой поддерживаемый релиз выбирают по [календарю Symfony](https://symfony.com/releases). [Оглавление серии](symfony-release-overviews.md)

## Как связаны 6.4 и 7.0

Общие возможности пары включают стабильный AssetMapper, `DatePoint`, profiler консольных команд, `AutowireLocator`/`AutowireIterator`, class-level контексты Serializer и новые Messenger-handlers. Подробные примеры приведены в [статье о 6.4](whats-new-in-symfony-6.4.md).

| Свойство | Symfony 6.4 | Symfony 7.0 |
| --- | --- | --- |
| Минимальный PHP | 8.1 | 8.2 |
| Основные новые функции релизной пары | Есть | Есть |
| Устаревшие API 6.x | Сохраняются с предупреждениями | Удалены |
| Тип релиза | LTS | Обычный minor-релиз новой major-ветки |

Основная подготовка выполняется на 6.4: там устаревший вызов ещё работает и сообщает, чем его заменить. Если сразу перескочить с более ранней версии, вместо подсказки можно получить ошибку загрузки класса или несовместимой сигнатуры.

## Нативные типы затрагивают классы-наследники

В 7.0 расширено использование нативных типов возврата и свойств. Если приложение наследуется от класса Symfony или реализует его интерфейс, несовпадающая сигнатура становится ошибкой PHP.

Например, собственная команда должна возвращать код завершения:

```php
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

#[AsCommand(name: 'app:rebuild-index', description: 'Пересобрать поисковый индекс')]
final class RebuildIndexCommand extends Command
{
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $output->writeln('Индекс обновлён');

        return Command::SUCCESS;
    }
}
```

Метод должен действительно вернуть `int`, а не только получить декларацию типа. Особенно внимательно проверяют собственные bundles, normalizers, validators, event dispatchers и реализации контрактов. [Объяснение изменений типов](https://symfony.com/blog/symfony-7-0-type-declarations)

## Console: `$defaultName` и `$defaultDescription` удалены

Свойства для автоматической регистрации имени и описания команды больше не используются. Их заменяют атрибутом:

```php
// Было в старом коде:
protected static $defaultName = 'app:rebuild-index';
protected static $defaultDescription = 'Пересобрать индекс';
```

```php
// В Symfony 7:
#[AsCommand(name: 'app:rebuild-index', description: 'Пересобрать индекс')]
```

Атрибут не появился впервые в 7.0: он был доступен раньше. Новость major-релиза — удаление старого механизма. Сам класс по-прежнему можно строить через `Command` с `configure()` и `execute()`; invokable-команды без наследования появятся позднее, в 7.3. [Console в UPGRADE-7.0](https://github.com/symfony/symfony/blob/7.0/UPGRADE-7.0.md#console)

## Аннотации Doctrine и PHP-атрибуты: убрать старые загрузчики

Из Routing, Validator и Serializer удалена интеграция Doctrine annotations. Речь о комментариях `@Route`, `@Assert\NotBlank` и подобных metadata. PHP-атрибуты остаются:

```php
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Validator\Constraints as Assert;

#[Route('/catalog', name: 'catalog')]
public function catalog(): Response
{
    return new Response('Каталог');
}
```

Если в настройках загрузчика было `type: annotation`, его заменяют на `type: attribute`. Для Validator и Serializer проверяют старые опции `enable_annotations` и переходят на `enable_attributes` там, где нужна явная настройка.

Не следует путать удаление интеграции **Doctrine annotations** с удалением Doctrine ORM: сущности и Doctrine Bridge продолжают поддерживаться. Metadata ORM и версии DoctrineBundle проверяют отдельно.

## Dependency Injection: уйти от доступа к полному контейнеру

Удалены `ContainerAwareInterface` и `ContainerAwareTrait`, а также поддержка `@required`. Конструктор явно показывает зависимости:

```php
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Email;

final class ReceiptSender
{
    public function __construct(private MailerInterface $mailer)
    {
    }

    public function send(Email $email): void
    {
        $this->mailer->send($email);
    }
}
```

Для оставшегося method injection есть `Symfony\Contracts\Service\Attribute\Required`. Если сервис выбирается во время выполнения, можно передать ограниченный locator, а не общий контейнер. Ещё одна замена: старый `MapDecorated` переименован в `AutowireDecorated`.

## Serializer: собственным normalizers нужен `getSupportedTypes()`

В 7.0 интерфейсы normalizer/denormalizer явно требуют описания поддерживаемых типов. Минимальный пример для объекта суммы:

```php
use Symfony\Component\Serializer\Normalizer\NormalizerInterface;

final readonly class Money
{
    public function __construct(public int $minorUnits, public string $currency)
    {
    }
}

final class MoneyNormalizer implements NormalizerInterface
{
    public function normalize(mixed $object, ?string $format = null, array $context = []): array
    {
        return ['amount' => $object->minorUnits, 'currency' => $object->currency];
    }

    public function supportsNormalization(mixed $data, ?string $format = null, array $context = []): bool
    {
        return $data instanceof Money;
    }

    public function getSupportedTypes(?string $format): array
    {
        return [Money::class => true];
    }
}
```

`true` означает, что результат проверки поддержки для указанного типа можно кешировать. Если поддержка зависит от контекста, нельзя бездумно заявлять её кешируемость. Старые `ContextAwareNormalizerInterface` и `CacheableSupportsMethodInterface` удалены: переходят на основной интерфейс.

Регистрация normalizer и его приоритет должны обеспечивать вызов раньше универсального ObjectNormalizer. Подробности контракта — в [разделе Serializer](https://github.com/symfony/symfony/blob/7.0/UPGRADE-7.0.md#serializer).

## Изменились значения по умолчанию

Некоторые изменения поведения возникают даже без вызова удалённого метода:

| Настройка | В 7.0 | Что проверить |
| --- | --- | --- |
| `framework.http_method_override` | `false` | Формы с `_method` и эмуляцией PUT/PATCH/DELETE |
| `framework.handle_all_throwables` | `true` | Собственную обработку ошибок |
| `framework.session.cookie_secure` | `auto` | Определение HTTPS за reverse proxy |
| `framework.session.cookie_samesite` | `lax` | Сценарии переходов между сайтами |
| `framework.uid.default_uuid_version` | `7` | Места, где версия UUID не задаётся явно |
| `framework.validation.email_validation_mode` | `html5` | Старый режим `loose` и ожидаемые ошибки форм |

Рецепт Flex или ваша конфигурация могут уже задавать значение явно. Смена default не гарантирует смену поведения конкретного приложения. [Таблица default-значений](https://github.com/symfony/symfony/blob/7.0/UPGRADE-7.0.md#frameworkbundle)

## HttpFoundation и формы стали строже

Невозможность преобразовать параметр запроса к ожидаемому типу чаще приводит к исключению вместо молчаливого `0`/`false`. Поэтому код, который считал любой странный `?page=abc` первой страницей, нужно пересмотреть.

В формах date/time widget по умолчанию стал `single_text`; несогласованный `model_timezone` и timezone переданного объекта даты могут приводить к ошибке. Если интерфейс должен сохранить прежнюю структуру полей, задают `widget` явно и проверяют часовой пояс модели.

Удалён `AbstractController::renderForm()`. Используется `render()` с объектом формы:

```php
return $this->render('profile/edit.html.twig', [
    'form' => $form,
]);
```

Если отправленная форма невалидна, стандартный helper учитывает это при формировании ответа. Форму по-прежнему нужно создать и обработать в контроллере.

## Другие несовместимости

| Область | Изменение |
| --- | --- |
| Messenger | Удалены `MessageHandlerInterface` и `MessageSubscriberInterface`; применяют `AsMessageHandler` |
| ExpressionLanguage | `in` и `not in` используют строгое сравнение |
| Monolog Bridge | Требуется Monolog 3+ |
| Twig | Прекращена поддержка Twig 2 |
| Doctrine Bridge | Пересмотрены старые subscribers и schema listeners |
| Templating | Удалён старый компонент Templating; используют Twig |
| Translation | `translation:update` заменён на `translation:extract` |

Полный перечень существенно шире этой таблицы: [UPGRADE-7.0](https://github.com/symfony/symfony/blob/7.0/UPGRADE-7.0.md).

## Порядок перехода

1. На Symfony 6.4 устранить предупреждения об устаревании, включая сообщения сторонних bundles.
2. Поднять PHP до совместимой версии и сверить Composer-ограничения всех bundles.
3. Обновить ограничения компонентов Symfony и, если используется Flex, `extra.symfony.require`.
4. Сопоставить рецепты и конфигурацию с изменёнными defaults.
5. Проверить действующие сценарии приложения и только затем выбирать следующую поддерживаемую ветку.

Отсутствие deprecations — полезный ориентир, но оно не проверяет код, который ни разу не выполнялся. Статический анализ и проверка пользовательских сценариев дополняют этот этап. Далее — [Symfony 7.1](whats-new-in-symfony-7.1.md).
