## Использование LIKE в условии

Вам нужно установить четвертый операнд равным false, чтобы использовать пользовательские условия where like:

```php
Table::find()->where(['like', 'name', $_GET['q'] . '%', false]);
```

## FAQ

### Опиши по шагам (с описанием кода) как создать REST API для книгохранилища в yii2

Вот пошаговое описание создания REST API для книгохранилища в Yii2:

1. Создайте новый проект Yii2 или используйте существующий. Для этого выполните команду в терминале:

```bash
composer create-project --prefer-dist yiisoft/yii2-app-basic book-api
```

2. Настройте подключение к базе данных в файле `config/db.php`.

3. Создайте таблицу `book` в базе данных для хранения информации о книгах. Например, таблица может иметь следующую структуру:

```sql
CREATE TABLE `book` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

4. Создайте модель `Book` для работы с таблицей `book`. Создайте файл `models/Book.php`:

```php
<?php

namespace app\models;

use yii\db\ActiveRecord;

class Book extends ActiveRecord
{
    public static function tableName()
    {
        return 'book';
    }

    public function rules()
    {
        return [
            [['title', 'author'], 'required'],
            [['description'], 'string'],
            [['title', 'author'], 'string', 'max' => 255],
        ];
    }
}
```

5. Создайте контроллер `BookController` для обработки REST-запросов. Создайте файл `controllers/BookController.php`:

```php
<?php

namespace app\controllers;

use yii\rest\ActiveController;

class BookController extends ActiveController
{
    public $modelClass = 'app\models\Book';
}
```

6. Настройте URL-правила для REST API в файле `config/web.php`:

```php
'urlManager' => [
    'enablePrettyUrl' => true,
    'showScriptName' => false,
    'rules' => [
        ['class' => 'yii\rest\UrlRule', 'controller' => 'book'],
    ],
],
```

7. Протестируйте REST API, используя инструменты, такие как Postman или cURL. Вы можете выполнять следующие запросы:

- GET `/books`: Получить список всех книг.
- GET `/books/{id}`: Получить информацию о книге по её ID.
- POST `/books`: Создать новую книгу (передайте данные книги в формате JSON в теле запроса).
- PUT `/books/{id}`: Обновить информацию о книге по её ID (передайте обновленные данные книги в формате JSON в теле запроса).
- DELETE `/books/{id}`: Удалить книгу по её ID.

Это базовый пример создания REST API для книгохранилища в Yii2. Вы можете дополнительно настроить контроллер, добавить авторизацию, валидацию и другие функции в соответствии с вашими требованиями.

### Опиши чем является и зачем нужен ActiveController

`ActiveController` в Yii2 - это специальный класс контроллера, который предоставляет набор готовых действий (actions) для реализации типичных операций CRUD (Create, Read, Update, Delete) над моделями Active Record.

Основные возможности и назначение `ActiveController`:

1. **Автоматическая генерация действий CRUD**: `ActiveController` автоматически предоставляет действия `index`, `view`, `create`, `update` и `delete` для работы с моделями. Это избавляет от необходимости вручную создавать эти действия для каждой модели.

2. **Работа с Active Record**: `ActiveController` тесно связан с моделями Active Record. Он автоматически определяет модель, связанную с контроллером, на основе имени контроллера. Например, контроллер `PostController` будет работать с моделью `Post`.

3. **Сериализация данных**: `ActiveController` автоматически сериализует данные модели в формат, подходящий для ответа API (например, JSON). Это упрощает создание RESTful API без необходимости вручную преобразовывать данные.

4. **Проверка доступа**: `ActiveController` предоставляет возможность настройки проверки доступа к действиям с помощью поведений (behaviors) и фильтров (filters). Можно легко ограничить доступ к определенным действиям на основе ролей или прав доступа пользователей.

5. **Настройка форматирования данных**: `ActiveController` позволяет настраивать способ форматирования и преобразования данных перед сериализацией. Можно указать, какие атрибуты модели должны быть включены в ответ API, применить дополнительные преобразования данных и т.д.

Зачем нужен `ActiveController`:

- **Быстрая разработка API**: `ActiveController` значительно ускоряет процесс создания RESTful API для работы с моделями. Вместо того, чтобы вручную создавать действия CRUD для каждой модели, можно просто унаследовать контроллер от `ActiveController` и настроить его по необходимости.

- **Стандартизация API**: `ActiveController` обеспечивает единообразие и согласованность в структуре и поведении API. Все контроллеры, унаследованные от `ActiveController`, будут иметь схожий набор действий и способ взаимодействия с моделями.

- **Сокращение повторяющегося кода**: Использование `ActiveController` позволяет избежать повторения однотипного кода для реализации CRUD-операций. Это делает код более чистым, читаемым и легко поддерживаемым.

### Опиши по шагам процесс миграции бд на разных примерах в yii2

Процесс миграции базы данных в Yii2 состоит из следующих шагов:

1. **Настройка подключения к базе данных:**
   - Откройте файл `config/db.php` и укажите параметры подключения к вашей базе данных.
   ```php
   return [
       'class' => 'yii\db\Connection',
       'dsn' => 'mysql:host=localhost;dbname=your_database_name',
       'username' => 'your_username',
       'password' => 'your_password',
       'charset' => 'utf8',
   ];
   ```

2. **Создание миграции:**
   - Выполните команду в терминале для создания новой миграции:
   ```
   php yii migrate/create create_users_table
   ```
   - Эта команда создаст новый файл миграции в директории `migrations` с названием, содержащим текущую дату и время, и суффиксом `create_users_table`.

3. **Определение структуры таблицы:**
   - Откройте созданный файл миграции и определите структуру таблицы в методе `up()`.
   ```php
   public function up()
   {
       $this->createTable('users', [
           'id' => $this->primaryKey(),
           'username' => $this->string()->notNull(),
           'email' => $this->string()->notNull()->unique(),
           'password_hash' => $this->string()->notNull(),
           'created_at' => $this->integer()->notNull(),
           'updated_at' => $this->integer()->notNull(),
       ]);
   }
   ```

4. **Откат миграции:**
   - Определите метод `down()` для отката миграции, если необходимо.
   ```php
   public function down()
   {
       $this->dropTable('users');
   }
   ```

5. **Применение миграции:**
   - Выполните команду в терминале для применения миграции:
   ```
   php yii migrate
   ```
   - Эта команда применит все новые миграции, которые еще не были выполнены.

Пример миграции для создания таблицы `posts`:
```php
public function up()
{
    $this->createTable('posts', [
        'id' => $this->primaryKey(),
        'title' => $this->string()->notNull(),
        'content' => $this->text(),
        'created_at' => $this->integer()->notNull(),
        'updated_at' => $this->integer()->notNull(),
    ]);
}

