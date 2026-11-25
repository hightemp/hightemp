## Базовый синтаксис

```
find [путь...] [выражение]
```

- путь по умолчанию — текущая директория (`.`);
- без действия результат печатается (`-print` подразумевается);
- условия в выражении объединяются по И, для ИЛИ используется `-o`.

```bash
find .                      # всё дерево от текущей директории
find /var/log -name '*.log' # файлы *.log в /var/log
```

## Поиск по имени

```bash
find . -name 'file.txt'        # точное имя, регистрозависимо
find . -iname 'readme*'        # без учёта регистра
find . -name '*.log'           # по шаблону (glob)
find . -regex '.*\.(jpe?g|png)' # по регулярному выражению (путь целиком)
find . -path '*/cache/*'       # по шаблону пути
```

## Поиск по типу

```bash
find . -type f   # обычные файлы
find . -type d   # директории
find . -type l   # символические ссылки
find . -type s   # сокеты
find . -type p   # именованные каналы (FIFO)
find . -type b   # блочные устройства
find . -type c   # символьные устройства
```

## Поиск по размеру

Единицы: `c` — байты, `k` — КиБ, `M` — МиБ, `G` — ГиБ. Префикс `+` — больше, `-` — меньше, без префикса — ровно.

```bash
find . -size +100M     # больше 100 МиБ
find . -size -10k      # меньше 10 КиБ
find . -size 1M        # ровно 1 МиБ
find . -size +1G -type f
find . -empty          # пустые файлы и директории
```

## Поиск по времени

`-mmin` / `-mtime` — изменение содержимого, `-amin` / `-atime` — доступ, `-cmin` / `-ctime` — изменение метаданных (inode). `min` — в минутах, `time` — в сутках (округление вниз). `+N` — больше N, `-N` — меньше N.

```bash
find . -mmin -60          # изменены за последний час
find . -mtime -7          # изменены за последние 7 дней
find . -mtime +30         # не менялись больше 30 дней
find . -newer reference.txt          # новее указанного файла
find . -newermt '2025-01-01'         # изменены после даты
find . -newermt '2025-01-01' ! -newermt '2025-02-01'  # за январь 2025
```

## Поиск по владельцу и правам

```bash
find . -user user          # по владельцу
find . -group devs         # по группе
find . -uid 1000           # по UID
find . -nouser             # владелец отсутствует в /etc/passwd
find . -perm 644           # ровно такие права
find . -perm -644          # все указанные биты установлены
find . -perm /111          # любой из битов исполнения (исполняемые)
find . -perm -u+s          # с SUID
find . -perm -g+s          # с SGID
```

## Глубина и обход

```bash
find . -maxdepth 1 -type f   # только текущий уровень
find . -mindepth 2           # пропустить первый уровень
find . -depth                # обход снизу вверх (нужно для -delete)
find . -follow               # следовать по символическим ссылкам
find . -xdev                 # не переходить на другие ФС
find . -name build -prune -o -name '*.c' -print   # исключить каталог build
```

## Действия над найденным

```bash
find . -name '*.tmp' -print            # напечатать (по умолчанию)
find . -name '*.tmp' -print0           # разделитель NUL — для xargs -0
find . -name '*.log' -ls               # подробный вывод
find . -name '*.tmp' -delete           # удалить (осторожно, работает с -depth)
find . -name '*.sh' -exec chmod +x {} \;          # выполнить для каждого файла
find . -name '*.sh' -exec chmod +x {} +           # пакетно, одним вызовом
find . -name '*.tmp' -ok rm {} \;                 # с подтверждением
find . -type f -name '*.txt' -exec grep -l 'TODO' {} \;
```

### Отличие `\;` и `+` в `-exec`

- `{} \;` — команда запускается отдельно для каждого найденного файла;
- `{} +` — find набирает список файлов и передаёт его одной команде (быстрее).

### find + xargs

```bash
find . -name '*.log' -print0 | xargs -0 rm          # безопасно для имён с пробелами
find . -name '*.c' -print0 | xargs -0 grep -n 'main'
```

`-print0`/`xargs -0` защищают от имён с пробелами и переводами строк.

## Логические операторы

```bash
find . -name '*.jpg' -o -name '*.png'          # ИЛИ
find . -type f ! -name '*.log'                 # НЕ
find . \( -name '*.jpg' -o -name '*.png' \) -size +1M   # группировка скобками
```

Скобки в шелле экранируются: `\(` и `\)`.

## Готовые рецепты

