# Packeton: приватные Composer-пакеты и зеркало Packagist

Packeton — self-hosted Composer-репозиторий. Он индексирует пакеты из Git, выдаёт Composer-метаданные и при необходимости собирает архивы. Дополнительно Packeton умеет проксировать другие Composer-репозитории, например Packagist. Исходные Git-репозитории остаются в GitHub, GitLab, Gitea или другом VCS.

В этом руководстве настроим Packeton так, чтобы он:

1. выдавал приватные пакеты с авторизацией;
2. проксировал публичные зависимости Packagist через отдельный URL.

Здесь нужны две разные авторизации:

- Packeton получает read-only доступ к Git-репозиторию, чтобы импортировать пакет и находить новые версии.
- Composer-клиент получает доступ к репозиторию Packeton по пользовательскому API token.

## 1. Установите Packeton через Docker Compose

Packeton публикует готовый Docker-образ. Быстрый вариант запускает веб-сервер, PHP-FPM, Redis, cron и worker в одном контейнере. Для постоянной production-установки у проекта есть пример с отдельными контейнерами PostgreSQL, Redis, PHP-FPM, worker и cron. [Установка Packeton в Docker](https://docs.packeton.org/installation-docker.html), [официальный Compose-пример с отдельными сервисами](https://github.com/vtsykun/packeton/blob/master/docker-compose-split.yml).

Ниже — компактная заготовка для первого запуска за reverse proxy. Данные сохраняются в именованный том, HTTP-порт доступен только на loopback хоста:

~~~yaml
services:
  packeton:
    image: ${PACKETON_IMAGE:?Set a tested Packeton image tag}
    restart: unless-stopped
    ports:
      - "127.0.0.1:8088:80"
    environment:
      APP_SECRET: ${PACKETON_APP_SECRET:?Set a stable APP_SECRET}
      ADMIN_USER: ${PACKETON_ADMIN_USER:?Set initial admin username}
      ADMIN_PASSWORD: ${PACKETON_ADMIN_PASSWORD:?Set initial admin password}
      ADMIN_EMAIL: ${PACKETON_ADMIN_EMAIL:?Set initial admin email}
      PACKAGIST_DIST_HOST: ${PACKETON_PUBLIC_URL:?Set the public HTTPS URL}
    volumes:
      - packeton_data:/data
      - ./config.yaml:/data/config.yaml:ro

volumes:
  packeton_data:
~~~

Создайте рядом с Compose-файлом файлы **config.yaml** и **.env**. Подставьте проверенный tag образа Packeton вместо шаблона и задайте значения:

~~~dotenv
PACKETON_IMAGE=packeton/packeton:REPLACE_WITH_TESTED_TAG
PACKETON_APP_SECRET=REPLACE_WITH_LONG_RANDOM_VALUE
PACKETON_ADMIN_USER=admin
PACKETON_ADMIN_PASSWORD=REPLACE_WITH_UNIQUE_PASSWORD
PACKETON_ADMIN_EMAIL=admin@example.org
PACKETON_PUBLIC_URL=https://packages.example.org
~~~

Замените шаблонный tag на реальный закреплённый tag или digest, который вы проверили. Не используйте **latest** для воспроизводимого production-развёртывания. Не добавляйте **.env** в Git и ограничьте доступ к нему на хосте: там находится начальный пароль администратора. Пользователь с доступом к Docker daemon может читать переменные контейнера, поэтому передавайте их только доверенной системе развёртывания.

**APP_SECRET** должен оставаться постоянным при пересоздании и обновлении Packeton: приложение использует его, в частности, для шифрования сохранённых SSH-ключей. Не генерируйте новый секрет при каждом запуске.

**PACKAGIST_DIST_HOST** задаёт внешний адрес, который Packeton помещает в ссылки на архивы. Укажите публичный HTTPS URL, по которому Composer-клиенты действительно достигают Packeton.

Проверьте конфигурацию и запустите контейнер:

~~~bash
docker compose config
docker compose up -d
docker compose logs --tail=100 packeton
~~~

Откройте **https://packages.example.org** через reverse proxy и войдите с начальной учётной записью. Не публикуйте контейнерный порт напрямую в интернет; завершайте TLS на reverse proxy. Если Packeton стоит за прокси, настройте **TRUSTED_PROXIES** только для фактического адреса или подсети этого прокси.

Если на VPS используется Nginx, базовый proxy для этого Compose-порта может выглядеть так. Сертификаты выпускайте и продлевайте своим обычным способом:

~~~nginx
server {
    listen 443 ssl;
    server_name packages.example.org;

    ssl_certificate /etc/letsencrypt/live/packages.example.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/packages.example.org/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:8088;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $remote_addr;
    }
}
~~~

