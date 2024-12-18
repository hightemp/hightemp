## Способы отправки HTTP запросов в Go

### 1. Стандартная библиотека `net/http`

#### 1.1 Простой GET запрос
```go
resp, err := http.Get("https://api.example.com/data")
if err != nil {
    log.Fatal(err)
}
defer resp.Body.Close()
```

#### 1.2 Использование http.Client
```go
client := &http.Client{}
req, err := http.NewRequest("GET", "https://api.example.com/data", nil)
resp, err := client.Do(req)
```

#### 1.3 POST запрос с данными
```go
data := strings.NewReader(`{"name": "John"}`)
resp, err := http.Post("https://api.example.com/data", "application/json", data)
```

#### 1.4 Кастомный клиент с таймаутом
```go
client := &http.Client{
    Timeout: time.Second * 10,
}
```

### 2. Популярные HTTP клиенты

#### 2.1 [go-resty](https://github.com/go-resty/resty)
```go
// GET
resp, err := resty.New().R().Get("https://api.example.com")

// POST
resp, err := resty.New().R().
    SetBody(map[string]interface{}{"name": "John"}).
    Post("https://api.example.com")
```

#### 2.2 [fasthttp](https://github.com/valyala/fasthttp)
```go
req := fasthttp.AcquireRequest()
resp := fasthttp.AcquireResponse()
defer fasthttp.ReleaseRequest(req)
defer fasthttp.ReleaseResponse(resp)

req.SetRequestURI("https://api.example.com")
err := fasthttp.Do(req, resp)
```

#### 2.3 [heimdall](https://github.com/gojek/heimdall)
```go
timeout := 1000 * time.Millisecond
client := heimdall.NewHTTPClient(timeout)
res, err := client.Get("https://api.example.com", nil)
```

## Напиши на net/http пример http сервера

```golang
package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"
)

// User структура для примера
type User struct {
	ID       int    `json:"id"`
	Username string `json:"username"`
	Email    string `json:"email"`
}

// Middleware для логирования
func loggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		next.ServeHTTP(w, r)
		log.Printf(
			"%s %s %s %v",
			r.Method,
			r.RequestURI,
			r.RemoteAddr,
			time.Since(start),
		)
	})
}

// Обработчик для GET /users
func getUsersHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	users := []User{
		{ID: 1, Username: "john_doe", Email: "john@example.com"},
		{ID: 2, Username: "jane_doe", Email: "jane@example.com"},
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(users)
}

// Обработчик для POST /user
func createUserHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var user User
	if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Здесь могла бы быть логика сохранения в БД
	
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(user)
}

// Обработчик здоровья сервера
func healthCheckHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(w, `{"status": "ok", "timestamp": "%s"}`, time.Now().Format(time.RFC3339))
}

func main() {
	// Создаем новый mux (маршрутизатор)
	mux := http.NewServeMux()

	// Регистрируем обработчики
	mux.HandleFunc("/users", getUsersHandler)
	mux.HandleFunc("/user", createUserHandler)
	mux.HandleFunc("/health", healthCheckHandler)

	// Создаем сервер
	server := &http.Server{
		Addr:         ":8080",
		Handler:      loggingMiddleware(mux),
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 10 * time.Second,
		IdleTimeout:  15 * time.Second,
	}

	// Запускаем сервер
	log.Printf("Starting server on :8080")
	if err := server.ListenAndServe(); err != nil {
		log.Fatal(err)
	}
}
```

## Напиши пример кода где на fasthttp и golang делается запрос проверки прокси

```golang
package main

import (
	"fmt"
	"time"

	"github.com/valyala/fasthttp"
)

func main() {
	// Прокси адрес
	proxyURL := "http://proxy_ip:proxy_port"
	
	// URL для проверки 
	testURL := "https://api.ipify.org?format=json"

	// Создаем клиент с настройками
	client := &fasthttp.Client{
		// Максимальное время ожидания ответа
		ReadTimeout: 5 * time.Second,
		WriteTimeout: 5 * time.Second,
		MaxIdleConnDuration: 5 * time.Second,
		
		// Устанавливаем прокси
		Dial: fasthttp.CreateDialer(proxyURL),
	}

	// Создаем запрос
	req := fasthttp.AcquireRequest()
	defer fasthttp.ReleaseRequest(req)

	req.SetRequestURI(testURL)
	req.Header.SetMethod("GET")

	// Создаем объект для ответа
	resp := fasthttp.AcquireResponse()
	defer fasthttp.ReleaseResponse(resp)

	// Делаем запрос
	err := client.Do(req, resp)
	if err != nil {
		fmt.Printf("Error: %s\n", err)
		return
	}

	// Получаем статус код
	statusCode := resp.StatusCode()

	// Получаем тело ответа
	body := resp.Body()

	fmt.Printf("Status code: %d\n", statusCode)
	fmt.Printf("Response body: %s\n", body)

	if statusCode == 200 {
		fmt.Println("Proxy is working!")
	} else {
		fmt.Println("Proxy is not working!")
	}
}
```

## Напиши список всех спецификаторов в golang

| Спецификатор | Описание |
|---------------|-----------------------------------------|
| `%v` | Значение в стандартном формате |
| `%+v` | Значение в стандартном формате с полем структуры |
| `%#v` | Значение в синтаксисе Go |
| `%T` | Тип значения |
| `%%` | Литеральный символ `%` |
| `%b` | База 2 (двоичное представление) |
| `%c` | Символ Unicode |
| `%d` | База 10 (десятичное представление) |
| `%o` | База 8 (восьмеричное представление) |
| `%x` | База 16 (шестнадцатеричное представление) с буквами `a-f` |
| `%X` | База 16 (шестнадцатеричное представление) с буквами `A-F` |
| `%U` | Unicode-кодоввая точка |
| `%f` | Десятичное представление с плавающей точкой |
| `%e` | Научное представление с плавающей точкой |
| `%E` | Научное представление с плавающей точкой |
| `%s` | Строковое представление |
| `%q` | Quoted string escaping |
| `%p` | Базовое шестнадцатеричное представление указателя памяти |
| `%t` | Значение типа `bool` (`true` или `false`) |

## чем RWMutex отличается от Mutex

1. **Типы блокировок**:
   - `Mutex` предоставляет только один тип блокировки.
   - `RWMutex` поддерживает два типа блокировок:
     * Блокировка для чтения (Read Lock)
     * Блокировка для записи (Write Lock)

2. **Параллельное чтение**:
   - `Mutex` позволяет только одной горутине получить доступ к ресурсу.
   - `RWMutex` позволяет нескольким горутинам одновременно читать данные, если нет активной блокировки для записи.

3. **Приоритет операций**:
   - `Mutex` не различает операции чтения и записи.
   - `RWMutex` отдает приоритет операциям записи над чтением.

4. **Методы блокировки**:
   - `Mutex` имеет методы `Lock()` и `Unlock()`.
   - `RWMutex` имеет дополнительные методы:
     * `RLock()` и `RUnlock()` для блокировки чтения
     * `Lock()` и `Unlock()` для блокировки записи

5. **Производительность**:
   - `Mutex` обычно быстрее для небольшого количества горутин.
   - `RWMutex` эффективнее при большом количестве операций чтения и редких операциях записи.

6. **Сложность использования**:
   - `Mutex` проще в использовании и понимании.
   - `RWMutex` требует более тщательного планирования и может быть сложнее в отладке.

7. **Случаи использования**:
   - `Mutex` подходит для общей защиты ресурсов.
   - `RWMutex` оптимален, когда чтение происходит намного чаще, чем запись.

## Пример использования валидатора

