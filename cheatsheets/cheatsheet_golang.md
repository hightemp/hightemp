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

