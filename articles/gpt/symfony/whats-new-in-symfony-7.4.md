# Что нового в Symfony 7.4: LTS, form flows, PHP-конфигурация и подпись сообщений

Symfony 7.4 вышел в ноябре 2025 года как LTS-релиз с минимальным PHP 8.2. На **16 октября 2026 года** это поддерживаемая долгосрочная ветка: исправления ошибок запланированы до ноября 2028 года, безопасности — до ноября 2029 года. [Страница релиза](https://symfony.com/releases/7.4)

Одновременно вышел Symfony 8.0 с PHP 8.4+ и удалением deprecated API. Основные новые функции релизной пары общие. Здесь разобраны возможности 7.4; особенности перехода на 8.0 описаны [отдельно](whats-new-in-symfony-8.0.md). [Оглавление серии](symfony-release-overviews.md)

## PHP-конфигурация на массивах с подсказками типов

Появился формат `App::config()`, близкий по структуре к YAML:

```php
// config/packages/framework.php
namespace Symfony\Component\DependencyInjection\Loader\Configurator;

return App::config([
    'framework' => [
        'secret' => env('APP_SECRET'),
        'session' => [
            'cookie_secure' => 'auto',
            'cookie_samesite' => 'lax',
        ],
    ],
]);
```

Для настроек установленных bundles генерируются array shapes: IDE и анализатор могут подсказать ключи, вложенную структуру и типы значений. В проекте появляется генерируемый `config/reference.php`; это справочная информация для инструментов, а не место ручного редактирования бизнес-настроек.

Устаревающими объявлены генерируемые fluent config builders вида `Symfony\Config\FrameworkConfig` и XML-конфигурация DI/маршрутов. Это не означает устаревание любого PHP DSL: обычная настройка services через `ContainerConfigurator` — другой механизм. YAML также остаётся поддерживаемым форматом.

Для маршрутов появился аналогичный `Routes::config()`, а для YAML — schemas с подсказками редактора. Не нужно дублировать одну настройку одновременно в YAML и PHP: сначала выбирают формат и проверяют порядок загрузки файлов. [Новый PHP-формат](https://symfony.com/blog/new-in-symfony-7-4-better-php-configuration), [направление изменений конфигурации](https://symfony.com/blog/new-in-symfony-7-4-deprecated-xml-configuration)

## Form flows: многошаговые формы в самом компоненте Form

Теперь большую форму можно разбить на обычные Symfony form types и связать в flow. Пример предполагает существующие шаги `ContactStepType`, `DetailsStepType` и модель `RegistrationData`:

```php
namespace App\Form;

use App\Dto\RegistrationData;
use Symfony\Component\Form\Flow\AbstractFlowType;
use Symfony\Component\Form\Flow\FormFlowBuilderInterface;
use Symfony\Component\Form\Flow\Type\NavigatorFlowType;
use Symfony\Component\OptionsResolver\OptionsResolver;

final class RegistrationFlowType extends AbstractFlowType
{
    public function buildFormFlow(FormFlowBuilderInterface $builder, array $options): void
    {
        $builder->addStep('contact', ContactStepType::class);
        $builder->addStep('details', DetailsStepType::class);
        $builder->add('navigator', NavigatorFlowType::class);
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => RegistrationData::class,
            'step_property_path' => 'currentStep',
        ]);
    }
}
```

У `RegistrationData` должно быть доступное для Form свойство `currentStep`, начальное значение — `contact`. Поля шагов должны соответствовать модели данных. В action, наследующем AbstractController:

```php
$flow = $this->createForm(RegistrationFlowType::class, new RegistrationData());
$flow->handleRequest($request);

if ($flow->isSubmitted() && $flow->isValid() && $flow->isFinished()) {
    $data = $flow->getData();
    // Финальная операция приложения: например, регистрация пользователя.
    return $this->redirectToRoute('registration_done');
}

return $this->render('registration/flow.html.twig', [
    'form' => $flow->getStepForm(),
]);
```

`isValid()` проверяет валидность, `isFinished()` — завершение flow: это разные условия. Для текущего шага используется соответствующая validation group. Кнопки `NextFlowType`, `PreviousFlowType`, `FinishFlowType` и `ResetFlowType` управляют переходами.

Flow решает навигацию и обработку формы; хранение черновика, транзакция финального действия и защита от повторного подтверждения требуют решения приложения. [Введение form flows](https://symfony.com/blog/new-in-symfony-7-4-multi-step-forms)

## Messenger: подпись сообщений

Если кто-то получил возможность подложить данные в очередь, обработчик не должен автоматически доверять их происхождению. В 7.4 можно включить проверку криптографической подписи:

```php
namespace App\MessageHandler;

use App\Message\SendReceipt;
use Symfony\Component\Messenger\Attribute\AsMessageHandler;

#[AsMessageHandler(sign: true)]
final class SendReceiptHandler
{
    public function __invoke(SendReceipt $message): void
    {
        // Отправка чека средствами приложения.
    }
}
```

HMAC вычисляется с использованием `kernel.secret`; заголовки transport содержат `Body-Sign` и `Sign-Algo`. При отсутствующей или неверной подписи возникает `InvalidMessageSignatureException`, сообщение не должно обрабатываться обычным handler.

Производители и потребители должны использовать согласованный секрет. При включении функции учитывают уже накопленную очередь и ротацию ключа. Подпись подтверждает целостность/подлинность в пределах общего секрета; она не шифрует содержимое и не заменяет доступы к broker. [Signing messages](https://symfony.com/blog/new-in-symfony-7-4-signing-messages)

## Новое HTTP-кеширование HttpClient

Кеширующий клиент переработан с опорой на Cache component и правила [RFC 9111](https://www.rfc-editor.org/rfc/rfc9111). Настроить его можно на уровне scoped client:

```yaml
# config/packages/framework.yaml
framework:
    cache:
        pools:
            app.catalog_http_cache:
                adapter: cache.adapter.filesystem
                tags: true
    http_client:
        scoped_clients:
            catalog.client:
                base_uri: '%env(PUBLIC_CATALOG_API_BASE_URI)%'
                caching:
                    cache_pool: app.catalog_http_cache
                    max_ttl: 300
                    shared: true
```

В примере клиент читает публичный каталог; адрес задаётся окружением. Cache pool должен поддерживать tags.

| Опция `caching` | Значение |
| --- | --- |
| `cache_pool` | Tag-aware pool для записей |
| `shared` | Общий HTTP-кеш; default — `true` |
| `max_ttl` | Верхняя граница срока хранения, заданного сервером |

`max_ttl` не делает любой ответ кешируемым на 300 секунд: учитываются HTTP-заголовки и правила кеширования. Для персональных ответов внимательно проверяют `Authorization`, `Cache-Control`, `Vary` и изоляцию контекстов. RFC 9111 описывает хранение, freshness и повторную проверку HTTP-ответов. [Caching HttpClient](https://symfony.com/blog/new-in-symfony-7-4-caching-http-client)

## ControllerHelper: helpers без наследования

`AbstractController` остаётся удобным стандартным вариантом. Если проекту нужна композиция, helpers доступны через отдельный сервис:

```php
use Symfony\Bundle\FrameworkBundle\Controller\ControllerHelper;
use Symfony\Component\DependencyInjection\Attribute\AutowireMethodOf;
use Symfony\Component\HttpFoundation\Response;

final class LandingController
{
    public function __construct(
        #[AutowireMethodOf(ControllerHelper::class)]
        private \Closure $render,
    ) {
    }

    public function __invoke(): Response
    {
        return ($this->render)('landing/index.html.twig');
    }
}
```

Так контроллер получает одну операцию `render`, а не наследует весь базовый класс. Метод можно описать собственным invokable-интерфейсом для подсказок типов. Это всё ещё Symfony helper: зависимость от фреймворка становится явной через DI. [ControllerHelper](https://symfony.com/blog/new-in-symfony-7-4-decoupled-controller-helpers)

## Request: явный источник параметра и разбор multipart

`Request::get()` объявлен deprecated: он последовательно искал значение в route attributes, query string и данных формы. Теперь источник лучше назвать явно:

```php
$id = $request->attributes->get('id');
$page = $request->query->getInt('page', 1);
$comment = $request->request->getString('comment');
$jsonOrForm = $request->getPayload()->all();
```

Последняя строка выбирает API данных тела, а не query string. В Symfony 8.0 общий `Request::get()` удалён.

Расширен разбор тела для методов PUT/PATCH/DELETE/QUERY, включая использование PHP 8.4 `request_parse_body()` для подходящих form content types. Особенно заметно это для multipart: возможность зависит от PHP и доступности функции, а не только от номера Symfony. Нельзя заранее потребить входное тело другим обработчиком и ожидать, что парсер заново получит исходные байты.

Список допустимых значений method override теперь можно ограничить:

```yaml
framework:
    http_method_override: true
    allowed_http_method_override: ['PUT', 'PATCH', 'DELETE']
```

Это относится к эмуляции метода, например через `_method`, и не запрещает реальные HTTP-запросы остальных методов. [Request 7.4](https://symfony.com/blog/new-in-symfony-7-4-request-class-improvements)

## Metadata для сторонних классов через атрибуты

`ExtendsValidationFor` и `ExtendsSerializationFor` позволяют добавить metadata классу из внешнего пакета без редактирования vendor:

```php
use Vendor\Package\CustomerData;
use Symfony\Component\Validator\Attribute\ExtendsValidationFor;
use Symfony\Component\Validator\Constraints as Assert;

#[ExtendsValidationFor(CustomerData::class)]
abstract class CustomerDataValidation
{
    #[Assert\NotBlank]
    #[Assert\Email]
    public string $email;
}
```

В `CustomerData` должно существовать соответствующее свойство или accessor. Symfony объединяет исходную metadata с расширением. Сам extension-класс не является новой моделью клиента и не предназначен для создания объектов. [Расширение metadata](https://symfony.com/blog/new-in-symfony-7-4-extending-validation-and-serialization-with-php-attributes)

## Остальные изменения

| Область | Что добавлено |
| --- | --- |
| Console | `MapInput` для DTO аргументов/опций, backed enums, `Ask`/`Interact`, улучшения тестирования invokable-команд |
| Validator | `Video`: размеры, соотношение сторон, codecs/containers; для metadata нужен `ffprobe` из FFmpeg |
| Security | `access_decision()` в Twig, дополнительные данные `Vote::extraData` |
| Workflow | Взвешенные переходы и улучшения enum |
| Uid | Дополнительные форматы и улучшения работы с UUID |
| Runtime | Каталог `share`, улучшенная интеграция FrankenPHP и вывод исключений в терминале |
| HTTP/Mime | QUERY, более точная работа с MIME suffix и заголовками Link |
| Интеграции | Microsoft Graph Mailer и доработки переводов/профайлера |

`Video` не является антивирусом или транскодером: он проверяет доступные metadata файла. Все тематические материалы собраны в [серии 7.4/8.0](https://symfony.com/blog/category/living-on-the-edge/8.0-7.4).

## Что проверить при переходе

Главные кандидаты — XML/fluent config, вызовы `Request::get()`, настройки HTTP override, собственные constraints и transport serializers. Новые возможности, зависящие от PHP 8.4/8.5, проверяют отдельно от минимального требования PHP 8.2 самой ветки.

Точные deprecations и изменения интерфейсов — в [UPGRADE-7.4](https://github.com/symfony/symfony/blob/7.4/UPGRADE-7.4.md). Для перехода на PHP 8.4+ и новую major-ветку — [обзор 8.0](whats-new-in-symfony-8.0.md).