```golang
package main

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/go-playground/validator/v10"
)

// User структура для хранения данных пользователя
type User struct {
	Username string `json:"username" validate:"required,min=3,max=20"`
	Email    string `json:"email" validate:"required,email"`
	Age      int    `json:"age" validate:"required,gte=18,lte=120"`
}

var validate *validator.Validate

func init() {
	validate = validator.New()
}

func userHandler(w http.ResponseWriter, r *http.Request) {
	var user User

	// Декодирование JSON из тела запроса
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		http.Error(w, "Invalid JSON", http.StatusBadRequest)
		return
	}

	// Валидация структуры
	err = validate.Struct(user)
	if err != nil {
		// Если есть ошибки валидации
		if _, ok := err.(*validator.InvalidValidationError); ok {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		var errorMessages []string
		for _, err := range err.(validator.ValidationErrors) {
			errorMessages = append(errorMessages, fmt.Sprintf("Field: %s, Error: %s", err.Field(), err.Tag()))
		}

		// Отправка ошибок валидации клиенту
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]interface{}{
			"errors": errorMessages,
		})
		return
	}

	// Если валидация прошла успешно
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "User data is valid"})
}

func main() {
	http.HandleFunc("/user", userHandler)
	fmt.Println("Server is running on :8080")
	http.ListenAndServe(":8080", nil)
}
```

## goose

`goose` - это простой в использовании инструмент для миграции баз данных, написанный на Go. Он поддерживает создание, применение и откат миграций для различных баз данных.

#### Основные характеристики:

1. Поддержка нескольких СУБД (PostgreSQL, MySQL, SQLite и др.)
2. CLI для управления миграциями
3. Программный API для интеграции в Go-приложения
4. Поддержка миграций на SQL и Go
5. Возможность создания, применения и отката миграций

#### Установка

```bash
go install github.com/pressly/goose/v3/cmd/goose@latest
```

#### Создание миграций

Создание SQL-миграции:

```bash
goose create add_users_table sql
```

Это создаст файл с именем вроде `20230515120000_add_users_table.sql` в текущей директории.

Создание Go-миграции:

```bash
goose create add_users_table go
```

Это создаст файл с именем вроде `20230515120000_add_users_table.go`.

#### Пример SQL-миграции

`20230515120000_add_users_table.sql`:

```sql
-- +goose Up
-- +goose StatementBegin
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE users;
-- +goose StatementEnd
```

#### Пример Go-миграции

`20230515120000_add_users_table.go`:

```go
package main

import (
    "database/sql"
    "github.com/pressly/goose/v3"
)

func init() {
    goose.AddMigration(upAddUsersTable, downAddUsersTable)
}

func upAddUsersTable(tx *sql.Tx) error {
    _, err := tx.Exec(`
        CREATE TABLE users (
            id SERIAL PRIMARY KEY,
            username VARCHAR(50) NOT NULL,
            email VARCHAR(100) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    `)
    if err != nil {
        return err
    }
    return nil
}

func downAddUsersTable(tx *sql.Tx) error {
    _, err := tx.Exec("DROP TABLE users;")
    if err != nil {
        return err
    }
    return nil
}
```

#### Выполнение миграций

Применение всех миграций:

```bash
goose postgres "user=username password=password dbname=mydb sslmode=disable" up
```

Применение определенного количества миграций:

```bash
goose postgres "user=username password=password dbname=mydb sslmode=disable" up-by-one
```

или

```bash
goose postgres "user=username password=password dbname=mydb sslmode=disable" up-to VERSION
```

#### Откат миграций

Откат последней миграции:

```bash
goose postgres "user=username password=password dbname=mydb sslmode=disable" down
```

Откат всех миграций:

```bash
goose postgres "user=username password=password dbname=mydb sslmode=disable" reset
```

#### Статус миграций

Просмотр статуса миграций:

```bash
goose postgres "user=username password=password dbname=mydb sslmode=disable" status
```

### Особенности goose

1. **Простота использования**: goose имеет простой и понятный CLI интерфейс.
2. **Go и SQL миграции**: Поддерживает миграции, написанные как на SQL, так и на Go.
3. **Транзакции**: Каждая миграция выполняется в отдельной транзакции.
4. **Версионирование**: Использует временные метки для версионирования миграций.
5. **Интеграция с приложением**: Легко интегрируется в Go-приложения через программный API.
6. **Гибкость**: Позволяет выполнять миграции до определенной версии, применять только одну миграцию и т.д.

## golang-migrate

`golang-migrate` - это инструмент для управления миграциями базы данных, который поддерживает автоматическую генерацию миграций и их выполнение. Вот основные особенности:

1. Поддержка множества баз данных (PostgreSQL, MySQL, SQLite и др.)
2. CLI инструмент для управления миграциями
3. Программный API для интеграции миграций в ваше приложение
4. Поддержка миграций вверх и вниз (up and down)
5. Поддержка различных источников миграций (файловая система, GitHub, AWS S3 и др.)

#### Установка

```bash
go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
```

#### Создание миграций

```bash
migrate create -ext sql -dir db/migrations -seq create_users_table
```

Это создаст два файла:
- `db/migrations/000001_create_users_table.up.sql`
- `db/migrations/000001_create_users_table.down.sql`

#### Пример миграции

`000001_create_users_table.up.sql`:
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

`000001_create_users_table.down.sql`:
```sql
DROP TABLE users;
```

#### Выполнение миграций

```bash
migrate -database "postgresql://username:password@localhost:5432/database?sslmode=disable" -path db/migrations up
```

#### Откат миграций

```bash
migrate -database "postgresql://username:password@localhost:5432/database?sslmode=disable" -path db/migrations down
```



## gormigrate

`gormigrate` позволяет определять миграции с использованием GORM и предоставляет простой способ управления версиями базы данных.

#### Установка

```bash
go get -u github.com/go-gormigrate/gormigrate/v2
```

#### Основные особенности

1. Интеграция с GORM
2. Поддержка миграций вверх и вниз
3. Возможность использования Go-кода для определения миграций
4. Автоматическое управление версиями миграций
5. Поддержка всех баз данных, которые поддерживает GORM

#### Пример использования

```go
package main

import (
	"log"

	"github.com/go-gormigrate/gormigrate/v2"
	"gorm.io/gorm"
	"gorm.io/driver/postgres"
)

func main() {
	db, err := gorm.Open(postgres.Open("host=localhost user=gorm password=gorm dbname=gorm port=9920 sslmode=disable TimeZone=Asia/Shanghai"), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}

	m := gormigrate.New(db, gormigrate.DefaultOptions, []*gormigrate.Migration{
		{
			ID: "202106010001",
			Migrate: func(tx *gorm.DB) error {
				// Создание таблицы
				return tx.AutoMigrate(&User{})
			},
			Rollback: func(tx *gorm.DB) error {
				// Откат изменений
				return tx.Migrator().DropTable("users")
			},
		},
		{
			ID: "202106010002",
			Migrate: func(tx *gorm.DB) error {
				// Добавление колонки
				return tx.Migrator().AddColumn(&User{}, "Email")
			},
			Rollback: func(tx *gorm.DB) error {
				// Удаление колонки
				return tx.Migrator().DropColumn(&User{}, "Email")
			},
		},
	})

	if err = m.Migrate(); err != nil {
		log.Fatalf("Could not migrate: %v", err)
	}
	log.Printf("Migration did run successfully")
}

type User struct {
	gorm.Model
	Name  string
	Email string // Добавлено во второй миграции
}
```

#### Особенности использования

1. **Определение миграций**: Каждая миграция определяется как структура `gormigrate.Migration` с уникальным ID, функциями Migrate и Rollback.
2. **Выполнение миграций**: Используйте метод `Migrate()` для применения всех миграций.
3. **Откат миграций**: Метод `RollbackLast()` откатывает последнюю миграцию.
4. **Выполнение до определенной версии**: Метод `MigrateTo()` позволяет мигрировать до конкретной версии.
5. **Интеграция с GORM**: Вы можете использовать все возможности GORM внутри функций миграции.

#### Преимущества gormigrate

1. **Тесная интеграция с GORM**: Если вы уже используете GORM, gormigrate будет естественным выбором.
2. **Использование Go-кода**: Вместо SQL вы пишете миграции на Go, что может быть более удобным и типобезопасным.
3. **Автоматическое управление версиями**: gormigrate автоматически отслеживает, какие миграции были применены.
4. **Простота использования**: API очень прост и интуитивно понятен.

#### Ограничения

1. **Зависимость от GORM**: Если вы не используете GORM, этот инструмент может быть излишним.
2. **Нет CLI-инструмента**: В отличие от некоторых других решений, gormigrate не предоставляет отдельного CLI-инструмента.
3. **Нет автогенерации миграций**: Вам нужно вручную писать каждую миграцию.




## Все виды валидаторов `go-playground/validator`

### Общие валидаторы

```go
`validate:"required"` // Поле обязательно для заполнения
`validate:"omitempty"` // Пропустить валидацию, если поле пустое
`validate:"len=10"` // Точная длина
`validate:"min=5"` // Минимальная длина или значение
`validate:"max=10"` // Максимальная длина или значение
`validate:"eq=10"` // Равно значению
`validate:"ne=10"` // Не равно значению
`validate:"oneof=red green blue"` // Значение должно быть одним из списка
```

### Числовые валидаторы

```go
`validate:"gt=0"` // Больше чем
`validate:"gte=0"` // Больше или равно
`validate:"lt=10"` // Меньше чем
`validate:"lte=10"` // Меньше или равно
`validate:"multiple=3"` // Кратно числу
```

### Строковые валидаторы

```go
`validate:"alpha"` // Только буквы
`validate:"alphanum"` // Буквы и цифры
`validate:"numeric"` // Только цифры
`validate:"hexadecimal"` // Шестнадцатеричное значение
`validate:"lowercase"` // Только нижний регистр
`validate:"uppercase"` // Только верхний регистр
`validate:"contains=substring"` // Содержит подстроку
`validate:"containsany=abcd"` // Содержит любой из символов
`validate:"excludes=substring"` // Не содержит подстроку
`validate:"excludesall=0123456789"` // Не содержит ни одного из символов
`validate:"startswith=prefix"` // Начинается с префикса
`validate:"endswith=suffix"` // Заканчивается суффиксом
```

### Форматные валидаторы

```go
`validate:"email"` // Валидный email
`validate:"url"` // Валидный URL
`validate:"uri"` // Валидный URI
`validate:"base64"` // Валидная Base64 строка
`validate:"json"` // Валидный JSON
`validate:"jwt"` // Валидный JWT токен
`validate:"uuid"` // Валидный UUID
`validate:"uuid3"` // Валидный UUID версии 3
`validate:"uuid4"` // Валидный UUID версии 4
`validate:"uuid5"` // Валидный UUID версии 5
`validate:"isbn"` // Валидный ISBN
`validate:"isbn10"` // Валидный ISBN10
`validate:"isbn13"` // Валидный ISBN13
```

### Сравнительные валидаторы

```go
`validate:"eqfield=ConfirmPassword"` // Равно другому полю
`validate:"nefield=Password"` // Не равно другому полю
`validate:"gtfield=MinAge"` // Больше чем другое поле
`validate:"ltfield=MaxAge"` // Меньше чем другое поле
```

### Временные валидаторы

```go
`validate:"datetime=2006-01-02"` // Соответствует формату даты/времени
`validate:"date"` // Валидная дата
`validate:"time"` // Валидное время
```

### Слайсы и карты

```go
`validate:"dive"` // Применить валидацию к элементам слайса или карты
`validate:"unique"` // Все элементы должны быть уникальными
`validate:"min=3,max=10,dive,required"` // Комбинированная валидация для слайса
```

### Файловые валидаторы

```go
`validate:"file"` // Существующий файл
`validate:"dir"` // Существующая директория
`validate:"isdefault"` // Значение по умолчанию для типа
```

### Условные валидаторы

```go
`validate:"required_if=Field1 value1 Field2 value2"` // Обязательно, если другие поля имеют определенные значения
`validate:"required_unless=Field1 value1 Field2 value2"` // Обязательно, если другие поля НЕ имеют определенных значений
`validate:"required_with=Field1 Field2"` // Обязательно, если одно из указанных полей присутствует
`validate:"required_without=Field1 Field2"` // Обязательно, если одно из указанных полей отсутствует
`validate:"excluded_with=Field1 Field2"` // Должно быть пустым, если указанные поля присутствуют
`validate:"excluded_without=Field1 Field2"` // Должно быть пустым, если указанные поля отсутствуют
```

## Использование прокси в http.Client

```golang
url_i := url.URL{}
url_proxy, _ := url_i.Parse(proxy_addr)

transport := http.Transport{}    
transport.Proxy = http.ProxyURL(url_proxy)// set proxy 
transport.TLSClientConfig = &tls.Config{InsecureSkipVerify: true} //set ssl

client := &http.Client{}
client.Transport = transport
resp, err := client.Get("http://example.com") // do request through proxy
```

## Сложение времени 

```golang
theTime := time.Date(2021, 8, 15, 14, 30, 45, 100, time.UTC)
fmt.Println("The time is", theTime)

toAdd := 24 * time.Hour
fmt.Println("Adding", toAdd)

newTime := theTime.Add(toAdd)
fmt.Println("The new time is", newTime)
```

## Как сравнить время

### Вариант 1

```golang
firstTime := time.Date(2021, 8, 15, 14, 30, 45, 100, time.UTC)
fmt.Println("The first time is", firstTime)

secondTime := time.Date(2021, 12, 25, 16, 40, 55, 200, time.UTC)
fmt.Println("The second time is", secondTime)

fmt.Println("First time before second?", firstTime.Before(secondTime))
fmt.Println("First time after second?", firstTime.After(secondTime))

fmt.Println("Second time before first?", secondTime.Before(firstTime))
fmt.Println("Second time after first?", secondTime.After(firstTime))
```

```
The first time is 2021-08-15 14:30:45.0000001 +0000 UTC
The second time is 2021-12-25 16:40:55.0000002 +0000 UTC
First time before second? true
First time after second? false
Second time before first? false
Second time after first? true
```

### Вариант 2

```
firstTime := time.Date(2021, 8, 15, 14, 30, 45, 100, time.UTC)
fmt.Println("The first time is", firstTime)

secondTime := time.Date(2021, 12, 25, 16, 40, 55, 200, time.UTC)
fmt.Println("The second time is", secondTime)

fmt.Println("Duration between first and second time is", firstTime.Sub(secondTime))
fmt.Println("Duration between second and first time is", secondTime.Sub(firstTime))
```

```
The first time is 2021-08-15 14:30:45.0000001 +0000 UTC
The second time is 2021-12-25 16:40:55.0000002 +0000 UTC
Duration between first and second time is -3170h10m10.0000001s
Duration between second and first time is 3170h10m10.0000001s
```

## Формула роста слайсов

```
starting cap    growth factor 
256             2.0 
512             1.63 
1024            1.44 
2048            1.35 
4096            1.30
```

## Все функции, которые могут остановить горутину:

runtime.Gosched
runtime.gopark
runtime.notesleep
runtime.Goexit

## Какие типы данных используются в Go?
Go работает со следующими типами:

- Method (метод)
- Boolean (логический тип)
- Numeric (численный)
- String (строковый)
- Array (массив)
- Slice (срез)
- Struct (структура)
- Pointer (указатель)
- Function (функция)
- Interface (интерфейс)
- Map (карта)
- Channel (канал)

## Создание библиотеки

- https://go.dev/doc/tutorial/create-module

## Paginating a slice

```go
func Paginate(pageNum int, pageSize int, sliceLength int) (int, int) {
    start := pageNum * pageSize

    if start > sliceLength {
        start = sliceLength
    }

    end := start + pageSize
    if end > sliceLength {
        end = sliceLength
    }

    return start, end
}
```

```go
start, end := Paginate(pageNum, pageSize, len(someSlice))
pagedSlice := someSlice[start:end]
```

## Дефолтные значения в методах

### Вариант 1. Вызывающий абонент выбирает значения по умолчанию.

```go
// Both parameters are optional, use empty string for default value
func Concat1(a string, b int) string {
  if a == "" {
    a = "default-a"
  }
  if b == 0 {
    b = 5
  }

  return fmt.Sprintf("%s%d", a, b)
}
```

### Вариант 2. Один необязательный параметр в конце.

```go
// a is required, b is optional.
// Only the first value in b_optional will be used.
func Concat2(a string, b_optional ...int) string {
  b := 5
  if len(b_optional) > 0 {
    b = b_optional[0]
  }

  return fmt.Sprintf("%s%d", a, b)
}
```

### Вариант 3: структура конфигурации

```go
// A declarative default value syntax
// Empty values will be replaced with defaults
type Parameters struct {
  A string `default:"default-a"` // this only works with strings
  B string // default is 5
}

func Concat3(prm Parameters) string {
  typ := reflect.TypeOf(prm)

  if prm.A == "" {
    f, _ := typ.FieldByName("A")
    prm.A = f.Tag.Get("default")
  }

  if prm.B == 0 {
    prm.B = 5
  }

  return fmt.Sprintf("%s%d", prm.A, prm.B)
}
```

### Вариант 4. Полный анализ аргументов с переменным числом аргументов (стиль Javascript)

```go
func Concat4(args ...interface{}) string {
  a := "default-a"
  b := 5

  for _, arg := range args {
    switch t := arg.(type) {
      case string:
        a = t
      case int:
        b = t
      default:
        panic("Unknown argument")
    }
  }

  return fmt.Sprintf("%s%d", a, b)
}
```

## Игнорирование полей в JSON парсинге

```go
package main

import (
        "encoding/json"
        "fmt"
        "os"
)

type Dummy struct {
        Name    string  `json:"name"`
        Number  int64   `json:"number"`
        Pointer *string `json:"-"` // we want to ignore JSON for this one
}

func main() {
        data := []byte(`
            {
                "name": "Mr Dummy",
                "number": 4,
                "pointer": "yes"
            }
        `)

        var dummy Dummy
        err := json.Unmarshal(data, &dummy)
        if err != nil {
                fmt.Println("An error occured: %v", err)
                os.Exit(1)
        }

	// we want to print the field names as well
        fmt.Printf("%+v\n", dummy)
}
```

## Создание файла

### Вариант 1

```go
package main

import (
    "io/ioutil"
    "log"
)

func main() {
    // create a byte array of a string
    data := []byte("Hello Gopher!")

    // write data to a hello file, with 0777 file permission
    err := ioutil.WriteFile("hello.txt", data, 0777)

    if err != nil {
        log.Fatalf("%v", err)
    }
}
```

### Вариант 2

```go
package main

import (
    "log"
    "os"
)

func main() {
    // If the file doesn't exist, create it, or append to the file
    file, err := os.OpenFile("hello.txt", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0777)

    if err != nil {
        log.Fatalf("error while opening the file. %v", err)
    }

    // close the file once program execution complete
    defer file.Close()

    if _, err := file.Write([]byte("\nappended data")); err != nil {
        log.Fatalf("error while writing the file. %v", err)
    }
}
```

## Суммирование строк пути

```go
/ Golang program to illustrate the usage of 
// filepath.Join() function 
  
// Including the main package 
package main 
  
// Importing fmt and path/filepath 
import ( 
    "fmt"
    "path/filepath"
) 
  
// Calling main 
func main() { 
  
    // Calling the Join() function 
    fmt.Println(filepath.Join("G", "F", "G")) 
    fmt.Println(filepath.Join("G/F", "G")) 
    fmt.Println(filepath.Join("gfg", "GFG")) 
    fmt.Println(filepath.Join("Geeks", "for", "Geeks")) 
} 
```

## Нахождение Hash

### Вариант 1

```go
package main

import (
        "fmt"
        "hash/fnv"
)

func hash(s string) uint32 {
        h := fnv.New32a()
        h.Write([]byte(s))
        return h.Sum32()
}

func main() {
        fmt.Println(hash("HelloWorld"))
        fmt.Println(hash("HelloWorld."))
}
```

```
926844193
107706013
```

## URL Parsing

```go
package main

import (
    "fmt"
    "net"
    "net/url"
)

func main() {

    s := "postgres://user:pass@host.com:5432/path?k=v#f"

    u, err := url.Parse(s)
    if err != nil {
        panic(err)
    }

    fmt.Println(u.Scheme)

    fmt.Println(u.User)
    fmt.Println(u.User.Username())
    p, _ := u.User.Password()
    fmt.Println(p)

    fmt.Println(u.Host)
    host, port, _ := net.SplitHostPort(u.Host)
    fmt.Println(host)
    fmt.Println(port)

    fmt.Println(u.Path)
    fmt.Println(u.Fragment)

    fmt.Println(u.RawQuery)
    m, _ := url.ParseQuery(u.RawQuery)
    fmt.Println(m)
    fmt.Println(m["k"][0])
}
```

## GUID

- go get github.com/beevik/guid

```go
g := guid.New()
fmt.Println("guid: %s  GUID: %s\n", g.String(), g.StringUpper())

s0 := "67a23ff3-20be-4420-9274-d16f2833d595"
s1 := "67a23ff3-20be-4420-9274"
fmt.Println("s0 a guid?  ", guid.IsGuid(s0))
fmt.Println("s0 a guid?  ", guid.IsGuid(s1))
```

## Ошибки

### Вариант 1 - String-based errors

```go
// simple string-based error
err1 := errors.New("math: square root of negative number")

// with formatting
err2 := fmt.Errorf("math: square root of negative number %g", x)
```

### Вариант 2 - Custom errors with data

```go
type error interface {
	Error() string
}

type SyntaxError struct {
	Line int
	Col  int
}

func (e *SyntaxError) Error() string {
	return fmt.Sprintf("%d:%d: syntax error", e.Line, e.Col)
}

type InternalError struct {
	Path string
}

func (e *InternalError) Error() string {
	return fmt.Sprintf("parse %v: internal error", e.Path)
}

if err := Foo(); err != nil {
	switch e := err.(type) {
	case *SyntaxError:
		// Do something interesting with e.Line and e.Col.
	case *InternalError:
		// Abort and file an issue.
	default:
		log.Println(e)
	}
}
```

## Циклы, for loops

- https://yourbasic.org/golang/for-loop/

### Вариант 1 - Three-component loop

```go
sum := 0
for i := 1; i < 5; i++ {
	sum += i
}
fmt.Println(sum) // 10 (1+2+3+4)
```

### Вариант 2 - While loop

```go
n := 1
for n < 5 {
	n *= 2
}
fmt.Println(n) // 8 (1*2*2*2)
```

### Вариант 3 - Infinite loop

```go
sum := 0
for {
	sum++ // repeated forever
}
fmt.Println(sum) // never reached
```

### Вариант 4 - For-each range loop

```go
strings := []string{"hello", "world"}
for i, s := range strings {
	fmt.Println(i, s)
}
```

### Вариант 5 - Exit a loop

```go
sum := 0
for i := 1; i < 5; i++ {
	if i%2 != 0 { // skip odd numbers
		continue
	}
	sum += i
}
fmt.Println(sum) // 6 (2+4)
```

## Удаление эделента из масива/слайса

### Способ 1

```go
func remove(slice []string, s int) []string {
	return append(slice[:s], slice[s+1:]...)
}
```

### Способ 2

```go
func removeItemFromArray(slice interface{}, index int) interface{} {
	sliceValue := reflect.ValueOf(slice)

	if sliceValue.Kind() != reflect.Slice {
		panic("Input is not a slice")
	}

	length := sliceValue.Len()

	if index < 0 || index >= length {
		panic("Index out of range")
	}

	return reflect.AppendSlice(sliceValue.Slice(0, index), sliceValue.Slice(index+1, length)).Interface()
}
```

## Создать директорию, если не нашлась

```go
func createDirectoryIfNotExists(dirPath string) error {
	_, err := os.Stat(dirPath)

	if os.IsNotExist(err) {
		err := os.Mkdir(dirPath, os.ModePerm)
		if err != nil {
			return err
		}
	} else if err != nil {
		return err
	} else {
		//
	}

	return nil
}
```

## Работа с каналами

- https://go101.org/article/channel.html
- https://go101.org/article/channel-use-cases.html

1. **Простой канал для передачи данных:**

```go
package main

import "fmt"

func main() {
    // Создаем канал
    ch := make(chan int)

    // Запускаем горутину для отправки данных в канал
    go func() {
        ch <- 42 // Помещаем значение 42 в канал
    }()

    // Читаем данные из канала
    value := <-ch
    fmt.Println(value) // Выводим значение 42
}
```

2. **Буферизированный канал:**

```go
package main

import "fmt"

func main() {
    // Создаем буферизированный канал с размером 2
    ch := make(chan string, 2)

    // Запускаем горутину для отправки данных в канал
    go func() {
        ch <- "Hello"
        ch <- "World"
    }()

    // Читаем данные из канала
    fmt.Println(<-ch)
    fmt.Println(<-ch)
}
```

3. **Использование канала для синхронизации горутин:**

```go
package main

import (
    "fmt"
    "sync"
)

func main() {
    var wg sync.WaitGroup
    ch := make(chan int)

    // Горутина отправляет данные в канал
    wg.Add(1)
    go func() {
        defer wg.Done()
        ch <- 42
    }()

    // Горутина читает данные из канала
    wg.Add(1)
    go func() {
        defer wg.Done()
        value := <-ch
        fmt.Println(value)
    }()

    wg.Wait()
}
```

4. **Использование `select` для работы с несколькими каналами:**

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    ch1 := make(chan string)
    ch2 := make(chan string)

    // Горутина отправляет данные в первый канал
    go func() {
        time.Sleep(time.Second)
        ch1 <- "Hello"
    }()

    // Горутина отправляет данные во второй канал
    go func() {
        time.Sleep(2 * time.Second)
        ch2 <- "World"
    }()

    // Используем select для чтения из нескольких каналов
    select {
    case msg1 := <-ch1:
        fmt.Println(msg1)
    case msg2 := <-ch2:
        fmt.Println(msg2)
    }
}
```

## Выделение памяти, создание объекта

Go имеет несколько способов выделения памяти и инициализации значений:

```go
&T{...}, &someLocalVar, new,make
```

Выделение также может происходить при создании составных литералов.

newможет использоваться для выделения значений, таких как целые числа, &intявляется незаконным:

```go
new(Point)
&Point{}      // OK
&Point{2, 3}  // Combines allocation and initialization

