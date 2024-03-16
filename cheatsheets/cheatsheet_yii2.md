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

### Распиши по шагам пример создания компонента в yii2

Вот пример создания компонента в Yii2 по шагам:

1. Создайте новый класс компонента в директории `components/` вашего приложения. Например, создадим компонент `MyComponent`:

```php
<?php

namespace app\components;

use yii\base\Component;

class MyComponent extends Component
{
    public $someProperty = 'default value';

    public function someMethod($param)
    {
        // ...
    }
}
```

2. Объявите свойства и методы компонента в классе. В данном примере мы объявили свойство `$someProperty` и метод `someMethod()`.

3. Сконфигурируйте компонент в конфигурационном файле приложения `config/web.php` или `config/main.php`:

```php
'components' => [
    // ...
    'myComponent' => [
        'class' => 'app\components\MyComponent',
        'someProperty' => 'custom value',
    ],
],
```

4. Теперь вы можете получить доступ к компоненту из любой части вашего приложения, используя выражение `Yii::$app->myComponent`. Например:

```php
echo Yii::$app->myComponent->someProperty;
Yii::$app->myComponent->someMethod('some value');
```

5. При необходимости вы можете переопределить методы `init()` и `__construct()` в классе компонента для выполнения дополнительной инициализации:

```php
public function init()
{
    parent::init();
    // Дополнительная инициализация
}

public function __construct($config = [])
{
    // ...
    parent::__construct($config);
}
```

6. Если ваш компонент должен реагировать на события, вы можете объявить методы-обработчики событий:

```php
public function beforeAction($event)
{
    // ...
}
```

7. При необходимости вы также можете создать виджеты, поведения (behaviors) или другие артефакты, связанные с вашим компонентом, в соответствующих директориях.

Это основные шаги для создания простого компонента в Yii2. Компоненты могут быть более сложными и включать дополнительную функциональность в зависимости от ваших потребностей.

### Распиши по шагам пример создания виджета в yii2

Вот пример создания виджета в Yii2 по шагам:

1. Создайте новую директорию для вашего виджета в папке `widgets`, например, `widgets/MyWidget`.

2. В директории `widgets/MyWidget` создайте файл `MyWidget.php` со следующим содержимым:

```php
<?php

namespace app\widgets\MyWidget;

use yii\base\Widget;

class MyWidget extends Widget
{
    public $message;

    public function init()
    {
        parent::init();
        if ($this->message === null) {
            $this->message = 'Hello World';
        }
    }

    public function run()
    {
        return "<div>" . $this->message . "</div>";
    }
}
```

3. Теперь вы можете использовать ваш виджет в представлениях. Например, в файле `views/site/index.php`:

```php
<?php
use app\widgets\MyWidget\MyWidget;
?>

<?= MyWidget::widget(['message' => 'Hello']); ?>
```

4. Если вы хотите использовать отдельный файл представления для вашего виджета, создайте файл `views/myWidget.php` в директории `widgets/MyWidget`:

```php
<div>
    <?= $message ?>
</div>
```

5. Измените метод `run()` в файле `MyWidget.php`:

```php
public function run()
{
    return $this->render('myWidget', ['message' => $this->message]);
}
```

6. Теперь ваш виджет будет использовать отдельный файл представления.

### Что из себя представляют и зачем нужны компоненты в yii2?

Компоненты в Yii2 представляют собой объекты, которые предоставляют определенную функциональность и могут быть использованы в различных частях приложения. Они играют важную роль в архитектуре фреймворка и служат для организации и повторного использования кода.

Основные причины использования компонентов в Yii2:

1. **Инкапсуляция функциональности**: Компоненты позволяют инкапсулировать связанную функциональность в отдельные объекты, что улучшает читаемость, понимание и поддержку кода.

2. **Повторное использование кода**: Компоненты могут быть использованы в различных частях приложения, что позволяет избежать дублирования кода и упрощает его поддержку.

3. **Конфигурация**: Компоненты могут быть сконфигурированы через свойства, что позволяет легко настраивать их поведение без изменения самого кода компонента.

4. **Расширяемость**: Компоненты могут быть расширены или переопределены в дочерних классах, что позволяет изменять или дополнять их функциональность.

5. **Dependency Injection**: Компоненты могут быть внедрены в другие объекты через механизм внедрения зависимостей (Dependency Injection), что упрощает управление зависимостями и тестирование кода.

Примеры компонентов в Yii2:

- `db` - компонент для работы с базой данных.
- `request` - компонент для получения информации о текущем запросе.
- `response` - компонент для формирования ответа на запрос.
- `user` - компонент для работы с пользователями и аутентификацией.
- `cache` - компонент для кэширования данных.
- `mailer` - компонент для отправки email-сообщений.

Компоненты в Yii2 могут быть как встроенными (предоставляемыми самим фреймворком), так и пользовательскими (создаваемыми разработчиком для конкретных нужд приложения).

Таким образом, компоненты в Yii2 являются важной частью архитектуры фреймворка, позволяющей организовывать и повторно использовать код, упрощать конфигурацию и расширять функциональность приложения.

### Напиши список встроенных компонентов в yii2 и их назначение

1. **Application (app)**: Представляет само приложение и является центральным местом для конфигурации и управления компонентами приложения.

2. **Request (request)**: Предоставляет информацию о запросе пользователя, такую как параметры запроса, HTTP-заголовки, cookies и т.д.

3. **Response (response)**: Представляет ответ, который будет отправлен пользователю. Позволяет настраивать заголовки ответа, статус ответа и содержимое.

4. **Session (session)**: Управляет сессиями пользователя, позволяя сохранять и извлекать данные, специфичные для каждого пользователя.

5. **User (user)**: Представляет информацию о текущем пользователе и реализует функциональность аутентификации и авторизации.

6. **UrlManager (urlManager)**: Отвечает за разбор и создание URL-адресов в приложении, реализуя маршрутизацию URL.

7. **View (view)**: Управляет отображением представлений и шаблонов, позволяя разделять логику контроллеров и представлений.

8. **Formatter (formatter)**: Предоставляет методы для форматирования данных, таких как даты, числа и валюты, в соответствии с локализацией.

9. **AssetManager (assetManager)**: Управляет ресурсами (asset), такими как CSS, JavaScript и изображения, и их публикацией.

10. **DbConnection (db)**: Представляет соединение с базой данных и обеспечивает методы для выполнения запросов к базе данных.

11. **Log (log)**: Предоставляет функциональность ведения журналов (логирования) для отладки и мониторинга приложения.

12. **Cache (cache)**: Реализует кэширование данных для повышения производительности приложения.

13. **I18N (i18n)**: Предоставляет поддержку интернационализации (I18N) и локализации (L10N) для многоязычных приложений.

14. **ErrorHandler (errorHandler)**: Обрабатывает исключения и ошибки, возникающие в приложении, и отображает соответствующие страницы ошибок.

15. **Mailer (mailer)**: Обеспечивает функциональность отправки электронной почты.

