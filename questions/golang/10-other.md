### Какой будет результат и какая будет cap у этих слайсов

```go
a1 := make([]int, 0)
a1 = append(a1, []int{1,2,3,4,5}...)
a2 := append(a1, 6)
a3 := append(a1, 7)

fmt.Println(a1,a2,a3)
```

```
правильный ответ:

[1 2 3 4 5] [1 2 3 4 5 7] [1 2 3 4 5 7]
a1: 6
a2: 6
a3: 6
```

### Какой будет вывод

```go
package main
import "fmt"

type I interface{}
type S struct{}

func main() {
    var i I
    var s *S
    fmt.Println(s, i) // nil nil
    fmt.Println(s == nil, i == nil, s == i) 
    i = s
    fmt.Println(s, i) // nil nil
    fmt.Println(s == nil, i == nil, s == i) 
}
```

```
t,t,f: Они равны, но на самом деле — нет.
t,f,t: Они не равны, но при этом — равны.
```

```
<nil> <nil>
true true false
<nil> <nil>
true false true
```

### Что выведет код

```go
package main

import "fmt"

func foo(a []string) {
	a = append(a, "NIGHTMARE")
}

func main() {
	a := []string{"hello", "world", "!"}
	foo(a[:1])
	fmt.Println(a)
}
```

```
[hello NIGHTMARE !]
```