new(int)
&int          // Illegal

// Works, but it is less convenient to write than new(int)
var i int
&i
```

Разницу между newи makeможно увидеть, посмотрев на следующий пример:

```go
p := new(chan int)   // p has type: *chan int
c := make(chan int)  // c has type: chan int
```

## Удаление элементов из массива

### Способ 1 Порядок имеет значение

Если вы хотите сохранить порядок в массиве, вам необходимо сдвинуть все элементы справа от индекса удаления на один влево. Надеюсь, это можно легко сделать в Golang:

```go
func remove(slice []int, s int) []int {
    return append(slice[:s], slice[s+1:]...)
}
```

Однако это неэффективно, поскольку в конечном итоге вам придется переместить все элементы, что потребует больших затрат.

### Способ 2 Порядок не важен

Если вас не волнует порядок, у вас есть гораздо более быстрая возможность заменить удаляемый элемент элементом в конце среза, а затем вернуть n-1 первых элементов:

```go
func remove(s []int, i int) []int {
    s[i] = s[len(s)-1]
    return s[:len(s)-1]
}
```

При методе реслицирования очистка массива из 1 000 000 элементов занимает 224 секунды, а в этом случае — всего 0,06 нс.

Этот ответ не выполняет проверку границ . Он ожидает действительный индекс в качестве входных данных. Это означает, что отрицательные значения или индексы, которые больше или равны исходному, len(s)вызовут панику Go.

Срезы и массивы имеют индекс 0, поэтому удаление n-го элемента массива подразумевает предоставление входных данных n-1 . Чтобы удалить первый элемент, вызовите Remove(s, 0) , чтобы удалить второй, вызовите Remove(s, 1) и так далее и тому подобное.

### Cпособ 3

```go
a := []string{"A", "B", "C", "D", "E"}
i := 2

