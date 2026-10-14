# Symfony Panther 2.4: браузерные тесты PHP-приложения на практике

Форма открывается, сервер отвечает, функциональные тесты проходят — а пользователь нажимает кнопку и ничего не происходит. Например, обработчик JavaScript не подключился или результат AJAX-запроса не появился на странице. Такие ошибки удобно искать браузерными тестами.

`symfony/panther` управляет настоящим Chrome или Firefox из PHP. Можно открывать страницы, вводить текст, отправлять формы, ждать изменений интерфейса и делать скриншоты. В Symfony тесты пишутся через `PantherTestCase`, а для самостоятельного PHP-скрипта достаточно класса `Client`.

На **9 октября 2026 года** последний стабильный релиз — **Panther 2.4.0 от 8 января 2026 года**. Ниже API разобран по исходникам именно этого тега. [Релиз 2.4.0](https://github.com/symfony/panther/releases/tag/v2.4.0)

В статье соберём небольшую форму обратной связи и проверим два сценария: сервер принял корректные данные и сервер отклонил некорректное имя. Затем рассмотрим поля формы, ожидания, несколько браузеров, Docker и CI.

## Как устроен Panther

При локальном запуске получается такая цепочка:

~~~text
PHPUnit → Panther Client → ChromeDriver → Chrome
                                           ↓ HTTP
                               PHP-сервер → Symfony
~~~

PHPUnit выполняет тест. Panther передаёт команды драйверу по протоколу WebDriver. Браузер обращается к приложению по HTTP и исполняет JavaScript. При использовании `PantherTestCase` локальный PHP-сервер может запускаться автоматически; по умолчанию он слушает `127.0.0.1:9080`. Вместо него можно подключиться к уже работающему серверу.

**Тест и приложение выполняются в разных PHP-процессах.** Полученный в тесте сервис из контейнера Symfony не становится тем же объектом, который обрабатывает браузерный запрос. Это влияет на моки, авторизацию и транзакции базы данных. Запуск сервера и выбор браузера реализованы в [PantherTestCaseTrait](https://github.com/symfony/panther/blob/v2.4.0/src/PantherTestCaseTrait.php).

### Какой тест для чего использовать

| Инструмент | Что удобно проверять |
| --- | --- |
| PHPUnit `TestCase` | Отдельные функции и классы. |
| Symfony `KernelTestCase` | Сервисы, репозитории, взаимодействие с контейнером. |
| Symfony `WebTestCase` | Маршруты, HTTP-статусы, серверную валидацию, ответы API. |
| Panther `PantherTestCase` | Действия пользователя и результат выполнения JavaScript в браузере. |

Для формы разумно иметь быстрые проверки серверной валидации и несколько браузерных сценариев, проходящих весь путь пользователя. Нет необходимости открывать Chrome для проверки каждого метода сервиса.

## Версии и зависимости примера

| Компонент | Версия в примере |
| --- | --- |
| PHP | 8.4 |
| Symfony | 7.4 |
| Panther | 2.4.0 |
| PHPUnit | 11.5 |
| Браузер | Chrome или Chromium с совместимым ChromeDriver |

Сам Panther 2.4.0 требует PHP `>=8.1`, `ext-dom`, `ext-libxml` и поддерживает основные компоненты Symfony с ограничениями `^6.4 || ^7.3 || ^8.0`. Это требования библиотеки: выбранная версия Symfony и PHPUnit может повышать минимальную версию PHP. Полный список находится в [composer.json Panther 2.4.0](https://github.com/symfony/panther/blob/v2.4.0/composer.json).

Для стека примера также нужны PHP-расширения `curl`, `zip`, `mbstring`, `xml` и `xmlwriter`. В частности, `curl` и `zip` использует зависимость `php-webdriver/webdriver`, а DOM/XML и `mbstring` нужны инструментам тестирования. Dockerfile ниже устанавливает эти расширения. [Зависимости PHP WebDriver](https://github.com/php-webdriver/php-webdriver/blob/1.15.2/composer.json)

## 1. Создаём проект

Команды выполняются в новой папке примера:

~~~bash
composer create-project symfony/skeleton:"7.4.*" panther-demo
cd panther-demo

composer require symfony/twig-bundle symfony/security-csrf
composer require --dev symfony/panther:"2.4.0" phpunit/phpunit:"^11.5" dbrekelmans/bdi
~~~

Panther — библиотека, её не нужно добавлять в `config/bundles.php` или назначать клиентом в `framework.yaml`. В тесте браузер создаёт вызов `createPantherClient()`.

Установите Chrome, Chromium или Firefox, затем скачайте драйвер для установленного браузера:

~~~bash
vendor/bin/bdi detect drivers
~~~

`bdi` устанавливает драйверы, но сам браузер должен уже присутствовать в системе. Panther ищет `chromedriver` в `PATH`, а также в `drivers/` и `vendor/bin/`. При нестандартном расположении Chrome путь к браузеру можно передать через `PANTHER_CHROME_BINARY`. Это видно в [ChromeManager](https://github.com/symfony/panther/blob/v2.4.0/src/ProcessManager/ChromeManager.php).

Добавьте в `.gitignore`:

~~~gitignore
/drivers/
/var/panther/
~~~

`composer.lock` сохраните в репозитории примера: при следующих установках он зафиксирует выбранные версии PHP-пакетов.

### Структура файлов

К стандартному skeleton добавим:

~~~text
panther-demo/
├── config/
│   ├── packages/framework.yaml
│   └── routes.yaml
├── src/Controller/ContactController.php
├── templates/contact/index.html.twig
├── tests/
│   ├── bootstrap.php
│   └── E2E/ContactTest.php
└── phpunit.dist.xml
~~~

## 2. Настраиваем Symfony

В `config/packages/framework.yaml` нужны сессия, CSRF и тестовое окружение. Объедините эти параметры с конфигурацией, созданной рецептами Flex:

~~~yaml
framework:
    secret: '%env(APP_SECRET)%'
    csrf_protection: true
    session: true

when@test:
    framework:
        test: true
        session:
            storage_factory_id: session.storage.factory.mock_file
~~~

`APP_SECRET` берётся из окружения или `.env` проекта. `mock_file` сохраняет тестовые сессии в файлах: браузер сможет отправить cookie при следующем HTTP-запросе, а приложение — прочитать соответствующую сессию.

Для нового примера зададим в `config/routes.yaml` импорт атрибутов контроллеров:

~~~yaml
controllers:
    resource:
        path: ../src/Controller/
        namespace: App\Controller
    type: attribute
~~~

## 3. Добавляем обработчик формы

Создайте `src/Controller/ContactController.php`:

~~~php
<?php

declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

final class ContactController extends AbstractController
{
    #[Route('/contact', name: 'contact_show', methods: ['GET'])]
    public function show(): Response
    {
        return $this->render('contact/index.html.twig');
    }

    #[Route('/contact', name: 'contact_submit', methods: ['POST'])]
    public function submit(Request $request): JsonResponse
    {
        if (!$this->isCsrfTokenValid(
            'contact',
            $request->request->getString('_token'),
        )) {
            return $this->json(
                ['error' => 'Форма устарела. Обновите страницу.'],
                Response::HTTP_FORBIDDEN,
            );
        }

        $name = trim($request->request->getString('name'));
        $email = trim($request->request->getString('email'));
        $topic = $request->request->getString('topic');
        $consent = $request->request->getBoolean('consent');

        if (
            mb_strlen($name) < 2
            || mb_strlen($name) > 80
            || strlen($email) > 254
            || filter_var($email, FILTER_VALIDATE_EMAIL) === false
            || !in_array($topic, ['support', 'partnership'], true)
            || !$consent
        ) {
            return $this->json(
                ['error' => 'Проверьте поля формы.'],
                Response::HTTP_UNPROCESSABLE_ENTITY,
            );
        }

        return $this->json([
            'message' => sprintf('Спасибо, %s! Заявка принята.', $name),
        ]);
    }
}
~~~

Обработчик проверяет CSRF, нормализует имя и email, валидирует поля и возвращает JSON. Для учебного сценария этим обработка заканчивается: отправку письма или сохранение заявки в базе нужно добавить отдельным сервисом в реальном приложении.

CSRF-токен будет сгенерирован при открытии формы. Panther получит его вместе с HTML, сохранит cookie браузера и отправит скрытое поле при заполнении формы. Генерация токена и проверка с одинаковым ID `contact` соответствуют [ручной CSRF-защите Symfony](https://symfony.com/doc/7.4/security/csrf.html#generating-and-checking-csrf-tokens-manually).

## 4. Добавляем HTML и JavaScript

Создайте `templates/contact/index.html.twig`:

~~~twig
<!doctype html>
<html lang="ru">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Связаться с нами</title>
</head>
<body>
    <h1>Связаться с нами</h1>

    <form
        action="{{ path('contact_submit') }}"
        method="post"
        data-testid="contact-form"
    >
        <input type="hidden" name="_token" value="{{ csrf_token('contact') }}">

        <p>
            <label>
                Имя
                <input name="name" required minlength="2" maxlength="80">
            </label>
        </p>

        <p>
            <label>
                Email
                <input name="email" type="email" required maxlength="254">
            </label>
        </p>

        <p>
            <label>
                Тема
                <select name="topic" required>
                    <option value="">Выберите тему</option>
                    <option value="support">Поддержка</option>
                    <option value="partnership">Сотрудничество</option>
                </select>
            </label>
        </p>

        <p>
            <label>
                <input name="consent" type="checkbox" value="1" required>
                Согласен на обработку данных
            </label>
        </p>

        <button type="submit" data-testid="contact-submit">Отправить</button>
    </form>

    <p
        role="status"
        aria-live="polite"
        data-testid="contact-status"
        data-state="idle"
    ></p>

    <script>
        const form = document.querySelector('[data-testid="contact-form"]');
        const button = document.querySelector('[data-testid="contact-submit"]');
        const status = document.querySelector('[data-testid="contact-status"]');

        form.addEventListener('submit', async (event) => {
            event.preventDefault();

            button.disabled = true;
            status.dataset.state = 'loading';
            status.textContent = 'Отправляем…';

            try {
                const response = await fetch(form.action, {
                    method: 'POST',
                    body: new FormData(form),
                    headers: { Accept: 'application/json' },
                });
                const payload = await response.json();

                if (!response.ok) {
                    throw new Error(payload.error ?? 'Ошибка отправки.');
                }

                status.textContent = payload.message;
                status.dataset.state = 'success';
                form.reset();
            } catch (error) {
                status.textContent = error instanceof Error
                    ? error.message
                    : 'Ошибка отправки.';
                status.dataset.state = 'error';
            } finally {
                button.disabled = false;
            }
        });
    </script>
</body>
</html>
~~~

Кнопка запускает настоящий `fetch()`. Сообщение об успехе появляется только после ответа сервера. Если JavaScript не загрузился или запрос не прошёл CSRF-проверку, браузерный тест не увидит состояние `success`.

`data-testid` задаёт устойчивые селекторы для теста. Изменение CSS-класса оформления не должно ломать сценарий. `data-state` показывает состояние самой формы: тесту удобно ждать завершения отправки, а не угадывать его по задержке.

В этом примере JavaScript находится прямо в шаблоне, поэтому отдельная сборка frontend не требуется.

## 5. Настраиваем PHPUnit

Создайте `tests/bootstrap.php`:

~~~php
<?php

declare(strict_types=1);

use Symfony\Component\Dotenv\Dotenv;

require dirname(__DIR__).'/vendor/autoload.php';

(new Dotenv())->bootEnv(dirname(__DIR__).'/.env');
~~~

Skeleton уже содержит настройку автозагрузки `App\Tests\` из каталога `tests/`. Если переносите пример в другой проект, проверьте его `autoload-dev`. [composer.json Symfony Skeleton 7.4](https://github.com/symfony/skeleton/blob/7.4/composer.json)

Создайте `phpunit.dist.xml`:

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<phpunit xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="https://schema.phpunit.de/11.5/phpunit.xsd"
         bootstrap="tests/bootstrap.php"
         cacheDirectory="var/phpunit"
         colors="true">
    <php>
        <server name="APP_ENV" value="test" force="true"/>
        <server name="APP_DEBUG" value="1"/>
        <server name="KERNEL_CLASS" value="App\Kernel"/>
        <server name="PANTHER_APP_ENV" value="test"/>
        <server name="PANTHER_WEB_SERVER_DIR" value="./public"/>
        <server name="PANTHER_ERROR_SCREENSHOT_DIR" value="./var/panther"/>
    </php>

    <testsuites>
        <testsuite name="e2e">
            <directory>tests/E2E</directory>
        </testsuite>
    </testsuites>

    <extensions>
        <bootstrap class="Symfony\Component\Panther\ServerExtension"/>
    </extensions>
</phpunit>
~~~

Здесь:

- `APP_ENV=test` задаёт окружение тестового процесса;
- `PANTHER_APP_ENV=test` задаёт окружение PHP-сервера, который запускает Panther;
- `KERNEL_CLASS` позволяет тестовому классу загрузить ядро Symfony;
- `PANTHER_WEB_SERVER_DIR` указывает document root;
- `PANTHER_ERROR_SCREENSHOT_DIR` задаёт каталог скриншотов при ошибках;
- `ServerExtension` подключает интеграцию с жизненным циклом PHPUnit.

Для PHPUnit 11 используется элемент `<bootstrap>` внутри `<extensions>`. Старый вариант `<extension class="..."/>` из статей о PHPUnit 9 сюда переносить не нужно. Реализация для PHPUnit 10+ находится в [ServerExtension Panther 2.4](https://github.com/symfony/panther/blob/v2.4.0/src/ServerExtension.php), формат XML описан в [руководстве PHPUnit 11.5](https://docs.phpunit.de/en/11.5/configuration.html).

Если в существующем проекте несколько конфигураций PHPUnit, запускайте пример с явным `-c phpunit.dist.xml`.

## 6. Пишем браузерные тесты

Создайте `tests/E2E/ContactTest.php`:

~~~php
<?php

declare(strict_types=1);

namespace App\Tests\E2E;

use Symfony\Component\Panther\Client;
use Symfony\Component\Panther\PantherTestCase;

final class ContactTest extends PantherTestCase
{
    public function testSuccessfulSubmissionShowsServerConfirmation(): void
    {
        $client = $this->openContact();

        self::assertPageTitleSame('Связаться с нами');
        self::assertSelectorTextContains('h1', 'Связаться с нами');

        $client->submitForm('Отправить', [
            'name' => 'Анна',
            'email' => 'anna@example.test',
            'topic' => 'support',
            'consent' => true,
        ]);

        $client->waitForAttributeToContain(
            '[data-testid="contact-status"]',
            'data-state',
            'success',
            5,
        );
        $client->waitForEnabled('[data-testid="contact-submit"]', 5);

        self::assertSelectorTextContains(
            '[data-testid="contact-status"]',
            'Спасибо, Анна! Заявка принята.',
        );
        self::assertSelectorIsEnabled('[data-testid="contact-submit"]');
        self::assertStringEndsWith('/contact', $client->getCurrentURL());
    }

    public function testServerRejectsNameContainingOnlySpaces(): void
    {
        $client = $this->openContact();

        $client->submitForm('Отправить', [
            'name' => '   ',
            'email' => 'anna@example.test',
            'topic' => 'support',
            'consent' => true,
        ]);

        $client->waitForAttributeToContain(
            '[data-testid="contact-status"]',
            'data-state',
            'error',
            5,
        );
        $client->waitForEnabled('[data-testid="contact-submit"]', 5);

        self::assertSelectorTextContains(
            '[data-testid="contact-status"]',
            'Проверьте поля формы.',
        );
        self::assertSelectorIsEnabled('[data-testid="contact-submit"]');
    }

    protected function tearDown(): void
    {
        try {
            parent::tearDown();
        } finally {
            self::stopWebServer();
        }
    }

    private function openContact(): Client
    {
        $browser = getenv('E2E_BROWSER') ?: self::CHROME;

        if (!in_array($browser, [self::CHROME, self::FIREFOX], true)) {
            throw new \InvalidArgumentException('E2E_BROWSER: chrome или firefox.');
        }

        $client = self::createPantherClient(['browser' => $browser]);
        $client->request('GET', '/contact');

        return $client;
    }
}
~~~

### Что проверяет первый сценарий

Тест открывает страницу, заполняет форму, выбирает тему, отмечает checkbox и нажимает кнопку. JavaScript отправляет POST, Symfony проверяет токен и поля, а браузер показывает ответ. Затем тест проверяет сообщение, доступность кнопки и сохранение текущего URL.

`submitForm()` получает название кнопки и значения по HTML-атрибуту `name`. Скрытый `_token` берётся из открытой формы автоматически. Для `<select>` передаётся значение `value` нужного `<option>`, для checkbox можно передать `true`.

### Зачем имя из пробелов во втором сценарии

HTML-проверки `required` и `minlength="2"` пропускают строку из трёх пробелов. Сервер делает `trim()`, получает пустое имя и возвращает `422`. Тест проверяет, что frontend показывает ошибку сервера и снова разрешает отправить форму.

Этот сценарий проходит через браузерную валидацию до backend. Простая попытка отправить заведомо неправильный email могла бы остановиться ещё в браузере и вообще не проверить серверный обработчик.

### Почему вызывается stopWebServer()

В 2.4 Panther может повторно использовать созданный клиент. В учебном примере после каждого теста закрываются браузеры и локальный сервер: следующий сценарий начинает работу с чистым браузерным состоянием. Сначала вызывается `parent::tearDown()`, чтобы Panther успел сделать скриншот ошибки.

Это увеличивает время запуска. В большой suite жизненный цикл можно оптимизировать отдельно, обеспечив очистку cookies, browser storage и данных приложения. Закрытие браузера само по себе не очищает базу.

## 7. Запускаем пример

Из корня `panther-demo`:

~~~bash
mkdir -p var/panther
vendor/bin/phpunit -c phpunit.dist.xml --testsuite=e2e
~~~

Запустить один сценарий:

~~~bash
vendor/bin/phpunit -c phpunit.dist.xml --filter testSuccessfulSubmissionShowsServerConfirmation
~~~

Показать окно браузера и остановиться для отладки при ошибке:

~~~bash
PANTHER_NO_HEADLESS=1 vendor/bin/phpunit -c phpunit.dist.xml --debug
~~~

Запустить те же два сценария в Firefox, если установлен браузер и GeckoDriver:

~~~bash
E2E_BROWSER=firefox vendor/bin/phpunit -c phpunit.dist.xml tests/E2E/ContactTest.php
~~~

`E2E_BROWSER` — переменная нашего примера, её читает метод `openContact()`. Это не встроенная настройка Panther.

Здесь Symfony CLI и предварительный запуск сервера не требуются: его поднимет `PantherTestCase`. Если порт занят другим процессом, выберите свободный:

~~~bash
PANTHER_WEB_SERVER_PORT=9081 vendor/bin/phpunit -c phpunit.dist.xml
~~~

## Как работать с элементами формы

В тестах выше используется сокращённый `submitForm()`. Если нужно поэтапно заполнить поля, можно получить объект формы:

~~~php
$crawler = $client->request('GET', '/contact');
$form = $crawler->selectButton('Отправить')->form();

$form['name'] = 'Анна';
$form['email'] = 'anna@example.test';
$form['topic']->select('support');
$form['consent']->tick();

$client->submit($form);
$client->waitForElementToContain(
    '[data-testid="contact-status"]',
    'Спасибо, Анна!',
    5,
);
~~~

`select()` и `tick()` принадлежат полю формы. Вызов `->filter('select')->selectOption(...)` не является API Crawler в Panther 2.4. Выбор `<option>` реализован в [ChoiceFormField](https://github.com/symfony/panther/blob/v2.4.0/src/DomCrawler/Field/ChoiceFormField.php).

Для работы непосредственно с элементом браузера доступны методы WebDriver:

~~~php
use Facebook\WebDriver\WebDriverBy;

$name = $client->findElement(WebDriverBy::cssSelector('[name="name"]'));
$name->clear();
$name->sendKeys('Анна');

$client->getCrawler()->filter('[data-testid="contact-submit"]')->click();
~~~

`clear()` очищает поле, `sendKeys()` вводит текст, `click()` выполняет браузерный клик. Учитывайте обычные правила HTML: незаполненные обязательные поля могут остановить отправку формы.

Для формы, созданной Symfony Form, имена часто имеют вид `contact[email]`. Тогда ключом будет именно `'contact[email]'`, а не вложенный PHP-массив `['contact' => ['email' => ...]]`.

## Ожидания: как не получить случайно проходящий тест

Нажатие кнопки и завершение JavaScript — разные события. Например, существование строки таблицы после смены фильтра ничего не доказывает: это может быть старая строка, которую приложение ещё не заменило.

В нашей форме тест ждёт изменения `data-state` на `success` или `error`. Такой результат связан с завершением запроса. Ожидание только самого `<p>` не подошло бы: элемент присутствует в HTML ещё до отправки.

### Основные методы ожидания

| Метод | Условие |
| --- | --- |
| `waitFor($locator, $timeout, $interval)` | Элемент появился в DOM; видимость не обязательна. |
| `waitForVisibility($locator, $timeout, $interval)` | Элемент стал видимым. |
| `waitForInvisibility($locator, $timeout, $interval)` | Элемент скрыт или отсутствует. |
| `waitForStaleness($locator, $timeout, $interval)` | Найденный элемент отсоединён от DOM. Он должен существовать в момент начала ожидания. |
| `waitForElementToContain($locator, $text, $timeout, $interval)` | Текст элемента содержит заданную строку. |
| `waitForElementToNotContain($locator, $text, $timeout, $interval)` | Текст элемента перестал содержать строку. |
| `waitForAttributeToContain($locator, $attribute, $text, $timeout, $interval)` | Значение атрибута содержит строку. |
| `waitForAttributeToNotContain($locator, $attribute, $text, $timeout, $interval)` | Значение атрибута не содержит строку. |
| `waitForEnabled($locator, $timeout, $interval)` | Элемент разрешено использовать. |
| `waitForDisabled($locator, $timeout, $interval)` | Элемент отключён. |

В этих вызовах `$locator` — CSS-селектор или поддерживаемое XPath-выражение, `$timeout` — максимальное ожидание **в секундах**, `$interval` — интервал проверок **в миллисекундах**. По умолчанию это `30` секунд и `250` миллисекунд. Например:

~~~php
$client->waitForElementToContain('#result', 'Готово', 5, 100);
~~~

Если условие выполнено раньше, метод сразу продолжает работу. При истечении времени ожидания выбрасывается исключение. После успешного ожидания метод возвращает обновлённый Panther Crawler. Контракты методов находятся в [Client.php тега 2.4.0](https://github.com/symfony/panther/blob/v2.4.0/src/Client.php).

Если JavaScript полностью заменил узел, старый объект элемента может вызвать `StaleElementReferenceException`. Получите его заново после ожидания:

~~~php
$client->waitForElementToContain('[data-testid="contact-status"]', 'Спасибо', 5);

$text = $client->getCrawler()
    ->filter('[data-testid="contact-status"]')
    ->text();
~~~

`sleep(5)` всегда расходует пять секунд и всё равно может оказаться слишком коротким на загруженном CI. Ожидание конкретного состояния страницы обычно делает тест быстрее и понятнее.

## Где похожий на BrowserKit API заканчивается

Panther поддерживает привычные названия методов, но браузерный клиент отличается от Symfony `KernelBrowser`:

| Задача | Как поступить |
| --- | --- |
| Открыть страницу | `$client->request('GET', '/contact')`. |
| Сделать POST через UI | Заполнить и отправить форму; браузер выполнит POST самостоятельно. |
| Проверить код ответа и JSON API | Использовать `WebTestCase` или HTTP-клиент. |
| Проверить результат AJAX в интерфейсе | Дождаться изменения DOM и проверить текст/состояние. |
| Проверить итоговый адрес после редиректа | Использовать `getCurrentURL()`. |
| Подменить сервис для браузерного запроса | Настроить замену в окружении отдельного сервера приложения. |

У `Panther\Client::request()` в 2.4 разрешён только `GET`; передача произвольного тела, параметров, файлов или серверных заголовков через аргументы этого метода не поддерживается. `getResponse()` и `getRequest()` не возвращают объекты HttpFoundation — они выбрасывают исключение. Поэтому `assertResponseIsSuccessful()` из обычного `WebTestCase` не подходит для такого браузерного клиента. Это ограничения [реализации Client](https://github.com/symfony/panther/blob/v2.4.0/src/Client.php), а не отсутствие POST в браузере.

## Два независимых браузера

Для чатов, Mercure и совместного редактирования нужен сценарий с несколькими пользователями. `createAdditionalPantherClient()` создаёт дополнительную сессию браузера. Сами cookies и storage не нужно вручную копировать между клиентами.

В нашем проекте можно добавить в `ContactTest` такой метод:

~~~php
public function testBrowsersHaveIndependentFormState(): void
{
    if ((getenv('E2E_BROWSER') ?: self::CHROME) !== self::CHROME) {
        self::markTestSkipped('Этот пример использует две Chrome-сессии.');
    }

    $first = $this->openContact();
    $first->executeScript("localStorage.setItem('panther-demo', 'first');");
    $first->getCrawler()->filter('[name="name"]')->sendKeys('Анна');

    $second = self::createAdditionalPantherClient();
    $second->request('GET', '/contact');

    self::assertNull($second->executeScript(
        "return localStorage.getItem('panther-demo');",
    ));
    self::assertSame('', $second->executeScript(
        "return document.querySelector('[name=name]').value;",
    ));

    $second->submitForm('Отправить', [
        'name' => 'Борис',
        'email' => 'boris@example.test',
        'topic' => 'partnership',
        'consent' => true,
    ]);
    $second->waitForElementToContain(
        '[data-testid="contact-status"]',
        'Спасибо, Борис!',
        5,
    );

    self::assertSame(
        'idle',
        $first->getCrawler()
            ->filter('[data-testid="contact-status"]')
            ->attr('data-state'),
    );
}
~~~

Здесь второй браузер не видит `localStorage` первого, открывает незаполненную форму и отправляет собственные данные. Первый остаётся на своей форме. Это проверка изоляции браузерного состояния; обмен сообщениями между пользователями нужно проверять отдельным сценарием приложения.

Когда клиентов несколько, проверяйте конкретный `$first` или `$second`. Короткие статические assertions используют зарегистрированный клиент, поэтому явный доступ к нужному браузеру делает проверку однозначной.

Пример с двумя сессиями рассчитан на Chrome. У локального GeckoDriver есть ограничение на одновременно активную сессию; несколько Firefox требуют другой организации драйверов, например отдельных экземпляров или Selenium Grid. Практический разбор разделения драйверов приведён в [статье об изоляции и параллельных тестах](https://blog.jondh.me.uk/2023/10/robust-and-parallelisable-browser-tests-with-php-geckodriver-and-symfony-panther/).

Полноценный пример проверки Mercure, где один браузер получает изменение из другого, есть в [EasyAdmin & Mercure: a concrete use case](https://les-tilleuls.coop/en/blog/easyadmin-mercure-a-concrete-use-case).

## Скриншоты и логи при ошибках

Каталог `var/panther` должен существовать и быть доступен на запись процессу тестов. С `ServerExtension` и `PANTHER_ERROR_SCREENSHOT_DIR` Panther сохраняет скриншоты при сбоях тестов. В нашем `tearDown()` родительская обработка выполняется до закрытия браузера.

Скриншот и HTML можно сохранить вручную после открытия страницы:

~~~php
$client->takeScreenshot('var/panther/contact.png');
file_put_contents('var/panther/contact.html', $client->getPageSource());
~~~

`takeScreenshot($path)` сохраняет изображение по указанному пути и возвращает его содержимое. Рассматривайте такой скриншот как снимок текущего браузерного вида: метод не задаёт универсальный контракт захвата всей длинной страницы.

Для консольных логов Chrome настройте capabilities **при создании клиента**:

~~~php
$client = self::createPantherClient(
    ['browser' => self::CHROME],
    [],
    [
        'capabilities' => [
            'goog:loggingPrefs' => ['browser' => 'ALL'],
        ],
    ],
);
$client->request('GET', '/contact');

$logs = $client->getWebDriver()->manage()->getLog('browser');
file_put_contents(
    'var/panther/browser.json',
    json_encode($logs, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR),
);
~~~

Третий аргумент `createPantherClient()` — настройки менеджера браузера, второй — параметры ядра тестового процесса. Настройки уже запущенной сессии не меняются повторным вызовом фабрики: при необходимости начните новую сессию.

## База данных, моки и вход пользователя

### Транзакция теста не равна транзакции приложения

Если тест создал запись, но ещё не закоммитил транзакцию, отдельный PHP-процесс приложения обычно её не увидит. Транзакция, открытая DAMADoctrineTestBundle в процессе PHPUnit, не становится транзакцией PHP-сервера Panther и не откатывает автоматически все изменения браузерного запроса.

Для браузерных тестов подготовьте отдельную базу, сохраните данные до открытия страницы и определите, как очищать их между сценариями. Если в проекте уже настроены DoctrineFixturesBundle и тестовое соединение, подготовка одноразовой базы может включать:

~~~bash
APP_ENV=test php bin/console doctrine:database:create --if-not-exists
APP_ENV=test php bin/console doctrine:migrations:migrate --no-interaction
APP_ENV=test php bin/console doctrine:fixtures:load --no-interaction
~~~

Последняя команда очищает данные перед загрузкой фикстур. Она предназначена для отдельной тестовой базы. Одной загрузки перед всей suite недостаточно, если тесты изменяют общие записи: нужны независимые данные или сброс между сценариями.

Если тест после браузерного запроса читает запись через свой Doctrine EntityManager, учитывайте его identity map: может потребоваться `clear()` или `refresh()`, чтобы увидеть изменения другого процесса.

### Мок нужно передать серверу приложения

Вызов `getContainer()->set(...)` меняет контейнер тестового процесса. Сервер Panther продолжит использовать свою конфигурацию. Для внешней оплаты, отправки писем и других интеграций задавайте тестовый транспорт или подмену сервиса в `config/services_test.yaml`, `config/packages/test/` и окружении сервера.

`PANTHER_APP_ENV=test` в примере нужен именно для запуска автоматического сервера в этом окружении. Если сервер уже существует и задан `PANTHER_EXTERNAL_BASE_URI`, его окружение нужно настроить при его собственном запуске.

### Авторизация проходит через браузер

Метод `loginUser()` обычного `KernelBrowser` не является методом браузерного Panther Client. Для E2E-сценария войдите через настоящую форму входа с подготовленной тестовой учётной записью. После этого клиент сохранит cookies и сможет перейти к защищённой странице.

Создание отдельного браузера не создаёт пользователя в приложении. Учётные записи и разрешения необходимо подготовить самостоятельно.

## Подключение к уже работающему приложению

Сервер может запускаться отдельно, например через Nginx и PHP-FPM. Тогда задайте адрес:

~~~bash
PANTHER_EXTERNAL_BASE_URI=http://127.0.0.1:8000 vendor/bin/phpunit -c phpunit.dist.xml
~~~

Panther не будет запускать встроенный PHP-сервер. `request('GET', '/contact')` откроет страницу относительно указанного адреса.

Адрес должен быть доступен **из браузера**. Если Chrome находится в другом контейнере, `127.0.0.1` указывает на контейнер Chrome. Для общей Compose-сети обычно нужен адрес вроде `http://app:8000`, где `app` — имя сервиса приложения.

Не путайте два соединения:

- PHP-процесс Panther обращается к WebDriver;
- сам браузер обращается к сайту.

Для удалённого Selenium создание клиента может выглядеть так:

~~~php
use Facebook\WebDriver\Remote\DesiredCapabilities;

$client = self::createPantherClient(
    [
        'browser' => self::SELENIUM,
        'external_base_uri' => 'http://app:8000',
    ],
    [],
    [
        'host' => 'http://selenium:4444',
        'capabilities' => DesiredCapabilities::chrome(),
    ],
);
~~~

Это вариант для уже подготовленной инфраструктуры с сервисами `app` и `selenium`. Его нужно подставить вместо фабрики в `openContact()`. Приложение и Selenium должны быть готовы принимать соединения до запуска suite.

## Docker: приложение и Chrome в одном тестовом контейнере

Для первого проекта проще собрать отдельный образ тестирования. В нём будут PHP, ChromeDriver, Chromium и приложение. Локальный сервер и браузер смогут общаться через loopback. Этот образ предназначен для E2E-запуска; браузер не требуется в образе приложения для production.

Создайте `Dockerfile.e2e`:

~~~dockerfile
FROM php:8.4-cli-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        unzip \
        chromium \
        chromium-driver \
        fonts-liberation \
        libcurl4-openssl-dev \
        libonig-dev \
        libxml2-dev \
        libzip-dev \
    && docker-php-ext-install curl dom mbstring xml xmlwriter zip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

ARG TEST_UID=1000
ARG TEST_GID=1000

RUN groupadd --gid "${TEST_GID}" tester \
    && useradd --create-home --uid "${TEST_UID}" --gid "${TEST_GID}" tester

WORKDIR /app
RUN chown tester:tester /app
COPY --chown=tester:tester . .

USER tester
RUN composer install --no-interaction --prefer-dist --no-progress \
    && mkdir -p var/panther

ENV PANTHER_CHROME_BINARY=/usr/bin/chromium

CMD ["vendor/bin/phpunit", "-c", "phpunit.dist.xml", "--testsuite=e2e"]
~~~

`chromium` и `chromium-driver` устанавливаются из одного репозитория Debian. Внутри этого образа `bdi detect drivers` запускать не нужно: драйвер уже доступен через `PATH`.

Создайте `.dockerignore`, чтобы локальные зависимости и драйверы не попали в образ:

~~~dockerignore
.git
vendor
var
drivers
.env.local
.env.*.local
~~~

Создайте `compose.e2e.yaml`:

~~~yaml
services:
  e2e:
    build:
      context: .
      dockerfile: Dockerfile.e2e
      args:
        TEST_UID: "${LOCAL_UID:-1000}"
        TEST_GID: "${LOCAL_GID:-1000}"
    environment:
      PANTHER_NO_SANDBOX: "${PANTHER_NO_SANDBOX:-1}"
    shm_size: "${PANTHER_SHM_SIZE:-1gb}"
    volumes:
      - ./var/panther:/app/var/panther
~~~

В этом изолированном тестовом контейнере отключён sandbox Chrome, поскольку стандартные ограничения контейнера могут мешать его запуску. Это ослабляет изоляцию самого браузера; запускайте здесь подготовленные тестовые страницы. Если среда позволяет Chrome работать с sandbox, передайте `PANTHER_NO_SANDBOX=0`.

`shm_size` увеличивает `/dev/shm`, который использует Chromium. UID и GID передаются из окружения, чтобы скриншоты в подключённой папке оставались доступны пользователю хоста.

Запуск:

~~~bash
mkdir -p var/panther
LOCAL_UID="$(id -u)" LOCAL_GID="$(id -g)" \
    docker compose -f compose.e2e.yaml run --rm --build e2e
~~~

PHP-пакеты берутся из `composer.lock`. Теги базовых Docker-образов и Debian-пакеты при пересборке могут обновиться; если нужен полностью воспроизводимый CI, дополнительно фиксируйте образы по digest и управляйте обновлениями браузера и драйвера вместе.

## GitHub Actions: запуск и сохранение артефактов

Когда Dockerfile и Compose-конфигурация добавлены в репозиторий примера, создайте `.github/workflows/e2e.yaml`:

~~~yaml
name: Panther E2E

on:
  push:
  pull_request:

jobs:
  e2e:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    permissions:
      contents: read

    steps:
      - uses: actions/checkout@v7

      - name: Prepare artifacts directory
        run: mkdir -p var/panther

      - name: Run browser tests
        run: |
          LOCAL_UID="$(id -u)" LOCAL_GID="$(id -g)" \
            docker compose -f compose.e2e.yaml run --rm --build e2e

      - name: Upload browser artifacts
        if: always()
        uses: actions/upload-artifact@v7
        with:
          name: panther-browser-artifacts
          path: var/panther/
          if-no-files-found: ignore
          retention-days: 7
~~~

PHPUnit возвращает ненулевой код при провале теста, и шаг CI завершается ошибкой. Следующий шаг выполняется благодаря `if: always()`, поэтому скриншоты можно скачать и после неуспешного запуска. Версии Actions указаны по состоянию на дату статьи. [Checkout](https://github.com/actions/checkout/releases/tag/v7.0.1), [Upload Artifact](https://github.com/actions/upload-artifact/releases/tag/v7.0.2)

### Параллельный запуск требует изоляции

Если перейти к ParaTest, каждому worker нужны собственные порты PHP-сервера и локального драйвера, данные приложения и браузерная сессия. Один общий порт `9080` и одна изменяемая база не дают независимые тесты. Вариант с несколькими отдельными CI jobs или контейнерами часто проще организовать сначала.

## Самостоятельный PHP-скрипт без PantherTestCase

Библиотеку можно использовать для браузерной автоматизации вне PHPUnit. В уже созданном проекте добавьте `bin/contact-screenshot.php`:

~~~php
<?php

declare(strict_types=1);

use Symfony\Component\Panther\Client;

require dirname(__DIR__).'/vendor/autoload.php';

$url = getenv('TARGET_URL') ?: 'http://127.0.0.1:8000/contact';
$directory = dirname(__DIR__).'/var/panther';

if (!is_dir($directory)) {
    mkdir($directory, 0775, true);
}

$client = Client::createChromeClient();

try {
    $client->request('GET', $url);
    $client->waitFor('[data-testid="contact-form"]', 5);

    echo $client->getTitle(), PHP_EOL;
    $client->takeScreenshot($directory.'/contact.png');
} finally {
    $client->quit();
}
~~~

`Client::createChromeClient()` сам не поднимает PHP-сервер приложения. Для этого скрипта запустите Symfony отдельно в первом терминале:

~~~bash
APP_ENV=test php -S 127.0.0.1:8000 -t public
~~~

Во втором терминале, из корня проекта:

~~~bash
php bin/contact-screenshot.php
~~~

`finally` закрывает браузер и драйвер при успешном выполнении и при обычном исключении. Это особенно полезно для пакетной обработки: оставленные процессы браузера постепенно расходуют память.

## Частые проблемы

| Симптом | Что проверить |
| --- | --- |
| `chromedriver binary not found` | Установлен ли драйвер, доступен ли он в `PATH` или `drivers/`. Запустите `bdi detect drivers` в локальном окружении. |
| `session not created` | Совпадают ли браузер и драйвер по поддерживаемым версиям; может ли Chrome создать временный профиль. |
| Браузер не открывается в контейнере | Наличие Chromium, путь `PANTHER_CHROME_BINARY`, права на временные каталоги, ограничения sandbox. |
| `port ... already in use` | Порты PHP-сервера и драйвера, оставшиеся процессы или параллельные worker. |
| Тест ждёт элемент до timeout | Итоговый URL, правильность селектора, авторизацию, ошибку JavaScript, ответ запроса; сохраните скриншот и HTML. |
| Страница открывается, но assets возвращают 404 | Собраны ли frontend-ресурсы. Для проекта с AssetMapper может потребоваться `APP_ENV=test php bin/console asset-map:compile`. |
| `StaleElementReferenceException` | Не заменил ли JavaScript узел, который хранится в старом объекте элемента. Найдите его заново. |
| Фикстура есть в тесте, но отсутствует в браузере | Одно ли тестовое соединение настроено у двух процессов, закоммичены ли данные. |
| Мок не вызывается | Был ли он настроен именно в серверном процессе приложения. |
| В Docker вместо приложения ошибка соединения | Что означает `localhost` из контейнера браузера и доступен ли нужный адрес через Compose-сеть. |

Перед увеличением таймаутов выясните, какое состояние страницы действительно наступило. Долгое ожидание не исправит неверный URL, упавший JavaScript или приложение, запущенное с другой базой.

## Panther и Playwright: что учитывать сейчас

Panther 2.4 остаётся отдельной библиотекой Symfony для браузерных тестов. При выборе дополнительных обёрток учитывайте изменения их API: в августе 2026 года автор `zenstruck/browser` описал переход своей библиотеки на Playwright и объявление её Panther-интеграции устаревшей. Это касается интеграции `zenstruck/browser`, а не статуса самого пакета `symfony/panther`. В примерах статьи используется Panther напрямую. [Разбор изменений от автора Zenstruck Browser](https://symfonycasts.com/blog/playwright-php-symfony)

## Что взять в свой проект

Начните с одного важного пользовательского пути. Подготовьте данные, откройте страницу, выполните действия через браузер и дождитесь результата, который видит пользователь. Затем добавьте сценарий отказа: ошибка валидации, недоступная операция или отклонённый запрос.

Для примера формы таким результатом стали сообщение сервера, состояние `data-state` и снова доступная кнопка. Для чата это может быть сообщение в другом браузере, для корзины — пересчитанная сумма, для админки — обновлённая запись после сохранения.

### Источники

- [Официальное руководство Symfony по Panther](https://symfony.com/doc/current/testing/end_to_end.html).
- [Исходники Panther 2.4.0](https://github.com/symfony/panther/tree/v2.4.0/src).
- [PHP WebDriver](https://github.com/php-webdriver/php-webdriver).
- [Настройка PHPUnit 11.5](https://docs.phpunit.de/en/11.5/configuration.html).
- [Пример двух браузеров для EasyAdmin и Mercure](https://les-tilleuls.coop/en/blog/easyadmin-mercure-a-concrete-use-case).
- [Изоляция и параллельные браузерные тесты](https://blog.jondh.me.uk/2023/10/robust-and-parallelisable-browser-tests-with-php-geckodriver-and-symfony-panther/).