```bash
# большие файлы, отсортированные по размеру
find / -type f -size +500M -exec du -h {} + 2>/dev/null | sort -rh

# файлы, изменённые за последние сутки, без каталогов .git
find . -path ./.git -prune -o -type f -mtime -1 -print

# найти и удалить пустые директории
find . -type d -empty -delete

# все исполняемые файлы с SUID (потенциально опасные)
find / -perm -u+s -type f 2>/dev/null

# посчитать количество файлов по расширениям
find . -type f | sed 's/.*\.//' | sort | uniq -c | sort -rn

# синхронизировать найденное с сохранением путей
find . -name '*.conf' -exec cp --parents {} /backup/ \;
```

## Частые ошибки

- `find . -name *.log` без кавычек — шелл раскроет glob до find; пишите `-name '*.log'`.
- `-delete` молча удаляет; сначала проверяйте выражение без `-delete`.
- `-prune` требует явного `-print` в другой ветке: `find . -path ./node_modules -prune -o -name '*.js' -print`.
- `-perm 644` ищет точное совпадение, для «есть все биты» нужен `-perm -644`.

## Рецепты для Node.js

```bash
# все package.json, исключая node_modules
find . -path '*/node_modules' -prune -o -name package.json -print

# суммарный размер node_modules по каждому проекту
find . -name node_modules -type d -prune -exec du -sh {} + | sort -rh

# освободить место: удалить все node_modules (сначала посмотреть без -exec)
find ~/Projects -name node_modules -type d -prune
find ~/Projects -name node_modules -type d -prune -exec rm -rf {} +

# каталоги сборок и кэшей для очистки
find . \( -name dist -o -name build -o -name .next -o -name .nuxt -o -name .turbo -o -name .cache \) -type d -prune

# lock-файлы и менеджеры пакетов в монорепе
find . -path '*/node_modules' -prune -o \( -name package-lock.json -o -name yarn.lock -o -name pnpm-lock.yaml \) -print

# .env и другие файлы с секретами, которые не должны попасть в git
find . -path '*/node_modules' -prune -o -name '.env*' -print

# исходники, изменённые за последний час (что я на самом деле правил?)
find . -path '*/node_modules' -prune -o -type f \( -name '*.js' -o -name '*.ts' \) -mmin -60 -print

# найти забытые console.log и debugger
find . -path '*/node_modules' -prune -o -type f -name '*.ts' -exec grep -nE 'console\.log|debugger' {} +

# большие файлы внутри проекта, не считая зависимостей
find . -path '*/node_modules' -prune -o -type f -size +10M -exec du -h {} + | sort -rh

# все tsconfig/jsconfig
find . -path '*/node_modules' -prune -o \( -name 'tsconfig*.json' -o -name jsconfig.json \) -print
```

## Рецепты для PHP

```bash
# все composer.json, исключая vendor
find . -path '*/vendor' -prune -o -name composer.json -print

# размер vendor по проектам
find . -name vendor -type d -prune -exec du -sh {} + | sort -rh

# удалить все vendor (сначала посмотреть без -exec)
find ~/Projects -name vendor -type d -prune
find ~/Projects -name vendor -type d -prune -exec rm -rf {} +

# кэши и логи Symfony
find . -path '*/vendor' -prune -o \( -path '*/var/cache/*' -o -path '*/var/log/*' \) -print

# кэши и скомпилированные шаблоны Laravel
find . \( -path '*/storage/framework/cache/*' -o -path '*/storage/framework/views/*' -o -path '*/storage/logs/*' \) -print

# .env и прочие файлы с секретами
find . -path '*/vendor' -prune -o -name '.env*' -print

# недавно изменённые PHP-файлы без vendor
find . -path '*/vendor' -prune -o -type f -name '*.php' -mmin -60 -print

# потенциальные веб-шеллы: eval, base64_decode, gzinflate, shell_exec
find . -path '*/vendor' -prune -o -type f -name '*.php' -exec grep -lE 'eval\(|base64_decode\(|gzinflate\(|shell_exec\(' {} +

# подозрительные PHP-файлы в каталогах загрузок (их там быть не должно)
find ./public/uploads ./storage/app/public -type f -name '*.php' 2>/dev/null

# файлы с избыточными правами (777, 666)
find . -path '*/vendor' -prune -o \( -perm 0777 -o -perm 0666 \) -print

# файлы, принадлежащие не тому пользователю (например, после запуска от root)
find . -path '*/vendor' -prune -o ! -user www-data -print

# большие логи для ротации
find . -path '*/vendor' -prune -o -type f -name '*.log' -size +100M -exec du -h {} + | sort -rh
```