// Remove the element at index i from a.
copy(a[i:], a[i+1:]) // Shift a[i+1:] left one index.
a[len(a)-1] = ""     // Erase last element (write zero value).
a = a[:len(a)-1]     // Truncate slice.

fmt.Println(a) // [A B D E]
```

## Удаление элементов из map

### Способ 1

```go
var sessions = map[string] chan int{};
delete(sessions, "moo");
```

### Способ 2

```go
items := map[string]int{"apple": 5, "банан": 3, "апельсин": 4}
var keysToDelete []string

for key, value := range items {
    if value < 4 {
        keysToDelete = append(keysToDelete, key) // Собираем ключи для удаления
    }
}

for _, key := range keysToDelete {
    delete(items, key) // Безопасное удаление после итерации
}

fmt.Println(items) // Это безопасно изменит карту
```

## Fiber - парсинг массива параметров

### Form (application/x-www-form-urlencoded)

После изучения go-fiberисходный код, который на данный момент имеет реализацию обработки данных пользовательской формы, которая, похоже, не поддерживает фрагмент пользовательского типа ([]Person{}).
Для получения дополнительной информации вы можете проверить эти ссылки на go-fiberисходный код, который обрабатывает данные формы: 1 2 3

Вместо этого мы можем использовать go-playground/form для обработки данных формы

Запрос на скручивание для нескольких параметров

```
curl -X POST -H "Content-Type: application/x-www-form-urlencoded" --data '[0].name=john&[0].pass=doe&[1].name=jack&[1].pass=jill' localhost:3000
```

Код:

```go
package main

import (
  "log"

  "net/url"
  "github.com/gofiber/fiber/v2"
  "github.com/go-playground/form/v4"
)

type Person struct {
  Name string `json:"name" xml:"name" form:"name"`
  Pass string `json:"pass" xml:"pass" form:"pass"`
}

var decoder = form.NewDecoder()