public function down()
{
    $this->dropTable('posts');
}
```

Пример миграции для добавления нового столбца в таблицу `users`:
```php
public function up()
{
    $this->addColumn('users', 'status', $this->smallInteger()->notNull()->defaultValue(0));
}

public function down()
{
    $this->dropColumn('users', 'status');
}
```

Пример миграции для создания внешнего ключа между таблицами `posts` и `users`:
```php
public function up()
{
    $this->addColumn('posts', 'user_id', $this->integer()->notNull());
    $this->addForeignKey('fk-posts-user_id', 'posts', 'user_id', 'users', 'id', 'CASCADE');
}

public function down()
{
    $this->dropForeignKey('fk-posts-user_id', 'posts');
    $this->dropColumn('posts', 'user_id');
}
```

Это лишь несколько примеров миграций в Yii2. Миграции могут выполнять различные операции с базой данных, такие как создание и удаление таблиц, добавление и удаление столбцов, создание индексов и внешних ключей, а также изменение существующих таблиц и данных.

### Опиши миграции бд для разных типов данных (нужено описание в одном примере кода)

Вот пример миграции базы данных в Yii2 для разных типов данных:

```php
<?php

use yii\db\Migration;

class m230521_100000_create_example_table extends Migration
{
    public function safeUp()
    {
        $this->createTable('example', [
            'id' => $this->primaryKey(),
            'string_column' => $this->string(255)->notNull(),
            'text_column' => $this->text(),
            'integer_column' => $this->integer(),
            'float_column' => $this->float(),
            'decimal_column' => $this->decimal(10, 2),
            'boolean_column' => $this->boolean(),
            'date_column' => $this->date(),
            'time_column' => $this->time(),
            'datetime_column' => $this->datetime(),
            'timestamp_column' => $this->timestamp(),
            'binary_column' => $this->binary(),
            'json_column' => $this->json(),
            'created_at' => $this->timestamp()->defaultExpression('CURRENT_TIMESTAMP'),
            'updated_at' => $this->timestamp()->defaultExpression('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'),
        ]);

        $this->createIndex('idx_example_string_column', 'example', 'string_column');
    }

    public function safeDown()
    {
        $this->dropTable('example');
    }
}
```

В этом примере создается таблица `example` со следующими столбцами:

- `id` - первичный ключ таблицы
- `string_column` - строковый столбец с максимальной длиной 255 символов, помеченный как обязательный (NOT NULL)
- `text_column` - текстовый столбец для хранения больших объемов текста
- `integer_column` - целочисленный столбец
- `float_column` - столбец с плавающей точкой
- `decimal_column` - десятичный столбец с точностью 10 и масштабом 2
- `boolean_column` - логический столбец (true/false)
- `date_column` - столбец для хранения даты
- `time_column` - столбец для хранения времени
- `datetime_column` - столбец для хранения даты и времени
- `timestamp_column` - столбец для хранения временной метки
- `binary_column` - бинарный столбец для хранения двоичных данных
- `json_column` - столбец для хранения данных в формате JSON
- `created_at` - столбец для хранения временной метки создания записи
- `updated_at` - столбец для хранения временной метки обновления записи

Также создается индекс `idx_example_string_column` на столбец `string_column` для оптимизации поиска по этому столбцу.

Метод `safeDown()` описывает операцию отката миграции, которая удаляет созданную таблицу `example`.

