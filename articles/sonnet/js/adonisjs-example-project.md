# Проект-пример на AdonisJS: трекер задач шаг за шагом

Oct 6, 2026 · @Iang

## Введение

В этой статье мы шаг за шагом создадим на AdonisJS 7 небольшой трекер задач: пользователи регистрируются, входят в систему и управляют только своими задачами. Такой проект достаточно мал, чтобы собрать его за вечер, и при этом затрагивает всё основное: маршруты, контроллеры, базу данных, валидацию, аутентификацию и тесты.

К концу вы получите работающее приложение с REST API для задач (список, создание, просмотр, обновление, удаление) и набор тестов, которые проверяют его поведение. Обзор самого фреймворка и его возможностей есть в отдельной статье «Обзор фреймворка AdonisJS».

## Требования и создание проекта

Для AdonisJS 7 нужны Node.js 24 или новее и npm 11 или новее. Проверьте версии:

```bash
node -v
npm -v
```

Проект создаётся официальным инициализатором. Мы возьмём стартовый набор `api`: он готовит бэкенд на AdonisJS и пустой фронтенд-проект рядом, а регистрация и вход уже работают.

```bash
npm create adonisjs@latest task-tracker -- --kit=api
```

Другие наборы (`hypermedia`, `react`, `vue`) подойдут, если нужен интерфейс на сервере или Inertia; для нашего REST API лучше API-кит. По умолчанию в проект уже включены Lucid ORM с SQLite, готовые маршруты регистрации и входа, а также настроенные ESLint и Prettier.

API-кит устроен как монорепозиторий под управлением Turborepo, поэтому все остальные команды `node ace` выполняйте внутри каталога бэкенда `apps/backend`. Запустить бэкенд и фронтенд вместе можно из корня проекта:

```bash
cd task-tracker
npm run dev
```

Бэкенд отвечает на `http://localhost:3333` и возвращает JSON `{ "hello": "world" }`. Таблица `users` уже существует в базе SQLite, а эндпоинты `POST /api/v1/auth/signup` и `POST /api/v1/auth/login` можно проверить любым HTTP-клиентом.

## Структура проекта

Главное правило: у каждого типа файла своё место, поэтому код легко найти. Внутри `apps/backend` вам понадобятся эти каталоги:

```text
apps/backend
├── app
│   ├── controllers   # контроллеры
│   ├── middleware    # промежуточные обработчики
│   ├── models        # модели Lucid
│   └── validators    # схемы VineJS
├── database
│   ├── migrations    # миграции
│   ├── factories     # фабрики тестовых данных
│   ├── seeders       # сидеры
│   └── schema.ts     # генерируется автоматически, не редактируется
├── start
│   ├── routes.ts     # маршруты
│   └── kernel.ts     # регистрация middleware
└── tmp
    └── db.sqlite     # локальная база данных
```

Обратите внимание на `database/schema.ts`: AdonisJS 7 генерирует его по таблицам базы после каждой миграции, а модели наследуются от сгенерированных классов вроде `TaskSchema`. Колонки в модели описывать не нужно, в ней остаются только связи и бизнес-логика.

Команды `node ace` запускайте из `apps/backend`. Полный список команд покажет `node ace`. Для самого бэкенда доступны два режима: `node ace serve --hmr` обновляет код без перезапуска процесса и рекомендуется для большинства случаев, а `node ace serve --watch` полностью перезапускает сервер при каждом изменении.

## База данных: модель Task и миграция

Создадим модель задачи вместе с миграцией. Флаг `-m` заставляет Ace сгенерировать оба файла сразу:

```bash
node ace make:model Task -m
```

Миграция описывает структуру таблицы. Откройте созданный файл в `database/migrations/` (в имени будет временная метка) и задайте колонки. Внешний ключ на пользователя добавляем сразу, чтобы каждая задача принадлежала владельцу:

```ts
import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'tasks'

  async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.increments('id')
      table.string('title').notNullable()
      table.text('description').nullable()
      table.boolean('is_done').notNullable().defaultTo(false)
      table.integer('user_id').unsigned().notNullable()
      table.foreign('user_id').references('users.id').onDelete('CASCADE')
      table.timestamp('created_at')
      table.timestamp('updated_at')
    })
  }

  async down() {
    this.schema.dropTable(this.tableName)
  }
}
```

