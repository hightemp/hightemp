# Что нового в Symfony 7.1: загрузка файлов, явный mapping маршрутов и TypeInfo

Symfony 7.1 вышел в мае 2024 года и требует PHP 8.2+. Релиз развивает подход «описать контракт рядом с аргументом»: загруженный файл можно получить и проверить атрибутом, route-параметры — явно связать с сущностями, а отдельный метод сервиса — внедрить как callable. [Страница версии](https://symfony.com/releases/7.1)

На **16 октября 2026 года** ветка 7.1 уже не поддерживается. Ниже разобраны изменения релиза и их практический смысл. [Оглавление серии](symfony-release-overviews.md)

## `MapUploadedFile`: файл сразу в аргументе контроллера

Для загрузки аватара раньше требовалось достать файл из `$request->files`, проверить его наличие и вызвать Validator. Новый resolver-атрибут выполняет подготовку до входа в action:

```php
use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Attribute\MapUploadedFile;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Validator\Constraints as Assert;

#[Route('/profile/avatar', methods: ['POST'], format: 'json')]
public function upload(
    #[MapUploadedFile(constraints: [
        new Assert\File(maxSize: '2M', extensions: ['png', 'jpg', 'jpeg']),
        new Assert\Image(maxWidth: 2000, maxHeight: 2000),
    ])]
    UploadedFile $avatar,
): JsonResponse {
    return new JsonResponse(['size' => $avatar->getSize()]);
}
```

Клиент отправляет `multipart/form-data` с полем `avatar`. Имя аргумента используется по умолчанию. Данные ещё не сохранены: перемещение файла, выбор имени и обновление профиля делает код приложения.

Параметры атрибута в ветке 7.1:

| Параметр | Назначение |
| --- | --- |
| `constraints` | Одно ограничение Validator, массив ограничений или `null` |
| `name` | Имя файлового поля вместо имени аргумента |
| `resolver` | Специализированный resolver вместо стандартного |
| `validationFailedStatusCode` | Код ошибки валидации; по умолчанию 422 |

Невалидный файл не попадает в action. Необязательную загрузку описывают nullable-аргументом с default, например `?UploadedFile $avatar = null`. Несколько файлов можно получить вариадическим `UploadedFile ...$documents`.

Сам атрибут не меняет правила, по которым PHP заполняет файлы запроса. Для этого примера используется POST; поддержку multipart PUT/PATCH в более новых комбинациях PHP/Symfony нельзя автоматически приписывать версии 7.1. [Обзор функции](https://symfony.com/blog/new-in-symfony-7-1-mapuploadedfile-attribute), [точный конструктор 7.1](https://github.com/symfony/symfony/blob/7.1/src/Symfony/Component/HttpKernel/Attribute/MapUploadedFile.php)

## Явное связывание параметров маршрута с аргументами

Рассмотрим action с двумя Doctrine-сущностями. Автоматическое использование всех route-параметров как критериев поиска может дать неожиданный запрос. В 7.1 появился синтаксис `{параметр:аргумент}`:

```php
use App\Entity\Article;
use App\Entity\Category;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/catalog/{slug:category}/articles/{id:article}')]
public function show(Category $category, Article $article): Response
{
    return new Response($category->getName().' / '.$article->getTitle());
}
```

Значение `slug` используется для поиска `Category`, `id` — для `Article`. Если обязательный объект не найден, ответом будет 404. Для более сложных случаев остаётся `MapEntity`, включая явный `mapping` или выражение поиска.

Важно: такой mapping не проверяет, что найденная статья принадлежит найденной категории. Связь проверяют отдельным запросом или бизнес-правилом.

В релизе также начато устаревание неявного Doctrine automapping, когда resolver пытается угадать критерии по route-параметрам. Явные `MapEntity` и route mapping делают поведение устойчивее. [Mapped route parameters](https://symfony.com/blog/new-in-symfony-7-1-mapped-route-parameters)

## `IsCsrfTokenValid`: проверка CSRF рядом с action

Для небольшого обработчика HTML-формы можно описать CSRF-проверку атрибутом:

```php
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsCsrfTokenValid;

#[Route('/preferences/reset', name: 'preferences_reset', methods: ['POST'])]
#[IsCsrfTokenValid('reset-preferences')]
public function reset(): Response
{
    // Здесь выполняется сброс настроек текущего пользователя.
    return new Response(status: 204);
}
```

```twig
<form action="{{ path('preferences_reset') }}" method="post">
    <input type="hidden" name="_token" value="{{ csrf_token('reset-preferences') }}">
    <button>Сбросить настройки</button>
</form>
```

`reset-preferences` — идентификатор токена, а `_token` — поле формы, в котором приходит его значение. При невалидном токене действие не выполняется. Права текущего пользователя проверяются отдельно: CSRF-защита не является авторизацией.

Идентификатор может быть ExpressionLanguage-выражением с доступом к аргументам action, например для отдельного токена на каждую запись. [Атрибут CSRF](https://symfony.com/blog/new-in-symfony-7-1-iscsrftokenvalid-attribute)

## `AutowireMethodOf`: внедрить конкретную операцию

Если потребителю нужна одна операция repository, её можно передать как замыкание:

```php
use App\Repository\ArticleRepository;
use Symfony\Component\DependencyInjection\Attribute\AutowireMethodOf;

final class LatestArticles
{
    public function __construct(
        #[AutowireMethodOf(ArticleRepository::class)]
        private \Closure $findPublished,
    ) {
    }

    public function load(int $limit): array
    {
        return ($this->findPublished)($limit);
    }
}
```

Здесь предполагается, что repository зарегистрирован как сервис и имеет метод `findPublished(int $limit): array`. Имя метода выводится из имени аргумента `$findPublished`.

Атрибут дополняет `AutowireCallable`, где метод можно указать явно. Новый `AutowireInline` позволяет описывать отдельный вложенный сервис и его factory/аргументы непосредственно в месте внедрения. Это полезно для локальной настройки зависимости; общие сервисы по-прежнему удобно объявлять централизованно. [Новые DI-атрибуты](https://symfony.com/blog/new-in-symfony-7-1-new-dependency-injection-attributes)

## TypeInfo: более выразительное описание PHP-типов

PropertyInfo исторически ориентирован на типы свойств. TypeInfo вводит отдельную модель типов, способную описывать union, intersection, generics, enum и другие конструкции. Информация может извлекаться из reflection, PHPDoc и строковых описаний, включая аргументы и результаты методов.

Практический пример задачи: библиотека читает PHPDoc `list<ArticleView>` и должна сохранить и факт «это список», и тип его элементов. Одного флага `isArray` для этого недостаточно. TypeInfo даёт структуру, по которой могут работать Serializer и другие инструменты.

В **7.1 компонент был экспериментальным**. Это существенно для библиотек: на experimental API не распространялось обычное обещание неизменности между minor-релизами. В 7.2 архитектуру пересмотрели и стабилизировали; примеры из нового руководства нельзя без сверки считать кодом для 7.1. [Введение TypeInfo](https://symfony.com/blog/new-in-symfony-7-1-typeinfo-component)

## Validator: больше проверок без собственных constraints

В 7.1 появились `MacAddress` и `Charset`. Существующие ограничения тоже стали точнее:

```php
use Symfony\Component\Validator\Constraints as Assert;

final class WebsiteInput
{
    #[Assert\Url(requireTld: true)]
    public string $website = '';

    #[Assert\Type('list')]
    public mixed $tags = [];
}
```

`requireTld: true` требует домен с TLD; это проверка формы адреса, а не разрешённости сетевого запроса к нему. Тип `list` означает ключи `0, 1, ...` без пропусков; `associative_array` описывает массив, который списком не является.

`UniqueEntity` расширен на обычные PHP-классы, включая DTO. Это удобно для предварительной проверки уникальности через сущность, но гонку параллельных записей окончательно предотвращает уникальное ограничение БД. Для Ip/Cidr добавлены дополнительные категории адресов. [Ограничения Validator](https://symfony.com/blog/new-in-symfony-7-1-constraint-improvements), [UniqueEntity для DTO](https://symfony.com/blog/new-in-symfony-7-1-expanding-uniqueentity-constraint-to-any-php-class)

## Консольные команды и эксплуатация

Встроенные команды получили полезные дополнения:

```bash
php bin/console messenger:consume --all
php bin/console lint:twig templates/ --excludes=data_collector/
php bin/console debug:serializer 'App\Dto\ArticleView'
```

`--all` запускает чтение доступных receivers одним worker; порядок и трудоёмкость сообщений нужно учитывать при организации очередей. `lint:twig --excludes` исключает указанные каталоги. `debug:serializer` стал показывать `serializedPath`.

Новая `secrets:reveal NAME` выводит расшифрованный секрет открытым текстом. Её используют осознанно, учитывая журналы терминала и CI. У `ArgvInput` появился `getRawTokens()` для передачи исходных аргументов другой команде. [Изменения Console](https://symfony.com/blog/new-in-symfony-7-1-commands-improvements)

## Что ещё вошло в релиз

Есть улучшения access token authenticator, POSIX-сигналов, profiler, emoji, Mailer/Notifier и нескольких низкоуровневых компонентов. Полная тематическая навигация — в [официальной серии 7.1](https://symfony.com/blog/category/living-on-the-edge/7.1).

При обновлении особенно проверяют Doctrine automapping, собственные реализации изменённых интерфейсов и код на экспериментальном TypeInfo. [UPGRADE-7.1](https://github.com/symfony/symfony/blob/7.1/UPGRADE-7.1.md) перечисляет частные несовместимости и deprecations. Следующий обзор — [Symfony 7.2](whats-new-in-symfony-7.2.md).
