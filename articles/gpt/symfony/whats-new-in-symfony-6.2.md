# Что нового в Symfony 6.2: встроенные атрибуты, Clock и аутентификация по токену

Symfony 6.2 вышел в ноябре 2022 года и требует PHP 8.1+. В этой версии фреймворк получил собственные атрибуты для контроллеров, компонент Clock, аутентификатор access token и условную валидацию. Релиз сократил количество вспомогательного кода, который раньше приходилось писать в приложении или получать из дополнительных бандлов. [Версия и требования](https://symfony.com/releases/6.2)

Это исторический обзор релиза: на **16 октября 2026 года ветка 6.2 уже не поддерживается**. Примеры показывают возможности именно этой версии; для действующего проекта выбирают поддерживаемую ветку. [Вся серия обзоров](symfony-release-overviews.md)

## Атрибуты контроллеров стали частью Symfony

Раньше для `IsGranted`, `Cache`, `Template` и преобразования параметров в Doctrine-сущности часто подключали SensioFrameworkExtraBundle. В 6.2 соответствующие механизмы появились в самом Symfony и Doctrine Bridge:

| Атрибут | Зачем нужен |
| --- | --- |
| `Security\Http\Attribute\IsGranted` | Проверяет роль или право через систему авторизации и voters |
| `HttpKernel\Attribute\Cache` | Настраивает HTTP-кеширование ответа |
| `Bridge\Twig\Attribute\Template` | Превращает возвращённые контроллером данные в результат рендера шаблона |
| `Bridge\Doctrine\Attribute\MapEntity` | Описывает поиск сущности для аргумента контроллера |

Пример фрагмента контроллера с существующей сущностью `Post` и voter для права `POST_EDIT`:

```php
use App\Entity\Post;
use Symfony\Bridge\Doctrine\Attribute\MapEntity;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[Route('/posts/{slug}/edit', methods: ['GET'])]
#[IsGranted('POST_EDIT', subject: 'post')]
public function edit(
    #[MapEntity(mapping: ['slug' => 'slug'])] Post $post,
): Response {
    return new Response($post->getTitle());
}
```

Ключ слева в `mapping` — имя параметра маршрута, справа — поле Doctrine. `subject: 'post'` передаёт объект из аргумента `$post` в voter. Если обязательная сущность не найдена, resolver формирует 404. `MapEntity` требует соответствующей интеграции Doctrine, включая DoctrineBundle 2.7.1+; это не встроенная в HttpKernel ORM.

При переносе кода меняют `use` и конфигурацию загрузчиков. Старый `ParamConverter` нельзя механически переименовать: `MapEntity` ставится на **аргумент метода**, а настройки поиска нужно перенести явно. [Разбор атрибутов](https://symfony.com/blog/new-in-symfony-6-2-built-in-cache-security-template-and-doctrine-attributes)

## Clock: время стало зависимостью приложения

Прямой вызов `new DateTimeImmutable()` неудобен в коде проверки срока действия: результат зависит от настоящих часов. Clock позволяет передать источник времени в конструктор:

```php
use Symfony\Component\Clock\ClockInterface;

final class ExpirationChecker
{
    public function __construct(private ClockInterface $clock)
    {
    }

    public function isExpired(\DateTimeImmutable $expiresAt): bool
    {
        return $expiresAt <= $this->clock->now();
    }
}
```

В Symfony 6.2 `ClockInterface` предоставляет три операции:

| Метод | Результат и поведение |
| --- | --- |
| `now(): DateTimeImmutable` | Текущее время выбранных часов |
| `sleep(float\|int $seconds): void` | Ожидание или продвижение виртуального времени |
| `withTimeZone(DateTimeZone\|string $timezone): static` | Часы с другим часовым поясом |

Есть `NativeClock` для системного времени, `MockClock` для управляемого времени и `MonotonicClock` для сценариев, где нужна монотонная шкала.

```php
use Symfony\Component\Clock\MockClock;

$clock = new MockClock('2022-11-30 10:00:00 UTC');
$checker = new ExpirationChecker($clock);
$deadline = new \DateTimeImmutable('2022-11-30 10:30:00 UTC');

var_dump($checker->isExpired($deadline)); // false
$clock->sleep(3600); // Для MockClock час проходит мгновенно.
var_dump($checker->isExpired($deadline)); // true
```

Заменяется только время, которое приложение получает через эти часы. Оставшиеся в коде `time()` и `new DateTimeImmutable()` продолжают обращаться к реальному времени. [Введение Clock](https://symfony.com/blog/new-in-symfony-6-2-clock-component)

## Access token authenticator: общий механизм для Bearer-токенов

Symfony научился извлекать access token из HTTP-запроса и передавать его обработчику приложения:

```yaml
# config/packages/security.yaml
security:
    firewalls:
        api:
            pattern: ^/api
            stateless: true
            access_token:
                token_handler: App\Security\ApiTokenHandler
```

Обычный клиент отправляет `Authorization: Bearer <token>`. Обработчик реализует `AccessTokenHandlerInterface` и метод `getUserBadgeFrom(string $accessToken): UserBadge`. Он проверяет токен и возвращает идентификатор пользователя через `UserBadge`.

Проверка содержимого остаётся ответственностью обработчика: срок действия, отзыв, существование в хранилище, а для JWT — подпись и необходимые claims. Невалидные учётные данные отклоняют исключением аутентификации, например `BadCredentialsException`. Настройка `access_token` сама по себе не создаёт OAuth-сервер и не выпускает токены.

По умолчанию используется заголовок. Извлечение из тела или query string настраивается отдельно; передача секрета в URL может оставить его в журналах и истории. [Устройство аутентификатора](https://symfony.com/blog/new-in-symfony-6-2-access-token-authenticator)

## `When`: применять правило только при выполнении условия

Например, процентная скидка не должна превышать 100, а скидка фиксированной суммой может быть больше:

```php
use Symfony\Component\Validator\Constraints as Assert;

final class Discount
{
    public function __construct(
        #[Assert\Choice(['percent', 'fixed'])]
        public string $type,

        #[Assert\GreaterThan(0)]
        #[Assert\When(
            expression: 'this.type == "percent"',
            constraints: [new Assert\LessThanOrEqual(100)],
        )]
        public int $value,
    ) {
    }
}
```

`expression` — выражение ExpressionLanguage, `constraints` — набор правил, запускаемых при истинном условии. `this` обозначает проверяемый объект, `value` доступен при валидации свойства и содержит его значение. Правило `GreaterThan` выполняется независимо от `When`. Для выражений нужен компонент `symfony/expression-language`. [Условные ограничения](https://symfony.com/blog/new-in-symfony-6-2-conditional-constraints)

## Проверка файлов: расширение вместе с MIME-типом

Опция `extensions` ограничения `File` проверяет и расширение, и соответствующий ему MIME-тип:

```php
use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Component\Validator\Constraints as Assert;

final class DocumentUpload
{
    #[Assert\File(maxSize: '5M', extensions: ['pdf'])]
    public ?UploadedFile $document = null;
}
```

`maxSize` ограничивает размер; `extensions` принимает строку, список расширений или соответствие расширений разрешённым MIME-типам. Например, `['txt' => 'text/plain']`. Если файл обязателен, дополнительно нужен `NotNull`: ограничение `File` само по себе допускает отсутствие значения.

Это проверка типа загруженного файла. Хранение под безопасным сгенерированным именем и запрет выполнения в каталоге загрузок настраиваются отдельно. [Новая опция File](https://symfony.com/blog/new-in-symfony-6-2-improved-file-validator)

## UUIDv7 и другие изменения Uid

Компонент Uid получил UUIDv7/UUIDv8, `TimeBasedUidInterface`, максимальные значения UUID/ULID и преобразование в hex:

```php
use Symfony\Component\Uid\Uuid;

$id = Uuid::v7();
echo $id->toRfc4122();
echo $id->getDateTime()->format('c');
echo $id->toHex();
```

UUIDv7 содержит временную составляющую и удобен для упорядоченных идентификаторов. Выбор типа столбца и индекса базы данных всё равно влияет на хранение и производительность. [Изменения Uid](https://symfony.com/blog/new-in-symfony-6-2-new-uid-features)

## Что ещё изменилось

| Область | Практическое изменение |
| --- | --- |
| Security | Методы `Security::login()`, `logout()` и `getFirewallConfig()`, цепочки user checkers, время жизни отдельных login links |
| Forms | `PasswordType` получил `hash_property_path` для немаппируемого поля; `render()` умеет принимать `FormInterface` |
| Twig | `app.current_route` и `app.current_route_parameters` для меню и навигации |
| Console | Возобновление progress bar с указанной позиции, ограничение высоты секции, Zsh completion, улучшенный вывод namespace команд |
| Routing | PSR-4-загрузчик маршрутов для каталогов классов |
| Отладка | Переработанный profiler и расширенные debug-команды |
| Остальные компоненты | Улучшения enum, Finder, извлечения переводов, Mailer/Notifier и работы с emoji |

Подробности: [Security, часть 1](https://symfony.com/blog/new-in-symfony-6-2-security-improvements-part-1), [Security, часть 2](https://symfony.com/blog/new-in-symfony-6-2-security-improvements-part-2), [DX](https://symfony.com/blog/new-in-symfony-6-2-dx-improvements), [Console](https://symfony.com/blog/new-in-symfony-6-2-console-improvements).

## Что учитывать при обновлении

Сначала обновляют зависимости в пределах текущей major-ветки и читают сообщения об устаревании. Для 6.2 особенно полезно проверить импорты Sensio-атрибутов, конфигурацию Doctrine resolver, переход с `renderForm()` на `render()` и собственные реализации интерфейсов Symfony. Полный перечень изменений контрактов приведён в [UPGRADE-6.2](https://github.com/symfony/symfony/blob/6.2/UPGRADE-6.2.md).

В этой статье разобраны основные возможности с примерами. Дополнения отдельных интеграций и компонентов перечислены в [официальной серии Symfony 6.2](https://symfony.com/blog/category/living-on-the-edge/6.2).
