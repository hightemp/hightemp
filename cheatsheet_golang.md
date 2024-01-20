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


