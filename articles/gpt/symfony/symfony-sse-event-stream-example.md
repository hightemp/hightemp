# SSE в Symfony: лента уведомлений с восстановлением соединения

Страница может получать обновления по обычному HTTP-соединению, которое сервер не закрывает после первого сообщения. Такой механизм называется **Server-Sent Events**, или **SSE**. В браузере для него есть встроенный `EventSource`, а в Symfony — `EventStreamResponse` и `ServerEvent`.

В этой статье реализуем общую ленту уведомлений. Symfony-команда будет сохранять события в SQLite, браузер сначала загрузит последние сообщения, а затем подпишется на новые. После временного разрыва сервер продолжит выдачу с последнего ID.

Пример рассчитан на **PHP 8.4 и Symfony 7.4**. API сверено с **HttpFoundation 7.4.20**, доступной на 9 октября 2026 года. Классы `EventStreamResponse` и `ServerEvent` появились в Symfony 7.3. [Анонс](https://symfony.com/blog/new-in-symfony-7-3-simpler-server-event-streaming), [исходники 7.4.20](https://github.com/symfony/http-foundation/tree/v7.4.20).

## Как проходит обновление

~~~text
Symfony-команда → SQLite: новое событие с ID
                           ↑
                 Symfony /events читает новые записи
                           │ SSE
                           ▼
                  EventSource → обновление DOM
~~~

Соединение с браузером обслуживает Symfony. При запуске через PHP-FPM оно занимает PHP worker на время потока. Для небольшой внутренней панели такой вариант может быть достаточным; количество одновременных подписок нужно учитывать при расчёте ресурсов.

В нашем примере сервер проверяет журнал каждые 500 миллисекунд. Получается SSE между браузером и приложением и периодическое чтение базы внутри приложения.

## Как выглядит SSE в HTTP

Ответ имеет тип `text/event-stream` и содержит текст в UTF-8:

~~~text
id: 43
event: notification
retry: 1500
data: {"message":"Отчёт готов","createdAt":"2026-10-09T12:00:00+00:00"}

~~~

Пустая строка завершает событие. До неё браузер продолжает собирать данные.

| Поле | Назначение |
| --- | --- |
| `data` | Полезная нагрузка. Несколько строк `data:` объединяются через перевод строки. |
| `event` | Имя события для `addEventListener()`. Без него используется `message`. |
| `id` | ID, который браузер сможет отправить в `Last-Event-ID` при переподключении. |
| `retry` | Рекомендуемая задержка переподключения, в миллисекундах. |
| Строка с `:` | Комментарий. Подходит для heartbeat, не вызывает обычный обработчик сообщения. |

SSE передаёт данные от сервера к браузеру. Действия пользователя отправляются обычными HTTP-запросами к приложению. Формат и поведение `EventSource` определены в [HTML Standard](https://html.spec.whatwg.org/multipage/server-sent-events.html).

## Что соберём

| Адрес или команда | Назначение |
| --- | --- |
| `GET /notifications` | HTML-страница ленты. |
| `GET /api/events/snapshot` | Последние 20 сообщений и курсор. |
| `GET /events?after=42` | Поток сообщений с ID больше 42. |
| `app:sse:init` | Создание файла и таблицы SQLite. |
| `app:sse:publish 'Текст'` | Добавление события в журнал. |

Лента общая: все подключившиеся клиенты видят одинаковые сообщения. Приватные данные в этот журнал помещать не следует; особенности авторизации рассмотрены отдельно.

## 1. Создаём проект

Нужны PHP-расширения `pdo_sqlite` и `mbstring`, а также Composer:

~~~bash
composer create-project symfony/skeleton:"7.4.*" sse-demo
cd sse-demo

composer require symfony/twig-bundle symfony/monolog-bundle symfony/http-foundation:"7.4.20"
~~~

Monolog пригодится для ошибок, возникших уже во время передачи потока. На этом этапе HTTP-заголовки могут быть отправлены, поэтому показать обычную страницу Symfony с другим статусом уже нельзя.

Создайте `.env.local`:

~~~dotenv
APP_ENV=dev
APP_DEBUG=0

SSE_DATABASE_PATH='%kernel.project_dir%/var/sse.sqlite'
SSE_STREAM_SECONDS=25
SSE_POLL_MILLISECONDS=500
SSE_HEARTBEAT_SECONDS=5
~~~

`resolve:` при внедрении пути ниже раскроет `%kernel.project_dir%`. Так PHP-сервер и консольная команда получат один абсолютный путь к файлу независимо от текущего рабочего каталога.

`APP_DEBUG=0` выбран для демонстрации потока без отладочного вывода. Ошибки ищите в логах приложения и терминале сервера.

В `config/routes.yaml` задайте импорт атрибутов контроллеров:

~~~yaml
controllers:
    resource:
        path: ../src/Controller/
        namespace: App\Controller
    type: attribute
~~~

Основные файлы примера:

~~~text
src/
├── Command/
│   ├── InitializeSseCommand.php
│   └── PublishSseCommand.php
├── Controller/NotificationController.php
└── Sse/
    ├── EventStore.php
    └── NotificationStream.php
templates/notifications/index.html.twig
~~~

## 2. Сохраняем события в SQLite

Создайте `src/Sse/EventStore.php`:

~~~php
<?php

declare(strict_types=1);

namespace App\Sse;

use Symfony\Component\DependencyInjection\Attribute\Autowire;

final class EventStore
{
    private ?\PDO $pdo = null;

    public function __construct(
        #[Autowire(env: 'resolve:SSE_DATABASE_PATH')]
        private readonly string $databasePath,
    ) {
    }

    public function initialize(): void
    {
        $directory = dirname($this->databasePath);

        if (!is_dir($directory) && !mkdir($directory, 0775, true) && !is_dir($directory)) {
            throw new \RuntimeException('Не удалось создать каталог журнала SSE.');
        }

        $pdo = $this->connection(true);
        $pdo->exec('PRAGMA journal_mode = WAL');
        $pdo->exec('CREATE TABLE IF NOT EXISTS sse_events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data TEXT NOT NULL
        )');
    }

    public function append(string $message): string
    {
        $message = trim($message);

        if ($message === '' || mb_strlen($message) > 500) {
            throw new \InvalidArgumentException('Нужно сообщение от 1 до 500 символов.');
        }

        $data = json_encode([
            'message' => $message,
            'createdAt' => (new \DateTimeImmutable())->format(DATE_ATOM),
        ], JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);

        $pdo = $this->connection();
        $statement = $pdo->prepare('INSERT INTO sse_events (data) VALUES (:data)');
        $statement->execute(['data' => $data]);
        $statement->closeCursor();

        return $pdo->lastInsertId();
    }

    /** @return list<array{id: string, data: string}> */
    public function readAfter(int $cursor, int $limit = 100): array
    {
        $statement = $this->connection()->prepare(
            'SELECT id, data FROM sse_events WHERE id > :cursor ORDER BY id ASC LIMIT :limit',
        );
        $statement->bindValue(':cursor', $cursor, \PDO::PARAM_INT);
        $statement->bindValue(':limit', $limit, \PDO::PARAM_INT);
        $statement->execute();
        $rows = $statement->fetchAll();
        $statement->closeCursor();

        return array_map(static fn (array $row): array => [
            'id' => (string) $row['id'],
            'data' => (string) $row['data'],
        ], $rows);
    }

    /** @return array{cursor: string, events: list<array{id: string, payload: array}>} */
    public function snapshot(): array
    {
        $statement = $this->connection()->query(
            'SELECT id, data FROM sse_events ORDER BY id DESC LIMIT 20',
        );
        $rows = array_reverse($statement->fetchAll());
        $statement->closeCursor();

        $events = array_map(static fn (array $row): array => [
            'id' => (string) $row['id'],
            'payload' => json_decode((string) $row['data'], true, 512, JSON_THROW_ON_ERROR),
        ], $rows);

        return [
            'cursor' => $events === [] ? '0' : $events[array_key_last($events)]['id'],
            'events' => $events,
        ];
    }

    public function latestId(): int
    {
        $statement = $this->connection()->query('SELECT COALESCE(MAX(id), 0) FROM sse_events');
        $id = (int) $statement->fetchColumn();
        $statement->closeCursor();

        return $id;
    }

    private function connection(bool $allowCreate = false): \PDO
    {
        if ($this->pdo !== null) {
            return $this->pdo;
        }

        if (!$allowCreate && !is_file($this->databasePath)) {
            throw new \RuntimeException('Сначала выполните app:sse:init.');
        }

        $this->pdo = new \PDO('sqlite:'.$this->databasePath, null, null, [
            \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION,
            \PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_ASSOC,
        ]);
        $this->pdo->exec('PRAGMA busy_timeout = 2000');

        return $this->pdo;
    }
}
~~~

У каждой записи есть возрастающий ID. Он нужен и для порядка сообщений, и для продолжения выдачи после разрыва. Время создания остаётся частью полезной нагрузки, но курсором служит именно ID: несколько событий могут иметь одинаковую временную метку.

`snapshot()` получает последние сообщения одним SQL-запросом и берёт курсор из последней возвращённой записи. Это согласованный снимок ленты. Событие, добавленное позже, будет иметь больший ID и попадёт в последующий поток.

SQLite работает в WAL-режиме, который позволяет чтению и записи выполняться параллельно. `busy_timeout` ограничивает ожидание блокировки двумя тысячами миллисекунд. WAL предназначен для процессов, использующих файл на одном хосте; размещать такой файл на произвольном сетевом файловом хранилище не следует. [Документация SQLite WAL](https://www.sqlite.org/wal.html).

Все строки запроса считываются в короткий массив, затем вызывается `closeCursor()`. Во время ожидания следующего события мы не держим открытый SQL-курсор или явную транзакцию. [PDOStatement::closeCursor()](https://www.php.net/manual/en/pdostatement.closecursor.php)

## 3. Добавляем команды инициализации и публикации

Создайте `src/Command/InitializeSseCommand.php`:

~~~php
<?php

declare(strict_types=1);

namespace App\Command;

use App\Sse\EventStore;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

#[AsCommand(name: 'app:sse:init', description: 'Подготовить журнал SSE')]
final class InitializeSseCommand extends Command
{
    public function __construct(private readonly EventStore $store)
    {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $this->store->initialize();
        $output->writeln('Журнал SSE готов.');

        return Command::SUCCESS;
    }
}
~~~

Создайте `src/Command/PublishSseCommand.php`:

~~~php
<?php

declare(strict_types=1);

namespace App\Command;

use App\Sse\EventStore;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

#[AsCommand(name: 'app:sse:publish', description: 'Добавить уведомление в ленту')]
final class PublishSseCommand extends Command
{
    public function __construct(private readonly EventStore $store)
    {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this->addArgument('message', InputArgument::REQUIRED, 'Текст уведомления');
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        try {
            $id = $this->store->append((string) $input->getArgument('message'));
        } catch (\InvalidArgumentException $exception) {
            $output->writeln('<error>'.$exception->getMessage().'</error>');

            return Command::INVALID;
        }

        $output->writeln('Сохранено событие '.$id);

        return Command::SUCCESS;
    }
}
~~~

Подготовьте журнал:

~~~bash
php bin/console app:sse:init
php bin/console app:sse:publish 'Приложение запущено'
~~~

В настоящем приложении `EventStore::append()` может вызываться из сервиса, обработчика Messenger или HTTP-контроллера после проверки прав. Команда здесь служит простым источником событий, работающим одновременно с веб-процессом.

## 4. Формируем поток событий

Создайте `src/Sse/NotificationStream.php`:

~~~php
<?php

declare(strict_types=1);

namespace App\Sse;

use Psr\Log\LoggerInterface;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Symfony\Component\HttpFoundation\ServerEvent;

final class NotificationStream
{
    public function __construct(
        private readonly EventStore $store,
        private readonly LoggerInterface $logger,
        #[Autowire(env: 'int:SSE_STREAM_SECONDS')]
        private readonly int $streamSeconds,
        #[Autowire(env: 'int:SSE_POLL_MILLISECONDS')]
        private readonly int $pollMilliseconds,
        #[Autowire(env: 'int:SSE_HEARTBEAT_SECONDS')]
        private readonly int $heartbeatSeconds,
    ) {
        if ($streamSeconds < 5 || $streamSeconds > 120) {
            throw new \InvalidArgumentException('SSE_STREAM_SECONDS: от 5 до 120.');
        }
        if ($pollMilliseconds < 100 || $pollMilliseconds > 5000) {
            throw new \InvalidArgumentException('SSE_POLL_MILLISECONDS: от 100 до 5000.');
        }
        if ($heartbeatSeconds < 1 || $heartbeatSeconds >= $streamSeconds) {
            throw new \InvalidArgumentException('Heartbeat должен быть положительным и короче потока.');
        }
    }

    /** @return \Generator<int, ServerEvent> */
    public function events(int $cursor): \Generator
    {
        $deadline = hrtime(true) + $this->streamSeconds * 1_000_000_000;
        $nextHeartbeat = hrtime(true) + $this->heartbeatSeconds * 1_000_000_000;

        yield new ServerEvent(data: '', comment: 'connected');

        try {
            while (hrtime(true) < $deadline && !connection_aborted()) {
                $rows = $this->store->readAfter($cursor);

                foreach ($rows as $row) {
                    if (hrtime(true) >= $deadline || connection_aborted()) {
                        return;
                    }

                    yield new ServerEvent(
                        data: $row['data'],
                        type: 'notification',
                        id: $row['id'],
                    );

                    $cursor = (int) $row['id'];
                    $nextHeartbeat = hrtime(true) + $this->heartbeatSeconds * 1_000_000_000;
                }

                if (hrtime(true) >= $nextHeartbeat) {
                    yield new ServerEvent(data: '', comment: 'heartbeat');
                    $nextHeartbeat = hrtime(true) + $this->heartbeatSeconds * 1_000_000_000;
                }

                if (count($rows) < 100) {
                    usleep($this->pollMilliseconds * 1000);
                }
            }
        } catch (\PDOException $exception) {
            $this->logger->error('Ошибка чтения журнала SSE.', ['exception' => $exception]);

            yield new ServerEvent(
                data: '{"message":"Поток временно недоступен."}',
                type: 'stream-error',
            );
        }
    }
}
~~~

Генератор выдаёт `ServerEvent` по мере появления записей. Каждая порция читается отдельно, поэтому новые события, сохранённые консольной командой, становятся видимы в следующих запросах к базе.

Если порция заполнена до 100 событий, следующая читается сразу: это помогает догнать накопившийся журнал. Когда записей мало или нет, выполняется пауза. При простое каждые пять секунд отправляется комментарий heartbeat.

Цикл ограничен примерно 25 секундами. Затем сервер завершает ответ, а браузер переподключается. Ожидание базы или медленная запись в соединение могут увеличить фактическое время запроса, поэтому системные таймауты должны иметь запас.

### Почему heartbeat не получает ID

Комментарий подтверждает, что соединение ещё обслуживается, но не является новым уведомлением. Если присвоить ему ID, который не соответствует журналу, курсор браузера перестанет обозначать последнее полученное бизнес-событие.

В HttpFoundation 7.4.20 аргумент `data` у `ServerEvent` обязателен. Поэтому комментарий создаётся как `new ServerEvent(data: '', comment: 'heartbeat')`.

## 5. Добавляем контроллер

Создайте `src/Controller/NotificationController.php`:

~~~php
<?php

declare(strict_types=1);

namespace App\Controller;

use App\Sse\EventStore;
use App\Sse\NotificationStream;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\EventStreamResponse;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;
use Symfony\Component\HttpKernel\Exception\ConflictHttpException;
use Symfony\Component\Routing\Attribute\Route;

final class NotificationController extends AbstractController
{
    public function __construct(
        private readonly EventStore $store,
        private readonly NotificationStream $stream,
    ) {
    }

    #[Route('/notifications', name: 'notifications', methods: ['GET'])]
    public function page(): Response
    {
        return $this->render('notifications/index.html.twig');
    }

    #[Route('/api/events/snapshot', name: 'events_snapshot', methods: ['GET'], format: 'json')]
    public function snapshot(): JsonResponse
    {
        return new JsonResponse($this->store->snapshot(), headers: [
            'Cache-Control' => 'private, no-store',
        ]);
    }

    #[Route('/events', name: 'events_stream', methods: ['GET'])]
    public function events(Request $request): EventStreamResponse
    {
        $rawCursor = $request->headers->get('Last-Event-ID')
            ?? $request->query->getString('after', '0');

        if (preg_match('/^(0|[1-9][0-9]*)$/D', $rawCursor) !== 1) {
            throw new BadRequestHttpException('Курсор должен быть целым неотрицательным числом.');
        }

        $cursor = filter_var($rawCursor, FILTER_VALIDATE_INT, [
            'options' => ['min_range' => 0],
        ]);

        if ($cursor === false) {
            throw new BadRequestHttpException('Курсор выходит за диапазон целого числа PHP.');
        }

        if ($cursor > $this->store->latestId()) {
            throw new ConflictHttpException('Обновите снимок ленты: курсор больше последнего ID журнала.');
        }

        if ($request->hasSession() && $request->getSession()->isStarted()) {
            $request->getSession()->save();
        }

        return new EventStreamResponse(
            fn (): iterable => $this->stream->events($cursor),
            retry: 1500,
        );
    }
}
~~~

`after` — параметр нашего приложения для первого подключения. Сам стандарт SSE не задаёт такое имя параметра URL. При автоматическом переподключении `EventSource` отправляет заголовок `Last-Event-ID`; контроллер отдаёт ему приоритет над первоначальным `after`.

Валидация и проверка существования журнала происходят до начала потока. Поэтому на этом этапе можно вернуть обычную HTTP-ошибку. Например, слишком большой курсор после замены базы даст `409`, и клиент сможет заново загрузить снимок.

### Что делает EventStreamResponse

| Аргумент конструктора | Назначение |
| --- | --- |
| `callback` | Callable, который может вернуть iterable объектов `ServerEvent` или отправлять их через `sendEvent()`. |
| `status` | HTTP-статус; по умолчанию `200`. |
| `headers` | Дополнительные или переопределённые HTTP-заголовки. |
| `retry` | Интервал переподключения в миллисекундах; в примере `1500`. |

Класс устанавливает `Content-Type: text/event-stream`, запрет кеширования и `X-Accel-Buffering: no`. При отправке события он выводит части SSE-записи, закрывает доступные выходные буферы PHP и вызывает `flush()` в веб-SAPI. Проверку отключения клиента он также выполняет между событиями. [EventStreamResponse 7.4.20](https://github.com/symfony/http-foundation/blob/v7.4.20/EventStreamResponse.php).

### Параметры ServerEvent

| Аргумент | Тип и назначение |
| --- | --- |
| `data` | Обязательная строка или `iterable<string>` с данными одного события. |
| `type` | Необязательное имя события для клиента. |
| `retry` | Необязательная задержка переподключения в миллисекундах. |
| `id` | Необязательный строковый ID события. |
| `comment` | Необязательный комментарий, например heartbeat. |

`iterable<string>` в `data` описывает части **одного** события. Чтобы отправить несколько разных событий, выдавайте несколько объектов `ServerEvent`. JSON нужно сформировать самостоятельно: конструктор не сериализует произвольные PHP-массивы как JSON. [ServerEvent 7.4.20](https://github.com/symfony/http-foundation/blob/v7.4.20/ServerEvent.php).

## 6. Подписываем браузер

Создайте `templates/notifications/index.html.twig`:

~~~twig
<!doctype html>
<html lang="ru">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Уведомления через SSE</title>
</head>
<body>
    <h1>Уведомления через SSE</h1>
    <p id="status" role="status">Загружаем ленту…</p>
    <button id="refresh" type="button">Обновить ленту и подключиться</button>
    <button id="stop" type="button">Остановить</button>
    <ul id="events"></ul>

    <div
        id="settings"
        data-snapshot-url="{{ path('events_snapshot') }}"
        data-stream-url="{{ path('events_stream') }}"
    ></div>

    <script>
        const settings = document.getElementById('settings').dataset;
        const list = document.getElementById('events');
        const status = document.getElementById('status');
        const refresh = document.getElementById('refresh');
        const stop = document.getElementById('stop');

        let source = null;
        let generation = 0;
        let lastId = '0';

        function stopStream() {
            generation += 1;
            source?.close();
            source = null;
        }

        function applyEvent(id, payload) {
            if (BigInt(id) <= BigInt(lastId)) {
                return;
            }

            const item = document.createElement('li');
            const time = new Date(payload.createdAt).toLocaleTimeString();
            item.textContent = `${id} — ${time}: ${payload.message}`;
            list.append(item);

            while (list.children.length > 100) {
                list.firstElementChild.remove();
            }

            lastId = id;
        }

        async function start() {
            stopStream();
            const currentGeneration = generation;
            refresh.disabled = true;
            status.textContent = 'Загружаем снимок ленты…';

            try {
                const response = await fetch(settings.snapshotUrl, { cache: 'no-store' });
                if (!response.ok) {
                    throw new Error(`Снимок: HTTP ${response.status}`);
                }
                const snapshot = await response.json();

                if (currentGeneration !== generation) {
                    return;
                }

                list.replaceChildren();
                lastId = '0';
                for (const event of snapshot.events) {
                    applyEvent(event.id, event.payload);
                }
                lastId = snapshot.cursor;

                const url = new URL(settings.streamUrl, window.location.origin);
                url.searchParams.set('after', lastId);

                const stream = new EventSource(url);
                source = stream;

                stream.addEventListener('open', () => {
                    if (source === stream) {
                        status.textContent = 'Получаем новые события';
                    }
                });

                stream.addEventListener('notification', (event) => {
                    if (source !== stream) {
                        return;
                    }

                    try {
                        applyEvent(event.lastEventId, JSON.parse(event.data));
                    } catch (error) {
                        stopStream();
                        status.textContent = 'Ошибка данных. Обновите ленту.';
                        console.error(error);
                    }
                });

                stream.addEventListener('stream-error', () => {
                    if (source === stream) {
                        stopStream();
                        status.textContent = 'Ошибка на сервере. Обновите ленту позже.';
                    }
                });

                stream.addEventListener('error', () => {
                    if (source === stream) {
                        status.textContent = stream.readyState === EventSource.CLOSED
                            ? 'Поток закрыт. Нажмите обновление ленты.'
                            : 'Соединение прервано. Переподключаемся…';
                    }
                });
            } catch (error) {
                if (currentGeneration === generation) {
                    status.textContent = 'Не удалось загрузить ленту.';
                    console.error(error);
                }
            } finally {
                if (currentGeneration === generation) {
                    refresh.disabled = false;
                }
            }
        }

        refresh.addEventListener('click', start);
        stop.addEventListener('click', () => {
            stopStream();
            refresh.disabled = false;
            status.textContent = 'Подписка остановлена';
        });

        start();
    </script>
</body>
</html>
~~~

Клиент сначала получает снимок, затем открывает поток с его курсором. Числовые ID передаются строками и сравниваются через `BigInt`, чтобы не зависеть от округления больших целых чисел в JavaScript.

`generation` не даёт старому запросу снимка открыть подписку после нажатия «Остановить» или после начала нового подключения. Ссылка на конкретный `stream` также защищает интерфейс от запоздавших callbacks предыдущей подписки.

Текст сообщения добавляется через `textContent`. HTML из сообщения не исполняется. Список ограничен сотней элементов; при обновлении страницы загружается свежий снимок последних 20.

### Почему не закрываем соединение на каждом error

Временный обрыв и обычное завершение 25-секундного ответа вызывают `error`, после которого `EventSource` обычно переподключается. Если каждый раз вызывать в этом обработчике `close()`, автоматическое восстановление остановится.

Явное закрытие используется для кнопки остановки и нашего события `stream-error`. В последнем случае сервер сообщил об отказе чтения журнала, и пример предлагает обновить ленту позже.

## 7. Запускаем пример

Из корня проекта, после выполнения `app:sse:init`, запустите сервер с несколькими worker:

~~~bash
PHP_CLI_SERVER_WORKERS=4 php -d output_buffering=0 -d zlib.output_compression=0 \
    -S 127.0.0.1:8000 -t public
~~~

Эта команда подходит для локального запуска на Linux и macOS. Поддержка нескольких worker встроенного сервера отсутствует на Windows. Сам встроенный сервер предназначен для разработки. [Руководство PHP](https://www.php.net/manual/en/features.commandline.webserver.php)

Несколько worker здесь нужны по конкретной причине: один процесс занят SSE-запросом, а другой должен уметь открыть вторую страницу или вернуть JSON-снимок. При обычном однопроцессном `php -S` такие запросы могут ждать завершения потока.

Откройте **http://127.0.0.1:8000/notifications** и добавьте событие из другого терминала:

~~~bash
php bin/console app:sse:publish 'Отчёт сформирован'
~~~

Сообщение должно появиться без перезагрузки страницы. Примерно через 25 секунд поток завершится и снова откроется с прежним курсором.

### Проверяем поток через curl

~~~bash
curl -N -H 'Accept: text/event-stream' \
    'http://127.0.0.1:8000/events?after=0'
~~~

`-N` отключает буферизацию вывода самого `curl`. Начальный комментарий и события должны выводиться по мере получения, а не одной пачкой после закрытия соединения.

Если события 1–3 уже есть в журнале, продолжение после третьего можно запросить так:

~~~bash
curl -N \
    -H 'Accept: text/event-stream' \
    -H 'Last-Event-ID: 3' \
    'http://127.0.0.1:8000/events?after=0'
~~~

Контроллер выберет `Last-Event-ID: 3`, а не `after=0`. В ответ попадут записи с ID больше 3.

## Как не потерять событие между снимком и подпиской

Допустим, снимок вернул курсор `42`. Сразу после этого консольная команда записала событие `43`, но SSE ещё не открылось:

~~~text
GET snapshot → сообщения до 42 включительно
Запись события 43
GET /events?after=42 → SELECT id > 42 → событие 43
~~~

Такой порядок сохраняет обновление, потому что оно записано в журнал, а поток читает записи после курсора. Если бы снимок и курсор вычислялись несогласованными запросами, можно было бы взять курсор нового события, ещё не включённого в снимок, и затем пропустить его.

При автоматическом переподключении браузер обновляет `Last-Event-ID` по полученным SSE-записям. Сервер повторно читает всё, что находится после этого значения. Обработка уведомления может повториться на границах сетевого сбоя, поэтому клиент отбрасывает уже применённые ID.

`Last-Event-ID` не является подтверждением бизнес-обработки. Браузер может обновить свой внутренний курсор ещё до того, как ваш JavaScript успешно обработал сообщение. Для критичных операций нужны собственные подтверждения, идемпотентность и сохранённое состояние приложения.

## Срок хранения журнала

Учебный `EventStore` не удаляет старые строки. Для постоянного сервиса нужна политика хранения: по времени, числу записей или бизнес-сроку жизни уведомлений.

Если начнёте очищать историю, сервер должен распознавать слишком старый курсор и предлагать новый снимок. Сейчас проверяется только курсор, который больше максимального ID: это полезно, например, после замены файла базы. Для очистки нижней части журнала понадобится дополнительная проверка минимального доступного ID или отдельной границы истории.

Не используйте постоянно сбрасывающийся счётчик внутри контроллера как SSE ID. После переподключения одинаковый ID начнёт обозначать другое событие, и восстановление потеряет смысл.

## Heartbeat, flush и отключение клиента

Heartbeat поддерживает активность соединения в промежутках между уведомлениями. Он должен приходить чаще, чем срабатывает idle timeout промежуточного прокси. Это не механизм подтверждения, что пользователь прочитал сообщение.

`EventStreamResponse` выполняет отправку и `flush()`, но промежуточные слои всё равно могут накапливать ответ: сжатие, FastCGI buffering, reverse proxy или CDN. Поэтому настройки сервера не менее важны, чем `yield` в PHP.

`connection_aborted()` показывает обнаруженное PHP отключение клиента. Часто оно становится известно после попытки записи, а не мгновенно после закрытия вкладки. Heartbeat помогает обнаружить разрыв при отсутствии полезных событий. Дополнительное ограничение времени цикла не позволяет ему ожидать бесконечно. [connection_aborted()](https://www.php.net/manual/en/function.connection-aborted.php)

### Сессия во время потока

Открытая файловая PHP-сессия может держать блокировку и задерживать другие запросы того же пользователя. В стандартном цикле Symfony сессия сохраняется обработчиком `kernel.response` до отправки ответа. В контроллере примера её также явно закрывает `save()`, если она уже была открыта. [AbstractSessionListener 7.4.20](https://github.com/symfony/http-kernel/blob/v7.4.20/EventListener/AbstractSessionListener.php).

Если добавите авторизацию, сначала получите пользователя и проверьте права. Во время долгого генератора используйте подготовленные значения: повторный доступ к сессии может снова её открыть.

## Nginx и PHP-FPM

Если маршрут обслуживается через FastCGI, в существующий `server`-блок можно добавить отдельный location. В этом фрагменте `root` уже указывает на `public/` приложения, а `app_php` — существующий upstream PHP-FPM:

~~~nginx
location = /events {
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $realpath_root/index.php;
    fastcgi_param SCRIPT_NAME /index.php;
    fastcgi_pass app_php;

    fastcgi_buffering off;
    fastcgi_cache off;
    fastcgi_read_timeout 45s;
    gzip off;
}
~~~

`X-Accel-Buffering: no` от Symfony также может отключить буферизацию Nginx, но его обработка зависит от конфигурации. Явная настройка location делает намерение понятным. `fastcgi_read_timeout` измеряет ожидание между чтениями от FastCGI, а не общую длительность ответа. [FastCGI-модуль Nginx](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html).

Если перед приложением стоит ещё один Nginx как HTTP reverse proxy, его настройки задаются отдельно:

~~~nginx
location = /events {
    proxy_pass http://application;
    proxy_http_version 1.1;
    proxy_set_header Connection "";

    proxy_buffering off;
    proxy_cache off;
    proxy_read_timeout 45s;
    gzip off;
}
~~~

Здесь `application` — upstream существующего HTTP-сервера приложения. Эти два фрагмента относятся к разным способам подключения; не помещайте `proxy_pass` и `fastcgi_pass` в один location. [HTTP proxy-модуль Nginx](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffering).

Для PHP-FPM учитывайте `request_terminate_timeout`, лимиты PHP и таймауты всех прокси. Они должны согласовываться с временем потока и heartbeat. `request_terminate_timeout` ограничивает обслуживание одного запроса worker-процессом. [Настройки PHP-FPM](https://www.php.net/manual/en/install.fpm.configuration.php)

Для отдельного FPM-пула SSE можно отключить PHP-буферизацию и сжатие:

~~~ini
php_admin_value[output_buffering] = 0
php_admin_value[zlib.output_compression] = 0
request_terminate_timeout = 45s
~~~

Число `45s` согласовано с локальными настройками этого примера, а не является универсальным значением для любого приложения. Если меняете длительность потока, пересмотрите связанные таймауты.

## Авторизация и пользовательские события

В основном примере журнал публичный. Для личных уведомлений нужны изменения в нескольких местах:

1. Закройте и `/events`, и `/api/events/snapshot` правилами Symfony Security.
2. Получайте ID пользователя из проверенного security token.
3. Фильтруйте журнал по владельцу и при выдаче снимка, и при чтении после курсора.
4. Выдавайте SSE только после проверки прав.
5. Повторяйте проверку при каждом новом HTTP-подключении.

Параметр `userId` в URL не доказывает принадлежность данных вызывающему пользователю. Также нельзя защищать только поток, оставляя endpoint снимка доступным всем.

При подписке на тот же origin браузер отправляет подходящие cookies автоматически. Для другого origin у `EventSource` есть `withCredentials: true`, а серверу потребуется корректный CORS с конкретным origin. Произвольный заголовок `Authorization` нативный `EventSource` задать не позволяет; если он необходим, нужен клиент SSE на основе `fetch()`.

Права, проверенные при начале запроса, сами собой не переоцениваются каждую секунду. Ограниченное время соединения даёт следующую точку проверки при переподключении. Для немедленного отзыва доступа потребуется дополнительная логика сервера.

## Ошибки после начала ответа

До создания потока можно вернуть `400`, `403`, `404` или `409`. После отправки HTTP-заголовков изменить уже полученный клиентом статус не получится.

Поэтому `NotificationStream` записывает ошибку PDO в лог, отправляет именованное событие `stream-error` и заканчивает генератор. Браузерный обработчик закрывает подписку и предлагает обновить ленту. Полный текст исключения с внутренними деталями базы в SSE не передаётся.

Сам по себе выход из генератора означает конец HTTP-ответа. Обычно `EventSource` попытается подключиться снова. Если конечная операция действительно завершена, можно отправить событие `done`, а в клиентском обработчике вызвать `close()`. Другой предусмотренный стандартом вариант — ответить `204 No Content` на новое подключение, чтобы остановить переподключения.

## Нагрузка и ограничения

В PHP-FPM одна открытая SSE-подписка занимает один worker. Ограничение потока 25 секундами помогает управлять временем жизни запросов, но большую часть подписки worker всё равно будет занят.

Кроме соединений, учитывайте чтение базы. При отсутствии накопившихся событий и интервале 500 миллисекунд получаются примерно такие значения:

| Одновременные потоки | Запросы чтения в секунду |
| --- | --- |
| 10 | 20 |
| 100 | 200 |
| 1000 | 2000 |

Это оценка только цикла чтения, без снимков, переподключений и записи событий. При большом backlog запросов может быть больше, потому что полные порции читаются без паузы.

Для внутренней панели с небольшим числом пользователей схема может быть удобной. Для массовой рассылки и большого числа постоянных подписчиков рассмотрите выделенный Hub: [пример Mercure с Symfony](symfony-mercure-notifications-example.md). Ограничение прямого SSE по одновременным соединениям отмечено и в [руководстве Symfony](https://symfony.com/doc/7.4/controller.html#streaming-server-sent-events).

У браузера также есть ограничения на число соединений: при HTTP/1.1 несколько SSE-подписок в разных вкладках могут быстро исчерпать лимит для одного origin. HTTP/2 позволяет использовать несколько потоков в одном соединении, но для PHP-FPM каждый обслуживаемый SSE-запрос всё равно занимает worker. [Руководство MDN по SSE](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events).

SQLite-файл в этой реализации общий для процессов одного хоста. Если приложение запускается на нескольких серверах, понадобятся общая система хранения событий и согласованный механизм чтения. Обычный массив в памяти PHP-процесса не заменит такой журнал.

## Частые проблемы

| Симптом | Что проверить |
| --- | --- |
| Всё приходит только после завершения запроса | PHP output buffering, сжатие, FastCGI buffering и все reverse proxy между браузером и PHP. |
| Вторая вкладка долго не открывается | Число worker; у встроенного сервера PHP по умолчанию один процесс. |
| Другие запросы того же пользователя ждут | Не осталась ли открыта сессия и не открывается ли она заново внутри генератора. |
| Событие видно в Network, но обработчик не вызывается | Имя `event`, имя в `addEventListener()` и пустую строку в конце записи. |
| После каждой переподписки приходят старые записи | Приоритет `Last-Event-ID` над начальным параметром `after`. |
| После замены базы поток закрывается | Курсор больше доступного максимального ID; загрузите новый снимок. |
| База часто занята | WAL, краткость запросов, отсутствие долгих транзакций и права на файл и его каталог. |
| Через несколько секунд соединение обрывается | Таймауты PHP-FPM, Nginx, внешнего прокси и частоту heartbeat. |
| Повторы в интерфейсе | Стабильность ID и идемпотентность обработчика. |
| В логе `could not find driver` | Расширение `pdo_sqlite` должно быть установлено именно у используемого PHP. |

Для проверки возобновления оставьте вкладку открытой, временно прервите соединение, запишите несколько событий и восстановите связь. В DevTools при повторном GET должен появиться `Last-Event-ID`, а сервер должен вернуть более новые записи, сохранившиеся в журнале.

## Что перенести в рабочее приложение

Полезная основа этого примера — согласованный снимок, устойчивый ID события, короткие чтения журнала, heartbeat и понятное завершение потока. При переносе определите срок хранения истории, модель доступа, правила обработки повторов и предел одновременных подключений.

Сам `EventStreamResponse` занимается HTTP-потоком и форматом передачи. Хранение событий, поиск пропусков, авторизация и восстановление бизнес-состояния остаются частью приложения.

## Источники

- [SSE в руководстве Symfony 7.4](https://symfony.com/doc/7.4/controller.html#streaming-server-sent-events).
- [EventStreamResponse 7.4.20](https://github.com/symfony/http-foundation/blob/v7.4.20/EventStreamResponse.php).
- [ServerEvent 7.4.20](https://github.com/symfony/http-foundation/blob/v7.4.20/ServerEvent.php).
- [SSE в HTML Standard](https://html.spec.whatwg.org/multipage/server-sent-events.html).
- [SQLite WAL](https://www.sqlite.org/wal.html).
- [Встроенный сервер PHP](https://www.php.net/manual/en/features.commandline.webserver.php).
- [FastCGI в Nginx](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html).
- [Конфигурация PHP-FPM](https://www.php.net/manual/en/install.fpm.configuration.php).
