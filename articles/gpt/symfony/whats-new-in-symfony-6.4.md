# Что нового в Symfony 6.4: LTS, зрелый AssetMapper, DatePoint и profiler команд

Symfony 6.4 вышел в ноябре 2023 года как LTS-релиз и требует PHP 8.1+. Он объединяет новые возможности с сохранением устаревающих API ветки 6.x, чтобы приложение можно было подготовить к Symfony 7 постепенно. На **16 октября 2026 года** исправления ошибок запланированы до ноября 2026 года, исправления безопасности — до ноября 2027 года. [Календарь поддержки](https://symfony.com/releases/6.4)

В тот же месяц вышел Symfony 7.0: основные новые функции у пары общие, но в 7.0 удалены deprecated API и повышено требование к PHP. Здесь разобраны возможности 6.4, а несовместимости новой major-ветки — в [отдельной статье о 7.0](whats-new-in-symfony-7.0.md). [Вся серия](symfony-release-overviews.md)

## AssetMapper стал стабильным

В 6.3 компонент появился как новый подход к frontend-ассетам. В 6.4 он получил статус стабильного и вошёл под обещание обратной совместимости Symfony.

Главное практическое изменение: зависимости import map теперь скачиваются локально по умолчанию в `assets/vendor`. После получения проекта на другой машине их восстанавливают отдельной командой:

```bash
php bin/console importmap:install
php bin/console asset-map:compile --env=prod
```

Первая команда загружает зависимости из `importmap.php`, вторая формирует production-ассеты в `public/assets`. Это разные операции: очистка Symfony cache не заменяет подготовку ассетов.

Появился удобный импорт CSS из JavaScript:

```javascript
// assets/app.js
import './styles/app.css';
```

```twig
{# templates/base.html.twig #}
{{ importmap('app') }}
```

AssetMapper обнаруживает CSS-зависимости и выводит нужные `link`-элементы. Он также рекурсивно определяет JS-зависимости entrypoint для preload.

Для контроля зависимостей добавлены:

```bash
php bin/console importmap:audit
php bin/console importmap:outdated
php bin/console importmap:update lodash
```

`audit` ищет известные уязвимости и возвращает ненулевой exit code при их обнаружении; `outdated` показывает доступные обновления. Поддержка Sass, Tailwind и TypeScript подключается отдельными интеграциями, а не появляется от одного обновления AssetMapper. [Обзор изменений](https://symfony.com/blog/new-in-symfony-6-4-assetmapper-improvements)

## Profiler теперь работает и для консольных команд

Поиск медленного SQL или лишней отправки писем часто нужен в импорте, очереди или ночном задании. Теперь команду приложения можно запустить с профилированием:

```bash
php bin/console --profile app:import-products -v
```

`app:import-products` здесь — команда вашего приложения. При включённом profiler и debug Symfony собирает время, память, события, логи, deprecations и данные подключённых collectors. В verbose-режиме выводится ссылка на профиль; `-vvv` дополнительно показывает время и память в терминале.

Это полезно для воспроизводимого разбора одного запуска. Долгоживущий worker с неограниченным сбором отладочных данных может потреблять много памяти, поэтому постоянное профилирование production-worker требует отдельного решения. [Profiler консольных команд](https://symfony.com/blog/new-in-symfony-6-4-command-profiler)

## `AutowireLocator`: получить ограниченный набор сервисов

Иногда сервису нужен один из нескольких обработчиков, но заранее создавать их все не требуется. Атрибут описывает небольшой service locator:

```php
use App\Export\CsvExporter;
use App\Export\JsonExporter;
use Psr\Container\ContainerInterface;
use Symfony\Component\DependencyInjection\Attribute\AutowireLocator;

final class ExportManager
{
    public function __construct(
        #[AutowireLocator([
            'csv' => CsvExporter::class,
            'json' => JsonExporter::class,
        ])]
        private ContainerInterface $exporters,
    ) {
    }

    public function export(string $format, array $rows): string
    {
        if (!$this->exporters->has($format)) {
            throw new \InvalidArgumentException('Неизвестный формат');
        }

        return $this->exporters->get($format)->export($rows);
    }
}
```

`CsvExporter` и `JsonExporter` — сервисы приложения с методом `export()`. Ключи массива становятся именами в locator. Сервис создаётся при обращении к нему. Доступа ко всему контейнеру приложения этот аргумент не даёт.

Для последовательного обхода набора сервисов есть `AutowireIterator`. При работе с тегами можно настраивать индексацию, приоритеты и исключения; для отсутствующего необязательного сервиса используется префикс `?` в его описании. [Атрибуты DI](https://symfony.com/blog/new-in-symfony-6-4-autowirelocator-and-autowireiterator-attributes)

## DatePoint: DateTimeImmutable, связанный с Clock

`DatePoint` наследует `DateTimeImmutable`, но при создании без явно заданного времени использует текущие часы компонента Clock. Благодаря этому код с `new DatePoint()` можно согласовать с виртуальным временем.

```php
use Symfony\Component\Clock\DatePoint;

$createdAt = new DatePoint('2023-11-30 12:00:00 UTC');
$expiresAt = new DatePoint('+30 days', reference: $createdAt);

echo $createdAt->format('Y-m-d'); // 2023-11-30
echo $expiresAt->format('Y-m-d'); // 2023-12-30
```

`reference` задаёт исходную дату для относительного выражения, `timezone` — часовой пояс. Методы изменения даты сохраняют семантику неизменяемого объекта: сохраняйте возвращаемое значение.

Ошибки некорректной даты и её изменения превращаются в `DateMalformedStringException`; polyfill позволяет использовать соответствующую модель ошибок и на поддерживаемых старых PHP. DatePoint полезен для согласованного времени приложения, но сам не вводит календарь рабочих дней и не заменяет бизнес-правила сроков. [Введение DatePoint](https://symfony.com/blog/new-in-symfony-6-4-datepoint)

## Контекст Serializer можно задать для класса

Если все даты DTO должны сериализоваться одинаково, не нужно повторять `Context` на каждом свойстве:

```php
use Symfony\Component\Serializer\Annotation\Context;
use Symfony\Component\Serializer\Normalizer\DateTimeNormalizer;

#[Context([DateTimeNormalizer::FORMAT_KEY => 'Y-m-d'])]
final class PeriodView
{
    public function __construct(
        public \DateTimeImmutable $from,
        public \DateTimeImmutable $until,
    ) {
    }
}
```

Контекст класса применяется к его свойствам; контекст отдельного свойства может переопределять настройки. Есть варианты контекста для групп. Это metadata сериализации, а не изменение самого `DateTimeImmutable`. [Контекст на уровне класса](https://symfony.com/blog/new-in-symfony-6-4-class-based-serializer-contexts)

В Serializer также развились class-level группы, нормализация переводимых объектов и диагностика ошибочного JSON. [Другие улучшения Serializer](https://symfony.com/blog/new-in-symfony-6-4-serializer-improvements)

## Messenger: готовые сообщения для процесса, команды и HTTP-вызова

Появились стандартные сообщения и handlers для распространённых действий:

| Сообщение | Действие |
| --- | --- |
| `Process\Messenger\RunProcessMessage` | Запуск внешнего процесса |
| `Console\Messenger\RunCommandMessage` | Запуск команды Console |
| `HttpClient\Messenger\PingWebhookMessage` | HTTP-запрос к webhook или служебному URL |

```php
use Symfony\Component\Console\Messenger\RunCommandMessage;

$bus->dispatch(new RunCommandMessage('app:refresh-catalog'));
```

`$bus` — `MessageBusInterface`, команда должна существовать в приложении. Наличие слова Messenger не делает выполнение асинхронным: для отправки в очередь нужно настроить routing к transport. Если требуется результат выполнения, отдельно учитывают синхронность и `HandledStamp`. [Готовые handlers](https://symfony.com/blog/new-in-symfony-6-4-more-built-in-message-handlers)

## Маршрут можно адресовать именем класса

Для контроллера с единственным подходящим маршрутом Symfony создаёт alias по FQCN. Для invokable-контроллера это имя класса, для метода — `ClassName::method`:

```php
use App\Controller\ReportController;

$url = $urlGenerator->generate(ReportController::class);
```

Явное имя маршрута продолжает работать. Alias удобен, когда переименование контроллера должна учитывать IDE; для нескольких маршрутов одного action нельзя рассчитывать на неоднозначный FQCN-alias. [FQCN-based routes](https://symfony.com/blog/new-in-symfony-6-4-fqcn-based-routes)

## Остальные заметные изменения

| Область | Что добавили |
| --- | --- |
| Cookies | Поддержка partitioned cookies / CHIPS для изолированного хранения cookie в стороннем контексте |
| Security | Более простой logout, утилиты impersonation, улучшенная диагностика badges в profiler |
| Workflow | Панель profiler с определением workflow и его визуализацией |
| Тестирование | Дополнительные assertions и настройки BrowserKit/DomCrawler |
| Локализация | Указание locale для рендера письма и доступ к enabled locales |
| Runtime | Улучшения build directory и отдельный handler для подпроцессов |
| Интеграции | Новые мосты Mailer, Notifier, Translation, Webhook и RemoteEvent |

Каждая возможность подробно описана в [серии 6.4/7.0](https://symfony.com/blog/category/living-on-the-edge/7.0-6.4).

## Что проверить при обновлении

Практический порядок: обновить последнюю доступную 6.x, устранить сообщения об устаревании, проверить рецепты Flex и отдельно подготовить pipeline ассетов. Для подготовки к 7.0 особенно важны старые аннотации, собственные normalizers, команды с `$defaultName`, `renderForm()` и настройки с новыми default-значениями.

Список изменений именно 6.4 — [UPGRADE-6.4](https://github.com/symfony/symfony/blob/6.4/UPGRADE-6.4.md). Следующий шаг — [обзор Symfony 7.0](whats-new-in-symfony-7.0.md).
