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
