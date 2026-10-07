# AdonisJS 7 + PostgreSQL: создание API с нуля

## Введение

В этой статье мы создадим на AdonisJS 7 API книжной полки с хранением данных в PostgreSQL: авторы, книги, связь между ними, валидация и тестовые данные. В отличие от предыдущего примера, где использовалась встроенная SQLite, здесь база работает как отдельный сервер, то есть так, как это бывает в реальной разработке.

К концу у вас будет работающий REST API с двумя ресурсами, миграциями и сидерами, а также понимание, как подключить PostgreSQL к любому проекту на Adonis. Нужны Node.js 24 и Docker (или уже установленный PostgreSQL).

## Запуск PostgreSQL и создание базы

Проще всего поднять PostgreSQL в контейнере. Переменные `POSTGRES_USER`, `POSTGRES_PASSWORD` и `POSTGRES_DB` заставят образ сразу создать пользователя и пустую базу:

```bash
docker run --name books-db \
  -e POSTGRES_USER=books \
  -e POSTGRES_PASSWORD=books \
  -e POSTGRES_DB=books \
  -p 5432:5432 \
  -v books-data:/var/lib/postgresql/data \
  -d postgres:17
```

Том `books-data` сохраняет данные между перезапусками контейнера. Убедитесь, что база отвечает:

```bash
docker exec -it books-db psql -U books -d books -c 'select version();'
```

Пароль `books` годится только для локальной разработки. Для любого общего окружения задайте другой и не храните его в репозитории.

Если PostgreSQL уже установлен на машине, создайте базу вручную: `createdb books`, затем пользователя с паролем через `psql`. Дальнейшие шаги от способа установки не зависят.

## Создание проекта и подключение к PostgreSQL

Создаём проект из API-кита. Ему нужны Node.js 24+ и npm 11+. По умолчанию кит настроен на SQLite, поэтому следующим шагом переключим Lucid на PostgreSQL.

```bash
npm create adonisjs@latest books-api -- --kit=api
cd books-api/apps/backend
```

Кит устроен как монорепозиторий, и бэкенд лежит в `apps/backend`: все команды `node ace` ниже выполняйте оттуда. Переключите драйвер командой configure с флагом `--db`:

```bash
node ace configure @adonisjs/lucid --db=postgres
```

Согласно документации Lucid, эта команда создаёт `config/database.ts` для выбранного драйвера, добавляет переменные окружения с валидацией и устанавливает драйвер `pg`. Если команда спросит о замене существующих файлов, подтвердите. Если драйвер не установился, поставьте его вручную: `npm install pg`.

После настройки `config/database.ts` должен выглядеть так:

```ts
import env from '#start/env'
import { defineConfig } from '@adonisjs/lucid'

const dbConfig = defineConfig({
  connection: 'postgres',
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
    },
  },
})

export default dbConfig
```

Значения подключения хранятся в `.env`. Подставьте данные контейнера из предыдущего раздела:

```dotenv
DB_HOST=127.0.0.1
DB_PORT=5432
DB_USER=books
DB_PASSWORD=books
DB_DATABASE=books
```

Когда провайдер выдаёт один адрес вида `postgres://user:password@host:5432/db`, можно вместо пяти переменных использовать строку подключения: передайте `env.get('DATABASE_URL')` прямо в поле `connection`.

Проверить соединение проще всего первой миграцией. Если стартовый набор уже содержит миграции пользователей, команда создаст эти таблицы в PostgreSQL:

```bash
node ace migration:run
```

## Миграции и модели

У нас две сущности: автор и книга. Создайте их по очереди, чтобы миграция авторов получила более раннюю временную метку и выполнилась первой. Флаг `-m` создаёт модель вместе с миграцией:

```bash
node ace make:model Author -m
node ace make:model Book -m
```

В миграции авторов (`database/migrations/..._create_authors_table.ts`) опишем колонки:

```ts
import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'authors'

  async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.increments('id')
      table.string('name').notNullable()
      table.text('bio').nullable()
      table.timestamp('created_at')
      table.timestamp('updated_at')
    })
  }

  async down() {
    this.schema.dropTable(this.tableName)
  }
}
```

В миграции книг добавим внешний ключ на автора. При удалении автора его книги удалятся каскадно, а уникальный ISBN не даст создать дубликат:

