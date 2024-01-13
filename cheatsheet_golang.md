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

Вместо этого мы можем использовать go-playground/formдля обработки данных формы

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

