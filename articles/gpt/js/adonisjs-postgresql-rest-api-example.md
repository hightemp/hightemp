# AdonisJS 7 и PostgreSQL: пример REST API с CRUD и токенами

Соберём API личных задач: пользователь регистрируется, получает токен и работает со своими записями в PostgreSQL. У задачи будут название, описание и статус. Добавим создание, просмотр, фильтрацию, пагинацию, частичное обновление и удаление.

Здесь важен весь путь запроса: как данные из JSON проходят проверку, превращаются в модель Lucid и сохраняются в PostgreSQL, а результат возвращается клиенту. Поэтому примеры включают полные файлы контроллера и валидаторов, запросы `curl` и функциональные тесты.

**Версии и дата:** пример подготовлен 9 октября 2026 года для AdonisJS 7, Lucid 22, VineJS 4 и PostgreSQL 18. Потребуются Node.js 24+, npm 11+, Docker с Compose v2 и `curl`. AdonisJS запускаем на компьютере, PostgreSQL — в отдельном локальном контейнере. [Требования AdonisJS](https://docs.adonisjs.com/installation#prerequisites).

## Что будет уметь API

| Метод | URL | Назначение | Успешный ответ |
|---|---|---|---|
| POST | `/api/v1/auth/signup` | Регистрация и выдача токена | 200, обработчик стартера |
| POST | `/api/v1/auth/login` | Вход и выдача нового токена | 200, обработчик стартера |
| GET | `/api/v1/account/profile` | Текущий пользователь | 200, обработчик стартера |
| POST | `/api/v1/account/logout` | Отзыв текущего токена | 200, обработчик стартера |
| GET | `/api/v1/tasks` | Список своих задач | 200 |
| POST | `/api/v1/tasks` | Создание задачи | 201 |
| GET | `/api/v1/tasks/:id` | Просмотр своей задачи | 200 |
| PATCH | `/api/v1/tasks/:id` | Изменение переданных полей | 200 |
| DELETE | `/api/v1/tasks/:id` | Удаление своей задачи | 204 |

Аутентификация уже есть в API-стартере. Наш код добавит ресурс `tasks` и ограничит запросы идентификатором текущего пользователя. Маршруты регистрации, входа, профиля и выхода приведены по [исходному файлу маршрутов стартера](https://github.com/adonisjs/starter-kits/blob/8fdf4c08bd172f9958a88a16a7139c391eb99fd8/api/start/routes.ts).

Основной путь запроса выглядит так:

```text
HTTP-запрос с Bearer-токеном
  → middleware аутентификации
  → контроллер и проверка данных VineJS
  → модель Lucid с ограничением по владельцу
  → PostgreSQL
  → JSON-ответ
```

## 1. Создаём проект

Проверьте версии инструментов:

```bash
node --version
npm --version
docker compose version
```

Для воспроизводимости используем initializer `3.4.0` и конкретный снимок официального API-шаблона:

```bash
npm create adonisjs@3.4.0 tasks-api -- \
  --kit="github:adonisjs/starter-kits/api#8fdf4c08bd172f9958a88a16a7139c391eb99fd8" \
  --skip-migrations

cd tasks-api
npm install pg
```

`--skip-migrations` откладывает создание таблиц до настройки PostgreSQL. Мастер создаст `.env` и сгенерирует ключ приложения `APP_KEY`; сохраните этот ключ. Драйвер `pg` нужен Lucid для подключения к PostgreSQL.

В выбранном шаблоне backend находится **в корне проекта**. Все дальнейшие команды выполняются в `tasks-api`. В текущем initializer есть два отдельных варианта: `api` и `api-monorepo`; структура с `apps/backend` относится к варианту монорепозитория. Это видно в [списке шаблонов initializer](https://github.com/adonisjs/create-adonisjs/blob/3.x/src/templates.ts). Возможность указывать репозиторий, подкаталог и Git reference описана в [README initializer](https://github.com/adonisjs/create-adonisjs/tree/3.x#--kit-default-triggers-prompt-for-selection).

Основные файлы нашего примера:

```text
tasks-api/
├── .env
├── compose.yaml
├── config/database.ts
├── start/env.ts
├── start/routes.ts
├── app/models/task.ts
├── app/validators/task.ts
├── app/controllers/tasks_controller.ts
├── database/migrations/..._create_tasks_table.ts
├── database/schema.ts
└── tests/functional/tasks.spec.ts
```

Сохраните созданный `package-lock.json`: последующие установки через `npm ci` будут использовать закреплённые версии зависимостей.

## 2. Задаём параметры PostgreSQL

Откройте существующий `.env` и добавьте настройки базы. Не заменяйте весь файл: в нём уже есть ключ приложения и настройки стартера.

```dotenv
DB_CONNECTION=postgres
DB_HOST=127.0.0.1
DB_PORT=5432
DB_USER=tasks_app
DB_PASSWORD=REPLACE_WITH_A_GENERATED_PASSWORD
DB_DATABASE=tasks_api
```

Сгенерировать локальный пароль можно командой:

```bash
node -e "console.log(require('node:crypto').randomBytes(24).toString('hex'))"
```

Подставьте полученное значение в `DB_PASSWORD`. Для приложения в этом примере также удобно задать:

```dotenv
HOST=127.0.0.1
PORT=3333
APP_URL=http://127.0.0.1:3333
```

В `start/env.ts` добавьте свойства в уже существующий объект, передаваемый `Env.create`:

```ts
  DB_CONNECTION: Env.schema.enum(['postgres'] as const),
  DB_HOST: Env.schema.string({ format: 'host' }),
  DB_PORT: Env.schema.number(),
  DB_USER: Env.schema.string(),
  DB_PASSWORD: Env.schema.string(),
  DB_DATABASE: Env.schema.string(),
```

Добавьте эти свойства внутрь объекта существующего `Env.create`. Импорт `Env` в стартере уже есть. Схема окружения позволит обнаружить пропущенные настройки при запуске и преобразует строковый `DB_PORT` в число. [Окружение AdonisJS](https://docs.adonisjs.com/configuration).

## 3. Запускаем PostgreSQL через Compose

Создайте `compose.yaml` в корне проекта:

```yaml
services:
  postgres:
    image: postgres:18
    environment:
      POSTGRES_USER: ${DB_USER:?Set DB_USER in .env}
      POSTGRES_PASSWORD: ${DB_PASSWORD:?Set DB_PASSWORD in .env}
      POSTGRES_DB: ${DB_DATABASE:?Set DB_DATABASE in .env}
    ports:
      - "127.0.0.1:${DB_PORT:-5432}:5432"
    volumes:
      - postgres_data:/var/lib/postgresql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U \"$${POSTGRES_USER}\" -d \"$${POSTGRES_DB}\""]
      interval: 5s
      timeout: 5s
      retries: 10
      start_period: 10s

volumes:
  postgres_data:
```

Compose читает переменные из `.env`. Таким образом, имя базы, пользователь и пароль задаются в одном месте и используются обеими сторонами подключения.

В строке `ports` слева указан порт компьютера, справа — порт внутри контейнера. Публикация привязана к `127.0.0.1`. Если локальный `5432` занят, задайте, например, `DB_PORT=55432`: приложение будет подключаться к `127.0.0.1:55432`, а PostgreSQL внутри контейнера продолжит слушать `5432`. [Порты и healthcheck в Compose](https://docs.docker.com/reference/compose-file/services/).

Для **официального образа PostgreSQL 18** том монтируется в `/var/lib/postgresql`. Образ использует версионный каталог данных внутри него. Это отличается от распространённых примеров для PostgreSQL 17 с `/var/lib/postgresql/data`. [Документация официального образа](https://github.com/docker-library/docs/blob/master/postgres/README.md#pgdata).

Запустите базу и дождитесь готовности:

```bash
docker compose up -d --wait postgres
docker compose ps
```

Проверьте вход по TCP с заданным паролем:

```bash
docker compose exec postgres sh -c \
  'PGPASSWORD="$POSTGRES_PASSWORD" psql -h 127.0.0.1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT current_database(), current_user;"'
```

Переменные `POSTGRES_USER`, `POSTGRES_PASSWORD` и `POSTGRES_DB` применяются при первоначальной инициализации пустого тома. Изменение `.env` не меняет пароль или имя уже существующей базы. Также учтите, что `POSTGRES_USER` в этом образе создаёт суперпользователя: такая схема удобна для локального примера, а рабочему приложению на сервере выделяют роль с ограниченными правами. [Инициализация образа](https://github.com/docker-library/docs/blob/master/postgres/README.md#environment-variables).

## 4. Переключаем Lucid на PostgreSQL

Замените `config/database.ts` следующим содержимым:

```ts
import env from '#start/env'
import { defineConfig } from '@adonisjs/lucid'

export default defineConfig({
  connection: env.get('DB_CONNECTION'),

  connections: {
    postgres: {
      client: 'pg',

      connection: {
        host: env.get('DB_HOST'),
        port: env.get('DB_PORT'),
        user: env.get('DB_USER'),
        password: env.get('DB_PASSWORD'),
        database: env.get('DB_DATABASE'),
      },

      migrations: {
        naturalSort: true,
        paths: ['database/migrations'],
      },

      schemaGeneration: {
        enabled: true,
        rulesPaths: ['./database/schema_rules.js'],
      },
    },
  },
})
```

`connection` выбирает ключ из объекта `connections`, а `client: 'pg'` указывает драйвер PostgreSQL. Lucid использует пул соединений; отдельное подключение на каждый HTTP-запрос вручную создавать не требуется.

Здесь важно сохранить `schemaGeneration`. В AdonisJS 7 модели стартера наследуют классы из `database/schema.ts`, которые Lucid генерирует по таблицам базы. При переключении с SQLite на PostgreSQL генерацию нужно включить в **новом подключении**. Файл `database/schema_rules.ts` уже есть в шаблоне; путь с `.js` соответствует ESM-импортам после компиляции TypeScript. [Настройка Lucid](https://docs.adonisjs.com/guides/database/lucid#configuration), [конфигурация выбранного стартера](https://github.com/adonisjs/starter-kits/blob/8fdf4c08bd172f9958a88a16a7139c391eb99fd8/api/config/database.ts).

Поскольку приложение работает на компьютере, `DB_HOST` равен `127.0.0.1`. Если позднее перенесёте приложение в ту же Compose-сеть, его адресом базы станет имя сервиса `postgres`, а портом — внутренний `5432`.

## 5. Создаём таблицу задач

Сгенерируйте миграцию:

```bash
node ace make:migration tasks
```

Откройте созданный файл в `database/migrations` с временной меткой в имени. Замените его содержимое:

```ts
import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'tasks'

  async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.increments('id')

      table
        .integer('user_id')
        .notNullable()
        .references('id')
        .inTable('users')
        .onDelete('CASCADE')

      table.string('title', 160).notNullable()
      table.text('description').nullable()

      table
        .string('status', 20)
        .notNullable()
        .defaultTo('todo')
        .checkIn(['todo', 'doing', 'done'])

      table.timestamp('created_at', { useTz: true }).notNullable().defaultTo(this.now())
      table.timestamp('updated_at', { useTz: true }).notNullable().defaultTo(this.now())

      table.index(['user_id', 'id'])
      table.index(['user_id', 'status', 'id'])
    })
  }

  async down() {
    this.schema.dropTable(this.tableName)
  }
}
```

Здесь несколько уровней защиты данных:

- Внешний ключ `user_id` не позволит записать задачу несуществующего пользователя. `CASCADE` удалит его задачи при удалении самого пользователя.
- `NOT NULL` требует владельца, название, статус и временные метки.
- `CHECK` ограничивает статус значениями `todo`, `doing`, `done` независимо от того, через API или напрямую через SQL записывают данные.
- Индексы соответствуют двум нашим запросам: список задач владельца и список его задач с фильтром по статусу.

Lucid использует schema builder Knex; метод `checkIn` создаёт ограничение для колонки. [Schema builder Knex](https://knexjs.org/guide/schema-builder.html#checkin).

Примените миграции:

```bash
node ace migration:run
```

Команда создаст также таблицы `users` и `auth_access_tokens` из миграций стартера. Затем Lucid обновит `database/schema.ts`, добавив `TaskSchema` с описанием колонок задачи.

`created_at` и `updated_at` хранятся как PostgreSQL `timestamptz`. Lucid представляет их объектами Luxon `DateTime`. При обычном `save()` Lucid обновляет `updatedAt`; значение `DEFAULT` в базе само по себе не обновляет колонку при каждом SQL `UPDATE`.

В `down()` описывается обратное действие миграции. После применения миграции в общем окружении последующие изменения таблицы оформляют новой миграцией, чтобы история схемы оставалась воспроизводимой. [Миграции Lucid](https://lucid.adonisjs.com/docs/migrations).

## 6. Добавляем модель

```bash
node ace make:model Task
```

Файл `app/models/task.ts`:

```ts
import { TaskSchema } from '#database/schema'

export default class Task extends TaskSchema {
  static ownedBy(userId: number) {
    return this.query().where('user_id', userId)
  }
}
```

Колонки не нужно повторно объявлять декораторами: они унаследованы от сгенерированной схемы. `TaskSchema` соответствует таблице `tasks`; `user_id` доступен в модели как `userId`, а `created_at` — как `createdAt`.

Метод `ownedBy` возвращает запрос с ограничением по владельцу. К нему можно добавлять поиск по идентификатору, фильтры и сортировку. Каждый вызов создаёт новый query builder.

Сам `database/schema.ts` не редактируйте: изменения в нём будут перезаписаны генератором. Пользовательскую логику добавляйте в `Task`, а правила генерации типов — в `database/schema_rules.ts`. [Генерация схем Lucid](https://lucid.adonisjs.com/docs/schema-generation).

## 7. Проверяем входные данные через VineJS

Создайте файл валидаторов:

```bash
node ace make:validator task
```

Полное содержимое `app/validators/task.ts`:

```ts
import vine from '@vinejs/vine'

const title = () => vine.string().trim().minLength(1).maxLength(160)
const description = () => vine.string().trim().maxLength(5000).nullable().optional()
const status = () => vine.enum(['todo', 'doing', 'done'])

export const createTaskValidator = vine.create({
  title: title(),
  description: description(),
  status: status().optional(),
})

export const updateTaskValidator = vine.create({
  title: title().optional(),
  description: description(),
  status: status().optional(),
})

export const taskIdValidator = vine.create({
  id: vine.number().withoutDecimals().min(1).max(2147483647),
})

export const listTasksValidator = vine.create({
  page: vine.number().withoutDecimals().min(1).max(10000).optional(),
  limit: vine.number().withoutDecimals().min(1).max(100).optional(),
  status: status().optional(),
})
```

Для создания обязательно только `title`. В PATCH-запросе все поля необязательные, поскольку клиент может менять одно из них. При этом пропущенное описание и `description: null` имеют разный смысл: в первом случае поле сохраняется, во втором — очищается.

`userId` отсутствует в схемах: владельца определит сервер по токену. Также мы не принимаем от клиента идентификатор задачи и временные метки. Валидатор возвращает только объявленные поля.

Параметры URL и query string приходят строками. `vine.number()` умеет преобразовывать числовые строки, а `withoutDecimals()` запрещает дробную часть. Поэтому `?limit=20` станет числом, а `?limit=1.5` будет отклонён. Верхняя граница `id` соответствует положительным значениям PostgreSQL `integer` в нашей таблице. [VineJS: числа](https://vinejs.dev/docs/types/number).

Фабрики правил `title()` и `status()` создают отдельные экземпляры схем для каждого валидатора. Так схемы создания и изменения можно развивать независимо. [Валидация в AdonisJS](https://docs.adonisjs.com/guides/basics/validation).

## 8. Пишем CRUD-контроллер

Создайте контроллер:

```bash
node ace make:controller tasks --resource
```

Замените содержимое `app/controllers/tasks_controller.ts`:

```ts
import type { HttpContext } from '@adonisjs/core/http'
import Task from '#models/task'
import {
  createTaskValidator,
  updateTaskValidator,
  taskIdValidator,
  listTasksValidator,
} from '#validators/task'

function presentTask(task: Task) {
  return {
    id: task.id,
    title: task.title,
    description: task.description,
    status: task.status,
    createdAt: task.createdAt.toUTC().toISO(),
    updatedAt: task.updatedAt.toUTC().toISO(),
  }
}

export default class TasksController {
  async index({ auth, request }: HttpContext) {
    const user = auth.getUserOrFail()
    const filters = await listTasksValidator.validate(request.qs())

    const query = Task.ownedBy(user.id).orderBy('id', 'desc')

    if (filters.status !== undefined) {
      query.where('status', filters.status)
    }

    const tasks = await query.paginate(filters.page ?? 1, filters.limit ?? 20)

    return {
      data: tasks.all().map(presentTask),
      meta: {
        total: tasks.total,
        page: tasks.currentPage,
        limit: tasks.perPage,
        lastPage: tasks.lastPage,
      },
    }
  }

  async store({ auth, request, response }: HttpContext) {
    const user = auth.getUserOrFail()
    const payload = await createTaskValidator.validate(request.body())

    const task = await Task.create({
      userId: user.id,
      title: payload.title,
      description: payload.description ?? null,
      status: payload.status ?? 'todo',
    })

    return response.created({ data: presentTask(task) })
  }

  async show({ auth, params }: HttpContext) {
    const user = auth.getUserOrFail()
    const { id } = await taskIdValidator.validate(params)
    const task = await Task.ownedBy(user.id).where('id', id).firstOrFail()

    return { data: presentTask(task) }
  }

  async update({ auth, params, request, response }: HttpContext) {
    const user = auth.getUserOrFail()
    const { id } = await taskIdValidator.validate(params)
    const task = await Task.ownedBy(user.id).where('id', id).firstOrFail()
    const payload = await updateTaskValidator.validate(request.body())

    if (
      payload.title === undefined &&
      payload.description === undefined &&
      payload.status === undefined
    ) {
      return response.unprocessableEntity({
        errors: [
          {
            field: 'body',
            rule: 'atLeastOneField',
            message: 'Передайте title, description или status',
          },
        ],
      })
    }

    if (payload.title !== undefined) task.title = payload.title
    if (payload.description !== undefined) task.description = payload.description
    if (payload.status !== undefined) task.status = payload.status

    await task.save()

    return { data: presentTask(task) }
  }

  async destroy({ auth, params, response }: HttpContext) {
    const user = auth.getUserOrFail()
    const { id } = await taskIdValidator.validate(params)
    const task = await Task.ownedBy(user.id).where('id', id).firstOrFail()

    await task.delete()

    return response.noContent()
  }
}
```

### Что здесь происходит

**Владелец проверяется в запросе к базе.** Для чтения, обновления и удаления используются одновременно `user_id` и `id`. Если запись существует, но принадлежит другому пользователю, `firstOrFail()` не найдёт её и приложение вернёт 404. Таким способом API также не раскрывает наличие чужой задачи.

**Валидация привязана к источнику данных.** Для JSON-тела вызываем `.validate(request.body())`, для фильтров — `.validate(request.qs())`, для параметров пути — `.validate(params)`. Это позволяет явно задать, откуда берётся каждое значение. AdonisJS также предоставляет `request.validateUsing()`, но в этом примере источники разделены непосредственно в коде.

Исключения VineJS обрабатывает стандартный HTTP exception handler. Для JSON API ошибки валидации превращаются в ответ 422 с массивом `errors`. Оборачивать каждый вызов в общий `try/catch` и превращать любую ошибку в 500 не требуется. [Обработка ошибок валидации](https://docs.adonisjs.com/guides/basics/validation#understanding-error-handling).

**PATCH меняет только переданные поля.** Проверка на `undefined` сохраняет старое значение, если поле не пришло. При этом `null` у описания проходит проверку и записывается в базу. Пустой PATCH или запрос только с неизвестными полями получает 422.

**Ответ формируется явно.** `presentTask` определяет публичный JSON-контракт: наружу выходят только перечисленные поля. Временные метки переводятся в ISO 8601 и UTC. Добавление внутренней колонки в модель не добавит её автоматически в ответ. Для большого проекта такую функцию можно оформить как [AdonisJS Transformer](https://docs.adonisjs.com/guides/frontend/transformers).

**Список ограничен по размеру и упорядочен.** Максимальный `limit` равен 100, сортировка по уникальному `id` делает порядок однозначным. `paginate()` выполняет выборку страницы и отдельный запрос количества записей. Для очень больших списков позже можно перейти к курсорной пагинации. [Пагинация Lucid](https://lucid.adonisjs.com/docs/pagination).

## 9. Регистрируем маршруты

В `start/routes.ts` уже есть импорты `router`, `middleware` и `controllers`, а также маршруты аутентификации. Сохраните их и добавьте группу:

```ts
router
  .group(() => {
    router.get('/tasks', [controllers.Tasks, 'index']).as('tasks.index')
    router.post('/tasks', [controllers.Tasks, 'store']).as('tasks.store')
    router.get('/tasks/:id', [controllers.Tasks, 'show']).as('tasks.show')
    router.patch('/tasks/:id', [controllers.Tasks, 'update']).as('tasks.update')
    router.delete('/tasks/:id', [controllers.Tasks, 'destroy']).as('tasks.destroy')
  })
  .prefix('/api/v1')
  .use(middleware.auth({ guards: ['api'] }))
```

Группа добавляет префикс всем URL и требует access token через guard `api`. Одного вызова `auth.getUserOrFail()` в контроллере для полноценной настройки аутентификации недостаточно: middleware сначала должен проверить токен запроса.

Импорты, которые уже присутствуют в файле стартера:

```ts
import router from '@adonisjs/core/services/router'
import { middleware } from '#start/kernel'
import { controllers } from '#generated/controllers'
```

`controllers.Tasks` берётся из сгенерированного реестра. Обновите его после создания контроллера, посмотрите зарегистрированные маршруты и проверьте типы:

```bash
node ace codegen
node ace list:routes
npm run typecheck
```

Затем запустите API:

```bash
npm run dev
```

Команда `codegen` предусмотрена текущей версией AdonisJS 7. Она обновляет генерируемые файлы без запуска HTTP-сервера. В нашей последовательности таблицы и `database/schema.ts` уже созданы миграцией. [Генерация кода](https://adonisjs.com/blog/codegen-and-application-warmup), [группы маршрутов и middleware](https://docs.adonisjs.com/guides/basics/routing).

## 10. Регистрируем пользователя и получаем токен

В другом терминале задайте адрес API:

```bash
API_URL=http://127.0.0.1:3333
```

Создайте пользователя:

```bash
AUTH_JSON=$(curl -fsS -X POST "$API_URL/api/v1/auth/signup" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    "fullName": "API Developer",
    "email": "developer@example.test",
    "password": "LocalDemoPassword_42",
    "passwordConfirmation": "LocalDemoPassword_42"
  }')
```

В выбранном стартере ответ имеет структуру:

```json
{
  "data": {
    "user": {
      "id": 1,
      "fullName": "API Developer",
      "email": "developer@example.test"
    },
    "token": "oat_..."
  }
}
```

Здесь показаны основные поля; у пользователя в ответе могут быть дополнительные публичные свойства. Токен находится **в `data.token`**: контроллер регистрации использует сериализатор API-стартера, который добавляет оболочку `data`. [Контроллер регистрации](https://github.com/adonisjs/starter-kits/blob/8fdf4c08bd172f9958a88a16a7139c391eb99fd8/api/app/controllers/new_account_controller.ts), [сериализатор стартера](https://github.com/adonisjs/starter-kits/blob/8fdf4c08bd172f9958a88a16a7139c391eb99fd8/api/providers/api_provider.ts).

Извлеките токен без установки дополнительных утилит:

```bash
TOKEN=$(printf '%s' "$AUTH_JSON" | \
  node -p 'JSON.parse(require("node:fs").readFileSync(0, "utf8")).data.token')
```

Для уже зарегистрированного пользователя вместо повторного signup выполните вход и снова извлеките `TOKEN` той же командой:

```bash
AUTH_JSON=$(curl -fsS -X POST "$API_URL/api/v1/auth/login" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    "email": "developer@example.test",
    "password": "LocalDemoPassword_42"
  }')
```

В каждый защищённый запрос передаётся заголовок `Authorization: Bearer ...`. Это opaque access token AdonisJS. При проверке сервер использует таблицу токенов; исходное значение токена клиент получает при его выдаче, а в базе хранится хеш. [Access tokens guard](https://docs.adonisjs.com/guides/auth/access-tokens-guard).

## 11. Проверяем CRUD запросами curl

### Создание

```bash
TASK_JSON=$(curl -fsS -X POST "$API_URL/api/v1/tasks" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    "title": "Разобраться с Lucid",
    "description": "Сделать CRUD API с PostgreSQL"
  }')

printf '%s\n' "$TASK_JSON"

TASK_ID=$(printf '%s' "$TASK_JSON" | \
  node -p 'JSON.parse(require("node:fs").readFileSync(0, "utf8")).data.id')
```

POST возвращает HTTP 201. В JSON будет задача со статусом `todo`, идентификатором и временными метками:

```json
{
  "data": {
    "id": 1,
    "title": "Разобраться с Lucid",
    "description": "Сделать CRUD API с PostgreSQL",
    "status": "todo",
    "createdAt": "2026-10-09T09:00:00.000Z",
    "updatedAt": "2026-10-09T09:00:00.000Z"
  }
}
```

Идентификатор и даты здесь иллюстративные. Переменная `TASK_ID` получает действительное значение из вашего ответа.

### Список и фильтр

```bash
curl -i "$API_URL/api/v1/tasks?page=1&limit=10&status=todo" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json'
```

Пример тела ответа:

```json
{
  "data": [
    {
      "id": 1,
      "title": "Разобраться с Lucid",
      "description": "Сделать CRUD API с PostgreSQL",
      "status": "todo",
      "createdAt": "2026-10-09T09:00:00.000Z",
      "updatedAt": "2026-10-09T09:00:00.000Z"
    }
  ],
  "meta": {
    "total": 1,
    "page": 1,
    "limit": 10,
    "lastPage": 1
  }
}
```

При отсутствии подходящих задач `data` будет пустым массивом. Это успешный ответ 200, поскольку запрос списка выполнен корректно.

### Просмотр и частичное изменение

```bash
curl -i "$API_URL/api/v1/tasks/$TASK_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json'

curl -i -X PATCH "$API_URL/api/v1/tasks/$TASK_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{"status":"doing","description":null}'
```

Название останется прежним, статус станет `doing`, а описание очистится. Затем повторный GET покажет сохранённое состояние.

### Проверка ошибок

```bash
# Нет токена: ожидается 401
curl -i "$API_URL/api/v1/tasks" \
  -H 'Accept: application/json'

# Неподдерживаемый статус: ожидается 422
curl -i -X POST "$API_URL/api/v1/tasks" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{"title":"Новая задача","status":"unknown"}'

# Дробный размер страницы: ожидается 422
curl -i "$API_URL/api/v1/tasks?limit=1.5" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json'

# Пустой PATCH: ожидается 422
curl -i -X PATCH "$API_URL/api/v1/tasks/$TASK_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{}'
```

Ошибки VineJS содержат поле, нарушенное правило и сообщение. Точный текст сообщения зависит от версии и настроек валидатора; клиенту лучше опираться на `field` и `rule`.

### Удаление

```bash
curl -i -X DELETE "$API_URL/api/v1/tasks/$TASK_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json'

curl -i "$API_URL/api/v1/tasks/$TASK_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json'
```

DELETE возвращает 204 с пустым телом. Повторный GET удалённой записи возвращает 404. [Операции с моделями Lucid](https://lucid.adonisjs.com/docs/crud-operations).

При завершении сессии можно отозвать текущий токен:

```bash
curl -i -X POST "$API_URL/api/v1/account/logout" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Accept: application/json'
```

После этого тот же токен перестанет проходить проверку.

## 12. Добавляем функциональные тесты с PostgreSQL

Запросы `curl` помогают пройти сценарий вручную. Автоматические тесты удобно использовать для регрессий: например, чтобы дальнейший рефакторинг не открыл доступ к чужим задачам.

Создайте отдельную базу:

```bash
docker compose exec postgres sh -c \
  'createdb -U "$POSTGRES_USER" tasks_api_test'
```

Создание нужно выполнить один раз. Обновите `.env.test`, сохранив необходимые настройки стартера:

```dotenv
NODE_ENV=test
SESSION_DRIVER=memory
PORT=3334
APP_URL=http://127.0.0.1:3334
DB_CONNECTION=postgres
DB_DATABASE=tasks_api_test
```

Адрес базы, пользователь и пароль наследуются из `.env`, а имя базы переопределяется для тестов. Отдельный порт позволяет запускать тестовый HTTP-сервер рядом с dev-сервером. Убедитесь, что `DB_DATABASE` указывает именно на тестовую базу: тестовые hooks меняют её схему и данные.

В `tests/bootstrap.ts` уже подключены API-клиент Japa, плагины аутентификации и `testUtils`. В существующем `runnerHooks` добавьте подготовку схемы:

```ts
export const runnerHooks: Required<Pick<Config, 'setup' | 'teardown'>> = {
  setup: [() => testUtils.db().migrate()],
  teardown: [],
}
```

Остальные экспорты файла, включая `configureSuite`, сохраняются. Он запускает тестовый HTTP-сервер для `functional`-набора.

Создайте тест:

```bash
node ace make:test tasks --suite=functional
```

Файл `tests/functional/tasks.spec.ts`:

```ts
import { test } from '@japa/runner'
import testUtils from '@adonisjs/core/services/test_utils'
import User from '#models/user'
import Task from '#models/task'

test.group('Tasks API', (group) => {
  group.each.setup(() => testUtils.db().wrapInGlobalTransaction())

  test('требует аутентификацию', async ({ client }) => {
    const response = await client.get('/api/v1/tasks')
    response.assertStatus(401)
  })

  test('создаёт задачу текущего пользователя', async ({ client, assert }) => {
    const user = await User.create({
      fullName: 'Owner',
      email: 'owner@example.test',
      password: 'TestPassword_42',
    })

    const response = await client
      .post('/api/v1/tasks')
      .withGuard('api')
      .loginAs(user)
      .json({ title: 'Изучить PostgreSQL' })

    response.assertStatus(201)
    response.assertBodyContains({
      data: { title: 'Изучить PostgreSQL', status: 'todo' },
    })

    const task = await Task.findOrFail(response.body().data.id)
    assert.equal(task.userId, user.id)
  })

  test('отклоняет неизвестный статус', async ({ client }) => {
    const user = await User.create({
      fullName: 'Owner',
      email: 'owner@example.test',
      password: 'TestPassword_42',
    })

    const response = await client
      .post('/api/v1/tasks')
      .withGuard('api')
      .loginAs(user)
      .json({ title: 'Задача', status: 'unknown' })

    response.assertStatus(422)
  })

  test('не раскрывает чужую задачу', async ({ client }) => {
    const owner = await User.create({
      fullName: 'Owner',
      email: 'owner@example.test',
      password: 'TestPassword_42',
    })

    const stranger = await User.create({
      fullName: 'Stranger',
      email: 'stranger@example.test',
      password: 'TestPassword_42',
    })

    const task = await Task.create({
      userId: owner.id,
      title: 'Личная задача',
      description: null,
      status: 'todo',
    })

    const response = await client
      .get(`/api/v1/tasks/${task.id}`)
      .withGuard('api')
      .loginAs(stranger)

    response.assertStatus(404)
  })
})
```

Глобальная транзакция откатывается после каждого теста, поэтому одинаковые тестовые email не конфликтуют между сценариями. `loginAs` — вспомогательный механизм тестового клиента; эти тесты проверяют задачи и права пользователя. Выдачу и отзыв настоящего токена следует покрыть отдельными тестами аутентификации.

Запуск:

```bash
node ace codegen
npm run typecheck
node ace test functional
```

Это интеграционные по содержанию HTTP-тесты: запрос проходит через приложение и обращается к настоящей тестовой PostgreSQL. [API-тесты](https://docs.adonisjs.com/guides/testing/api-tests), [управление состоянием между тестами](https://docs.adonisjs.com/guides/testing/resetting-state-between-tests).

## 13. Почему нельзя склеивать SQL из параметров запроса

В нашем контроллере пользовательский статус передаётся в `.where('status', filters.status)`. Query builder формирует SQL с параметром и передаёт значение отдельно. Пользовательский текст становится значением условия, а не частью SQL-синтаксиса.

Аналогично поиск своей задачи концептуально сводится к запросу:

```sql
SELECT *
FROM tasks
WHERE user_id = $1 AND id = $2
LIMIT 1;
```

Значения `$1` и `$2` передаются драйверу отдельно. Валидация обеспечивает допустимый формат, параметризация обеспечивает корректную передачу значений в SQL, а условие по `user_id` обеспечивает ограничение доступа. Это три разные задачи.

Если позже добавите сортировку по полю из запроса, задавайте список разрешённых имён колонок. Имя колонки — часть структуры SQL и не заменяется обычным параметром значения. [Query builder Lucid](https://lucid.adonisjs.com/docs/select-query-builder).

## 14. Типичные проблемы при повторении примера

| Симптом | Что проверить |
|---|---|
| `ECONNREFUSED` при миграции | Контейнер запущен и healthy; `DB_HOST` и порт соответствуют месту запуска приложения |
| `password authentication failed` | Пароль в `.env` соответствует реальной роли PostgreSQL; существующий том не переинициализируется после изменения переменных |
| `relation "tasks" does not exist` | Миграция применена к той базе, которую использует процесс AdonisJS |
| Нет `TaskSchema` | В PostgreSQL-подключении включена `schemaGeneration`; после создания таблицы выполнена миграция |
| Нет `controllers.Tasks` | Контроллер создан; после этого выполнен `node ace codegen` |
| После регистрации получился токен `undefined` | Из ответа выбранного стартера нужно читать `data.token` |
| Защищённый маршрут возвращает 401 | Передан Bearer-токен; токен не отозван; маршрут использует guard `api` |
| Своя задача не найдена | Проверяется действительный `TASK_ID`; токен принадлежит создавшему задачу пользователю |
| На PATCH возвращается 422 | Передано хотя бы одно разрешённое поле; название непустое; статус входит в разрешённый список |

Посмотреть таблицы и записанные задачи можно через `psql`:

```bash
docker compose exec postgres sh -c \
  'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT id, user_id, title, status FROM tasks ORDER BY id;"'
```

Для остановки локальной базы:

```bash
docker compose down
```

Именованный том сохраняет данные после этой команды.

## Что потребуется перед публикацией сервиса

У примера уже есть ограничение доступа по владельцу, валидация и ограничения базы. Для рабочего сервиса дополнительно настройте:

- HTTPS и ограниченный CORS для выбранного frontend.
- Rate limiting регистрации и входа.
- Срок жизни токенов: в стандартном провайдере они не истекают автоматически, если срок не задан.
- Отдельные роли PostgreSQL для приложения и миграций, резервные копии и проверку восстановления.
- Секреты окружения и TLS для удалённого подключения к базе с проверкой сертификата.
- Тесты обновления, удаления, фильтрации и попыток изменения чужих записей.

При росте бизнес-логики операции, затрагивающие несколько таблиц, стоит выносить в прикладные сервисы и объединять транзакциями. Для правил доступа сложнее «пользователь видит свои записи» можно добавить политики Bouncer.

## Источники

- [Установка AdonisJS и требования к Node.js](https://docs.adonisjs.com/installation).
- [Официальный API-стартер в используемом снимке](https://github.com/adonisjs/starter-kits/tree/8fdf4c08bd172f9958a88a16a7139c391eb99fd8/api).
- [Шаблоны initializer: api и api-monorepo](https://github.com/adonisjs/create-adonisjs/blob/3.x/src/templates.ts).
- [Lucid ORM в AdonisJS](https://docs.adonisjs.com/guides/database/lucid).
- [Миграции Lucid](https://lucid.adonisjs.com/docs/migrations) и [генерация схем](https://lucid.adonisjs.com/docs/schema-generation).
- [VineJS: типы и правила](https://vinejs.dev/docs/introduction).
- [Схема таблиц Knex](https://knexjs.org/guide/schema-builder.html).
- [Официальный Docker-образ PostgreSQL](https://github.com/docker-library/docs/blob/master/postgres/README.md).
- [Обзор AdonisJS в этой подборке](./adonisjs-backend-framework-overview.md).