```ts
import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'books'

  async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.increments('id')
      table.string('title').notNullable()
      table.string('isbn').nullable().unique()
      table.integer('published_year').nullable()
      table.integer('author_id').unsigned().notNullable()
      table.foreign('author_id').references('authors.id').onDelete('CASCADE')
      table.timestamp('created_at')
      table.timestamp('updated_at')
    })
  }

  async down() {
    this.schema.dropTable(this.tableName)
  }
}
```

Запустите миграции. Lucid применит их в PostgreSQL и после этого обновит `database/schema.ts` классами для новых таблиц:

```bash
node ace migration:run
```

Модели описывают только связи: колонки они наследуют от сгенерированных классов. Имя базового класса (`AuthorSchema`, `AuthorsSchema` и т. п.) зависит от версии генератора, поэтому оставьте тот импорт, который создал `make:model`, и добавьте связи:

```ts
// app/models/author.ts
import { AuthorSchema } from '#database/schema'
import { hasMany } from '@adonisjs/lucid/orm'
import type { HasMany } from '@adonisjs/lucid/types/relations'
import Book from '#models/book'

export default class Author extends AuthorSchema {
  @hasMany(() => Book)
  declare books: HasMany<typeof Book>
}
```

```ts
// app/models/book.ts
import { BookSchema } from '#database/schema'
import { belongsTo } from '@adonisjs/lucid/orm'
import type { BelongsTo } from '@adonisjs/lucid/types/relations'
import Author from '#models/author'

export default class Book extends BookSchema {
  @belongsTo(() => Author)
  declare author: BelongsTo<typeof Author>
}
```

## Валидаторы, контроллеры и маршруты

Создайте два валидатора и два контроллера:

```bash
node ace make:validator author
node ace make:validator book
node ace make:controller authors
node ace make:controller books
```

Валидаторы описывают, какие данные принимает API. Внешний ключ проверять будем в контроллере, поэтому здесь достаточно числа:

```ts
// app/validators/author.ts
import vine from '@vinejs/vine'

export const createAuthorValidator = vine.create({
  name: vine.string().trim().minLength(2).maxLength(255),
  bio: vine.string().trim().maxLength(2000).optional(),
})
```

```ts
// app/validators/book.ts
import vine from '@vinejs/vine'

export const createBookValidator = vine.create({
  title: vine.string().trim().minLength(1).maxLength(255),
  isbn: vine.string().trim().maxLength(20).optional(),
  publishedYear: vine.number().withoutDecimals().min(1450).optional(),
  authorId: vine.number().withoutDecimals().positive(),
})
```

Контроллер авторов возвращает список, одного автора вместе с его книгами и создаёт нового:

```ts
// app/controllers/authors_controller.ts
import type { HttpContext } from '@adonisjs/core/http'
import Author from '#models/author'
import { createAuthorValidator } from '#validators/author'

export default class AuthorsController {
  async index() {
    return Author.query().orderBy('name')
  }

  async show({ params }: HttpContext) {
    return Author.query().where('id', params.id).preload('books').firstOrFail()
  }

  async store({ request, response }: HttpContext) {
    const payload = await request.validateUsing(createAuthorValidator)
    return response.created(await Author.create(payload))
  }
}
```

В контроллере книг список постраничный, а автора перед созданием книги мы ищем явно: если его нет, `findOrFail` вернёт 404 вместо ошибки внешнего ключа от PostgreSQL:

```ts
// app/controllers/books_controller.ts
import type { HttpContext } from '@adonisjs/core/http'
import Author from '#models/author'
import Book from '#models/book'
import { createBookValidator } from '#validators/book'

export default class BooksController {
  async index({ request }: HttpContext) {
    const page = request.input('page', 1)
    return Book.query().preload('author').orderBy('title').paginate(page, 10)
  }

  async store({ request, response }: HttpContext) {
    const payload = await request.validateUsing(createBookValidator)
    await Author.findOrFail(payload.authorId)
    return response.created(await Book.create(payload))
  }

  async destroy({ params, response }: HttpContext) {
    const book = await Book.findOrFail(params.id)
    await book.delete()
    return response.noContent()
  }
}
```