func main() {
  app := fiber.New()

  app.Post("/", func(c *fiber.Ctx) error {
    persons := []Person{}

    m, err := url.ParseQuery(string(c.Body()))
    if err != nil {
      return err
    }
    err = decoder.Decode(&persons, m)
    if err != nil {
      return err
    }
    log.Printf("%#v\n", persons)
    // []main.Person{main.Person{Name:"john", Pass:"doe"}, main.Person{Name:"jack", Pass:"jill"}}
    return c.SendString("Post Called")
  })

  app.Listen(":3000")
}
```

Я поднял issueи PRв go-fiber githubрепозиторий, который был объединен, поэтому приведенный ниже запрос и код теперь будут работать.

Запрос на скручивание для нескольких параметров

```
curl -X POST -H "Content-Type: application/x-www-form-urlencoded" --data 'persons[0].name=one&persons[0].pass=1&persons[1].name=two&persons[1].pass=2' localhost:3000
```

Код:

```go
package main

import (
    "log"

    "github.com/gofiber/fiber/v2"
)

// recommendation -> name of the api and parameters
type ApiParameters struct {
    Persons []Person `query:"persons" json:"persons" xml:"persons" form:"persons"`
}

type Person struct {
    Name string `query:"name" json:"name" xml:"name" form:"name"`
    Pass string `query:"pass" json:"pass" xml:"pass" form:"pass"`
}

func main() {
    app := fiber.New()

    app.Post("/", func(c *fiber.Ctx) error {
        parameters := ApiParameters{}

        if err := c.BodyParser(&parameters); err != nil {
            return err
        }

        log.Printf("POST: %#v\n", parameters)

        return c.SendString("Post Called")
    })

    log.Fatalln(app.Listen(":3000"))
}
```

## HTTP Запрос

### Способ 1

```go
package main

import (
   "io/ioutil"
   "log"
   "net/http"
)

func main() {
   resp, err := http.Get("https://jsonplaceholder.typicode.com/posts")
   if err != nil {
      log.Fatalln(err)
   }
//We Read the response body on the line below.
   body, err := ioutil.ReadAll(resp.Body)
   if err != nil {
      log.Fatalln(err)
   }
//Convert the body to type string
   sb := string(body)
   log.Printf(sb)
}
```

### Способ 2

```go
import (
   "bytes"
   "encoding/json"
   "io/ioutil"
   "log"
   "net/http"
)

func main() {
//Encode the data
   postBody, _ := json.Marshal(map[string]string{
      "name":  "Toby",
      "email": "Toby@example.com",
   })
   responseBody := bytes.NewBuffer(postBody)
//Leverage Go's HTTP Post function to make request
   resp, err := http.Post("https://postman-echo.com/post", "application/json", responseBody)
//Handle Error
   if err != nil {
      log.Fatalf("An Error Occured %v", err)
   }
   defer resp.Body.Close()
//Read the response body
   body, err := ioutil.ReadAll(resp.Body)
   if err != nil {
      log.Fatalln(err)
   }
   sb := string(body)
   log.Printf(sb)
}
```

## Быстрая сортировка

```go
package main

import "fmt"

// QuickSort сортирует слайс любого сравнимого типа.
func QuickSort[T any](data []T, compare func(a, b T) bool) {
    if len(data) < 2 {
        return
    }
    left, right := 0, len(data)-1
    pivot := len(data) / 2
    data[pivot], data[right] = data[right], data[pivot]
    for i := range data {
        if compare(data[i], data[right]) {
            data[left], data[i] = data[i], data[left]
            left++
        }
    }
    data[left], data[right] = data[right], data[left]
    QuickSort(data[:left], compare)
    QuickSort(data[left+1:], compare)
}

func main() {
    slice := []int{9, 4, 6, 2, 10, 3}
    QuickSort(slice, func(a, b int) bool { return a < b })
    fmt.Println(slice) // Выведет: [2 3 4 6 9 10]
}
```

## Паттерны

### Напиши пример паттерна Strategy в golang

```golang
// Интерфейс Strategy определяет операцию, необходимую для всех конкретных стратегий
type Strategy interface {
    Execute(a, b int) int
}

// Конкретные реализации стратегий
type Addition struct{}

func (a *Addition) Execute(x, y int) int {
    return x + y
}

type Subtraction struct{}

func (s *Subtraction) Execute(x, y int) int {
    return x - y
}

// Класс контекста
type Context struct {
    strategy Strategy
}

func (c *Context) SetStrategy(strategy Strategy) {
    c.strategy = strategy
}

func (c *Context) Execute(a, b int) int {
    return c.strategy.Execute(a, b)
}

// Использование
func main() {
    context := &Context{}

    addition := &Addition{}
    context.SetStrategy(addition)
    result := context.Execute(5, 3)
    fmt.Println("Addition result:", result) // Output: Addition result: 8

    subtraction := &Subtraction{}
    context.SetStrategy(subtraction)
    result = context.Execute(5, 3)
    fmt.Println("Subtraction result:", result) // Output: Subtraction result: 2
}
```

### Напиши пример паттерна Observer в golang

```golang
// Определяем интерфейс Наблюдателя
type Observer interface {
    Update(data interface{})
}

// Определяем интерфейс Subjectа
type Subject interface {
    RegisterObserver(o Observer)
    RemoveObserver(o Observer)
    NotifyObservers(data interface{})
}

// Конкретная реализация Subjectа
type ConcreteSubject struct {
    observers []Observer
    data      interface{}
}

func (s *ConcreteSubject) RegisterObserver(o Observer) {
    s.observers = append(s.observers, o)
}

func (s *ConcreteSubject) RemoveObserver(o Observer) {
    var newObservers []Observer
    for _, observer := range s.observers {
        if observer != o {
            newObservers = append(newObservers, observer)
        }
    }
    s.observers = newObservers
}

func (s *ConcreteSubject) NotifyObservers(data interface{}) {
    s.data = data
    for _, observer := range s.observers {
        observer.Update(s.data)
    }
}

// Конкретная реализация Наблюдателя
type ConcreteObserver struct {
    id int
}

func (o *ConcreteObserver) Update(data interface{}) {
    println("Observer", o.id, "received data:", data)
}

// Пример использования
func main() {
    subject := &ConcreteSubject{}

    observer1 := &ConcreteObserver{1}
    observer2 := &ConcreteObserver{2}

    subject.RegisterObserver(observer1)
    subject.RegisterObserver(observer2)

    subject.NotifyObservers("Hello, World!")

    subject.RemoveObserver(observer2)

    subject.NotifyObservers("Goodbye, World!")
}
```

### Напиши пример паттерна Decorator в golang

```golang
// Интерфейс Beverage определяет операцию, которую можно декорировать
type Beverage interface {
	GetDescription() string
	GetCost() float64
}

// Конкретный компонент
type Espresso struct{}

func (e Espresso) GetDescription() string {
	return "Espresso"
}

func (e Espresso) GetCost() float64 {
	return 1.99
}

// Декоратор
type BeverageDecorator struct {
	beverage Beverage
}

func (d *BeverageDecorator) GetDescription() string {
	return d.beverage.GetDescription()
}

func (d *BeverageDecorator) GetCost() float64 {
	return d.beverage.GetCost()
}

// Конкретный декоратор
type Mocha struct {
	BeverageDecorator
}

func NewMocha(b Beverage) *Mocha {
	return &Mocha{BeverageDecorator{b}}
}

func (m *Mocha) GetDescription() string {
	return m.BeverageDecorator.GetDescription() + ", Mocha"
}

func (m *Mocha) GetCost() float64 {
	return m.BeverageDecorator.GetCost() + 0.20
}

// Другой конкретный декоратор
type Whip struct {
	BeverageDecorator
}

func NewWhip(b Beverage) *Whip {
	return &Whip{BeverageDecorator{b}}
}

func (w *Whip) GetDescription() string {
	return w.BeverageDecorator.GetDescription() + ", Whip"
}

func (w *Whip) GetCost() float64 {
	return w.BeverageDecorator.GetCost() + 0.10
}