Этот пример рассчитан на Nginx и Packeton на одном хосте. Для другого proxy проверьте, какой адрес этого proxy видит контейнер, и укажите его в **TRUSTED_PROXIES**.

В одноконтейнерном варианте Packeton по умолчанию использует SQLite и встроенный Redis; **/data** хранит файлы и базу. Для production с внешними PostgreSQL и Redis возьмите официальный split-пример за основу, закрепите версии всех образов и настройте резервное копирование базы и постоянных томов. В split-схеме нужная конфигурация должна быть доступна всем соответствующим контейнерам; не забывайте про worker и cron.

## 2. Настройте зеркало Packagist

Создайте в **config.yaml** конфигурацию upstream:

~~~yaml
packeton:
  mirrors:
    packagist:
      url: https://repo.packagist.org
      sync_lazy: true
      enable_dist_mirror: true
      # Только если зеркало должно быть анонимно доступно:
      # public_access: true
~~~

Docker-установка Packeton читает конфигурацию из **/data/config.yaml**; Compose выше монтирует туда файл только для чтения. **sync_lazy** включает ленивую синхронизацию метаданных. **enable_dist_mirror** включает зеркалирование архивов. Для большого Packagist ленивый режим позволяет не загружать весь каталог заранее. [Конфигурация зеркал Packeton](https://docs.packeton.org/usage/mirroring.html).

После изменения конфигурации перезапустите Packeton. В split-развёртывании перезапустите также worker и cron, если они читают этот файл. Затем выполните первую синхронизацию:

~~~bash
docker compose exec packeton bin/console packagist:sync:mirrors packagist -vvv
~~~

Команда синхронизирует зеркало с именем **packagist**; параметр **-vvv** включает подробный вывод. Дальше Packeton также запускает синхронизацию по расписанию.

В split Compose замените имя сервиса **packeton** в команде на контейнер, где доступен Packeton CLI, например **php-fpm**.

У зеркала отдельный Composer URL: **https://packages.example.org/mirror/packagist**. Корневой адрес **https://packages.example.org** предназначен для пакетов, размещённых в Packeton. Этот формат URL приведён в [статье автора Packeton о Composer proxy](https://dev.to/vtsykun/mirror-composer-dependencies-with-packeton-1jea).

### Доступ к публичному зеркалу

По умолчанию прокси закрыты. Если клиенты должны скачивать публичные пакеты Packagist без учётной записи, Packeton документирует **public_access: true** для конкретного зеркала. Не включайте глобальный **PUBLIC_ACCESS=true** только ради Packagist: эта переменная разрешает анонимный доступ к метаданным приложения в целом. Если зеркало остаётся закрытым, клиентам нужны учётные записи Packeton и API tokens. [Настройки доступа к зеркалу](https://docs.packeton.org/usage/mirroring.html), [переменные Docker-образа Packeton](https://docs.packeton.org/installation-docker.html).

Поскольку на одном Packeton могут быть приватные пакеты и публичное зеркало, после настройки проверьте доступ без авторизации к обоим URL. Корневой URL не должен раскрывать приватные пакеты, если это не предусмотрено вашей политикой.

## 3. Подготовьте приватный пакет в Git

У библиотеки должен быть **composer.json** с уникальным именем и настройкой автозагрузки:

~~~json
{
  "name": "acme/payment-contracts",
  "description": "Shared payment interfaces",
  "type": "library",
  "autoload": {
    "psr-4": {
      "Acme\\PaymentContracts\\": "src/"
    }
  },
  "require": {
    "php": "^8.2"
  }
}
~~~

Проверьте файл в репозитории:

~~~bash
composer validate
~~~

Опубликуйте код в приватном Git-репозитории и отмечайте стабильные версии Git-тегами, например **1.2.0**. Composer определяет версии по Git-тегам; используйте семантическое версионирование и не меняйте содержимое опубликованного тега. [Composer: версии библиотек](https://getcomposer.org/doc/02-libraries.md#versions).

Передайте Packeton read-only доступ к этому репозиторию. Используйте deploy key с правом только на чтение или настройте интеграцию с GitHub, GitLab либо Gitea. Credentials должны быть доступны Packeton-процессам, которые выполняют импорт и фоновые задачи. В Docker их можно настроить через Packeton или Composer home. Ключ на ноутбуке разработчика не даёт доступа worker-контейнеру. [SSH-ключи и Composer credentials Packeton](https://docs.packeton.org/installation.html).

Не смешивайте эти credentials с API token клиента: ключ VCS нужен Packeton для чтения исходников, а API token нужен Composer для чтения репозитория Packeton.

## 4. Импортируйте пакет и настройте обновления

Отправлять пакеты могут **ROLE_MAINTAINER** и **ROLE_ADMIN**. Импортируйте адрес Git-репозитория через интерфейс Packeton либо API:

~~~http
POST https://packages.example.org/api/create-package?token=<username>:<api_token>
Content-Type: application/json

{
  "repository": {
    "url": "git@github.com:acme/payment-contracts.git"
  }
}
~~~

Создайте token для пользователя, которому разрешена отправка пакетов, и передавайте его в CI как secret. Не добавляйте рабочий token в Git, **composer.json** или обычный лог сборки. [Packeton API: отправка пакета](https://docs.packeton.org/usage/api.html), [роли пользователей](https://docs.packeton.org/usage/index.html).

Документированный API передаёт token в query-параметре URL. Такие URL могут попадать в access-логи reverse proxy и CI. Используйте отдельный token с ограниченными правами, настройте редактирование query-параметров в логах и отзывайте token при утечке.

После импорта Packeton прочитает **composer.json**, проиндексирует версии и покажет пакет в интерфейсе. Чтобы новые Git-теги попадали в Packeton автоматически, настройте webhook или интеграцию с Git-провайдером. Для ручной синхронизации используйте интерфейс Packeton. Webhook авторизуется API token; заведите для него отдельную учётную запись или token с нужными правами. [Обновление пакетов через webhooks](https://docs.packeton.org/usage/update-packages.html).

Для клиентов создавайте отдельные учётные записи и назначайте доступ к нужным пакетам. **ROLE_USER** читает назначенные пакеты, **ROLE_FULL_CUSTOMER** — метаданные всех пакетов, **ROLE_MAINTAINER** может отправлять пакеты, **ROLE_ADMIN** управляет пользователями, webhooks и credentials.

## 5. Подключите Composer-проект

В проекте-потребителе укажите корневой Packeton для приватных пакетов и отдельный URL зеркала для публичных. Если нужно, чтобы публичные зависимости тоже шли через ваш Packeton, отключите встроенный Packagist Composer:

~~~json
{
  "repositories": [
    {
      "type": "composer",
      "url": "https://packages.example.org"
    },
    {
      "type": "composer",
      "url": "https://packages.example.org/mirror/packagist"
    },
    {
      "packagist.org": false
    }
  ],
  "require": {
    "acme/payment-contracts": "^1.2",
    "symfony/console": "^7.0"
  }
}
~~~

Порядок источников важен: Composer проверяет репозитории в указанном порядке. В Composer 2 репозитории по умолчанию canonical: если приватный репозиторий содержит пакет, Composer не станет подменять его версией того же имени из нижестоящего публичного источника. Это снижает риск dependency confusion. Не отключайте canonical без конкретной причины. [Composer: приоритет репозиториев](https://getcomposer.org/doc/articles/repository-priorities.md).

Если оставить встроенный Packagist включённым, часть публичных запросов может обходить ваше зеркало. Composer учитывает **repositories** из корневого проекта; репозитории из зависимой библиотеки не добавляются автоматически.

Добавьте API token через Composer, а не в **composer.json**:

~~~bash
composer config --global --auth \
  http-basic.packages.example.org \
  "$PACKETON_USER" "$PACKETON_API_TOKEN"
~~~

Передайте переменные из безопасного хранилища CI или локального менеджера секретов. Composer сохранит credentials в глобальный **auth.json**. Для CI используйте отдельный Composer home или **COMPOSER_AUTH** через секреты системы сборки; не печатайте token в логах. [Packeton: аутентификация Composer API](https://docs.packeton.org/authentication.html), [Composer: credentials приватных репозиториев](https://getcomposer.org/doc/articles/authentication-for-private-packages.md).

Проверьте, что Composer видит приватный пакет и его версии:

~~~bash
composer show --all acme/payment-contracts
~~~

Затем в тестовом проекте выполните обычный **composer require acme/payment-contracts:^1.2**. При необходимости добавьте **-vvv** и проверьте, что метаданные и архив скачиваются с ожидаемого домена Packeton.

## 6. Одобряйте сторонние зависимости

В прокси Packeton новые пакеты могут автоматически добавляться в доступные при первом **composer update**. Если проксируете сторонний Composer-репозиторий, включите Strict mode и утвердите нужные пакеты через Mass Mirror. Это снижает риск принять неожиданную зависимость или одноимённый пакет из upstream. Следите, чтобы пакеты вашего пространства имён, например **поставщика acme**, не разрешались через нежелательный источник. [Strict mode и ручное подтверждение зависимостей](https://docs.packeton.org/usage/mirroring.html).

Если используете **available_packages** или **available_package_patterns**, задайте ограниченный список пакетов и обновляйте его вместе с зависимостями проекта.

## Диагностика

Если приватный пакет не появляется:

- проверьте имя пакета и **autoload** в его **composer.json**;
- проверьте, что Packeton может клонировать репозиторий с правами read-only;
- убедитесь, что нужный Git-тег уже отправлен;
- проверьте логи worker и cron, а не только веб-контейнера;
- проверьте роль пользователя, который отправляет пакет.

Если публичный пакет не находится через зеркало:

- проверьте запись **packagist** в **/data/config.yaml**;
- выполните **packagist:sync:mirrors packagist -vvv**;
- проверьте Strict mode и allowlist;
- проверьте, что Composer URL содержит **/mirror/packagist**;
- проверьте API token или настройку **public_access**, если зеркало закрыто.

Если Composer скачивает архивы по внутреннему адресу или по HTTP, проверьте **PACKAGIST_DIST_HOST**, TLS на reverse proxy и сформированные Packeton ссылки на архивы. Не отключайте проверку HTTPS как обходную меру.

## Чек-лист

- [ ] Закрепить проверенный tag или digest Packeton.
- [ ] Сохранять данные и конфигурацию в постоянных томах; настроить резервное копирование и проверку восстановления.
- [ ] Задать постоянный **APP_SECRET** и создать начального администратора.
- [ ] Настроить DNS, HTTPS, reverse proxy и внешний **PACKAGIST_DIST_HOST**.
- [ ] Добавить в Git-пакет корректный **composer.json** и Git-теги версий.
- [ ] Выдать Packeton только read-only доступ к VCS.
- [ ] Импортировать приватный пакет и проверить работу worker.
- [ ] Настроить webhook обновления после push.
- [ ] Создать отдельные учётные записи Packeton и назначить им разрешённые пакеты.
- [ ] Добавить в Composer оба URL Packeton; отключить прямой Packagist, если весь трафик должен идти через зеркало.
- [ ] Хранить Composer API tokens вне Git.
- [ ] Проверить, что приватные пакеты не доступны анонимно.
- [ ] Включить Strict mode там, где нужно вручную одобрять upstream-пакеты.

## Источники

- [Packeton: установка Docker-образа и переменные окружения](https://docs.packeton.org/installation-docker.html)
- [Packeton: установка, SSH-ключи и Composer credentials](https://docs.packeton.org/installation.html)
- [Packeton: зеркала Composer и Strict mode](https://docs.packeton.org/usage/mirroring.html)
- [Автор Packeton: настройка Composer proxy и URL зеркала](https://dev.to/vtsykun/mirror-composer-dependencies-with-packeton-1jea)
- [Packeton API: отправка пакета](https://docs.packeton.org/usage/api.html)
- [Packeton: обновление пакетов через webhooks](https://docs.packeton.org/usage/update-packages.html)
- [Packeton: роли пользователей](https://docs.packeton.org/usage/index.html)
- [Composer: authentication приватных репозиториев](https://getcomposer.org/doc/articles/authentication-for-private-packages.md)
- [Composer: приоритет репозиториев](https://getcomposer.org/doc/articles/repository-priorities.md)
- [Composer: версии библиотек](https://getcomposer.org/doc/02-libraries.md#versions)
