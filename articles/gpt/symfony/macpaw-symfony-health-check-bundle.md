# Symfony Health Check Bundle: как работает и как использовать

`Symfony Health Check Bundle` от MacPaw добавляет в Symfony два HTTP-адреса — `/health` и `/ping` — и проверки базы данных, Redis, окружения и других зависимостей. Ниже разобран конкретно пакет `macpaw/symfony-health-check-bundle`, а не одноимённые бандлы.

Статья описывает релиз `v2.1.0` — последний опубликованный релиз на 5 октября 2026 года. В его composer.json указаны PHP `^8.1` и Symfony FrameworkBundle `^6.4`, `^7.4` или `^8.0`. Требования установленной версии можно сверить в [composer.json релиза](https://github.com/MacPaw/symfony-health-check-bundle/blob/v2.1.0/composer.json).

## Что делает HealthController::check

Метод [HealthController::check()](https://github.com/MacPaw/symfony-health-check-bundle/blob/v2.1.0/src/Controller/HealthController.php) — обработчик GET-запроса `/health`. Он вызывает общую логику родительского `BaseController::checkAction()`. Сам метод не проверяет базу или Redis: он запускает настроенный список проверок и возвращает результат в `JsonResponse`.

~~~text
GET /health
    ↓
HealthController::check()
    ↓
BaseController::checkAction()
    ↓
по очереди вызывается check() каждой проверки из health_checks
    ↓
результаты преобразуются в массив и JSON
    ↓
возвращается HTTP-ответ
~~~

При компиляции контейнера Symfony расширение бандла читает `health_checks` и `ping_checks` из конфигурации, находит сервисы по указанным ID и добавляет их в контроллеры. При запросе контроллер последовательно вызывает `check()` у каждого сервиса, преобразует ответы в массив и формирует JSON. Это видно в [расширении бандла](https://github.com/MacPaw/symfony-health-check-bundle/blob/v2.1.0/src/DependencyInjection/SymfonyHealthCheckExtension.php) и [базовом контроллере](https://github.com/MacPaw/symfony-health-check-bundle/blob/v2.1.0/src/Controller/BaseController.php).

Проверки выполняются синхронно в порядке конфигурации. Если одна вернула неуспех, остальные всё равно запускаются, чтобы ответ включал их результаты. Если пользовательская проверка выбросила исключение, `BaseController` его не перехватывает: обработка запроса прервётся, и Symfony сформирует обычный ответ об ошибке. Штатные проверки при обычном отказе зависимости возвращают неуспешный DTO.

## Как выглядит ответ

Каждая проверка возвращает `SymfonyHealthCheckBundle\Dto\Response` с четырьмя полями:

- `name` — короткое имя проверки;
- `result` — `true` или `false`;
- `message` — краткое описание результата;
- `params` — дополнительные значения; по умолчанию пустой массив.

Например, успешная проверка Doctrine может выглядеть так:

~~~json
[
  {
    "name": "doctrine",
    "result": true,
    "message": "ok",
    "params": []
  }
]
~~~

Это массив результатов, а не объект с общим полем `status`. Если проверок нет, ответом будет пустой массив `[]`: сам факт успешного HTTP-запроса ещё не говорит, что база или другие зависимости проверены.

### HTTP-код при неуспешной проверке

По умолчанию бандл возвращает HTTP `200`, даже если один из элементов JSON содержит `"result": false`. Код ошибки можно включить параметром `health_error_response_code`. Если он задан, контроллер вернёт этот код, когда хотя бы одна проверка завершилась неуспешно; успешные проверки по-прежнему дают `200`. Это поведение реализовано в `BaseController`, а README проекта отдельно указывает `200` как код по умолчанию.

Например, если мониторинг должен считать неуспешную проверку ошибкой HTTP:

~~~yaml
symfony_health_check:
    health_error_response_code: 503
~~~

Это важно для `curl -f` и Docker HEALTHCHECK: они проверяют HTTP-статус, а не анализируют JSON. Без `health_error_response_code` мониторинг может считать ответ успешным, хотя в теле есть `"result": false`.

## /health и /ping — две настраиваемые группы

Бандл регистрирует два GET-маршрута:

- `/health` запускает проверки из `health_checks`;
- `/ping` запускает проверки из `ping_checks`.

Контроллеры используют одинаковую механику, а наборы проверок и коды ошибок для них настраиваются независимо. В README проекта для `/ping` показан `status_up_check`, который возвращает `status / up`.

Названия адресов сами по себе не задают поведение liveness/readiness. Например, если в `ping_checks` добавить только `status_up_check`, `/ping` подтвердит, что приложение обрабатывает запрос, но не проверит соединение с базой. Добавление проверки базы превратит его в более строгий сигнал готовности. Выбирайте набор проверок по тому, как мониторинг или балансировщик будет реагировать на ошибку.

## Установка и регистрация маршрутов

Установите пакет через Composer:

~~~bash
composer require macpaw/symfony-health-check-bundle
~~~

С Symfony Flex бандл обычно подключается автоматически. В приложении без Flex добавьте его в `config/bundles.php`:

~~~php
return [
    SymfonyHealthCheckBundle\SymfonyHealthCheckBundle::class => ['all' => true],
];
~~~

Затем импортируйте маршруты пакета. В v2.1.0 используется PHP-файл маршрутизации:

~~~yaml
# config/routes/symfony_health_check.yaml
health_check:
    resource: '@SymfonyHealthCheckBundle/Resources/config/routes.php'
~~~

После этого пакет предоставляет GET `/health` и GET `/ping`. XML-конфигурация в README текущей версии отмечена как неподдерживаемая; параметры бандла задавайте в YAML или PHP.

## Встроенные проверки

Идентификатор в YAML — это ID сервиса в контейнере Symfony.

Например, `symfony_health_check.doctrine_orm_check` — service ID встроенной ORM-проверки. За ним зарегистрирован класс `SymfonyHealthCheckBundle\Check\DoctrineORMCheck`. Бандл находит сервис по этому ID и вызывает его `check()`. В JSON у результата поле `name` будет содержать `doctrine`; это отдельное имя, оно не совпадает с ID сервиса.

Список встроенных сервисов объявлен в [конфигурации проверок](https://github.com/MacPaw/symfony-health-check-bundle/blob/v2.1.0/src/Resources/config/health_checks.php).

| ID сервиса | Что проверяет |
| --- | --- |
| `symfony_health_check.doctrine_orm_check` | Находит ORM Entity Manager и выполняет простой запрос к его соединению. |
| `symfony_health_check.doctrine_odm_check` | Проверяет доступность MongoDB командой `ping`. |
| `symfony_health_check.redis_check` | Отправляет Redis-команду `PING`. Требуются `symfony/cache` и настроенный DSN. |
| `symfony_health_check.environment_check` | Получает `kernel.environment` и возвращает его в `params`. Это не проверка БД или других зависимостей. |
| `symfony_health_check.status_up_check` | Всегда возвращает успешный результат `status / up`; не проверяет БД или Redis. |

Старый сервис-ID `symfony_health_check.doctrine_check` оставлен как устаревший псевдоним. Используйте `symfony_health_check.doctrine_orm_check`.

ORM и ODM-проверки рассчитаны на соответствующие Doctrine-бандлы. Если менеджер отсутствует или база недоступна, встроенные реализации возвращают неуспешный `Response`. Для Redis укажите DSN и установите `symfony/cache`; если Redis-проверка настроена без Cache-компонента или без DSN, контейнер Symfony не соберётся.

## Пример конфигурации

Этот вариант проверяет базу на `/health`, а `/ping` оставляет лёгкой проверкой ответа приложения:

~~~yaml
# config/packages/symfony_health_check.yaml
symfony_health_check:
    health_checks:
        - id: symfony_health_check.doctrine_orm_check
        - id: symfony_health_check.environment_check
    ping_checks:
        - id: symfony_health_check.status_up_check
    health_error_response_code: 503
    ping_error_response_code: 503
~~~

Теперь неуспешная проверка в любом из двух наборов меняет HTTP-код соответствующего адреса на `503`. Код валидируется Symfony; задайте реальный HTTP-статус.

Если нужен Redis, добавьте его в список и задайте DSN через переменную окружения:

~~~yaml
symfony_health_check:
    health_checks:
        - id: symfony_health_check.doctrine_orm_check
        - id: symfony_health_check.redis_check
    redis_dsn: '%env(REDIS_DSN)%'
    health_error_response_code: 503
~~~

Не помещайте пароль Redis в репозиторий. Используйте секреты окружения или платформы. В зависимости от способа подключения могут понадобиться `symfony/cache`, PHP-расширение Redis или клиент Predis.

## Как добавить собственную проверку

Пользовательская проверка реализует `CheckInterface` и возвращает DTO бандла. Например, проверка каталога, куда приложение загружает файлы:

~~~php
<?php

namespace App\HealthCheck;

use SymfonyHealthCheckBundle\Check\CheckInterface;
use SymfonyHealthCheckBundle\Dto\Response as CheckResponse;

final class UploadDirectoryCheck implements CheckInterface
{
    public function __construct(
        private readonly string $directory,
    ) {
    }

    public function check(): CheckResponse
    {
        $writable = is_dir($this->directory) && is_writable($this->directory);

        return new CheckResponse(
            'uploads',
            $writable,
            $writable ? 'writable' : 'directory is unavailable',
        );
    }
}
~~~

Зарегистрируйте сервис явной настройкой, если класс ещё не попадает в автоматическую загрузку сервисов приложения:

~~~yaml
# config/services.yaml
services:
    App\HealthCheck\UploadDirectoryCheck:
        arguments:
            $directory: '%kernel.project_dir%/var/uploads'
~~~

Затем добавьте сервис в нужную группу:

~~~yaml
# config/packages/symfony_health_check.yaml
symfony_health_check:
    health_checks:
        - id: App\HealthCheck\UploadDirectoryCheck
    health_error_response_code: 503
~~~

Бандл получает проверки по ID сервиса; отдельный тег не нужен. Делайте проверки быстрыми и возвращайте стабильные сообщения. Если проверка может завершиться ожидаемой ошибкой, поймайте её внутри сервиса и верните `CheckResponse` с `result: false`. Иначе исключение прервёт формирование общего списка. Не помещайте в `message` и `params` секреты, DSN, токены или подробные внутренние адреса.

## Подключение к Docker Compose

Пример проверки подходит для контейнера, где доступен HTTP-сервер приложения и установлен `curl`:

~~~yaml
services:
  web:
    healthcheck:
      test:
        - CMD-SHELL
        - curl --fail --silent --show-error http://127.0.0.1/health >/dev/null
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 15s
~~~

В конфигурации Symfony при этом должен быть задан `health_error_response_code: 503`, иначе `curl --fail` может получить `200` при неуспешных проверках. Команда HEALTHCHECK выполняется внутри контейнера. Если приложение работает в отдельном PHP-FPM-контейнере без HTTP-сервера, запрос к `127.0.0.1/health` внутри него не попадёт в Nginx. В такой схеме проверяйте HTTP-маршрут в контейнере веб-сервера или отдельным монитором, который видит нужную сеть.

Docker записывает результат HEALTHCHECK в состояние контейнера (`healthy` или `unhealthy`). Сам HEALTHCHECK не перезапускает контейнер при `unhealthy`: политика `restart` реагирует на завершение основного процесса. В Compose условие `depends_on: condition: service_healthy` может задержать запуск зависимого сервиса до прохождения проверки; это условие порядка запуска, а не постоянный механизм восстановления.

## Доступ, нагрузка и безопасность

В README бандла приведён пример firewall `security: false` для анонимного доступа к `/health` и `/ping`. Такая настройка отключает Symfony Security для совпавших запросов, но сама по себе не ограничивает IP-адреса. Если маршрут нужен Docker, балансировщику или мониторингу, закройте его на внешнем уровне от публичных клиентов: внутренней сетью, правилами reverse proxy, firewall или подходящей аутентификацией.

Особенно важно ограничить `/health`: встроенные проверки могут помещать в `message` текст ошибок драйвера БД или Redis, а `environment_check` включает название окружения в `params`. Пользовательские проверки должны возвращать наружу короткое безопасное сообщение, а подробности отправлять в лог.

Каждый запрос запускает все проверки из соответствующего списка. Если маршрут часто опрашивается, медленный запрос к зависимости занимает время и ресурсы PHP-процесса. Задайте разумные интервалы в Docker или мониторинге, а для сетевых проверок используйте таймауты. Для частого liveness-сигнала оставьте только быструю проверку HTTP-пути; проверки БД и Redis запускайте с подходящей частотой и учитывайте, как система будет реагировать на их отказ.

## Как проверить настройку

Сначала убедитесь, что маршруты зарегистрированы, затем вызовите оба адреса из окружения, где работает приложение:

~~~bash
php bin/console debug:router | grep -E 'health|ping'
curl -i http://127.0.0.1/health
curl -i http://127.0.0.1/ping
~~~

Проверьте и тело ответа, и HTTP-статус. При настроенном коде ошибки `503` любая запись с `result: false` должна переводить соответствующий endpoint в `503`; при пустой группе проверок ответ будет `[]` со статусом `200`.

## Источники

Основной источник — [README MacPaw Symfony Health Check Bundle для v2.1.0](https://github.com/MacPaw/symfony-health-check-bundle/blob/v2.1.0/README.md), [релиз v2.1.0](https://github.com/MacPaw/symfony-health-check-bundle/releases/tag/v2.1.0) и исходный код:

- [HealthController](https://github.com/MacPaw/symfony-health-check-bundle/blob/v2.1.0/src/Controller/HealthController.php) и [BaseController](https://github.com/MacPaw/symfony-health-check-bundle/blob/v2.1.0/src/Controller/BaseController.php)
- [Интерфейс проверки](https://github.com/MacPaw/symfony-health-check-bundle/blob/v2.1.0/src/Check/CheckInterface.php) и [DTO ответа](https://github.com/MacPaw/symfony-health-check-bundle/blob/v2.1.0/src/Dto/Response.php)
- [Список встроенных сервисов проверок](https://github.com/MacPaw/symfony-health-check-bundle/blob/v2.1.0/src/Resources/config/health_checks.php), [маршруты](https://github.com/MacPaw/symfony-health-check-bundle/blob/v2.1.0/src/Resources/config/routes.php) и [настройки контейнера](https://github.com/MacPaw/symfony-health-check-bundle/blob/v2.1.0/src/DependencyInjection/Configuration.php)
- [Docker HEALTHCHECK](https://docs.docker.com/reference/dockerfile/#healthcheck), [healthcheck в Compose](https://docs.docker.com/reference/compose-file/services/#healthcheck), [порядок запуска зависимостей Compose](https://docs.docker.com/compose/how-tos/startup-order/) и [политики перезапуска Docker](https://docs.docker.com/engine/containers/start-containers-automatically/)
- [Symfony Security: правила доступа к маршрутам](https://symfony.com/doc/current/security.html)

Для общего понимания liveness/readiness можно дополнительно прочитать статью [Symfony in Kubernetes: health checks that actually check something](https://www.mironsoft.de/en/blog/symfony-kubernetes-health-checks-liveness-and-readiness-probes). Она объясняет устройство проверок Symfony в Kubernetes и не описывает конкретно MacPaw-бандл.