Осталось зарегистрировать маршруты в `start/routes.ts`. Добавьте группу рядом с уже существующими маршрутами кита:

```ts
import router from '@adonisjs/core/services/router'
import { controllers } from '#generated/controllers'

router
  .group(() => {
    router.get('/authors', [controllers.Authors, 'index'])
    router.get('/authors/:id', [controllers.Authors, 'show'])
    router.post('/authors', [controllers.Authors, 'store'])

    router.get('/books', [controllers.Books, 'index'])
    router.post('/books', [controllers.Books, 'store'])
    router.delete('/books/:id', [controllers.Books, 'destroy'])
  })
  .prefix('/api/v1')
```

Эти маршруты открыты для всех. Чтобы закрыть запись, оберните нужные маршруты в `.use(middleware.auth())`, как в предыдущей статье.

## Тестовые данные и проверка API

Сидер заполнит базу авторами и книгами, чтобы было что запрашивать:

```bash
node ace make:seeder MainSeeder
```

```ts
// database/seeders/main_seeder.ts
import { BaseSeeder } from '@adonisjs/lucid/seeders'
import Author from '#models/author'

export default class extends BaseSeeder {
  async run() {
    const bradbury = await Author.create({ name: 'Рэй Брэдбери' })
    await bradbury.related('books').createMany([
      { title: '451 градус по Фаренгейту', isbn: '9780000000001', publishedYear: 1953 },
      { title: 'Марсианские хроники', isbn: '9780000000002', publishedYear: 1950 },
    ])

    const lem = await Author.create({ name: 'Станислав Лем' })
    await lem.related('books').create({ title: 'Солярис', isbn: '9780000000003', publishedYear: 1961 })
  }
}
```

Запустите сидеры и сервер:

```bash
node ace db:seed
node ace serve --hmr
```

Сидер не проверяет, есть ли данные, поэтому повторный запуск упрётся в уникальный ISBN. Для чистого перезаполнения в разработке используйте `node ace migration:fresh --seed`: команда удаляет все таблицы и создаёт их заново, так что на реальных данных её применять нельзя.

Теперь проверьте API запросами:

```bash
# список книг с авторами, по 10 на страницу
curl http://localhost:3333/api/v1/books

# автор вместе с книгами
curl http://localhost:3333/api/v1/authors/1

# новая книга
curl -X POST http://localhost:3333/api/v1/books \
  -H 'Content-Type: application/json' \
  -d '{"title":"Вино из одуванчиков","authorId":1,"publishedYear":1957}'

# несуществующий автор: ожидаем 404
curl -i -X POST http://localhost:3333/api/v1/books \
  -H 'Content-Type: application/json' \
  -d '{"title":"Тест","authorId":999}'

# пустое название: ожидаем 422 с описанием ошибки
curl -i -X POST http://localhost:3333/api/v1/books \
  -H 'Content-Type: application/json' \
  -d '{"title":"","authorId":1}'
```

Убедиться, что данные действительно лежат в PostgreSQL, можно напрямую:

```bash
docker exec -it books-db psql -U books -d books -c 'select id, title, author_id from books;'
```

## Дальнейшие шаги

- Закрыть запись авторизацией через `middleware.auth()`, оставив чтение открытым.
- Добавить обновление книг и авторов отдельным валидатором, где все поля необязательны.
- Вынести ответы в трансформеры, чтобы контролировать, какие поля уходят клиенту.
- Для продакшена перейти на строку подключения `DATABASE_URL`, включить `ssl` и настроить размер пула соединений.
- Описать окружение в `docker-compose.yml`, чтобы поднимать PostgreSQL одной командой.

## Источники

- [Lucid: Installation and usage](https://lucid.adonisjs.com/docs/installation)
- [Lucid: Configuration](https://lucid.adonisjs.com/docs/configuration)
- [AdonisJS: Installation](https://docs.adonisjs.com/installation)
- [AdonisJS: Database and models (учебник)](https://docs.adonisjs.com/tutorial/hypermedia/database-and-models)

Конфигурация PostgreSQL, миграции и связи сверены с документацией на 7 октября 2026 года. Код контроллеров, валидаторов и сидера составлен по аналогии с официальными примерами и не запускался, поэтому проверьте его на своей версии стартового набора.
