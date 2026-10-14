# Mercure с Symfony: общая лента и личные уведомления в реальном времени

Пользователь открыл страницу, а на сервере закончилось формирование отчёта. Как показать сообщение об этом сразу, без обновления страницы? Один из вариантов — Mercure: приложение публикует событие в Hub, а Hub передаёт его открытым браузерам.

В этой статье соберём пример на Symfony: общая лента уведомлений доступна всем, а личные сообщения получают только Alice или Bob. События будем отправлять Symfony-командой. В браузере используем стандартный `EventSource`, для приватной подписки — JWT в `HttpOnly` cookie.

Пример описывает версии, актуальные на **9 октября 2026 года**:

| Компонент | Версия |
| --- | --- |
| PHP | 8.4 |
| Symfony | 7.4 |
| `symfony/mercure` | 0.9.0 |
| `symfony/mercure-bundle` | 0.6.0 |
| Mercure Hub | 1.1.0 |
| Протокол Mercure | 1.0 |

Версия PHP-компонента, версия Bundle и версия протокола — разные номера. Hub 1.1.0 опубликован 8 октября 2026 года, PHP-компонент 0.9.0 и Bundle 0.6.0 — 7 октября. [Релиз Hub](https://github.com/dunglas/mercure/releases/tag/v1.1.0), [релиз компонента](https://github.com/symfony/mercure/releases/tag/v0.9.0), [релиз Bundle](https://github.com/symfony/mercure-bundle/releases/tag/v0.6.0).

## Как проходит событие

~~~text
Symfony-команда
    │ POST: событие + publisher JWT
    ▼
Mercure Hub
    │ длительное SSE-соединение
    ▼
EventSource в браузере → обработчик JavaScript → сообщение на странице
~~~

Symfony отправляет обычный HTTP-запрос к Hub. Постоянное соединение с браузером держит Hub: PHP-процесс приложения не занят ожиданием следующего события.

SSE передаёт события от сервера к клиенту. Действия пользователя в обратную сторону можно отправлять обычными HTTP-запросами к Symfony. Для полноценного двустороннего обмена по одному соединению существуют другие варианты, например WebSocket.

## Что изменилось по сравнению со старыми примерами

В Bundle 0.6 и компоненте 0.9 протокол 1.0 используется по умолчанию. Ниже мы зададим его явно. Это важно: старый пример с `mercure.publish` и современная конфигурация Hub не всегда совместимы.

| Часть интеграции | В примере с протоколом 1.0 |
| --- | --- |
| Подписка на точную тему | Параметр `match` в URL Hub. |
| Подписка по URL Pattern | Параметр `match_urlpattern`. |
| Разрешения JWT | `authorization_details`, содержащий действия и темы. |
| Тип JWT | Заголовок `typ: at+jwt`. |
| Проверка издателя токена | Блок `issuer` в Caddyfile. |
| Cookie для HTTPS | `__Secure-mercure_access_token`. |
| Курсор при создании подписки | Параметр `last_event_id`. |

Синтаксис сверяется с [протоколом из тега Hub 1.1.0](https://github.com/dunglas/mercure/blob/v1.1.0/spec/mercure.md). В статьях и отдельных страницах документации ещё встречаются `topic=` для подписки, `lastEventID` и старое имя cookie `mercureAuthorization`.

При **публикации** поле `topic` по-прежнему используется: изменилось имя параметра подписки, а не название этого поля HTTP POST.

## Что получится

У приложения будут три HTTP-маршрута:

| Адрес | Назначение |
| --- | --- |
| `GET /notifications` | Общая лента, вход не требуется. |
| `GET /private/notifications` | Личная лента текущего пользователя. |
| `POST /private/mercure/authorize` | Обновление cookie для приватной подписки. |

И одна Symfony-команда:

~~~bash
php bin/console app:notify 'Общее уведомление'
php bin/console app:notify 'Ваш отчёт готов' --user=alice
~~~

Это пример доставки уведомлений. Постоянный список сообщений в базе данных, отметки о прочтении и бизнес-процесс формирования отчёта сюда не входят.

## 1. Устанавливаем зависимости

Создайте новый проект:

~~~bash
composer create-project symfony/skeleton:"7.4.*" mercure-demo
cd mercure-demo

composer require \
    symfony/twig-bundle \
    symfony/security-bundle \
    symfony/security-csrf \
    symfony/mercure-bundle:"0.6.0" \
    symfony/mercure:"0.9.0" \
    --no-scripts
~~~

`--no-scripts` откладывает очистку и прогрев контейнера приложения до настройки Mercure. Для протокола 1.0 новые версии Bundle требуют дополнительные JWT claims, которых может не оказаться в конфигурации, созданной старым рецептом Flex.

После настройки запустим `auto-scripts` отдельно. Рецепт Flex регистрирует Bundle в `config/bundles.php`; при ручной регистрации используется класс:

~~~php
Symfony\Bundle\MercureBundle\MercureBundle::class => ['all' => true],
~~~

Для PHP-процесса потребуется обычное окружение Symfony 7.4; примеры с `mb_strlen()` ниже предполагают доступность `mbstring`.

## 2. Готовим секреты и локальное окружение

Сгенерируйте три разных значения: `APP_SECRET`, ключ издателя и ключ подписчика. Например, выполните эту команду три раза:

~~~bash
php -r 'echo bin2hex(random_bytes(32)), PHP_EOL;'
~~~

Для Alice и Bob выберите свои пароли и получите bcrypt-хеш каждого. Следующая команда читает пароль из стандартного ввода; введите его и нажмите Enter:

~~~bash
php -r 'echo password_hash(rtrim(fgets(STDIN), "\r\n"), PASSWORD_BCRYPT), PHP_EOL;'
~~~

Создайте `.env.local` и **замените все пять маркеров** с секретами и хешами:

~~~dotenv
APP_ENV=dev
APP_DEBUG=1
APP_SECRET=ВСТАВЬ_ОТДЕЛЬНЫЙ_СЕКРЕТ

APP_ORIGIN=http://localhost:8000
MERCURE_ISSUER=http://localhost:8000
MERCURE_HTTP_PORT=3000

MERCURE_URL=http://127.0.0.1:3000/.well-known/mercure
MERCURE_PUBLIC_URL=http://localhost:3000/.well-known/mercure

MERCURE_PUBLISHER_JWT_KEY=ВСТАВЬ_КЛЮЧ_ИЗДАТЕЛЯ
MERCURE_SUBSCRIBER_JWT_KEY=ВСТАВЬ_ДРУГОЙ_КЛЮЧ_ПОДПИСЧИКА
MERCURE_COOKIE_NAME=mercure_access_token
MERCURE_COOKIE_TTL=300

ALICE_PASSWORD_HASH='ВСТАВЬ_ХЕШ_ПАРОЛЯ_ALICE'
BOB_PASSWORD_HASH='ВСТАВЬ_ХЕШ_ПАРОЛЯ_BOB'
~~~

Хеши помещены в одинарные кавычки, чтобы символы `$` внутри bcrypt не интерпретировались как переменные. Храните `.env.local` вне Git.

В примере PHP работает на хосте, Hub — в Docker. Поэтому `127.0.0.1:3000` доступен PHP-команде. Браузер открывает приложение и Hub по имени `localhost`: это важно для cookie и CORS.

| Переменная | Что означает |
| --- | --- |
| `MERCURE_URL` | Адрес публикации, доступный PHP-процессу. |
| `MERCURE_PUBLIC_URL` | Адрес подписки, доступный браузеру. |
| `MERCURE_ISSUER` | Идентификатор доверенного издателя JWT, значение claim `iss`. |
| `APP_ORIGIN` | Разрешённый origin страницы: схема, имя хоста и порт. |
| `MERCURE_COOKIE_NAME` | Одинаковое имя cookie в Symfony и Hub. |
| `MERCURE_COOKIE_TTL` | Срок жизни cookie и выдаваемого для неё токена, в секундах. |

## 3. Поднимаем Hub через Docker Compose

Создайте `docker/mercure/Caddyfile`:

~~~caddyfile
{
    auto_https off
}

:80 {
    mercure {
        issuer {$MERCURE_ISSUER} {
            publisher {
                jwt {env.MERCURE_PUBLISHER_JWT_KEY} HS256
            }
            subscriber {
                jwt {env.MERCURE_SUBSCRIBER_JWT_KEY} HS256
            }
        }

        resource_identifier {$MERCURE_PUBLIC_URL}
        cookie_name {$MERCURE_COOKIE_NAME}
        cors_origins {$APP_ORIGIN}
        anonymous

        transport bolt {
            path /data/mercure.db
            size 1000
            cleanup_frequency 0.3
        }
    }

    respond "Not Found" 404
}
~~~

Здесь:

- `issuer` связывает ожидаемое значение `iss` с ключами проверки токенов;
- `publisher` проверяет JWT публикации, `subscriber` — JWT приватной подписки;
- `resource_identifier` фиксирует идентификатор Hub для проверки `aud`, независимо от имени хоста во внутреннем HTTP-запросе;
- `cookie_name` согласует имя cookie с приложением;
- `cors_origins` разрешает браузерные подключения со страницы приложения;
- `anonymous` разрешает анонимные подписки на публичные обновления;
- Bolt transport хранит историю в файле, а настройки очистки ограничивают её рост.

Параметр `size` задаёт целевой размер сохраняемой истории, а очистка выполняется вероятностно. Не рассматривайте это как обещание хранить ровно тысячу событий в любой момент. [Конфигурация Caddy-модуля 1.1.0](https://github.com/dunglas/mercure/blob/v1.1.0/caddy/mercure.go), [Bolt transport](https://github.com/dunglas/mercure/blob/v1.1.0/caddy/bolt.go).

Создайте `compose.mercure.yaml`:

~~~yaml
services:
  mercure:
    image: dunglas/mercure:v1.1.0
    restart: unless-stopped
    ports:
      - "127.0.0.1:${MERCURE_HTTP_PORT:-3000}:80"
    environment:
      APP_ORIGIN: "${APP_ORIGIN:?Укажи APP_ORIGIN}"
      MERCURE_ISSUER: "${MERCURE_ISSUER:?Укажи MERCURE_ISSUER}"
      MERCURE_PUBLIC_URL: "${MERCURE_PUBLIC_URL:?Укажи MERCURE_PUBLIC_URL}"
      MERCURE_COOKIE_NAME: "${MERCURE_COOKIE_NAME:?Укажи MERCURE_COOKIE_NAME}"
      MERCURE_PUBLISHER_JWT_KEY: "${MERCURE_PUBLISHER_JWT_KEY:?Укажи ключ издателя}"
      MERCURE_SUBSCRIBER_JWT_KEY: "${MERCURE_SUBSCRIBER_JWT_KEY:?Укажи ключ подписчика}"
    volumes:
      - ./docker/mercure/Caddyfile:/etc/caddy/Caddyfile:ro
      - mercure_data:/data
      - mercure_config:/config

volumes:
  mercure_data:
  mercure_config:
~~~

Запуск:

~~~bash
docker compose --env-file .env.local -f compose.mercure.yaml up -d
docker compose --env-file .env.local -f compose.mercure.yaml logs --tail=50 mercure
~~~

`--env-file .env.local` нужен Docker Compose для подстановки переменных. Symfony сам читает свой `.env.local` через Dotenv. Совпадение имён файлов не означает, что Compose автоматически использует правила загрузки окружения Symfony.

HTTP и имя cookie без `__Secure-` здесь используются для локальной разработки. Порт Hub опубликован только на loopback. Для реальных пользователей нужны HTTPS и другая конфигурация внешних адресов — к этому вернёмся ниже.

## 4. Настраиваем MercureBundle

Замените содержимое `config/packages/mercure.yaml`:

~~~yaml
mercure:
    default_cookie_lifetime: '%env(int:MERCURE_COOKIE_TTL)%'
    hubs:
        default:
            url: '%env(MERCURE_URL)%'
            public_url: '%env(MERCURE_PUBLIC_URL)%'
            protocol_version: '1.0'
            cookie_name: '%env(MERCURE_COOKIE_NAME)%'

            publisher:
                secret: '%env(MERCURE_PUBLISHER_JWT_KEY)%'
                algorithm: hmac.sha256
                topics:
                    - 'https://example.test/notifications/public'
                    - 'https://example.test/users/alice/notifications'
                    - 'https://example.test/users/bob/notifications'
                claims:
                    iss: '%env(MERCURE_ISSUER)%'
                    aud: '%env(MERCURE_PUBLIC_URL)%'
                    sub: mercure-demo-publisher
                    client_id: mercure-demo

            subscriber:
                secret: '%env(MERCURE_SUBSCRIBER_JWT_KEY)%'
                algorithm: hmac.sha256
                claims:
                    iss: '%env(MERCURE_ISSUER)%'
                    aud: '%env(MERCURE_PUBLIC_URL)%'
                    sub: mercure-demo-subscriber
                    client_id: mercure-demo
~~~

Bundle 0.6 поддерживает отдельные разделы `publisher` и `subscriber`: публикация и выдача подписчику cookie используют разные ключи. Не добавляйте рядом третий раздел `jwt`: эти способы конфигурации взаимоисключающие. [Схема конфигурации Bundle 0.6](https://github.com/symfony/mercure-bundle/blob/v0.6.0/src/DependencyInjection/Configuration.php).

В Caddyfile алгоритм называется `HS256`, а фабрика Lcobucci в Bundle использует имя `hmac.sha256`. Это обозначения одного алгоритма в разных API.

### Что означают claims

| Claim | Значение в примере |
| --- | --- |
| `iss` | Кто выпустил токен. Должен совпасть с `issuer` в Caddyfile. |
| `aud` | Для какого Hub выдан токен. Совпадает с `resource_identifier`. |
| `sub` | Субъект токена: издатель либо конкретный пользователь. |
| `client_id` | Идентификатор приложения-клиента. |
| `exp` | Время истечения токена. Фабрика задаёт его автоматически, а для cookie мы используем TTL из конфигурации. |

Современный access token использует структуру [RFC 9068](https://www.rfc-editor.org/rfc/rfc9068), а его разрешения описываются через `authorization_details` из [RFC 9396](https://www.rfc-editor.org/rfc/rfc9396). В PHP будем задавать эти разрешения объектами `Grant`, а сериализацию в JWT выполнит библиотека.

Список `publisher.topics` ограничивает нашу команду тремя точными темами. Если получателей станет больше, потребуется изменить модель разрешений. Подписчикам разрешение на чтение всех личных тем мы не выдаём.

В обычном режиме фабрика генерирует токен публикации при обращении к provider; длинно работающий процесс не обязан хранить один заранее скопированный JWT бесконечно. [FactoryTokenProvider](https://github.com/symfony/mercure/blob/v0.9.0/src/Jwt/FactoryTokenProvider.php), [формирование claims](https://github.com/symfony/mercure/blob/v0.9.0/src/Jwt/JwtClaims.php).

## 5. Настраиваем Symfony Security

В `config/packages/framework.yaml` включите сессию и CSRF, объединив параметры с конфигурацией skeleton:

~~~yaml
framework:
    secret: '%env(APP_SECRET)%'
    session: true
    csrf_protection: true
~~~

Создайте или замените `config/packages/security.yaml`:

~~~yaml
security:
    password_hashers:
        Symfony\Component\Security\Core\User\PasswordAuthenticatedUserInterface: auto

    providers:
        demo_users:
            memory:
                users:
                    alice:
                        password: '%env(ALICE_PASSWORD_HASH)%'
                        roles: [ROLE_USER]
                    bob:
                        password: '%env(BOB_PASSWORD_HASH)%'
                        roles: [ROLE_USER]

    firewalls:
        main:
            lazy: true
            provider: demo_users
            http_basic:
                realm: 'Mercure demo'

    access_control:
        - { path: '^/private/', roles: ROLE_USER }
~~~

Для демонстрации достаточно двух пользователей в memory provider и встроенного окна HTTP Basic в браузере. В существующем проекте используйте свой provider и привычную форму входа: Mercure нужен уже определённый Symfony-пользователь. [Memory user provider](https://symfony.com/doc/7.4/security/user_providers.html#memory-user-provider), [HTTP Basic](https://symfony.com/doc/7.4/reference/configuration/security.html#http-basic).

В `config/routes.yaml` задайте импорт атрибутов контроллеров:

~~~yaml
controllers:
    resource:
        path: ../src/Controller/
        namespace: App\Controller
    type: attribute
~~~

## 6. Определяем темы уведомлений

Создайте `src/Notification/NotificationTopic.php`:

~~~php
<?php

declare(strict_types=1);

namespace App\Notification;

final class NotificationTopic
{
    public const PUBLIC = 'https://example.test/notifications/public';

    public static function forUser(string $identifier): string
    {
        return 'https://example.test/users/'
            .rawurlencode($identifier)
            .'/notifications';
    }
}
~~~

Тема — идентификатор ресурса или канала. Адрес `https://example.test/...` не обязан открываться как страница: Hub сопоставляет строку темы со строкой подписки и разрешениями токена.

Одна функция формирует тему и при публикации, и при подписке. Это исключает ситуацию, когда издатель использует `/users/alice/notifications`, а подписчик случайно ждёт `/user/alice/notifications`.

## 7. Публикуем через HubInterface

Создайте `src/Notification/NotificationPublisher.php`:

~~~php
<?php

declare(strict_types=1);

namespace App\Notification;

use Symfony\Component\Mercure\HubInterface;
use Symfony\Component\Mercure\Update;

final class NotificationPublisher
{
    public function __construct(private readonly HubInterface $hub)
    {
    }

    public function publish(string $message, ?string $recipient = null): string
    {
        $message = trim($message);

        if ($message === '' || mb_strlen($message) > 500) {
            throw new \InvalidArgumentException('Сообщение должно содержать от 1 до 500 символов.');
        }

        if ($recipient !== null && trim($recipient) === '') {
            throw new \InvalidArgumentException('Получатель не может быть пустым.');
        }

        $topic = $recipient === null
            ? NotificationTopic::PUBLIC
            : NotificationTopic::forUser($recipient);

        $data = json_encode([
            'notificationId' => bin2hex(random_bytes(16)),
            'message' => $message,
            'createdAt' => (new \DateTimeImmutable())->format(DATE_ATOM),
        ], JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);

        return $this->hub->publish(new Update(
            topics: $topic,
            data: $data,
            private: $recipient !== null,
            type: 'notification',
            retry: 3000,
        ));
    }
}
~~~

`HubInterface` внедряется через контейнер Symfony. `publish()` выполняет HTTP POST к `MERCURE_URL` и передаёт JWT публикации. При успешном ответе он возвращает идентификатор обновления, выданный Hub; сетевые и HTTP-ошибки оборачиваются в исключение Mercure. [Реализация Hub](https://github.com/symfony/mercure/blob/v0.9.0/src/Hub.php).

### Параметры Update

| Параметр | Тип и назначение |
| --- | --- |
| `topics` | Строка или массив строк: темы обновления. |
| `data` | Строка с полезной нагрузкой. Здесь это JSON. |
| `private` | `true` для доставки только авторизованным подписчикам; по умолчанию `false`. |
| `id` | Необязательный ID обновления. В примере его назначает Hub. |
| `type` | Необязательное имя SSE-события. Здесь `notification`. |
| `retry` | Необязательный интервал повторного подключения клиента, в миллисекундах. |

Конструктор и значения по умолчанию находятся в [Update.php](https://github.com/symfony/mercure/blob/v0.9.0/src/Update.php).

`notificationId` внутри JSON — идентификатор нашего уведомления. ID SSE-события — отдельное значение, которое браузер получает через `event.lastEventId`.

Обратите внимание на `private: $recipient !== null`. Название темы `/users/alice/...` само по себе ничего не защищает. Если отправить туда публичное обновление, его сможет получить анонимный клиент с подходящей подпиской.

## 8. Добавляем команду публикации

Создайте `src/Command/NotifyCommand.php`:

~~~php
<?php

declare(strict_types=1);

namespace App\Command;

use App\Notification\NotificationPublisher;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;
use Symfony\Component\Mercure\Exception\RuntimeException as MercureException;

#[AsCommand(name: 'app:notify', description: 'Отправить уведомление через Mercure')]
final class NotifyCommand extends Command
{
    public function __construct(private readonly NotificationPublisher $publisher)
    {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this
            ->addArgument('message', InputArgument::REQUIRED, 'Текст уведомления')
            ->addOption('user', null, InputOption::VALUE_REQUIRED, 'Получатель: alice или bob');
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);
        $recipient = $input->getOption('user');

        if ($recipient !== null && !in_array($recipient, ['alice', 'bob'], true)) {
            $io->error('В этом примере получателем может быть alice или bob.');

            return Command::INVALID;
        }

        try {
            $eventId = $this->publisher->publish(
                (string) $input->getArgument('message'),
                $recipient,
            );
        } catch (\InvalidArgumentException $exception) {
            $io->error($exception->getMessage());

            return Command::INVALID;
        } catch (MercureException $exception) {
            $io->error('Hub не принял событие. Проверьте адрес, JWT и логи Hub.');

            return Command::FAILURE;
        }

        $io->success('Hub принял обновление: '.$eventId);

        return Command::SUCCESS;
    }
}
~~~

Команду может вызывать оператор, worker или другой доверенный процесс приложения. Если перенесёте публикацию в HTTP-контроллер, отдельно проверьте, имеет ли вызывающий пользователь право создавать такое уведомление и выбирать получателя.

Успешный ответ Hub подтверждает принятие события. Он не означает, что пользователь прочитал сообщение или что браузер уже обработал JavaScript.

## 9. Выдаём разрешение на личную подписку

Создайте `src/Controller/NotificationController.php`:

~~~php
<?php

declare(strict_types=1);

namespace App\Controller;

use App\Notification\NotificationTopic;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Mercure\Authorization;
use Symfony\Component\Mercure\HubInterface;
use Symfony\Component\Mercure\Jwt\Grant;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Component\Security\Http\Attribute\CurrentUser;

final class NotificationController extends AbstractController
{
    public function __construct(
        private readonly HubInterface $hub,
        private readonly Authorization $authorization,
        #[Autowire(env: 'int:MERCURE_COOKIE_TTL')]
        private readonly int $cookieTtl,
    ) {
        if ($cookieTtl < 10) {
            throw new \InvalidArgumentException('Для примера MERCURE_COOKIE_TTL должен быть не меньше 10 секунд.');
        }
    }

    #[Route('/notifications', name: 'notifications_public', methods: ['GET'])]
    public function publicPage(): Response
    {
        return $this->page(NotificationTopic::PUBLIC, false);
    }

    #[Route('/private/notifications', name: 'notifications_private', methods: ['GET'])]
    public function privatePage(
        Request $request,
        #[CurrentUser] UserInterface $user,
    ): Response {
        $this->authorizeSubscriber($request, $user);

        return $this->page(
            NotificationTopic::forUser($user->getUserIdentifier()),
            true,
        );
    }

    #[Route('/private/mercure/authorize', name: 'mercure_authorize', methods: ['POST'])]
    public function renewAuthorization(
        Request $request,
        #[CurrentUser] UserInterface $user,
    ): Response {
        if (!$this->isCsrfTokenValid(
            'mercure_subscribe',
            $request->headers->get('X-CSRF-TOKEN', ''),
        )) {
            return new JsonResponse(
                ['error' => 'Неверный CSRF-токен.'],
                Response::HTTP_FORBIDDEN,
            );
        }

        $this->authorizeSubscriber($request, $user);

        return new Response('', Response::HTTP_NO_CONTENT, [
            'Cache-Control' => 'private, no-store',
        ]);
    }

    private function authorizeSubscriber(Request $request, UserInterface $user): void
    {
        $topic = NotificationTopic::forUser($user->getUserIdentifier());

        $this->authorization->setCookie(
            $request,
            [new Grant([Grant::ACTION_SUBSCRIBE], [$topic])],
            additionalClaims: ['sub' => $user->getUserIdentifier()],
        );
    }

    private function page(string $topic, bool $privateMode): Response
    {
        $response = $this->render('notifications/index.html.twig', [
            'topic' => $topic,
            'hubPublicUrl' => $this->hub->getPublicUrl(),
            'privateMode' => $privateMode,
            'renewAfterSeconds' => max(1, (int) floor($this->cookieTtl * 0.8)),
        ]);
        $response->headers->set('Cache-Control', 'private, no-store');

        return $response;
    }
}
~~~

`CurrentUser` получает уже аутентифицированного пользователя Symfony. Тема вычисляется на сервере из его идентификатора. Клиент не передаёт `userId`, по которому сервер без проверки выдавал бы разрешение на чужую ленту.

`Grant` содержит действие `subscribe` и одну точную тему. У Alice токен разрешает чтение `/users/alice/notifications`, у Bob — `/users/bob/notifications`. Значение `sub` переопределяется идентификатором текущего пользователя; остальные claims приходят из конфигурации фабрики.

`Authorization::setCookie()` подготавливает cookie, а подписчик событий Bundle добавляет её в HTTP-ответ. JWT не передаётся в JavaScript. В нашем HTTP-окружении cookie имеет имя `mercure_access_token`, `HttpOnly`, `SameSite=Strict` и путь Hub; для HTTPS библиотека выставляет `Secure`. [Authorization.php](https://github.com/symfony/mercure/blob/v0.9.0/src/Authorization.php), [Grant.php](https://github.com/symfony/mercure/blob/v0.9.0/src/Jwt/Grant.php).

Для подписки выбирается отдельная фабрика `subscriber`, поэтому выданный пользователю токен не подписывается ключом издателя событий.

## 10. Подписываем браузер через EventSource

Создайте `templates/notifications/index.html.twig`:

~~~twig
<!doctype html>
<html lang="ru">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ privateMode ? 'Личные уведомления' : 'Общие уведомления' }}</title>
</head>
<body>
    <nav>
        <a href="{{ path('notifications_public') }}">Общая лента</a>
        <a href="{{ path('notifications_private') }}">Личная лента</a>
    </nav>

    <h1>{{ privateMode ? 'Личные уведомления' : 'Общие уведомления' }}</h1>
    {% if privateMode %}
        <p>Пользователь: {{ app.user.userIdentifier }}</p>
    {% endif %}

    <p>Тема: <code>{{ topic }}</code></p>
    <p id="connection" role="status">Подключаемся…</p>
    <button id="disconnect" type="button">Отключиться</button>
    <ul id="notifications"></ul>

    {% set settings = {
        hubUrl: hubPublicUrl,
        topic: topic,
        privateMode: privateMode,
        renewUrl: privateMode ? path('mercure_authorize') : null,
        csrf: privateMode ? csrf_token('mercure_subscribe') : null,
        renewAfterSeconds: renewAfterSeconds
    } %}

    <script type="application/json" id="mercure-settings">
        {{ settings|json_encode(
            constant('JSON_HEX_TAG') b-or constant('JSON_HEX_AMP')
            b-or constant('JSON_HEX_APOS') b-or constant('JSON_HEX_QUOT')
        )|raw }}
    </script>

    <script>
        const settings = JSON.parse(
            document.getElementById('mercure-settings').textContent,
        );
        const status = document.getElementById('connection');
        const list = document.getElementById('notifications');
        const disconnect = document.getElementById('disconnect');

        const url = new URL(settings.hubUrl);
        url.searchParams.append('match', settings.topic);

        let source = null;
        let lastEventId = '';
        let stopped = false;
        let renewalTimer = null;
        const seenIds = new Set();
        const idQueue = [];

        function connect() {
            const subscriptionUrl = new URL(url);
            if (lastEventId) {
                subscriptionUrl.searchParams.set('last_event_id', lastEventId);
            }

            const connection = new EventSource(subscriptionUrl, {
                withCredentials: settings.privateMode,
            });
            source = connection;

            connection.addEventListener('open', () => {
                if (!stopped && source === connection) {
                    status.textContent = 'Соединение открыто';
                }
            });

            connection.addEventListener('notification', (event) => {
                if (stopped || source !== connection) {
                    return;
                }

                try {
                    const payload = JSON.parse(event.data);
                    if (event.lastEventId && seenIds.has(event.lastEventId)) {
                        return;
                    }

                    const item = document.createElement('li');
                    const time = new Date(payload.createdAt).toLocaleTimeString();
                    item.textContent = `${time}: ${payload.message}`;
                    list.prepend(item);

                    while (list.children.length > 100) {
                        list.lastElementChild.remove();
                    }

                    if (event.lastEventId) {
                        lastEventId = event.lastEventId;
                        seenIds.add(event.lastEventId);
                        idQueue.push(event.lastEventId);
                        if (idQueue.length > 200) {
                            seenIds.delete(idQueue.shift());
                        }
                    }
                } catch (error) {
                    console.error('Не удалось обработать уведомление', error);
                }
            });

            connection.addEventListener('error', () => {
                if (!stopped && source === connection) {
                    status.textContent = connection.readyState === EventSource.CLOSED
                        ? 'Поток закрыт. Обновите страницу.'
                        : 'Связь прервана. Ожидаем переподключения…';
                }
            });
        }

        connect();

        async function renewAuthorization() {
            if (stopped) {
                return;
            }

            try {
                const response = await fetch(settings.renewUrl, {
                    method: 'POST',
                    credentials: 'same-origin',
                    headers: { 'X-CSRF-TOKEN': settings.csrf },
                });

                if (!response.ok) {
                    throw new Error(`Обновление доступа: HTTP ${response.status}`);
                }

                if (!stopped) {
                    source.close();
                    connect();
                    scheduleRenewal();
                }
            } catch (error) {
                if (!stopped) {
                    stopped = true;
                    source.close();
                    status.textContent = 'Не удалось продлить доступ. Обновите страницу.';
                    console.error(error);
                }
            }
        }

        function scheduleRenewal() {
            renewalTimer = setTimeout(
                renewAuthorization,
                settings.renewAfterSeconds * 1000,
            );
        }

        if (settings.privateMode) {
            scheduleRenewal();
        }

        disconnect.addEventListener('click', () => {
            stopped = true;
            clearTimeout(renewalTimer);
            source.close();
            status.textContent = 'Подписка остановлена';
            disconnect.disabled = true;
        });
    </script>
</body>
</html>
~~~

### Почему слушаем notification, а не onmessage

При публикации задано `type: 'notification'`. Поэтому браузер вызывает обработчик события с таким именем:

~~~javascript
source.addEventListener('notification', handler);
~~~

Если `type` не задан, используйте `message` или `source.onmessage`. Иначе можно получить исправное SSE-соединение, в котором JavaScript просто не слушает нужный тип события.

### Зачем withCredentials

Hub находится на другом origin: порт `3000`, приложение — на `8000`. `withCredentials: true` разрешает браузеру отправить cookie при такой подписке. Hub должен разрешать точный origin страницы через CORS.

Нативный `EventSource` не принимает произвольный заголовок `Authorization`. Для cookie-варианта это не нужно: Symfony выставляет `HttpOnly` cookie, браузер прикладывает её самостоятельно. Для Hub на другом сайте, который нельзя авторизовать подходящей cookie, используйте SSE-клиент на основе `fetch()` с Bearer-токеном. [Авторизация Hub 1.1.0](https://github.com/dunglas/mercure/blob/v1.1.0/docs/concepts/authorization.md).

### Что происходит при истечении JWT

Cookie выдаётся на `MERCURE_COOKIE_TTL` секунд. Страница заранее вызывает Symfony endpoint обновления, который снова проверяет пользователя и CSRF и выдаёт новый JWT.

Активное соединение не меняет уже проверенный токен. Поэтому после успешного обновления cookie наш JavaScript закрывает прежний поток и открывает новый. Hub сразу проверяет свежие разрешения. В новый `EventSource` передаётся последний обработанный ID через `last_event_id`, чтобы восстановить события, сохранившиеся за время переподключения.

Фоновые вкладки могут задерживать таймеры. Повторное подключение после обновления cookie помогает и в случае, когда прежний JWT уже истёк, но размер истории всё равно ограничивает возможное восстановление. Если обновление cookie не удалось, пример останавливает поток и предлагает перезагрузить страницу.

Для logout или смены пользователя в настоящем приложении закройте `EventSource`, остановите таймер и очистите cookie через `Authorization::clearCookie()`. Изменение cookie само по себе не отзывает мгновенно уже открытое соединение.

## 11. Запускаем приложение

Теперь, когда окружение и конфигурация готовы, выполните отложенные команды Flex:

~~~bash
composer run-script auto-scripts
~~~

Запустите Symfony в отдельном терминале:

~~~bash
php -S 127.0.0.1:8000 -t public
~~~

Откройте **http://localhost:8000/notifications**. Используйте именно `localhost`, как в `APP_ORIGIN` и `MERCURE_PUBLIC_URL`.

В другом терминале, из корня проекта:

~~~bash
php bin/console app:notify 'Приложение обновлено'
~~~

Уведомление должно появиться в общей ленте без обновления страницы. Откройте её во второй вкладке и отправьте ещё одно событие: обе вкладки подписаны на одну тему.

### Проверяем личные уведомления

Откройте **http://localhost:8000/private/notifications**, в окне HTTP Basic введите `alice` и выбранный для неё пароль. В другом браузере или отдельном приватном профиле откройте тот же адрес как `bob`.

Обычные вкладки одного профиля разделяют cookies и браузерную HTTP Basic-авторизацию. Для одновременной проверки двух учётных записей нужны изолированные профили.

Отправьте сообщения:

~~~bash
php bin/console app:notify 'Alice, ваш отчёт готов' --user=alice
php bin/console app:notify 'Bob, вам назначена новая задача' --user=bob
~~~

Ожидаемый результат:

- Alice получает первое сообщение в своей личной ленте;
- Bob получает второе;
- общая лента не получает ни одно из этих приватных обновлений.

Статус «Соединение открыто» сам по себе не подтверждает права на конкретные приватные темы. Например, при включённом `anonymous` клиент без JWT может открыть поток, но личные обновления Hub ему не отправит.

## Как Hub проверяет приватное обновление

Здесь работают два независимых условия:

1. **Маршрутизация:** подходит ли тема обновления под `match`, указанный клиентом.
2. **Авторизация:** разрешает ли JWT этого клиента чтение приватной темы.

Если Bob изменит JavaScript и подпишется на тему Alice, строка `match` будет выбирать нужный канал, но токен Bob не даст права получить его приватные события.

Для получения обновления достаточно авторизации хотя бы на одну из его тем. Поэтому при использовании нескольких тем или alternate topics нельзя добавлять к личному событию общий канал, разрешённый всем пользователям. Для издателя, напротив, разрешение требуется на все темы, которые он указал в обновлении. Эти правила описаны в [авторизации протокола 1.0](https://github.com/dunglas/mercure/blob/v1.1.0/docs/concepts/authorization.md#publishers).

## Подписка по шаблону темы

В примере используются точные темы. Если ресурс содержит много однотипных вложенных объектов, можно выдать разрешение на URL Pattern:

~~~php
new Grant(
    [Grant::ACTION_SUBSCRIBE],
    ['urlpattern' => ['https://example.test/users/alice/*']],
);
~~~

И подписаться в браузере по шаблону:

~~~javascript
url.searchParams.append(
    'match_urlpattern',
    'https://example.test/users/alice/*',
);
~~~

Такое разрешение шире одной точной темы. Формируйте пользовательскую часть пути из авторизованного пользователя, как в контроллере выше. URL Patterns и старые URI Templates имеют разный синтаксис; например, `:id` в URL Pattern не нужно заменять на `{id}` из старых примеров. [Правила matcher types](https://github.com/dunglas/mercure/blob/v1.1.0/spec/mercure.md).

## Переподключение и история событий

`EventSource` умеет переподключаться после временного разрыва. Получив ID SSE-события, при следующем подключении тот же объект отправляет `Last-Event-ID`. Hub может повторно передать более новые события, сохранившиеся в истории. [Поведение EventSource в HTML Standard](https://html.spec.whatwg.org/multipage/server-sent-events.html).

Сейчас история хранится в BoltDB на Docker volume. Но есть ограничения:

- новая подписка без курсора не является запросом всей истории уведомлений;
- обновление всей страницы создаёт новый `EventSource` и теряет его прежний курсор;
- старые события могут быть удалены при очистке истории;
- сообщения могут приходить повторно, поэтому UI должен учитывать дубли;
- перезапуск с другим transport или утрата volume могут лишить Hub истории.

Наш JavaScript хранит до 200 обработанных SSE ID для подавления недавних повторов и показывает до 100 элементов. Этот ограниченный буфер не является гарантией доставки «ровно один раз».

### Как передать курсор после обновления страницы

В основной реализации `lastEventId` уже сохраняется в переменной для повторного создания потока. Если нужно восстанавливать курсор между загрузками страницы, замените её инициализацию на чтение из хранилища браузера:

~~~javascript
const cursorKey = `mercure-cursor:${settings.topic}`;
let lastEventId = sessionStorage.getItem(cursorKey) ?? '';

// В обработчике после успешного применения события:
sessionStorage.setItem(cursorKey, lastEventId);
~~~

Последнюю строку добавьте после присваивания `lastEventId = event.lastEventId` в обработчике. `connect()` уже передаёт это значение параметром **`last_event_id`**. Не сохраняйте курсор события, которое ещё не удалось обработать. При автоматическом переподключении `Last-Event-ID` из заголовка имеет приоритет над параметром URL. [Восстановление событий в протоколе](https://github.com/dunglas/mercure/blob/v1.1.0/spec/mercure.md).

Для важных данных держите актуальное состояние в базе приложения и предоставляйте HTTP endpoint чтения. После потери истории клиент сможет получить свежий снимок состояния. Mercure-уведомление о готовом отчёте и сам сохранённый отчёт решают разные задачи.

## Если событие связано с изменением базы

В реальном приложении сначала зафиксируйте изменение данных, затем публикуйте уведомление. Если событие отправлено до commit, браузер может сразу запросить ресурс и получить ещё старую версию. При rollback он вообще получит сообщение о несуществующем изменении.

При прямом синхронном сохранении без внешней транзакции схема может выглядеть так:

~~~text
Изменить объект → Doctrine flush/commit → NotificationPublisher → Hub
~~~

Если транзакция управляется вызывающим кодом или Messenger middleware, одного `flush()` внутри обработчика недостаточно: commit может произойти позже.

Другая проблема — отказ Hub после успешного commit. Данные уже сохранены, а уведомление не отправлено. Для гарантированной повторной отправки применяют transactional outbox: изменение и запись события сохраняются в одной транзакции, отдельный worker публикует накопленные события и повторяет попытки при отказе Hub.

При повторной публикации сохраняйте стабильный ID бизнес-уведомления и определите правила обработки дублей. Новый SSE ID после повторной отправки не означает, что произошло новое бизнес-событие. Генерация `notificationId` в нашем простом сервисе рассчитана на создание нового уведомления при каждом вызове.

Для необязательной подсказки интерфейса иногда достаточно записать ошибку публикации в лог и восстановить состояние через обычный API. Для критичного уведомления нужен отдельный механизм хранения и повторов.

## Что поменять для HTTPS и production

Локальный пример использует HTTP, Basic auth и cookie без защищённого префикса. В рабочей конфигурации внешние адреса должны быть HTTPS, а имя cookie — согласовано между приложением и Hub, например:

~~~dotenv
APP_ORIGIN=https://app.example.com
MERCURE_ISSUER=https://app.example.com
MERCURE_PUBLIC_URL=https://app.example.com/.well-known/mercure
MERCURE_COOKIE_NAME=__Secure-mercure_access_token
~~~

`MERCURE_URL` выбирается отдельно по сети PHP-сервиса. Он может быть внутренним адресом, например `http://mercure/.well-known/mercure`, если TLS завершается на доверенном reverse proxy. `resource_identifier` при этом сохраняет публичный HTTPS-идентификатор Hub для проверки `aud`.

Удобный вариант — проксировать `/.well-known/mercure` через тот же origin, где работает Symfony. Тогда браузеру не нужен CORS между приложением и Hub. Прокси должен передавать SSE без накопления ответа; настройте также достаточный idle timeout и heartbeat. Не направляйте этот путь в обычный PHP-контроллер.

Если Hub находится на `hub.example.com`, а Symfony на `app.example.com`, cookie должна быть доступна нужным поддоменам, а CORS должен разрешать точный origin приложения с credentials. Порт входит в origin для CORS, но cookie не изолируются по порту.

HTTP Basic в примере позволяет сосредоточиться на Mercure. В приложении подключите свою аутентификацию и модель пользователей. Также определите, как отзывать или обновлять доступ при изменении разрешений: уже открытая подписка не обязана немедленно узнать, что роль пользователя изменилась.

## Диагностика

| Проблема | Что проверить |
| --- | --- |
| Ошибка контейнера Symfony об `iss`, `sub`, `client_id` | Настроены ли claims в фабриках `publisher` и `subscriber` для протокола 1.0. |
| Публикация получает `401 invalid_token` | Совпадают ли ключ, алгоритм, `iss`, `aud`, тип и срок действия JWT; нет ли старого формата токена. |
| Публикация получает `403 insufficient_scope` | Разрешает ли publisher JWT все темы обновления. |
| Подписка отвечает `200`, но личных событий нет | Отправлена ли cookie, совпадает ли её имя, имеет ли токен нужный `subscribe` grant. |
| CORS error | Точный origin страницы, включая порт; для cookie нельзя использовать wildcard `*`. |
| Ошибка создания cookie или cookie не сохраняется | HTTPS для имени с `__Secure-`, общий домен приложения и Hub, путь cookie, `withCredentials`. |
| События видны в Network, но список пустой | Имя события: при `type: notification` слушайте `notification`, а не только `message`. |
| События приходят пачками | Буферизацию reverse proxy, промежуточных сервисов и параметры сжатия. |
| Через несколько минут пропадает доступ | Истечение JWT, успешность endpoint обновления и доступность cookie при переподключении. |
| PHP не может подключиться к Hub | Что означает `localhost` из конкретного процесса или контейнера. |
| Старые события не восстанавливаются | Наличие курсора, сохранность volume, политику очистки истории. |

Для просмотра логов Hub:

~~~bash
docker compose --env-file .env.local -f compose.mercure.yaml logs -f mercure
~~~

Публичный поток можно открыть из терминала:

~~~bash
curl -N -G 'http://localhost:3000/.well-known/mercure' \
    -H 'Accept: text/event-stream' \
    --data-urlencode 'match=https://example.test/notifications/public'
~~~

Пока `curl` ждёт события, отправьте уведомление командой `app:notify` из другого терминала. Открытое SSE-соединение выглядит как долго выполняющийся HTTP-запрос — это ожидаемое поведение.

## Что проверить при переносе в свой проект

- PHP и браузер используют доступные им адреса Hub.
- Версии протокола, формат токенов и параметры подписки согласованы.
- Publisher имеет права только на нужные темы.
- Личная тема вычисляется из проверенного пользователя.
- Личные обновления публикуются с `private: true`.
- Cookie и срок действия JWT обновляются по понятному сценарию.
- JavaScript слушает тип события, заданный издателем.
- После разрыва связи приложение может восстановить своё состояние.
- Ошибка публикации после commit имеет определённую обработку.

Для автоматизации сценария с Alice и Bob понадобятся два изолированных браузера. Такой приём разобран в [статье о Panther](symfony-panther-e2e-testing-example.md).

## Источники

- [Исходники Mercure Hub 1.1.0](https://github.com/dunglas/mercure/tree/v1.1.0).
- [Протокол Mercure из выбранного тега](https://github.com/dunglas/mercure/blob/v1.1.0/spec/mercure.md).
- [Авторизация Hub 1.1.0](https://github.com/dunglas/mercure/blob/v1.1.0/docs/concepts/authorization.md).
- [Symfony Mercure 0.9.0](https://github.com/symfony/mercure/tree/v0.9.0/src).
- [MercureBundle 0.6.0](https://github.com/symfony/mercure-bundle/tree/v0.6.0/src).
- [Общее руководство Symfony по Mercure](https://symfony.com/doc/current/mercure.html).
- [Server-sent events в HTML Standard](https://html.spec.whatwg.org/multipage/server-sent-events.html).
