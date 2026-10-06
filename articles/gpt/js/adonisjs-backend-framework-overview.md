# AdonisJS: обзор backend-фреймворка для Node.js и TypeScript

**Срез статьи — 6 октября 2026 года, актуальная документация — AdonisJS 7.** AdonisJS — backend-first фреймворк на TypeScript с MVC-конвенциями, ORM, миграциями, валидацией, авторизацией и готовыми наборами для разных типов приложений. По стилю он ближе к Rails/Laravel/Symfony, чем к Express: меньше приходится склеивать самостоятельно, зато нужно принять его соглашения и подход к данным.

## Версия и требования к runtime

AdonisJS 7 требует **Node.js 24 или новее** и npm 11 или новее. На дату среза Node 24 находится в LTS, а Node 26 — в ветке Current. Для production Node.js рекомендует ветки Active LTS или Maintenance LTS, поэтому для нового сервиса разумная отправная точка — Node 24 LTS. Node 22, даже если он установлен на сервере, не удовлетворяет требованию AdonisJS 7. [Установка AdonisJS](https://docs.adonisjs.com/installation), [график поддержки Node.js](https://nodejs.org/en/about/previous-releases).

Новые приложения AdonisJS написаны на TypeScript, используют ESM и собираются в JavaScript для production. Это важно проверить заранее, если команда использует CommonJS-only зависимости, старые сборочные плагины или инфраструктуру, закреплённую на Node 22.

Переход с AdonisJS 6 на 7 — major-обновление. Помимо Node.js 24, руководство описывает изменения JIT-компилятора TypeScript, поддержку TypeScript 5.9/6.0, ESLint 10 и Vite 7. Не стоит сводить такой переход к команде обновления npm-пакетов: проверьте шаги миграции по отдельному [upgrade guide для v6 → v7](https://docs.adonisjs.com/v6-to-v7).

## В каких приложениях он уместен

AdonisJS поддерживает несколько способов построить пользовательскую часть:

- серверный HTML на шаблонах Edge;
- React или Vue вместе с Inertia;
- отдельный API, к которому подключается выбранный frontend;
- full-stack приложение, где серверная и клиентская части развиваются в одном репозитории.

Это позволяет начать с серверных HTML-страниц и позже выделить SPA или отдельный клиент. API и бизнес-логику при этом не обязательно переписывать. [Обзор AdonisJS](https://docs.adonisjs.com/introduction).

### Starter kits

Новый проект создают командой:

~~~bash
npm create adonisjs@latest my-app
~~~

Интерактивный мастер предлагает выбрать стартовый комплект. Его можно указать явно:

~~~bash
npm create adonisjs@latest my-app -- --kit=hypermedia
npm create adonisjs@latest my-react-app -- --kit=react
npm create adonisjs@latest my-vue-app -- --kit=vue
npm create adonisjs@latest my-api -- --kit=api
~~~

Комплекты решают разные задачи:

| Kit | Что он создаёт | Когда выбирать |
|---|---|---|
| Hypermedia | Edge для HTML на сервере и Alpine.js для небольшой интерактивности | Формы, личные кабинеты, внутренние системы и сайты с преимущественно серверным рендерингом |
| React | AdonisJS backend и React frontend через Inertia | Полноценное приложение, где хочется React-компоненты и серверную маршрутизацию AdonisJS |
| Vue | Backend и Vue frontend через Inertia | Full-stack приложение с Vue в клиентской части |
| API | Monorepo с backend-приложением AdonisJS и отдельной frontend-заготовкой | Клиенту нужны REST API и сквозные TypeScript-типы; frontend можно выбрать или заменить |

Во всех официальных starter kits уже настроены Lucid с SQLite, аутентификация и тестовая среда. Это помогает быстро запустить прототип, но не означает, что SQLite автоматически подходит для production. API kit тоже не только серверная папка: это monorepo с отдельными приложениями backend и frontend под управлением Turborepo. У сообщества есть более лёгкий Slim starter kit, но это отдельный community-проект. [Варианты установки и starter kits](https://docs.adonisjs.com/installation), [структура проекта](https://docs.adonisjs.com/folder-structure).

Если нужен совсем короткий обзор возможностей, API starter поднимает backend и frontend командой из корня:

~~~bash
cd my-api
npm run dev
~~~

Для остальных комплектов dev-сервер обычно запускают командой Ace:

~~~bash
node ace serve --hmr
~~~

## Как устроено приложение

В AdonisJS маршруты регистрируются в **start/routes.ts**, а контроллеры, модели и middleware лежат в **app/**. Главные части типичного проекта:

| Путь | Назначение |
|---|---|
| start/routes.ts | URL, HTTP-методы, группы маршрутов и middleware |
| app/controllers/ | обработка HTTP-запросов и вызов прикладной логики |
| app/models/ | модели Lucid ORM и связи между ними |
| app/validators/ | схемы проверки входных данных с VineJS |
| app/middleware/ | логика, выполняемая вокруг обработки запроса |
| database/migrations/ | версионированные изменения схемы БД |
| database/schema.ts | сгенерированные TypeScript-описания таблиц и колонок |
| config/ | настройка AdonisJS и подключённых пакетов |
| start/env.ts | схема проверки переменных окружения |
| tests/ | тесты на Japa |

**start/env.ts** — исполняемая схема: AdonisJS проверяет значения переменных при запуске приложения и сообщает об отсутствующих или некорректных настройках до обработки запросов. В коде их читают через типизированный env-сервис. В production переменные задаются системой развёртывания; файл **.env** намеренно не попадает в build. [Конфигурация и окружение](https://docs.adonisjs.com/configuration), [Production build](https://docs.adonisjs.com/deployment).

Простой маршрут может вернуть JSON без отдельного контроллера:

~~~ts
import router from '@adonisjs/core/services/router'

router.get('/health', () => ({ status: 'ok' }))
~~~

Для предметной логики используют контроллеры и сервисы. HTTP-контекст AdonisJS даёт обработчику доступ к маршруту, параметрам, запросу, ответу, сессии и аутентифицированному пользователю. Группы маршрутов позволяют одним вызовом применять общий префикс и middleware, например к защищённой части API. [Маршрутизация](https://docs.adonisjs.com/guides/basics/routing), [HTTP context](https://docs.adonisjs.com/guides/basics/http-context).

AdonisJS использует IoC-контейнер и dependency injection. Контроллеры, middleware, event listeners и Ace-команды создаются контейнером, поэтому в них можно внедрять зависимости. Для произвольных сервисных классов контейнер тоже доступен, но классы, которые должны получать constructor injection, нужно явно подготовить через декоратор inject или создавать через контейнер. [Dependency injection и IoC](https://docs.adonisjs.com/guides/concepts/dependency-injection).

Фреймворк также генерирует файлы в **.adonisjs/**: среди них реестры контроллеров и информация для импорта и типизации. Храните эту директорию в Git: TypeScript и production-сборке нужны сгенерированные файлы, в том числе в CI. [Структура проекта](https://docs.adonisjs.com/folder-structure).

## Работа с базой: Lucid и миграции

Lucid — официальный ORM AdonisJS. Это **Active Record ORM** на базе Knex: модели представляют строки таблиц, связи можно описывать в классах, а для сложного SQL доступен query builder. Поддерживаются MySQL, PostgreSQL, SQLite, MSSQL и Turso. [Обзор Lucid ORM](https://docs.adonisjs.com/guides/database/lucid).

В AdonisJS 7 используется migrations-first workflow:

1. Создаёте миграцию для изменения схемы.
2. Запускаете её на базе данных.
3. Lucid генерирует TypeScript-описания в database/schema.ts.
4. Модель использует сгенерированную схему и добавляет связи или прикладное поведение.

Например:

~~~bash
node ace make:model Post
node ace make:migration posts
node ace migration:run
~~~

Сгенерированные schema-классы в **database/schema.ts** редактировать вручную не нужно: они обновляются после миграций. Собственную логику модели размещают в **app/models/**, а изменение таблиц оформляют следующей миграцией. Миграции задают направление вперёд и откат, а Lucid оборачивает их в транзакции там, где это поддерживает выбранная база. [Lucid и миграции](https://docs.adonisjs.com/guides/database/lucid).

Проверка уникальности через валидатор полезна для понятного ответа пользователю, но не заменяет ограничение UNIQUE в самой базе. Два параллельных запроса могут пройти проверку одновременно; ограничение базы остаётся последней гарантией целостности.

## Валидация на границе запроса

AdonisJS поставляет VineJS для схем валидации. Обычно валидатор описывает допустимые входные данные, а контроллер сразу получает проверенный payload:

~~~ts
import vine from '@vinejs/vine'

export const createPostValidator = vine.create({
  title: vine.string(),
  body: vine.string(),
})
~~~

В контроллере:

~~~ts
const payload = await request.validateUsing(createPostValidator)
const post = await Post.create(payload)

return response.created(post)
~~~

VineJS проверяет тело запроса, а также может проверять параметры маршрута, query string, заголовки и cookies. Ошибки обрабатываются exception handler фреймворка с учётом формата запроса. Валидатор помогает определить границу доверия: в прикладной слой поступают данные ожидаемой формы. Он не заменяет авторизацию пользователя и ограничения базы данных. [Валидация с VineJS](https://docs.adonisjs.com/guides/basics/validation).

## Аутентификация и авторизация — разные части

Пакет **@adonisjs/auth** отвечает на вопрос «кто делает запрос?». В нём есть несколько guards:

| Guard | Как работает | Где подходит |
|---|---|---|
| Session | Хранит состояние входа в сессии и cookie | Серверный HTML и SPA на том же домене |
| Access tokens | Использует opaque bearer-токен, сохранённый в базе в виде хеша | Мобильные приложения, отдельный SPA, интеграции |
| Basic auth | Клиент передаёт логин и пароль в заголовке каждого запроса | В основном прототипы и ограниченные внутренние инструменты. Для обычной production-аутентификации не рекомендуется: нужны TLS и дополнительные меры управления учётными записями |

Нюанс для API: токены AdonisJS по умолчанию **не JWT**. Это случайные opaque tokens, хеши которых хранятся в базе. Их можно немедленно отозвать удалением записи, но для проверки нужен запрос к хранилищу. Если контракт требует именно stateless JWT, потребуется отдельная реализация guard или подходящий пакет. [Authentication overview](https://docs.adonisjs.com/guides/auth/introduction), [Access tokens](https://docs.adonisjs.com/guides/auth/access-tokens-guard).

Сам auth-пакет не реализует регистрацию пользователей, восстановление пароля, подтверждение email и управление аккаунтом. Официальные starter kits добавляют готовые потоки для типичного приложения. Разрешения — вопрос «что этому пользователю можно делать?» — оформляются отдельно через **Bouncer**: abilities или policies. А middleware auth нужно явно повесить на защищённый маршрут или группу. [Границы auth-пакета](https://docs.adonisjs.com/guides/auth/introduction), [Bouncer и policies](https://docs.adonisjs.com/guides/auth/authorization).

Для серверных HTML-форм полезен пакет Shield: он позволяет настроить CSRF-защиту, CSP и связанные HTTP-заголовки. CSRF-защита зависит от настроенных сессий. Для API отдельно продумайте CORS, rate limiting и правила авторизации; сам факт наличия auth guard не защищает все маршруты автоматически. [Защита SSR-приложений](https://docs.adonisjs.com/guides/security/securing-ssr-applications), [rate limiting](https://docs.adonisjs.com/guides/security/rate-limiting).

## Тесты, CLI и подключаемые пакеты

**Ace** — CLI AdonisJS. Через него создают контроллеры, модели, валидаторы, миграции и команды. Некоторые официальные пакеты подключаются командой node ace add: она устанавливает пакет и настраивает нужные service providers, middleware и config-файлы.

Для тестирования AdonisJS использует **Japa** и интеграционный плагин. Starter kits обычно включают unit и browser suites; есть API client для HTTP-тестов и утилиты для сброса базы между тестами:

~~~bash
node ace test
node ace test unit
node ace test browser
~~~

Это не Jest с поверхностной Adonis-обёрткой: Japa интегрирован с жизненным циклом приложения, маршрутами и HTTP-клиентом. При необходимости можно использовать другие инструменты, но для типового Adonis-проекта Japa — официальный путь. [Тестирование с Japa](https://docs.adonisjs.com/guides/testing/introduction).

Cache, очередь задач, rate limiting, файлы и почта поставляются как подключаемые части экосистемы. Проверьте, что именно установлено в выбранном starter kit. Для очередей в production обычно нужен отдельный worker-процесс: наличие пакета в коде само по себе не запускает обработчик заданий. [Официальный пакет очередей](https://docs.adonisjs.com/guides/digging-deeper/queues).

## Сопоставление с Symfony и Rails

| Задача в PHP/Rails-приложении | Подход AdonisJS | Существенное отличие |
|---|---|---|
| Routes и controllers | start/routes.ts и app/controllers | Похожа MVC-структура; типы маршрутов и генерация URL встроены в экосистему |
| Doctrine или Active Record | Lucid ORM | Lucid использует Active Record поверх Knex; для команды, привыкшей к Doctrine Data Mapper/Unit of Work, модель работы будет отличаться |
| Symfony Validator | VineJS | Схемы обычно проверяют запрос на уровне контроллера до вызова модели |
| Symfony Security, роли и права | Auth guards плюс Bouncer | Аутентификация и авторизация подключаются как отдельные пакеты/части |
| Symfony Console или Rake | Ace | Команды, генераторы, миграции и служебные действия запускаются через node ace |
| Twig или серверные шаблоны | Edge | Edge — свой движок AdonisJS; для React/Vue есть Inertia, а view слой можно опустить в API-проекте |
| Service container | Adonis IoC container | Есть DI, но для обычных пользовательских классов нужно явно подключить injection или вручную создавать класс через контейнер |
| PHPUnit / RSpec | Japa | Japa ориентирован на Node.js и имеет HTTP/browser integration с AdonisJS |

По цельности набора компонентов AdonisJS ближе всего к Rails/Laravel. По модульности и DI он тоже будет понятен Symfony-разработчику. Главная потенциальная точка трения для PHP-команды — Lucid: это Active Record, а не Doctrine с его привычным Data Mapper и Unit of Work.

## Production: сборка, конфигурация и данные

Production-сборка создаётся командой:

~~~bash
npm run build
~~~

Она вызывает **node ace build**, компилирует TypeScript в JavaScript и собирает standalone каталог **build/**. В нём нет исходников TypeScript, dev-зависимостей и файлов **.env**. Переменные окружения нужно настроить на сервере или в системе развёртывания. Запуск production-сборки выглядит так:

~~~bash
cd build
npm ci --omit=dev
NODE_ENV=production node bin/server.js
~~~

В production migration:run защищена от случайного запуска и требует флаг **--force**. Выполняйте миграции контролируемым шагом релиза, а не при каждом старте каждого экземпляра приложения:

~~~bash
node ace migration:run --force
~~~

Проверьте конфигурацию после сборки: не-TypeScript файлы, например шаблоны Edge и static assets, попадают в build только если указаны в metaFiles. Пользовательские загрузки нельзя хранить только внутри build-каталога: при следующем деплое он заменяется. Для постоянных файлов используйте управляемое хранилище или отдельно сохраняемый том.

Статические файлы в production лучше отдавать через Nginx, Caddy или CDN. Если Node.js подключён за Nginx, сверьте таймауты keep-alive: документация AdonisJS описывает ситуацию, когда Node закрывает idle-соединение раньше, чем proxy ожидает его повторно использовать, и Nginx отвечает 502. Значение keepAliveTimeout приложения должно быть согласовано с proxy_read_timeout. [Deployment guide AdonisJS](https://docs.adonisjs.com/deployment).

При стандартной схеме проверки AdonisJS v7 требует Node 24 или новее; Node 24 сейчас LTS. Для нового production-сервиса используйте поддерживаемую LTS-ветку и проверьте, что локальная разработка, CI, Docker image и сервер запускают одинаковый major Node.js.

## Когда выбирать AdonisJS

AdonisJS подходит, если:

- нужен полный backend для бизнес-приложения, а не только маршрутизатор;
- команда пишет на TypeScript и хочет MVC-конвенции;
- важны ORM, миграции, авторизация и валидация из согласованной официальной экосистемы;
- приложение сочетает API с HTML, React или Vue;
- команде ближе Laravel/Rails-подход «сначала понятные соглашения, затем точечные расширения».

Другой выбор разумен, если проект обязан работать на Node.js 22 или старше, требует точного соответствия Doctrine Data Mapper, построен вокруг очень нестандартного ORM, или команде нужен только тонкий HTTP-слой. Если сложные вычисления занимают event loop, переход между Express и AdonisJS сам по себе не добавит параллелизма: выносите CPU-intensive задачи в Worker Threads или отдельную очередь. [Поддержка Node.js Worker Threads](https://nodejs.org/api/worker_threads.html).

## Краткий вывод

AdonisJS — цельный MVC-фреймворк для TypeScript/Node.js, особенно интересный командам, которым привычны Rails, Laravel или Symfony. Его сильная сторона — общий стиль проекта и официальные пакеты для частых backend-задач. Самые важные ограничения на старте: Node.js 24+, выбор starter kit, Active Record модель Lucid, auth/authorization как разные части и отдельная настройка хранения файлов и production-секретов.

## Источники

- [AdonisJS: introduction и назначение](https://docs.adonisjs.com/introduction)
- [AdonisJS: установка и starter kits](https://docs.adonisjs.com/installation)
- [Структура проекта и сгенерированные файлы](https://docs.adonisjs.com/folder-structure)
- [Lucid ORM, модели и миграции](https://docs.adonisjs.com/guides/database/lucid)
- [VineJS validation](https://docs.adonisjs.com/guides/basics/validation)
- [Authentication guards и ограничения auth-пакета](https://docs.adonisjs.com/guides/auth/introduction)
- [Opaque access tokens](https://docs.adonisjs.com/guides/auth/access-tokens-guard)
- [Bouncer authorization](https://docs.adonisjs.com/guides/auth/authorization)
- [IoC и dependency injection](https://docs.adonisjs.com/guides/concepts/dependency-injection)
- [Japa testing](https://docs.adonisjs.com/guides/testing/introduction)
- [Deployment и standalone build](https://docs.adonisjs.com/deployment)
- [Переход с AdonisJS v6 на v7](https://docs.adonisjs.com/v6-to-v7)
- [Node.js: поддерживаемые ветки и LTS](https://nodejs.org/en/about/previous-releases)