Метод `up` создаёт таблицу, `down` откатывает изменение. Выполните миграцию:

```bash
node ace migration:run
```

После запуска AdonisJS обновит `database/schema.ts` и добавит класс `TaskSchema` со всеми колонками. В модели остаётся только связь с пользователем:

```ts
import { TaskSchema } from '#database/schema'
import { belongsTo } from '@adonisjs/lucid/orm'
import type { BelongsTo } from '@adonisjs/lucid/types/relations'
import User from '#models/user'

export default class Task extends TaskSchema {
  @belongsTo(() => User)
  declare user: BelongsTo<typeof User>
}
```

Имена колонок в базе пишутся в `snake_case` (`is_done`), а свойства модели в `camelCase` (`isDone`): Lucid преобразует их автоматически.

## Маршруты и контроллер задач

Генерируем контроллер. По соглашению AdonisJS на каждый ресурс приходится один контроллер:

```bash
node ace make:controller tasks
```

В файле `app/controllers/tasks_controller.ts` реализуем пять действий. Каждое из них работает только с задачами текущего пользователя, поэтому чужую задачу получить невозможно: запрос просто не найдёт строку, и фреймворк вернёт 404.

```ts
import type { HttpContext } from '@adonisjs/core/http'
import Task from '#models/task'

export default class TasksController {
  async index({ auth }: HttpContext) {
    return Task.query().where('userId', auth.user!.id).orderBy('createdAt', 'desc')
  }

  async show({ auth, params }: HttpContext) {
    return Task.query().where('userId', auth.user!.id).where('id', params.id).firstOrFail()
  }

  async store({ auth, request, response }: HttpContext) {
    // валидацию добавим в следующем разделе
    const payload = request.only(['title', 'description'])
    const task = await Task.create({ ...payload, userId: auth.user!.id })
    return response.created(task)
  }

  async update({ auth, params, request }: HttpContext) {
    const task = await Task.query()
      .where('userId', auth.user!.id)
      .where('id', params.id)
      .firstOrFail()
    task.merge(request.only(['title', 'description', 'isDone']))
    await task.save()
    return task
  }

  async destroy({ auth, params, response }: HttpContext) {
    const task = await Task.query()
      .where('userId', auth.user!.id)
      .where('id', params.id)
      .firstOrFail()
    await task.delete()
    return response.noContent()
  }
}
```

Теперь подключим маршруты в `start/routes.ts`. Контроллеры импортируются через автоматически сгенерированный файл `#generated/controllers`, а middleware `auth()` закрывает всю группу от неавторизованных пользователей:

```ts
import router from '@adonisjs/core/services/router'
import { middleware } from '#start/kernel'
import { controllers } from '#generated/controllers'

router
  .group(() => {
    router.get('/tasks', [controllers.Tasks, 'index'])
    router.get('/tasks/:id', [controllers.Tasks, 'show'])
    router.post('/tasks', [controllers.Tasks, 'store'])
    router.put('/tasks/:id', [controllers.Tasks, 'update'])
    router.delete('/tasks/:id', [controllers.Tasks, 'destroy'])
  })
  .prefix('/api/v1')
  .use(middleware.auth())
```

В стартовом наборе в этом файле уже есть маршруты авторизации; добавьте группу рядом с ними и не удаляйте существующие строки. Список зарегистрированных маршрутов можно посмотреть командой `node ace list:routes`.

## Валидация входных данных

Сейчас контроллер доверяет всему, что прислал клиент. Исправим это с помощью VineJS. Создайте файл валидаторов:

```bash
node ace make:validator task
```

В `app/validators/task.ts` опишем две схемы: для создания и для обновления, где все поля необязательны:

```ts
import vine from '@vinejs/vine'

export const createTaskValidator = vine.create({
  title: vine.string().trim().minLength(3).maxLength(255),
  description: vine.string().trim().maxLength(2000).optional(),
})

export const updateTaskValidator = vine.create({
  title: vine.string().trim().minLength(3).maxLength(255).optional(),
  description: vine.string().trim().maxLength(2000).optional(),
  isDone: vine.boolean().optional(),
})
```