// Использование декоратора
func main() {
	beverage := Espresso{}
	fmt.Printf("Description: %s, Cost: $%.2f\n", beverage.GetDescription(), beverage.GetCost())

	mocha := NewMocha(&beverage)
	fmt.Printf("Description: %s, Cost: $%.2f\n", mocha.GetDescription(), mocha.GetCost())

	whip := NewWhip(mocha)
	fmt.Printf("Description: %s, Cost: $%.2f\n", whip.GetDescription(), whip.GetCost())
}
```

## Вопросы

### Что выведет программа?

```golang
func main() {
    var ptr *struct{}
    var iface interface{}
    iface = ptr
    if iface == nil {
        println("It's nil!")
    }
}
```

Программа ничего не выведет - условие `if iface == nil` не выполнится.

Разберем почему:

1. Сначала создается указатель `ptr` типа `*struct{}` со значением `nil`

2. Создается пустой интерфейс `iface`

3. Когда мы присваиваем `ptr` переменной `iface`, создается интерфейсное значение, которое состоит из двух частей:
   - type descriptor (тип) = `*struct{}`
   - value (значение) = `nil`

4. При сравнении интерфейса с `nil`, интерфейс считается `nil` только если **обе** части равны `nil`:
   - type descriptor = `nil`
   - value = `nil`

В нашем случае:
- type descriptor = `*struct{}` (не nil)
- value = `nil`

Поэтому условие `iface == nil` возвращает `false`, и строка "It's nil!" не печатается.

Чтобы это проверить, можно модифицировать программу:

```go
func main() {
    var ptr *struct{}
    var iface interface{}
    iface = ptr
    
    fmt.Printf("iface == nil: %v\n", iface == nil)
    fmt.Printf("iface type: %T, value: %v\n", iface, iface)
}
```

Это выведет:
```
iface == nil: false
iface type: *struct {}, value: <nil>
```

### А как тогда проверить iface на то что он пустой и nil?

```golang
func main() {
    var ptr *struct{}
    var iface interface{}
    iface = ptr
    
    // Способ 1: Проверка через reflect
    if reflect.ValueOf(iface).IsNil() {
        fmt.Println("Value is nil")
    }
    
    // Способ 2: Type assertion и проверка конкретного типа
    if p, ok := iface.(*struct{}); ok && p == nil {
        fmt.Println("Pointer is nil")
    }    
}
```

## Пример использования libp2p для синхронизации папок

```go
package main

import (
    "bufio"
    "context"
    "crypto/rand"
    "flag"
    "fmt"
    "io"
    "log"
    "os"
    "path/filepath"
    "sync"
    "time"

    "github.com/libp2p/go-libp2p"
    "github.com/libp2p/go-libp2p-core/crypto"
    "github.com/libp2p/go-libp2p-core/host"
    "github.com/libp2p/go-libp2p-core/network"
    "github.com/libp2p/go-libp2p-core/peer"
    "github.com/libp2p/go-libp2p-core/protocol"
    dht "github.com/libp2p/go-libp2p-kad-dht"
    "github.com/multiformats/go-multiaddr"
)

const (
    protocol1        = "/sync/1.0.0"
    syncInterval     = 30 * time.Second
    folderPermission = 0755
)

type FileSync struct {
    host       host.Host
    dht        *dht.IpfsDHT
    targetPeer peer.ID
    syncFolder string
    mutex      sync.Mutex
}

func main() {
    // Флаги командной строки
    syncFolder := flag.String("folder", "", "Folder to sync")
    targetPeer := flag.String("peer", "", "Target peer multiaddr")
    flag.Parse()

    if *syncFolder == "" {
        log.Fatal("Please specify folder to sync")
    }

    // Создаем контекст
    ctx := context.Background()

    // Создаем новый узел libp2p
    prvKey, _, err := crypto.GenerateKeyPairWithReader(crypto.RSA, 2048, rand.Reader)
    if err != nil {
        log.Fatal(err)
    }

    h, err := libp2p.New(
        libp2p.ListenAddrStrings("/ip4/0.0.0.0/tcp/0"),
        libp2p.Identity(prvKey),
        libp2p.EnableNATService(),
        libp2p.EnableRelay(),
        libp2p.EnableAutoRelay(),
    )
    if err != nil {
        log.Fatal(err)
    }

    // Создаем DHT
    kadDHT, err := dht.New(ctx, h)
    if err != nil {
        log.Fatal(err)
    }

    // Создаем объект синхронизации
    fs := &FileSync{
        host:       h,
        dht:        kadDHT,
        syncFolder: *syncFolder,
    }

    // Устанавливаем обработчик протокола
    h.SetStreamHandler(protocol1, fs.handleStream)

    // Подключаемся к целевому пиру если указан
    if *targetPeer != "" {
        maddr, err := multiaddr.NewMultiaddr(*targetPeer)
        if err != nil {
            log.Fatal(err)
        }

        peerInfo, err := peer.AddrInfoFromP2pAddr(maddr)
        if err != nil {
            log.Fatal(err)
        }

        fs.targetPeer = peerInfo.ID

        if err := h.Connect(ctx, *peerInfo); err != nil {
            log.Fatal(err)
        }
    }

    // Запускаем периодическую синхронизацию
    go fs.periodicSync()

    // Выводим адрес узла
    for _, addr := range h.Addrs() {
        fmt.Printf("Address: %s/p2p/%s\n", addr, h.ID().Pretty())
    }

    // Ожидаем прерывания
    select {}
}

func (fs *FileSync) handleStream(s network.Stream) {
    defer s.Close()

    fs.mutex.Lock()
    defer fs.mutex.Unlock()

    reader := bufio.NewReader(s)
    writer := bufio.NewWriter(s)

    // Получаем список файлов
    files, err := fs.getFileList()
    if err != nil {
        log.Printf("Error getting file list: %v", err)
        return
    }

    // Отправляем список файлов
    for _, file := range files {
        fmt.Fprintf(writer, "%s\n", file)
    }
    writer.Flush()

    // Получаем список файлов от другой стороны
    remoteFiles := make(map[string]bool)
    for {
        file, err := reader.ReadString('\n')
        if err == io.EOF {
            break
        }
        if err != nil {
            log.Printf("Error reading remote files: %v", err)
            return
        }
        remoteFiles[file[:len(file)-1]] = true
    }

    // Синхронизируем файлы
    for _, file := range files {
        if !remoteFiles[file] {
            // Отправляем файл
            if err := fs.sendFile(writer, file); err != nil {
                log.Printf("Error sending file %s: %v", file, err)
                continue
            }
        }
    }
}

func (fs *FileSync) getFileList() ([]string, error) {
    var files []string
    err := filepath.Walk(fs.syncFolder, func(path string, info os.FileInfo, err error) error {
        if err != nil {
            return err
        }
        if !info.IsDir() {
            relPath, err := filepath.Rel(fs.syncFolder, path)
            if err != nil {
                return err
            }
            files = append(files, relPath)
        }
        return nil
    })
    return files, err
}

func (fs *FileSync) sendFile(writer *bufio.Writer, filename string) error {
    file, err := os.Open(filepath.Join(fs.syncFolder, filename))
    if err != nil {
        return err
    }
    defer file.Close()

    _, err = io.Copy(writer, file)
    return err
}

