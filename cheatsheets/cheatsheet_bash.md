
### Как в bash разбить строку по символу?

1. Разбить строку по пробелу:

```bash
string="Hello world how are you"; for word in $string; do echo "$word"; done
```

2. Разбить строку по запятой:

```bash
IFS=',' read -ra fruits <<< "apple,banana,orange,grape"; for fruit in "${fruits[@]}"; do echo "$fruit"; done
```

3. Разбить строку по произвольному символу (например, по точке с запятой):

```bash
IFS=';' read -ra values <<< "value1;value2;value3;value4"; for value in "${values[@]}"; do echo "$value"; done
```