Метод `vine.create()` компилирует схему один раз, поэтому проверка работает быстро. Теперь замените в контроллере `request.only(...)` на валидацию:

```ts
import { createTaskValidator, updateTaskValidator } from '#validators/task'

// в методе store
const payload = await request.validateUsing(createTaskValidator)

// в методе update
const payload = await request.validateUsing(updateTaskValidator)
task.merge(payload)
```

Если данные не проходят проверку, запрос завершается ошибкой 422 с описанием проблемных полей, а в базу ничего не попадает. Заодно мы защищаемся от лишних полей: клиент не сможет подставить чужой `userId`, потому что валидатор пропускает только описанные в схеме значения.

## Аутентификация и проверка вручную

Писать авторизацию с нуля не придётся: стартовый набор уже содержит регистрацию и вход, а middleware `auth()` кладёт текущего пользователя в контекст запроса. Именно поэтому в контроллере доступен `auth.user`, а каждая выборка ограничена условием `userId`. Так задачи привязываются к владельцу, и пользователь видит только свои.

Проверим API вручную. Сначала зарегистрируйте пользователя (набор обязательных полей смотрите в валидаторе регистрации вашего проекта; ниже показан типичный вариант):

```bash
curl -X POST http://localhost:3333/api/v1/auth/signup \
  -H 'Content-Type: application/json' \
  -d '{"email":"jane@example.com","password":"secret-pass-123"}'
```

Затем выполните вход через `POST /api/v1/auth/login` с теми же данными. Ответ покажет, как ваш набор выдаёт доступ; если вернулся токен, передавайте его в заголовке `Authorization: Bearer <токен>`. Дальше создайте задачу и запросите список:

```bash
curl -X POST http://localhost:3333/api/v1/tasks \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <токен>' \
  -d '{"title":"Написать статью про AdonisJS"}'

curl http://localhost:3333/api/v1/tasks -H 'Authorization: Bearer <токен>'
```

Чтобы убедиться в изоляции данных, зарегистрируйте второго пользователя и запросите список от его имени: он должен быть пустым. Запрос без авторизации вернёт ошибку доступа, а запрос с коротким названием задачи (меньше трёх символов) завершится ошибкой валидации.

## Тесты и дальнейшие шаги

Тесты в AdonisJS пишутся на Japa, а HTTP-запросы к приложению отправляет встроенный API-клиент. Создайте функциональный тест:

```bash
node ace make:test tasks --suite=functional
```

Начнём с проверки, что неавторизованный запрос не получает данные:

```ts
import { test } from '@japa/runner'

test.group('Tasks API', () => {
  test('требует авторизации', async ({ client }) => {
    const response = await client.get('/api/v1/tasks').header('accept', 'application/json')
    response.assertStatus(401)
  })
})
```

Запуск выполняется командой `node ace test`. Следующий шаг — тесты с пользователем: клиент Japa умеет выполнять запросы от имени вошедшего пользователя через `loginAs()`, а нужных пользователей удобно создавать фабриками. Проверьте в тестах три сценария: создание задачи, отказ по короткому названию и невозможность прочитать чужую задачу.

Куда развивать проект дальше:

- добавить пагинацию списка и фильтр по статусу `isDone`;
- вынести форму ответа в трансформеры, которые AdonisJS 7 использует для типизированных данных;
- наполнить базу тестовыми данными через фабрики и сидеры;
- подключить фронтенд из каталога API-кита, воспользовавшись сгенерированным типизированным клиентом;
- перейти с SQLite на PostgreSQL перед развёртыванием.

## Источники

- [Installation (документация AdonisJS)](https://docs.adonisjs.com/installation)
- [Database and models (учебник AdonisJS)](https://docs.adonisjs.com/tutorial/hypermedia/database-and-models)
- [Forms and validation (учебник AdonisJS)](https://docs.adonisjs.com/tutorial/hypermedia/forms-and-validation)
- [Releases (документация AdonisJS)](https://docs.adonisjs.com/releases)

Команды установки, миграций и валидации сверены с документацией на момент написания; код контроллера, тестов и примеры запросов составлены по аналогии с официальным учебником, поэтому перед использованием проверьте их на вашей версии стартового набора.