func (fs *FileSync) periodicSync() {
    ticker := time.NewTicker(syncInterval)
    for range ticker.C {
        if fs.targetPeer != "" {
            s, err := fs.host.NewStream(context.Background(), fs.targetPeer, protocol1)
            if err != nil {
                log.Printf("Error creating stream: %v", err)
                continue
            }
            fs.handleStream(s)
        }
    }
}
```

Чтобы использовать эту программу:

1. Установите необходимые зависимости:
```bash
go get github.com/libp2p/go-libp2p
go get github.com/libp2p/go-libp2p-kad-dht
```

2. Запустите программу на первом компьютере:
```bash
go run main.go -folder /path/to/sync/folder
```

3. Скопируйте выведенный адрес и запустите на втором компьютере:
```bash
go run main.go -folder /path/to/sync/folder -peer <address_from_first_computer>
```

Особенности программы:

1. Использует libp2p для P2P-коммуникации
2. Поддерживает NAT traversal
3. Периодически синхронизирует файлы между узлами
4. Использует протокол DHT

## Сравнение в golang

Если ваши байт-слайсы (или строки) содержат текстовые данные, то, когда понадобится сравнить значения без учёта регистра, вы можете использовать ToUpper() или ToLower() из пакетов bytes и strings (прежде чем прибегнуть к ==, bytes.Equal() или bytes.Compare()). Это сработает для англоязычных текстов, но не для многих других языков. Так что лучше выбрать strings.EqualFold() и bytes.EqualFold().

Если ваши байт-слайсы содержат секретные данные (криптографические хеши, токены и т. д.), которые нужно сравнивать с предоставленной пользователями информацией, обойдитесь без reflect.DeepEqual(), bytes.Equal() или bytes.Compare(). Эти функции сделают приложение уязвимым к атакам по времени. Чтобы избежать утечки информации о времени, используйте функции из пакета crypto/subtle (например, subtle.ConstantTimeCompare()).

## Сравнение struct, array, slice и map

Можно использовать оператор эквивалентности `==` для сравнения переменных структур, если каждое поле структуры можно сравнить с помощью этого оператора.

```go
package main

import "fmt"

type data struct {
    num     int
    fp      float32
    complex complex64
    str     string
    char    rune
    yes     bool
    events  <-chan string
    handler interface{}
    ref     *byte
    raw     [10]byte
}

func main() {
    v1 := data{}
    v2 := data{}
    fmt.Println("v1 == v2:", v1 == v2) // выводит: v1 == v2: true
}
```

Если хоть одно из полей несравниваемо, то применение оператора эквивалентности приведёт к ошибке компилирования. Обратите внимание, что сравнивать массивы можно только тогда, когда сравниваемы их данные.

```go
package main

import "fmt"

type data struct {
    num    int                // ok
    checks [10]func() bool   // несравниваемо
    doit   func() bool       // несравниваемо
    m      map[string]string // несравниваемо
    bytes  []byte           // несравниваемо
}

func main() {
    v1 := data{}
    v2 := data{}
    fmt.Println("v1 == v2:", v1 == v2)
}
```

Go предоставляет несколько вспомогательных функций для сравнения переменных, которые нельзя сравнивать с помощью операторов сравнения.

Самое популярное решение: использовать функцию `DeepEqual()` из пакета reflect.

```go
package main

import (
    "fmt"
    "reflect"
)

type data struct {
    num    int                // ok
    checks [10]func() bool   // несравниваемо
    doit   func() bool       // несравниваемо
    m      map[string]string // несравниваемо
    bytes  []byte           // несравниваемо
}

func main() {
    v1 := data{}
    v2 := data{}
    fmt.Println("v1 == v2:", reflect.DeepEqual(v1, v2)) // prints: v1 == v2: true

    m1 := map[string]string{"one": "a", "two": "b"}
    m2 := map[string]string{"two": "b", "one": "a"}
    fmt.Println("m1 == m2:", reflect.DeepEqual(m1, m2)) // prints: m1 == m2: true

    s1 := []int{1, 2, 3}
    s2 := []int{1, 2, 3}
    fmt.Println("s1 == s2:", reflect.DeepEqual(s1, s2)) // prints: s1 == s2: true
}
```

Помимо невысокой скорости (что может быть критично для вашего приложения), `DeepEqual()` имеет свои собственные подводные камни.

```go
package main

import (
    "fmt"
    "reflect"
)

func main() {
    var b1 []byte = nil
    b2 := []byte{}
    fmt.Println("b1 == b2:", reflect.DeepEqual(b1, b2)) // prints: b1 == b2: false
}
```

`DeepEqual()` не считает пустой слайс эквивалентным `nil`-слайсу. Это поведение отличается от того, что вы получите при использовании функции `bytes.Equal()`: она считает эквивалентными `nil` и пустые слайсы.

```go
package main

import (
    "fmt"
    "bytes"
)

func main() {
    var b1 []byte = nil
    b2 := []byte{}
    fmt.Println("b1 == b2:", bytes.Equal(b1, b2)) // prints: b1 == b2: true
}
```

`DeepEqual()` не всегда идеальна при сравнении слайсов.

```go
package main

import (
    "fmt"
    "reflect"
    "encoding/json"
)

func main() {
    var str string = "one"
    var in interface{} = "one"
    fmt.Println("str == in:", str == in, reflect.DeepEqual(str, in))
    //prints: str == in: true true

    v1 := []string{"one", "two"}
    v2 := []interface{}{"one", "two"}
    fmt.Println("v1 == v2:", reflect.DeepEqual(v1, v2))
    //prints: v1 == v2: false (not ok)

    data := map[string]interface{}{
        "code":  200,
        "value": []string{"one", "two"},
    }
    encoded, _ := json.Marshal(data)
    var decoded map[string]interface{}
    json.Unmarshal(encoded, &decoded)
    fmt.Println("data == decoded:", reflect.DeepEqual(data, decoded))
    //prints: data == decoded: false (not ok)
}
```

## Переменные стека и кучи

Не всегда известно, находится ли переменная в стеке или в куче. Если в С++ создать переменную с помощью оператора new, то она всегда будет в куче. В Go место размещения переменной выбирает компилятор, даже если используются функции new() или make(). Компилятор делает выбор на основании размера и результата «анализа локальности» (escape analysis). Это также означает, что можно возвращать ссылки на локальные переменные, что недопустимо в других языках, например в С и С++.

Если вы хотите знать, где находятся переменные, то передайте -gcflags -m в go build или go run (например, go run -gcflags -m app.go).

## Изменение порядка операций чтения и записи

Go может менять порядок некоторых операций, но общее поведение внутри горутины, где это происходит, не меняется. Однако сказанное не относится к порядку исполнения самих горутин.

```go
package main

import (  
    "runtime"
    "time"
)

var _ = runtime.GOMAXPROCS(3)

var a, b int

func u1() {  
    a = 1
    b = 2
}

func u2() {  
    a = 3
    b = 4
}

func p() {  
    println(a)
    println(b)
}

func main() {  
    go u1()
    go u2()
    go p()
    time.Sleep(1 * time.Second)
}
```

Если запустить этот код несколько раз, то можно увидеть такие комбинации переменных `a` и `b`:

```
1 
2

3 
4

0 
2

0 
0

1 
4
```

Самая интересная комбинация — `0 2` — говорит о том, что `b` была обновлена раньше `a`.

**Важно**: Если нужно сохранить порядок операций чтения и записи среди нескольких горутин, то используйте каналы или соответствующие конструкции из пакета `sync`.

## Аббревиатура GMP в golang?

В Golang аббревиатура **GMP** относится к планировщику (scheduler) и обозначает три основных компонента:

- **G** - Goroutines
  - Легковесные единицы выполнения
  - Функции, которые выполняются конкурентно
  - Занимают около 2KB памяти каждая

- **M** - Machine / OS Thread
  - Реальные потоки операционной системы
  - Выполняют goroutines
  - По умолчанию количество = количеству CPU ядер (GOMAXPROCS)

- **P** - Processor
  - Связывает M и G
  - Содержит очередь готовых к выполнению goroutines
  - По умолчанию количество = GOMAXPROCS

GMP модель обеспечивает:
- Эффективное планирование goroutines
- Балансировку нагрузки
- Масштабируемость приложений