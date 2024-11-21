
### Коллекции

- https://dev.to/t/go
- https://medium.com/tag/golang/archive
- https://go.libhunt.com/
- https://github.com/avelino/awesome-go
- https://awesome-go.com/
- https://github.com/uhub/awesome-go
- Design patterns https://github.com/tmrts/go-patterns
- https://github.com/wangrenjun/awesome-go-blogs
- GoDS (Go Data Structures) https://github.com/emirpasic/gods
- https://github.com/betty200744/ultimate-go
- Reverse Engineering Golang https://gist.github.com/0xdevalias/4e430914124c3fd2c51cb7ac2801acba
- Go Lang Reverse Engineering Resources/Links https://gist.github.com/alexander-hanel/59af86b0154df44a2c9cebfba4996073
- https://github.com/dariubs/GoBooks
- https://bitfieldconsulting.com/posts/best-go-books
- https://mehdihadeli.github.io/awesome-go-education/clean-architecture/
- https://github.com/gostor/awesome-go-storage
- Проект представляет собой коллекцию 22 популярных паттернов проектирования с примерами на языке Go, кратким описанием каждого паттерна и возможностью скачать репозиторий для запуска тестов. https://github.com/AlexanderGrom/go-patterns

### Песочницы

- https://goplay.space/
- https://go.dev/play/
- https://goplay.tools/
- https://www.boot.dev/playground/go
- https://verytools.net/go-playground

### Упражнения

- https://github.com/cblte/100-golang-exercises
- Проект представляет собой сборник задач по программированию на языке Go, где участники решают различные алгоритмические и практические задачи, реализуя функции, проходя тесты и соревнуясь за наиболее элегантные и эффективные решения. https://github.com/plutov/practice-go
- https://github.com/bregman-arie/go-exercises
- https://github.com/inancgumus/learngo
  - https://github.com/inancgumus/gobyexample

### VIM

- https://github.com/fatih/vim-go

### Style-guides

- https://github.com/thanos-io/thanos/blob/main/docs/contributing/coding-style-guide.md

### Roadmaps

- https://roadmap.sh/golang
- https://github.com/darius-khll/golang-developer-roadmap
- https://github.com/baselrabia/Golang-Roadmap

### Вопросы

- Подробный разбор задач https://github.com/alivewel/sber-tasks
- Go — 100 вопросов/заданий с собеседований
  - https://habr.com/ru/articles/786826/ 
      - https://web.archive.org/web/20240201014633/https://habr.com/ru/articles/786826/
      - https://github.com/hightemp/hightemp/blob/main/notes/computer_science/backend/golang/articles/go-100-interview-questions-and-tasks.md

### Библиотеки

- cli
  - Парсер командной строки
    - "Kingpin" - это проект на Go (golang), представляющий собой парсер командной строки и атрибутов, который поддерживает флаги, вложенные команды и позиционные аргументы, предлагая пользовательские решения и обширные возможности по настройке помощи через шаблоны Go, и который в настоящее время поддерживается только через вклады сообщества. https://github.com/alecthomas/kingpin
    - urfave/cli - это мощный и гибкий пакет на Go для создания инструментов командной строки, предлагающий широкий набор функций, включая поддержку команд и подкоманд, динамическое автодополнение для различных оболочек, отсутствие зависимостей и генерацию документации. https://github.com/urfave/cli
- Остальное
  - go-linq - это мощная библиотека для языка Go, реализующая интегрированный язык запросов (LINQ) с ленивым выполнением, поддержкой параллельного использования и различных типов коллекций. https://github.com/ahmetb/go-linq
  - LiveKit - это открытый проект, предоставляющий масштабируемую многопользовательскую платформу для конференций на основе WebRTC, который включает в себя все необходимое для создания возможностей передачи видео, аудио и данных в реальном времени в ваших приложениях. https://github.com/livekit/livekit
  - Проект goex представляет собой унифицированный и стандартизированный интерфейс для взаимодействия с различными платформами криптовалютной торговли. https://github.com/nntaoli-project/GoEx
  - go-finance - это библиотека на Go, предоставляющая набор финансовых функций для расчетов временной стоимости денег, денежных потоков, конвертации процентных ставок, облигаций и амортизации. https://github.com/alpeb/go-finance
  - Проект "lgo" представляет собой ядро Jupyter Notebook для языка Go (golang) и интерактивный REPL, позволяющий писать и выполнять код Go интерактивно, с поддержкой полной спецификации языка и интеграцией с Jupyter Notebook. https://github.com/yunabe/lgo
  - Watermill - это библиотека Go для эффективной работы с потоками сообщений, предназначенная для создания приложений, управляемых событиями, с использованием различных технологий публикации/подписки и обладающая такими характеристиками, как простота понимания, универсальность, быстродействие, гибкость и устойчивость. https://github.com/ThreeDotsLabs/watermill
  - FAIR - это библиотека на Go, которая обеспечивает справедливое распределение ограниченных ресурсов (таких как пропускная способность базы данных или хранилища) между множеством клиентов во время нехватки ресурсов, используя модифицированный алгоритм Stochastic Fair BLUE и многоуровневую структуру данных Bloom Filter для предотвращения перераспределения и истощения на основе поведения клиентов. https://github.com/satmihir/fair/
- Сеть
  - SSH
    - goscp - это Go-пакет для простого и безопасного копирования файлов через протокол SCP с использованием SSH-соединения. https://github.com/bramvdbogaerde/go-scp
    - scp - это реализованный на языке Go протокол для безопасного копирования файлов через SSH, позволяющий передавать файлы и директории между локальным и удаленным хостами с сохранением прав доступа и временных меток. https://github.com/povsister/scp
  - Proxy
    - SOCKS5
      - go-socks5 - это реализация SOCKS5-сервера на языке Go, предоставляющая возможность маршрутизации трафика между клиентом и сервером через промежуточный прокси-слой с поддержкой различных методов аутентификации, фильтрации команд и пользовательского разрешения DNS. https://github.com/armon/go-socks5
    - Остальное
      - Проект GoProxy - это настраиваемая библиотека HTTP-прокси для Go, которая поддерживает обычный HTTP-прокси, HTTPS через CONNECT и "перехват" HTTPS-соединений с использованием атаки типа "человек посередине", предназначенная для обработки значительного трафика с возможностью кастомизации и программирования. https://github.com/elazarl/goproxy
  - gRPC
    - FauxRPC - это инструмент для ускорения разработки и тестирования, который позволяет легко создавать фейковые реализации сервисов gRPC, gRPC-Web, Connect и REST на основе protobuf-спецификаций. https://github.com/sudorandom/fauxrpc
  - Остальное
    - afs - это библиотека на Go, предоставляющая единый абстрактный интерфейс для работы с различными системами хранения данных (локальная файловая система, облачное хранилище, SCP, контейнеры), включая базовые CRUD-операции и возможность тестирования обработки ошибок. https://github.com/viant/afs/
- htmlx
  - htmgo - это легковесный фреймворк на Go для создания интерактивных веб-приложений, использующий HTMX для добавления динамического поведения без JavaScript и компилирующийся в единый исполняемый файл. https://github.com/maddalax/htmgo
- Middleware
  - Negroni - это минималистичная Go-библиотека для создания цепочек HTTP-middleware, совместимая со стандартным пакетом net/http и популярными роутерами. https://github.com/urfave/negroni
  - Alice - это библиотека на Go, которая предоставляет удобный способ объединения HTTP-middleware функций и обработчика приложения в цепочку, упрощая процесс их композиции. https://github.com/justinas/alice
- OpenAPI
  - Проект libopenapi представляет собой набор высококачественных инструментов для работы с OpenAPI (включая Swagger, OpenAPI 3 и OpenAPI 3.1) в языке программирования Go, предназначенных для обработки самых крупных и сложных спецификаций. https://github.com/pb33f/libopenapi
  - https://github.com/getkin/kin-openapi
- Базы данных
  - Генераторы
    - sqlc - это компилятор SQL, который генерирует типобезопасный код на основе SQL-запросов, позволяя разработчикам писать запросы на SQL, автоматически создавать типобезопасные интерфейсы для этих запросов и использовать сгенерированный код в своих приложениях. https://github.com/sqlc-dev/sqlc
    - SQLBoiler - это инструмент для генерации ORM на Go, адаптированного под схему вашей базы данных, который использует подход "сначала база данных" и предлагает производительность, типобезопасность и удобство использования, сравнимое с ActiveRecord. https://github.com/volatiletech/sqlboiler
  - Остальное
    - https://github.com/go-sql-driver/mysql
    - https://github.com/lib/pq
    - https://github.com/mattn/go-sqlite3
    - Проект sqlx представляет собой библиотеку, расширяющую стандартную библиотеку database/sql в Go, предоставляя дополнительные функции для работы с базами данных, такие как маршалинг строк в структуры, поддержка именованных параметров и удобные методы для быстрого получения данных из запросов. https://github.com/jmoiron/sqlx
    - Squirrel - это завершенный проект на Go, представляющий собой генератор SQL-запросов с удобным и гибким синтаксисом, который позволяет создавать сложные запросы из составных частей, поддерживает условное построение запросов и прямое выполнение их в базе данных. https://github.com/masterminds/squirrel
    - Проект "ent" - это мощный фреймворк для работы с сущностями в Go, который упрощает создание и поддержку приложений с большими моделями данных, предоставляя возможности схемы как кода, удобной навигации по графам, статической типизации, поддержки различных хранилищ данных и расширяемости. https://github.com/ent/ent
    - Jet - это комплексное решение для эффективного и высокопроизводительного доступа к базам данных, включающее типобезопасный конструктор SQL-запросов с генерацией кода и автоматическим маппингом результатов запросов, поддерживающее PostgreSQL, MySQL, CockroachDB, MariaDB и SQLite. https://github.com/go-jet/jet
- Парсинг
  - HTML
    - goquery - это библиотека для Go, напоминающая популярную JavaScript-библиотеку jQuery, предназначенная для работы с HTML-документами. https://github.com/PuerkitoBio/goquery
    - Colly - это молниеносно быстрый и элегантный фреймворк для веб-скрапинга на Go, предоставляющий чистый интерфейс для написания любого вида краулеров/скраперов/пауков, способных извлекать структурированные данные с веб-сайтов для различных приложений, таких как data mining, обработка данных или архивирование, с поддержкой автоматического управления куками, сессиями, задержками запросов, параллельного скрапинга, кэширования и распределенного скрапинга. https://github.com/gocolly/colly
- Браузеры
  - Проект chromedp представляет собой Go-пакет для более быстрого и простого управления браузерами, поддерживающими Chrome DevTools Protocol, без внешних зависимостей. https://github.com/chromedp/chromedp
- Утилиты
  - Goclone - утилита для скачивания веб-сайтов с Интернета в локальный каталог, позволяющая получить HTML, CSS, JS, изображения и другие файлы с сервера на компьютер, сохраняя исходную структуру относительных ссылок, чтобы можно было просматривать сайт в автономном режиме в браузере, как будто он находится в Интернете. https://github.com/imthaghost/goclone
- Конверторы
  - https://github.com/JohannesKaufmann/html-to-markdown
- Конфигурация
  - env
    - https://github.com/caarlos0/env
    - https://github.com/hashicorp/go-envparse
  - Viper - это мощная библиотека для Go, предоставляющая комплексное решение для управления конфигурацией приложений, поддерживающая различные форматы файлов, переменные окружения, удаленные системы конфигурации и множество других функций для гибкой настройки приложений. https://github.com/spf13/viper
  - Config - это многофункциональная библиотека на Go для управления конфигурацией приложений, поддерживающая различные форматы данных, загрузку из нескольких источников, привязку к структурам, обработку событий и множество других полезных возможностей. https://github.com/gookit/config
  - Allows to read configurations from different sources and combine all together in one structure. https://github.com/Mansiper/GoConfiguration
- Внедрение зависимостей
  - Fx - это система внедрения зависимостей для Go, предлагающая ряд преимуществ, включая устранение глобальных переменных, повышение переиспользуемости кода и надежность, подтвержденную широким использованием в сервисах Uber. https://github.com/uber-go/fx
- Безопасность
  - Санитайзеры
    - bluemonday - это быстрый и гибко настраиваемый HTML-санитайзер, реализованный на Go, который очищает пользовательский контент от потенциально опасных элементов, делая его безопасным для включения в веб-страницы. https://github.com/microcosm-cc/bluemonday
 - Встраиваемые языки программирования
   - Проект Common Expression Language (CEL) - это не полностью правильный язык программирования, созданный для простоты, скорости, безопасности и мобильности, с C-подобным синтаксисом, который почти идентичен аналогичным выражениям в C++, Go, Java и TypeScript, и предназначенный для легкой оценки выражений, когда полностью изолированный язык программирования слишком ресурсоемкий. https://github.com/google/cel-go
- Многопоточное программирование
  - lfmap - это универсальная конкурентная неблокирующая карта для Go, обеспечивающая итерацию по консистентному снимку без блокировки других потоков и поддерживающая удобные транзакции для чтения-записи нескольких ключей. https://github.com/Snawoot/lfmap

### Репозитории

- Консольный RSS ридер на #golang https://github.com/radulucut/cleed
- Домен для Go пакетов для gitflic.ru https://gohome.4gophers.ru/
- DBWeb - это веб-инструмент администрирования баз данных, подобный phpMyAdmin, написанный с использованием xorm, tango и nodb, поддерживающий MySQL, PostgreSQL и SQLite3. https://gitea.com/xorm/dbweb
- Проект "Glance" представляет собой легковесное и быстрое веб-приложение для создания персонализированной домашней страницы с различными виджетами, включая RSS-ленты, погоду, закладки, новости и другие полезные функции, оптимизированное для мобильных устройств и настраиваемое с помощью тем. https://github.com/glanceapp/glance
- Compiler written in Go for the Monkey language https://github.com/SaladinoBelisario/Compiler_Go
- GoHop - это проект VPN на языке Go, нацеленный на обход цензуры и интеллектуальной проверки пакетов путем использования встроенного шифрования, обфускации и "частотных скачков" портов и протоколов. https://github.com/bigeagle/gohop
- Проект Simple-VPN представляет собой написанный на Golang VPN-сервер, использующий веб-сокеты в качестве транспорта, который позволяет нескольким узлам, подключенным к центральному серверу, безопасно общаться друг с другом независимо от их местоположения. https://github.com/skx/simple-vpn
- Проект "approf" представляет собой нативное macOS-приложение для работы с профилями pprof, предлагающее удобный графический интерфейс с функциями сравнения профилей, управления файлами и поддержкой тёмного режима, что упрощает анализ производительности без необходимости использования командной строки. https://github.com/moderato-app/approf
- Tetrigo - это реализация классической игры Тетрис на языке программирования Golang, следующая официальным правилам дизайна Тетриса 2009 года и предоставляющая как готовый текстовый интерфейс для игры, так и возможность создания собственных игровых режимов и пользовательских интерфейсов. https://github.com/Broderick-Westrope/tetrigo
- Permify - это вдохновленный системой Google Zanzibar открытый проект по управлению детализированным контролем доступа, который позволяет быстро внедрять и масштабировать авторизацию в приложениях за считанные минуты вместо месяцев. https://github.com/Permify/permify
- Gokapi - это реализованный на языке Go поисковый движок на основе алгоритма Okapi BM25, который хранит данные на диске и позволяет осуществлять поиск среди миллионов документов без ограничений по памяти. https://github.com/raphaelsty/gokapi
- MTG - это эффективный MTPROTO-прокси для Telegram с открытым исходным кодом, написанный на Go, который отличается минималистичным подходом, использованием единого секретного ключа и отсутствием излишнего функционала для обеспечения простоты развертывания и эксплуатации. https://github.com/9seconds/mtg
- WireProxy - это приложение с открытым исходным кодом, работающее в пользовательском пространстве, которое подключается к пиру WireGuard и предоставляет SOCKS5/HTTP прокси или туннели без необходимости root-прав для маршрутизации определенного трафика через WireGuard. https://github.com/pufferffish/wireproxy
- This subrepository holds the source for the Go playground: https://go.dev/play/ https://github.com/golang/playground 
- Проект minimock представляет собой генератор типизированных моков для Go-интерфейсов, который полностью интегрирован с пакетом "testing", поддерживает дженерики, модули Go и табличные тесты, генерирует потокобезопасный код, проходящий проверки golangci-lint, и предоставляет удобные инструменты для установки ожиданий и верификации вызовов методов. https://github.com/gojuno/minimock
- prep - утилита, которая позаоляет выполнить функции во время сборки и заменить их на результат выполнения https://github.com/pijng/prep
- Twitter Scraper - это проект на Go для извлечения данных из Twitter (твитов, профилей пользователей и трендов) без использования официального API, путем обхода фронтенда Twitter, с возможностью масштабирования за счет покупки новых аккаунтов и прокси-серверов. https://github.com/imperatrona/twitter-scraper
- Данный проект представляет собой CLI и GUI инструмент для скачивания медиафайлов из Twitter без использования API-ключа, основанный на twitter-scrapper и позволяющий загружать до 3200 твитов. https://github.com/mmpx12/twitter-media-downloader

### Примеры приложений

- Anor - это полнофункциональное e-commerce приложение на Golang, HTMX и _hyperscript, вдохновленное Uzum, eBay и Zalando, использующее PostgreSQL, Redis и Typesense для хранения данных, кэширования и поиска. https://github.com/aliml92/anor

### Фреймворки

- Тестирование
  - go-mutesting - это фреймворк для Go, выполняющий мутационное тестирование исходного кода с целью обнаружения участков программы, не покрытых тестами, путем внесения небольших изменений (мутаций) в код и проверки реакции тестового набора на эти изменения.
- web
  - Простые веб-фреймворки
    - Atreugo - это высокопроизводительный и расширяемый микро-веб-фреймворк на основе fasthttp, обеспечивающий нулевое выделение памяти в критических путях и предлагающий широкий спектр функций, включая оптимизацию скорости, низкое использование памяти, поддержку middlewares, гибкую маршрутизацию и различные типы ответов. https://github.com/savsgio/atreugo
    - Fiber - это вдохновленный Express веб-фреймворк для Go, построенный на Fasthttp, предлагающий высокую производительность, низкое потребление памяти и удобный API для быстрой разработки веб-приложений. https://gofiber.io/
    - Gorilla web toolkit - это набор полезных и компонуемых пакетов для языка программирования Go, предназначенный для создания HTTP-приложений, включающий в себя инструменты для маршрутизации запросов, управления сессиями, работы с WebSocket и многое другое. https://gorilla.github.io/ https://github.com/gorilla/mux
    - Echo - это высокопроизводительный, расширяемый и минималистичный веб-фреймворк на Go, предоставляющий оптимизированный HTTP-роутер, поддержку RESTful API, группировку маршрутов, гибкую систему middleware, привязку данных, удобные функции для HTTP-ответов, централизованную обработку ошибок, рендеринг шаблонов и множество других возможностей для разработки современных веб-приложений. https://github.com/labstack/echo
    - GoFr - это opinionated фреймворк для разработки микросервисов на Go, который упрощает создание API, обеспечивает соблюдение REST-стандартов, предоставляет встроенную наблюдаемость и поддерживает различные функции, включая аутентификацию, gRPC, публикацию/подписку и миграцию баз данных. https://github.com/gofr-dev/gofr
  - Сложные веб-фреймворки
    - Revel - это гибкий веб-фреймворк для языка Go, предлагающий широкий спектр функций, включая горячую перезагрузку кода, маршрутизацию, валидацию, кэширование, интернационализацию и многое другое, что делает его мощным инструментом для разработки веб-приложений. https://revel.github.io/
    - Buffalo - это экосистема веб-разработки на Go, предоставляющая набор инструментов и функций для упрощения создания веб-приложений, включая маршрутизацию, ORM, шаблонизацию, горячую перезагрузку кода и многое другое. https://gobuffalo.io/
    - Goravel - это полнофункциональный и масштабируемый веб-фреймворк для Go, вдохновленный Laravel, который помогает разработчикам быстро создавать приложения, облегчая переход с PHP и приветствуя вклад сообщества в виде звезд, PR и issues на GitHub. https://www.goravel.dev/ https://github.com/goravel/framework
  - REST
    - The enterprise Golang REST API framework. Goyave is an opinionated all-in-one Golang web framework focused on REST APIs, with emphasis on code reliability, maintainability and developer experience. https://goyave.dev/
  - Микросервисы
    - Проект Go Micro представляет собой фреймворк для разработки распределенных систем, предоставляющий ключевые компоненты, такие как RPC и событийно-ориентированное взаимодействие, с философией разумных настроек по умолчанию и подключаемой архитектурой. https://github.com/micro/go-micro
- Мобильная разработка
  - Матча - это приложение для iOS и Android, написанное на языке Go, которое обеспечивает библиотеку компонентов пользовательского интерфейса, похожую на ReactNative, предоставляет доступ к кодам Objective-C и Java через отражение и содержит API для выполнения часто используемых задач приложения. https://github.com/gomatcha/matcha

#### GUI

- https://github.com/guark/guark Guark - это open-source фреймворк для создания кроссплатформенных настольных приложений с графическим интерфейсом, позволяющий разрабатывать логику на Go, а пользовательский интерфейс - с использованием современных веб-технологий, таких как Vue.js и React.js.
- https://gioui.org/ Gio - библиотека для написания кроссплатформенных GUI-приложений с использованием языка Go, поддерживающая все основные платформы: Linux, macOS, Windows, Android, iOS, FreeBSD, OpenBSD и WebAssembly.
- https://github.com/fyne-io/fyne Fyne - простой в использовании набор инструментов для создания пользовательского интерфейса и API приложений, написанный на Go. Предназначен для разработки приложений, работающих на рабочих столах и мобильных устройствах с использованием единого исходного кода.
- https://github.com/wailsapp/wails Wails - создавайте настольные приложения с использованием Go и веб-технологий, объединяя код на Go и веб-интерфейс в единый бинарный файл для удобства разработки и использования.
- https://github.com/aarzilli/nucular Nucular - библиотека для создания GUI на Go с поддержкой mostly-immediate-mode, представляющая порт ранней версии nuklear. Важно учитывать, что проект подвержен изменениям, несовместимым с предыдущими версиями, и запросы функций без соответствующей реализации не обслуживаются.

### Desktop Enviroment (DE)

- FyneDesk - это легкий в использовании рабочий стол для Linux/Unix, построенный на основе инструментария Fyne, следующий принципам материального дизайна и разработанный на языке Go с целью обеспечения простоты как в использовании, так и в разработке. https://github.com/FyshOS/fynedesk 

### Утилиты

- Альтернатива makefile - go-task https://taskfile.dev/
- Проект "go-cleanarch" представляет собой инструмент для проверки соблюдения правил Чистой архитектуры в проектах на языке Go, обеспечивающий независимость от фреймворков, тестируемость, гибкость пользовательского интерфейса и базы данных, а также соблюдение принципа зависимостей между модулями. https://github.com/roblaszczak/go-cleanarch

### Генераторы проекта

- https://autostrada.dev/#generate

### Операционные системы

- https://github.com/google/gvisor
- https://github.com/gopher-os/gopher-os
- https://github.com/SanseroGames/LetsGo-OS
- https://github.com/mit-pdos/biscuit
- https://github.com/fjballest/clive

### Полезные ссылки

- Go в примерах https://gobyexample.com.ru/
- Go Wiki: Iota https://go.dev/wiki/Iota
- Блог разработчиков https://go.dev/blog/all
- Схема golang проекта https://github.com/golang-standards/project-layout/blob/master/README_ru.md
- Golang как пройти собеседование. Полный разбор 100 вопросов https://pikabu.ru/story/golang_kak_proyti_sobesedovanie_polnyiy_razbor_100_voprosov_11074799
- https://draft.dev/learn/golang-blogs
- TOP 50 project ideas to become a golang hero https://dev.to/kumarkalyan/top-50-project-ideas-to-become-a-golang-hero-98k
- An example of a reasonably complex web server in Go. https://github.com/jordan-wright/http-boilerplate
- https://go101.org/
- 43 ресурса для изучения Golang в 2021 году: сайты, блоги, сообщества, курсы, каналы и книги https://proglib.io/p/43-resursa-dlya-izucheniya-golang-v-2021-godu-sayty-blogi-soobshchestva-kursy-kanaly-i-knigi-2021-07-20
- Go Implementation of WireGuard https://git.zx2c4.com/wireguard-go/about/
- Go.nvim - это современный плагин для Neovim, написанный на Lua, который предоставляет широкий набор функций для разработки на Go, включая интеграцию с treesitter, nvim-lsp и отладчиком dap, а также множество инструментов для работы с кодом, тестирования, отладки и рефакторинга. https://github.com/ray-x/go.nvim
- Этот проект представляет собой детально настроенную конфигурацию Neovim с множеством плагинов и функций, включая управление пакетами, мнемонические сочетания клавиш, улучшенный интерфейс, интеграцию с терминалом, поддержку AI и оптимизированную производительность, работающую как на NixOS Linux, так и на macOS. https://github.com/Allaman/nvim
- A collection of real world advice for writing maintainable Go programs. https://dave.cheney.net/practical-go
- Go Wiki: Go Code Review Comments https://go.dev/wiki/CodeReviewComments
- Этот проект демонстрирует реализацию Clean Architecture в Go, развивавшуюся через четыре версии (с 2017 по 2024 год), с акцентом на независимость бизнес-логики от внешних фреймворков, баз данных и UI, включающую четыре основных слоя: Models, Repository, Usecase и Delivery. https://github.com/bxcodec/go-clean-arch
- Проект GoDDD представляет собой попытку портирования примера DDD-приложения на язык Go с целью демонстрации тактических паттернов проектирования из предметно-ориентированного дизайна (Domain Driven Design) и служит примером современного корпоративного приложения, готового к промышленному использованию. https://github.com/marcusolsson/goddd
- Это обучающий проект по языку программирования Go, основанный на подходе разработки через тестирование (TDD), который включает в себя изучение фундаментальных концепций языка и создание полноценного приложения с использованием стандартной библиотеки. https://github.com/quii/learn-go-with-tests

### Курсы

- https://www.boot.dev/courses/learn-golang
- https://www.classcentral.com/report/best-go-courses/
- Top 10 Udemy Courses for Golang Developers in 2024 https://medium.com/javarevisited/top-10-udemy-courses-for-golang-developers-in-2023-fa157cceff8
- Go Class Matt KØDVB https://www.youtube.com/playlist?list=PLoILbKo9rG3skRCj37Kn5Zj803hhiuRK6
- Основы программирования на Golang (на индонезийском) https://dasarpemrogramangolang.novalagung.com/
- https://github.com/CodeYourFuture/immersive-go-course/

### Гайды

- Go Concurrency Guide https://github.com/luk4z7/go-concurrency-guide

### Шпаргалки

- https://quickref.me/go
- Go features by version https://antonz.org/which-go/
- https://refactoring.guru/design-patterns/go

### Книги

- Книга Калеба Докси «Введение в программирование на Go»
  - https://golang-book.ru/chapter-03-types.html
- Архивы книг
  - https://edu.anarcho-copy.org/Programming%20Languages/Go/
- The Go Programming Language (Alan A. A. Donovan, Brian W. Kernighan) 
  - http://www.cs.uniroma2.it/upload/2017/TSC/The%20Go%20Programming%20Language.pdf
  - https://vk.com/wall-69839157_767
- Go in Action (William Kennedy, Brian Ketelsen, Erik St. Martin)
  - https://books.awesee.cn/Go%2FGo%20In%20Action.pdf
- Go Web Programming. (2016) Sau Sheong Chang
  - https://edu.anarcho-copy.org/Programming%20Languages/Go/Go%20Web%20Programming.pdf
- Mastering Go (Mihalis Tsoukalos)
  - https://rutracker.org/forum/viewtopic.php?t=5929666
- Go Design Patterns: Best practices in software development and CSP (Castro Contreras) 
  - https://www.packtpub.com/en-us/product/go-design-patterns-9781786466204
- Full-Stack Web Development with Go. Nanik Tolaram, 2023 https://t.me/code_storage/756
- Practical Go Lessons https://www.practical-go-lessons.com/
- This document outlines best practices for writing high-performance Go code. https://github.com/dgryski/go-perfbook
- Go Optimizations 101 https://go101.org/optimizations/101.html
- Writing A Compiler In Go https://compilerbook.com/
- Go from the beginning https://github.com/softchris/golang-book/
- Common Go Mistakes https://100go.co/

### Статьи

- Описание языка
  - Основное
    - Fundamentals of I/O in Go https://medium.com/@andreiboar/fundamentals-of-i-o-in-go-c893d3714deb
    - Go Generics: Everything You Need To Know https://medium.com/the-godev-corner/go-generics-everything-you-need-to-know-52dd3796d8a1
    - Go range iterators demystified https://www.dolthub.com/blog/2024-07-12-golang-range-iters-demystified/
    - Go 1.23 Iterators Tutorial https://tutorialedge.net/golang/go-123-iterators-tutorial/
  - Типы
    - The differences between "Type Alias" and "New Types" in Go https://perfects.engineering/blog/go_alias_vs_new_types
    - All your comparable types https://go.dev/blog/comparable
  - Struct
    - Golang Field ordering matters? https://dev.to/aymanepraxe/golang-field-ordering-matters-2i6m
  - Внутреннее устройство
    - Внутреннее устройство sync.Map, сравнение производительности с map + RWMutex https://habr.com/ru/companies/karuna/articles/834400/
  - Каналы
    - Анатомия каналов в Go https://habr.com/ru/articles/490336/
  - Гоурутины, goroutines
    - Demystifying Golang Channels, Goroutines, and Optimal Concurrency https://levelup.gitconnected.com/golang-channels-goroutines-and-optimal-concurrency-demystifying-through-examples-a43ba6aee74f
  - Слайсы
    - Slices in Go: Grow Big or Go Home https://victoriametrics.com/blog/go-slice/index.html
  - Defer
    - Golang Defer: From Basic To Traps https://victoriametrics.com/blog/defer-in-go/index.html
  - Массивы
    - How Go Arrays Work and Get Tricky with For-Range https://victoriametrics.com/blog/go-array/index.html
  - Map
    - Вопросы по мэпам (map) в Go https://habr.com/ru/articles/854214/
  - Waitgroup
    - Go sync.WaitGroup and The Alignment Problem https://victoriametrics.com/blog/go-sync-waitgroup/index.html
  - JSON
    - Go: десериализация JSON с неправильной типизацией, или как обходить ошибки разработчиков API https://habr.com/ru/articles/502176/
  - Sync
    - Sync Package: What Are New Features in Golang sync.Once? https://reliasoftware.com/blog/new-features-in-golang-sync-once
    - Go sync.Map: The Right Tool for the Right Job https://victoriametrics.com/blog/go-sync-map/index.html
  - Mutex
    - Go sync.Mutex: Normal and Starvation Mode https://victoriametrics.com/blog/go-sync-mutex/
  - Unique
    - Остальное
      - Reduce allocations and comparison performance with the new unique package in Go 1.23 https://josephwoodward.co.uk/2024/08/performance-improvements-unique-package-go-1-23
      - Exploring the New Unique Package in Go 1.23 https://www.bytesizego.com/blog/go-1-23-unique-package
    - Interning
      - New unique package https://go.dev/blog/unique
      - Interning in Go https://medium.com/google-cloud/interning-in-go-4319ea635002
  - embed
    - Embedding files in Go using the "embed" package https://echorand.me/posts/go-embed/
  - plugin
    - Getting started with Go plugin package https://echorand.me/posts/getting-started-with-golang-plugins/
  - init
    - \[Memo\] Go init behavior https://articles.singee.me/go-init-behaviour
  - time
    - Do you really understand time.Now()? https://articles.singee.me/golang-time
    - Time in Golang - Working With Time, Duration, and Dates (With Examples) https://www.sohamkamani.com/golang/time/
    - Working With Time in Golang https://www.bytesizego.com/blog/golang-time
    - Comprehensive Guide to Dates and Times in Go https://dev.to/bootdotdev/comprehensive-guide-to-dates-and-times-in-go-dpn
  - Утилиты
    - Let's stop editing go.mod manually https://tpaschalis.me/go-mod-edit/
  - Остальное
    - Notes on Go https://echorand.me/posts/go-notes/
    - Shallow copy and Deep copy in Go https://echorand.me/posts/go-values-references-etc/
    - Named return values in Go https://echorand.me/posts/go-named-return-values/
    - Введение в систему модулей Go https://habr.com/ru/articles/421411/
    - Range Over Function Types https://go.dev/blog/range-functions
    - Preemption in Go: an introduction https://unskilled.blog/posts/preemption-in-go-an-introduction/
    - Пример создания Makefile для Go-приложений https://habr.com/ru/articles/461467/
    - Некоторые подводные грабли в языке Go https://eax.me/golang-gotchas/
- vim, nvim
  - My NeoVim Go(lang) setup — As good as Intellj/Goland IDE https://medium.com/@suyash10581108/my-neovim-go-lang-setup-as-good-as-intellj-goland-ide-d48dd765f6de
  - Configure Neovim for Golang https://andrewcourter.substack.com/p/configure-neovim-for-golang
- Логирование
  - Structured Logging In Go Using Standard Library - Slog https://programmingpercy.tech/blog/structured-logging-in-go-using-std-lib-slog/
- Валидация данных
  - Using Go Validator for Efficient Data Validation in Go Applications https://www.codingexplorations.com/blog/using-go-validator-for-efficient-data-validation-in-go-applications
- Оптимизация
  - Maps and memory leaks https://100go.co/28-maps-memory-leaks/
  - How to Use Maps Safely in Go https://hackernoon.com/how-to-use-maps-safely-in-go
  - Выжимаем из Go максимум производительности https://habr.com/ru/companies/vk/articles/824484/
  - How to optimize garbage collection in Go https://www.cockroachlabs.com/blog/how-to-optimize-garbage-collection-in-go/
  - GopherCon 2019 - Optimizing Go Code without a blindfold https://sourcegraph.com/blog/go/gophercon-2019-optimizing-go-code-without-a-blindfold
  - Оптимизация Go: как повысить скорость и эффективность кода https://habr.com/ru/companies/simbirsoft/articles/819015/
- Сигналы SIG**
  - go[channels]: hot config reload with os signal https://mrturkmen.com/posts/hot-reload-with-os-signals/
  - Terminating Elegantly: A Guide to Graceful Shutdowns https://itnext.io/terminating-elegantly-a-guide-to-graceful-shutdowns-e0dcd9940f4b
  - Listening to OS signals in Golang https://dev.to/lautarojayat/listening-to-os-signals-in-golang-nkh
  - Signal handling and graceful shutdown in Go https://riad.run/go-signals-and-graceful-shutdown
  - Go Tidbit: Handling Signals, Exiting Gracefully https://hjr265.me/blog/go-tidbit-handling-signals-exitting-gracefully/
  - Catching Multiple SIGINTs in Go - Confirming if You Really Want to Quit https://vlads.me/post/catching-multiple-sigints-in-go-confirming-if-you-really-want-to-quit/
  - SIGKILL vs SIGTERM: A Developer's Guide to Process Termination https://www.stackstate.com/blog/sigkill-vs-sigterm-a-developers-guide-to-process-termination/
- Пример создания приложения или сервиса
  - Building a CRUD gRPC Service with Go https://medium.com/@erwindev/building-a-crud-grpc-service-with-go-8ea99fba4ba8
  - Пример простейшей key-value СУБД на основе Badger https://eax.me/golang-badger/
  - Пишем веб сервис на Go (часть первая) (2014) https://habr.com/ru/articles/208680/
  - Как создать систему страшных звонков на Хэллоуин на Go и Exolve Voice API https://habr.com/ru/companies/exolve/articles/853952/
  - Альтернативный сервис оплаты в приложениях и играх https://kovardin.ru/articles/miniservices/payments/
  - Приложение на Go шаг за шагом. Часть первая: скелет, НТТР-сервер и конфигурация https://habr.com/ru/companies/yandex_praktikum/articles/854482/
  - Escape JavaScript hell and write everything in Go https://oblivion.keyruu.de/Web-Development/Everything-in-Go
  - Golang Project with Kafka, MongoDB, Using Hexagonal Architecture https://medium.com/@mike_polo/creating-a-golang-project-with-kafka-mongodb-using-hexagonal-architecture-e4bd54d12347
  - Learn the Basics of Go by Building a Full Stack Web App with React and Go https://www.freecodecamp.org/news/learn-the-basics-of-go-by-building-a-full-stack-web-app-with-react-and-go/
  - How I write HTTP services in Go after 13 years https://grafana.com/blog/2024/02/09/how-i-write-http-services-in-go-after-13-years/
  - Deploying a Golang RESTful API with Gin, SQLC and PostgreSQL https://dev.to/geoff89/deploying-a-golang-restful-api-with-gin-sqlc-and-postgresql-1lbl
  - Разработка веб-серверов на Go https://tproger.ru/translations/go-web-server
  - Создание веб-приложения с помощью Go и React https://bestcode.su/frontend/sozdanie-veb-prilozheniya-s-pomoschyu-go-i-react/
  - Creating a Simple Web Application with HTML Templates(Part-15) https://medium.com/@kamruljpi/creating-a-simple-web-application-with-html-templates-part-15-d47490bcdbed
  - Writing Web Applications https://go.dev/doc/articles/wiki/
  - How to build a fullstack application with Go, Templ, and HTMX https://dev.to/hackmamba/how-to-build-a-fullstack-application-with-go-templ-and-htmx-4444
  - Шаблон Go-микросервиса для начинающих от .NET разработчика. Часть 2 https://habr.com/ru/articles/820385/
  - Consuming A RESTful API With Go https://tutorialedge.net/golang/consuming-restful-api-with-go/
  - Go and MongoDB: Building a CRUD API from Scratch https://dev.to/aquibpy/go-and-mongodb-building-a-crud-api-from-scratch-10p6
  - Let’s Build a Movie API With Separated Layered Architecture Using Go https://betterprogramming.pub/lets-build-a-movie-api-with-clean-architecture-ef1f555b563d
  - Go and Gin - Building a Task Manager REST API https://bytegoblin.io/blog/mastering-rest-apis-with-the-go-gin-framework.mdx
  - Deep Dive into Go: Crafting a CRUD RESTful API Without Frameworks https://medium.com/@bensatriya3/deep-dive-into-go-crafting-a-crud-restful-api-without-frameworks-920cd6eab3be
  - Build Your Own SMTP Server in Go https://valyent.substack.com/p/build-your-own-smtp-server-in-go
    - Пишем свой SMTP сервер на Go https://kovardin.ru/articles/go/smtp-server/
- Файловая система
  - Mastering Golang — Part 7: Read File https://blog.stackademic.com/mastering-golang-part-6-read-file-41a8292497e5
- Базы данных
  - PostgreSQL
    - Connecting to PostgreSQL in Golang https://medium.com/@dewirahmawatie/connecting-to-postgresql-in-golang-59d7b208bad2
    - GO-PG Golang Postgre ORM https://medium.com/tunaiku-tech/go-pg-golang-postgre-orm-2618b75c0430
- Сеть
  - net/http
    - client
      - Making REST API Requests in Golang using the HTTP Client https://www.sohamkamani.com/golang/http-client/
    - Примеры
      - How to Parse a JSON Request Body in Go https://www.alexedwards.net/blog/how-to-properly-parse-a-json-request-body
    - Остальное
      - Writing HTTP client middleware in Go https://echorand.me/posts/go-http-client-middleware/
      - HTTP request debugging in Go with httputil http://speakmy.name/2014/07/29/http-request-debugging-in-go/
      - Diving deep into net/http : A look at http.RoundTripper https://lanre.wtf/blog/2017/07/24/roundtripper-go
      - Adding middleware to Go HTTP client requests https://jonfriesen.ca/articles/go-http-client-middleware/
      - Understanding Interfaces Through Golang: Mocking HTTP Server Response https://chettriyuvraj.github.io/blog/Understanding_Interfaces_Golang_Mock_HTTP
      - Go: Dump HTTP Request https://blog.cubieserver.de/2016/go-dump-http-request/
      - A story about Go http.Client https://www.jacoelho.com/blog/2017/08/a-story-about-go-http.client/
      - HTTP Connection reuse in Go clients https://blog.cubieserver.de/2022/http-connection-reuse-in-go-clients/
  - HTTP/3
    - gRPC Over HTTP/3 https://kmcd.dev/posts/grpc-over-http3/
  - HTTP
    - HTTP/0.9 From Scratch https://kmcd.dev/posts/http0.9-from-scratch/
    - HTTP/1.0 From Scratch https://kmcd.dev/posts/http1.0-from-scratch/
  - gRPC
    - gRPC From Scratch: Part 1 - Client https://kmcd.dev/posts/grpc-from-scratch/
    - gRPC From Scratch: Part 2 - Server https://kmcd.dev/posts/grpc-from-scratch-part-2/
    - gRPC From Scratch: Part 3 - Protobuf Encoding https://kmcd.dev/posts/grpc-from-scratch-part-3/
  - DNS
    - Building a DNS Resolver in Golang: A Step-by-Step Guide https://harshagarwal29.hashnode.dev/building-a-dns-resolver-in-golang-a-step-by-step-guide
  - WebSockets
    - Implementing WebSockets in Golang: Real-Time Communication for Modern Applications https://medium.com/wisemonks/implementing-websockets-in-golang-d3e8e219733b
    - How to implement instant messaging with WebSockets in Go https://yalantis.com/blog/how-to-build-websockets-in-go/
    - Using WebSockets in Golang https://blog.logrocket.com/using-websockets-go/
    - How To Build WebSocket Server In Golang https://piehost.com/websocket/how-to-build-websocket-server-in-golang
    - Mastering WebSockets With Go https://programmingpercy.tech/blog/mastering-websockets-with-go/
    - How to Use WebSocket in Golang: Step-by-Step Guide https://www.videosdk.live/developer-hub/websocket/golang-websocket
  - Proxy, Прокси
    - Implementing a Reverse Proxy API in Go https://tobiojuolape.hashnode.dev/implementing-a-reverse-proxy-api-in-go
    - Creating a simple proxy server with Go https://reintech.io/blog/creating-simple-proxy-server-with-go
    - Implementing a Logging Proxy Server with Golang https://medium.com/@bless2k/implementing-a-logging-proxy-server-with-golang-d0c673ef1f56
    - How to use a Forwarding Proxy with golang https://gianarb.it/blog/golang-forwarding-proxy
    - HTTP(S) прокси на Go в 100 строчек кода https://kovardin.ru/articles/go/https-proxy-golang/
    - Go and Proxy Servers: Part 1 - HTTP Proxies https://eli.thegreenplace.net/2022/go-and-proxy-servers-part-1-http-proxies/
    - Go and Proxy Servers: Part 2 - HTTPS Proxies https://eli.thegreenplace.net/2022/go-and-proxy-servers-part-2-https-proxies/
    - Go and Proxy Servers: Part 3 - SOCKS proxies https://eli.thegreenplace.net/2022/go-and-proxy-servers-part-3-socks-proxies/
    - Transparent http proxy with Golang and tproxy https://taczanowski.net/transparent-http-proxy-with-golang-and-tproxy/
  - VPN
    - Using TUN/TAP in go or how to write VPN https://nsl.cz/using-tun-tap-in-go-or-how-to-write-vpn/
    - Simple VPN in Golang https://taoshu.in/go/simple-vpn.html
    - Writing VPN with Go — 1. Server https://bdemirpolat.medium.com/go-ile-vpn-1-server-323bbda85b8b
    - Writing VPN with Go — 2. Client https://bdemirpolat.medium.com/go-ile-vpn-2-client-b6bc5848db29
  - Работа с траффиком
    - pcap
      - Capture traffic with Golang https://dev.to/aohorodnyk/capture-traffic-with-golang-2nmo
      - How to Read and Extract Information from a PCAP File in Go https://byteshiva.medium.com/how-to-read-and-extract-information-from-a-pcap-file-in-go-287c0bd66561
      - Programmatically Analyze Packet Captures with GoPacket https://www.akitasoftware.com/blog-posts/programmatically-analyze-packet-captures-with-gopacket
  - Балансировщик
    - Building a simple load balancer in Go https://dev.to/vivekalhat/building-a-simple-load-balancer-in-go-70d
  - Веб-сервер
    - load-balancer
      - Building a simple load balancer in Go https://dev.to/vivekalhat/building-a-simple-load-balancer-in-go-70d
    - Файлы
      - Go Tips & Common Mistakes - Go HTTP File Upload and Download https://bytegoblin.io/blog/go-tips-common-mistakes.mdx
    - Остальное
      - Golang HTTP server: basics https://medium.com/@bartosz.piekny/golang-http-server-basics-6936ddab7474
- Криптография
  - Go: Verify Cryptographic Signatures https://blog.cubieserver.de/2016/go-verify-cryptographic-signatures/
- git
  - Notes on using Go to write gitbackup https://echorand.me/posts/golang-notes-gitbackup/
  - Gitch. Сервис для зеркалирования репозиториев https://kovardin.ru/articles/miniservices/gitch/
- Файлы
  - Read File in Golang https://www.scaler.com/topics/golang/golang-read-file/
  - How to Read a Text File with Go https://www.jeremymorgan.com/tutorials/go/how-to-read-text-file-go/
- Мониторинг, метрики
  - prometheus
    - Пишем метрики в Prometheus на языке Go https://eax.me/golang-prometheus-metrics/
    - Monitoring the Golang App with Prometheus, Grafana, New Relic and Sentry https://medium.com/@mertcakmak2/monitoring-the-golang-app-with-prometheus-grafana-new-relic-and-sentry-fce1ca6980b5
- Аунтификация
  - Authentication for Go Applications: The Secure Way https://www.jetbrains.com/guide/go/tutorials/authentication-for-go-apps/auth/?ysclid=m06r9cxvkn600024780
- Авторизация
  - Обычная
    - Сайт на Golang. Авторизация. Часть 1 https://alextonkonogov.ru/?p=572
    - Сайт на Golang. Авторизация. Часть 2 https://alextonkonogov.ru/?p=601 
  - JWT
    - Implementing JWT Authentication and Authorization in Go with Gin https://medium.com/novai-go-programming-101/implementing-jwt-authentication-and-authorization-in-go-with-gin-ef0dc1cf33cd
    - Авторизация в Go с использованием JWT https://kovardin.ru/articles/go/avtorizaciya-v-go-s-ispolzovaniem-jwt/?ysclid=m06qqbjia1238948380
    - API Login using echo framework Golang, Postgres and JWT https://martinyonathann.medium.com/api-login-with-echo-framework-golang-postgres-and-jwt-dca330357020
    - A guide to JWT authentication in Go https://blog.logrocket.com/jwt-authentication-go/
- Telegram
  - Telegram на go: часть 1, парсим схему https://habr.com/ru/articles/535076/
  - Telegram на go, часть 2: бинарный протокол https://habr.com/ru/articles/541920/
- REST
  - REST Servers in Go: Part 1 - standard library https://eli.thegreenplace.net/2021/rest-servers-in-go-part-1-standard-library/
  - REST Servers in Go: Part 2 - using a router package https://eli.thegreenplace.net/2021/rest-servers-in-go-part-2-using-a-router-package/
- pipe
  - Mastering io.Pipe in Go https://bytegoblin.io/blog/mastering-io-pipe-in-go
- API
  - Откажитесь уже наконец от gin, echo и <иной ваш фреймворк> https://habr.com/ru/companies/ozonbank/articles/817381/
- OpenAPI
  - Parsing OpenAPI files using go https://quobix.com/articles/parsing-openapi-using-go/
  - OpenAPI 3 with Go https://medium.com/@bbakla/open-api-with-go-d75eb3afac19
- Обработка ошибок
  - Go: Управление обработкой множественных ошибок https://habr.com/ru/companies/otus/articles/558404/
- Транзакции
  - Database Transactions in Go with Layered Architecture https://threedots.tech/post/database-transactions-in-go
- Фреймворки
  - Fiber
    - Остальное
      - HTTP-серверы на Fiber в Golang https://habr.com/ru/companies/otus/articles/841194/
  - Echo
    - REST API
      - Golang CRUD REST API with Echo https://blog.stackademic.com/golang-crud-rest-api-with-echo-a1599b35fe4f
      - Go Echo API Server Development https://dev.to/nrikiji/go-echo-api-server-development-4008
      - Golang Echo Tutorial: REST API with PostgreSQL https://www.kelche.co/blog/go/golang-echo-tutorial/
      - Creating a Go(lang) API with Echo Framework and PostgreSQL https://www.restapiexample.com/golang-tutorial/creating-golang-api-echo-framework-postgresql/
    - Шаблоны
      - How to Show Flash Messages in Go web applications (with Echo framework) https://webdevstation.com/posts/how-to-show-flash-messages-in-go-echo/
      - How To Set Up Nested HTML Templates In The Go Echo Web Framework https://www.bomberbot.com/web-development/how-to-set-up-nested-html-templates-in-the-go-echo-web-framework/
- Лучшие практики
  - Go best practices, six years in https://peter.bourgon.org/go-best-practices-2016/?ref=refind
  - Применения Continuation-passing style в Go https://habr.com/ru/articles/836702/
  - Практические советы по устранению утечек памяти в Go https://habr.com/ru/articles/724402/
  - Go structs are copied on assignment (and other things about Go I'd missed) https://jvns.ca/blog/2024/08/06/go-structs-copied-on-assignment/
  - Securing Your Go Backend: Encryption, Vulnerability Prevention, and More! https://senowijayanto.medium.com/securing-your-go-backend-encryption-vulnerability-prevention-and-more-3fc980f45a8f
- Таймеры
  - Resetting timers in Go https://antonz.org/timer-reset/
- Отладка
  - Трассировщики
    - Jaeger для трассировки в микросервисной архитектуре https://habr.com/ru/companies/yandex_praktikum/articles/729906/
- Android
  - Using Golang + Gomobile To Build Android Application (with code) https://dev.to/nikl/using-golang-gomobile-to-build-android-application-with-code-18jo
  - Прокси-сервер для Android на Go https://habr.com/ru/articles/796105/
  - Using Golang + Gomobile To Build Android Application (with code) https://dev.to/nikl/using-golang-gomobile-to-build-android-application-with-code-18jo
  - Разработка мобильных приложений на Go https://habr.com/ru/companies/otus/articles/698140/
- Архитектура
  - Кэширование
    - [По полочкам] Кэширование https://habr.com/ru/articles/734660/
  - DDD
    - Introduction to DDD Lite: When microservices in Go are not enough https://threedots.tech/post/ddd-lite-in-go-introduction/
    - Implementing Domain Patterns with Hexagonal Architecture in Go https://medium.com/@jmanuelabanto/implementing-domain-patterns-with-hexagonal-architecture-in-go-5aac29fde7e1
  - CQRS (использование разных моделей для чтения и записи)
    - How to use basic CQRS in Go https://threedots.tech/post/basic-cqrs-in-go/
  - Чистая архитектура
    - Building a CRUD App with Clean Architecture in Go https://dev.to/michinoins/building-a-crud-app-with-mysql-gorm-echo-and-clean-architecture-in-go-h6d
    - How to implement Clean Architecture in Go https://threedots.tech/post/introducing-clean-architecture/
    - How to implement clean architecture in Golang (EN) https://medium.com/@rayato159/how-to-implement-clean-architecture-in-golang-en-f50d66378ebf
    - Clean Architecture in Go (Golang): A Comprehensive Guide https://medium.com/@omidahn/clean-architecture-in-go-golang-a-comprehensive-guide-f8e422b7bfae
    - Anatomy of a Go app with a clean architecture https://kumojin.com/anatomy-golang-app-clean-architecture/
    - Go Backend Clean Architecture https://outcomeschool.com/blog/go-backend-clean-architecture https://github.com/amitshekhariitbhu/go-backend-clean-architecture
    - Trying Clean Architecture on Golang https://medium.easyread.co/golang-clean-archithecture-efd6d7c43047 https://github.com/bxcodec/go-clean-arch
    - Trying Clean Architecture on Golang — 2 https://medium.easyread.co/trying-clean-architecture-on-golang-2-44d615bf8fdf
    - Clean Architecture in Go [2024 Updated] https://pkritiotis.io/clean-architecture-in-golang/
    - How to implement Clean Architecture in Go (Golang) https://threedots.tech/post/introducing-clean-architecture/
    - Dive to Clean Architecture with Golang https://dev.to/bmf_san/dive-to-clean-architecture-with-golang-cd4
    - Golang and clean architecture https://itnext.io/golang-and-clean-architecture-19ae9aae5683
    - Applying Clean Architecture in GoLang https://bytegoblin.io/blog/applying-clean-architecture-in-golang
    - An easy and practical approach to structuring Golang applications https://mbvisti.medium.com/a-practical-approach-to-structuring-go-applications-7f77d7f9c189
    - When using Microservices or Modular Monolith in Go can be just a detail? https://threedots.tech/post/microservices-or-monolith-its-detail/
    - Clean Architecture, 2 years later https://dev.to/eminetto/clean-architecture-2-years-later-4een
    - Go, Kafka and gRPC clean architecture CQRS microservices with Jaeger tracing https://dev.to/aleksk1ng/go-kafka-and-grpc-clean-architecture-cqrs-microservices-with-jaeger-tracing-45bj
    - Go, NATS, gRPC and PostgreSQL clean architecture microservice with monitoring and tracing https://dev.to/aleksk1ng/go-nats-grpc-and-postgresql-clean-architecture-microservice-with-monitoring-and-tracing-2kka
    - Go, RabbitMQ and gRPC Clean Architecture microservice https://dev.to/aleksk1ng/go-rabbitmq-and-grpc-clean-architecture-microservice-2kdn
    - Go gRPC Clean architecture microservice with Prometheus, Grafana monitoring and Jaeger opentracing https://dev.to/aleksk1ng/go-grpc-clean-architecture-microservice-with-prometheus-grafana-monitoring-and-jaeger-opentracing-51om
    - Hexagonal Architecture: Structuring a project and the influence of granularity https://medium.com/@TonyBologni/hexagonal-architecture-structuring-a-project-and-the-influence-of-granularity-df4e0851ab5c
  - Паттерны
    - Паттерны многопоточности в Go https://habr.com/ru/articles/852556/
    - Sidecar на Go: позволь другому заниматься твоими проблемами https://habr.com/ru/companies/otus/articles/852642/
    - Паттерны проектирования Go. Fan-in https://habr.com/ru/articles/854302/
    - Анти-паттерны в Go Web Applications https://habr.com/ru/articles/823766/
    - Microservices test architecture. Can you sleep well without end-to-end tests? https://threedots.tech/post/microservices-test-architecture/
    - SOLID в Go и щепотка паттернов https://habr.com/ru/companies/domclick/articles/816885/
    - Safeguarding changes using the plan-execute pattern https://tn1ck.com/blog/update-plans
    - Golang Design Patterns: Creational Patterns https://medium.com/@asgrr/golang-design-patterns-creational-patterns-5b8fdb4f5ae4
    - Golang Design Patterns — Overview https://medium.com/@MTrax/golang-design-patterns-overview-4a40a66db204
    - Mastering 6 Golang Concurrency Patterns to Level Up Your Apps https://reliasoftware.com/blog/golang-concurrency-patterns
    - Top 3 Design Patterns for a Large Go Codebase https://medium.com/@opheliaandcat/top-3-design-patterns-for-a-large-go-codebase-79a324003b47
    - Common design patterns in Golang - Part 1 https://dwarvesf.hashnode.dev/common-design-patterns-in-golang-part-1
  - Остальное
    - Distributed Transactions in Go: Read Before You Try https://threedots.tech/post/distributed-transactions-in-go
    - Definitive Guide to Software Architecture with Golang https://masteringbackend.com/posts/software-architecture-with-golang
    - Structuring your Golang app: Flat structure vs. layered architecture https://blog.logrocket.com/flat-structure-vs-layered-architecture-structuring-your-go-app/
- PDF
  - How To Create a PDF in Go: a Step-by-Step Tutorial https://medium.com/the-godev-corner/how-to-create-a-pdf-in-go-157355429a94
  - Go long by generating PDFs in Golang with Maroto https://dev.to/logrocket/go-long-by-generating-pdfs-in-golang-with-maroto-1g25
- Компилятор
  - Statically and Dynamically Linked Go Binaries https://itnext.io/statically-and-dynamically-linked-go-binaries-5a3c0313b3a4
  - Building static binaries with Go on Linux https://eli.thegreenplace.net/2024/building-static-binaries-with-go-on-linux/
- Конкурентное программирование, sync
  - Concurrency, Параллелизм
    - Understanding Concurrency Patterns in Go https://hackernoon.com/understanding-concurrency-patterns-in-go
    - Mastering Concurrent Processing: A Step-by-Step Guide to Building a Scalable Worker Pool in Go https://medium.com/@souravchoudhary0306/mastering-concurrent-processing-a-step-by-step-guide-to-building-a-scalable-worker-pool-in-go-54093074c612
  - Синхронизация
    - Атомарные операции
      - Go: жарим общие данные. Атомно, быстро и без мьютексов https://habr.com/ru/companies/ruvds/articles/833264/
    - Примитивы синхронизации
      - Mutex
        - Using a Mutex in Go (Golang) - with Examples https://www.sohamkamani.com/golang/mutex/
  - Пулы, pool
    - Go sync.Pool and the Mechanics Behind It https://victoriametrics.com/blog/go-sync-pool/index.html
  - Остальное
    - Go sync.Cond, the Most Overlooked Sync Mechanism https://victoriametrics.com/blog/go-sync-cond/index.html
- Кэширование
  - Go High-Performance Cache with TTL and Disk Persistence https://dev.to/leoantony72/go-high-performance-cache-with-ttl-and-disk-persistence-4a4m
- Логгирование
  - Trace Log in Golang https://riad.run/trace-in-golang
  - Effective Logging in Go: Best Practices and Examples https://medium.com/novai-go-programming-101/effective-logging-in-go-best-practices-and-examples-911c31145260
- Планировщик, Scheduler
  - Mastering Task Scheduling in Go: Gron, JobRunner, and Gocron https://medium.com/@murataslan1/mastering-task-scheduling-in-go-gron-jobrunner-and-gocron-0123d5c4ee95
- Тестирование
  - Практика написания модульных тестов в языке Go https://eax.me/golang-unit-testing/
  - Мутационное тестирование: опыт внедрения на 1500 сервисов https://habr.com/ru/companies/avito/articles/650073/
  - Go: How the Testing Harness Works https://matttproud.com/blog/posts/go-testing-harness.html
  - How to do unit testing + mock function in Golang within clean architecture https://medium.com/@rayato159/how-to-do-unit-testing-mock-function-in-golang-within-clean-architecture-2a674c42dfc4
  - f-tests as a replacement for table-driven tests in Go https://itnext.io/f-tests-as-a-replacement-for-table-driven-tests-in-go-8814a8b19e9e
  - Testing in Go - a crash article to get you going https://thedevelopercafe.com/articles/testing-in-go-929e2ad2
  - Emulating real dependencies in Integration Tests using Testcontainers https://itnext.io/emulating-real-dependencies-in-integration-tests-using-testcontainers-6244f0cbe027
- Distributed Systems, Распределенные системы
  - Consensus Algorithms, Алгоритмы консенсуса
    - Raft Consensus Algorithm, Алгоритм консенсуса Raft
      - Implementing Raft: Part 0 - Introduction https://eli.thegreenplace.net/2020/implementing-raft-part-0-introduction/
      - Raft Consensus Algorithm Implementation with Go https://yunuskilicdev.medium.com/raft-consensus-algorithm-implementation-with-go-d0f9bf4472a0
      - Raft Consensus — leader election with Golang https://medium.com/@govinda.attal/raft-consensus-leader-election-with-golang-89bfdbd471cb
- AI
  - LLM
    - Building LLM-powered applications in Go https://go.dev/blog/llmpowered
    - Prompt Engineering to Grow Yourself a Nanoservice Garden https://nathanleclaire.com/blog/2024/06/23/prompt-engineering-to-grow-yourself-a-nanoservice-garden/
- SSH
  - Некоторые возможности ssh в golang https://habr.com/ru/articles/788094/
  - Forwarding a Port Over SSH in Go https://hjr265.me/blog/forwarding-a-port-over-ssh-in-go/
  - Guide to Implement an SSH Client Using Golang https://www.pixelstech.net/article/1699714722-Guide-to-Implement-an-SSH-Client-Using-Golang
  - Go | SSH Client Shell Session https://medium.com/@marcus.murray/go-ssh-client-shell-session-c4d40daa46cd
  - A Simple Cross-Platform SSH Client in 100 Lines of Go https://betterprogramming.pub/a-simple-cross-platform-ssh-client-in-100-lines-of-go-280644d8beea
  - Building An SSH Chatroom With Go https://medium.com/@alexfoleydevops/building-an-ssh-chatroom-with-go-6df65facd6cb
  - Golang — Upload File to SFTP https://medium.com/@bilalemre_gulsen/golang-upload-file-to-sftp-e1b7a08737cb
  - Secure File Transfer Made Easy: Connect to SFTP Servers with Golang https://dev.to/frasnym/secure-file-transfer-made-easy-connect-to-sftp-servers-with-golang-53a1
- Redis
  - Rate limiting HTTP requests in Go using Redis https://mauricio.github.io/2021/12/30/rate-limiting-in-go.html
- Kafka
  - Connect Kafka with Golang https://dev.to/chauhoangminhnguyen/connect-kafka-with-golang-3h4d
- WebAssembly
  - WebAssembly and Go: A Guide to Getting Started (Part 1) https://thenewstack.io/webassembly-and-go-a-guide-to-getting-started-part-1/
  - WebAssembly and Go: A Guide to Getting Started (Part 2) https://thenewstack.io/webassembly-and-go-a-guide-to-getting-started-part-2/
  - Running WebAssembly code in Go https://dev.to/eminetto/running-webassembly-code-in-go-35k9
  - WebAssembly on the server: Compiling Rust to WASM and executing it from Go https://blog.arcjet.com/webassembly-on-the-server-compiling-rust-to-wasm-and-executing-it-from-go/
  - Notes on running Go in the browser with WebAssembly https://eli.thegreenplace.net/2024/notes-on-running-go-in-the-browser-with-webassembly/
- Поиск
  - pgvector
    - Пишем поиск семантически похожих текстов (или товаров) за полчаса на Go и Postgres (pgVector) https://habr.com/ru/companies/karuna/articles/809305/
- Остальное
  - Go Singleflight Melts in Your Code, Not in Your DB https://victoriametrics.com/blog/go-singleflight/index.html
  - Mastering Real-Time Data Pipelines in Golang with Channels and Worker Pools https://levelup.gitconnected.com/mastering-real-time-data-pipelines-in-golang-with-channels-and-worker-pools-7eae2f2d662b
  - Многопоточный генератор шоунотов на Go https://eax.me/go-show-notes-generator/
  - Modifying an interface{}-ed struct in Go via reflection http://speakmy.name/2014/09/14/modifying-interfaced-go-struct/
  - Things to know about HTTP in Go https://scene-si.org/2017/09/27/things-to-know-about-http-in-go/
  - Развлекаемся с итераторами в Go https://habr.com/ru/companies/beget/articles/852940/
  - Некоторые тонкости управления зависимостями в Go https://eax.me/go-mod/
  - Using OpenSearch with Golang https://www.inanzzz.com/index.php/post/7e0s/using-opensearch-with-golang
  - Simple Fixed-window Rate Limiter With Redis https://hjr265.me/blog/simple-rate-limiter-with-redis/
  - Multi-threaded Downloads in Go https://hjr265.me/blog/multi-threaded-downloads-in-go/
  - Scanning a Website for Broken Links in Go https://hjr265.me/blog/scanning-a-website-for-broken-links-in-go/
  - The 4-chan Go programmer https://www.dolthub.com/blog/2024-08-23-the-4-chan-go-programmer/
  - Свой артефактори для Android библиотек https://kovardin.ru/articles/miniservices/depot/
  - SCALING ONE MILLION CHECKBOXES TO 650,000,000 CHECKS https://eieio.games/essays/scaling-one-million-checkboxes/
  - Enums in Go: A Practical Guide https://blog.stackademic.com/enums-in-go-a-practical-guide-aa26d0cb3e22
  - Binary Search Tree with SIMD https://clement-jean.github.io/simd_binary_search_tree/
  - Parsing Protobuf Definitions with Tree-sitter https://relistan.com/parsing-protobuf-files-with-treesitter
  - Quick Sort in Go https://thedevelopercafe.com/articles/quick-sort-in-go-1c4ef4b5
  - Write a time-series database engine from scratch https://nakabonne.dev/posts/write-tsdb-from-scratch/
  - Software Transactional Memory: a stairway to lock-free programming heaven? https://medium.com/@talhof8/software-transactional-memory-a-stairway-to-lock-free-programming-heaven-9ca1f4dce23f
  - Mastering Contexts in Go https://hackernoon.com/mastering-contexts-in-go
  - Building a high performance JSON parser https://dave.cheney.net/high-performance-json.html
  - Distributed Locking In Go https://blogs.halodoc.io/distributed-locking-in-go/
  - Probabilistic Data Structures for Go https://blog.gopheracademy.com/advent-2014/go-probably/
  - Hash-Based Bisect Debugging in Compilers and Runtimes https://research.swtch.com/bisect
  - Server-side I/O Performance: Node vs. PHP vs. Java vs. Go https://www.toptal.com/back-end/server-side-io-performance-node-php-java-go?ref=refind
  - Rubbing control theory on the Go scheduler https://www.cockroachlabs.com/blog/rubbing-control-theory/?ref=refind
  - Interactive Go programming with Jupyter https://medium.com/@yunabe/interactive-go-programming-with-jupyter-93fbf089aff1
  - Why Go and not Rust? https://kristoff.it/blog/why-go-and-not-rust/?ref=refind
  - The Best Go framework: no framework? https://threedots.tech/post/best-go-framework?ref=refind
  - Making a Go program run 1.7x faster with a one character change 2022-11-13 https://hmarr.com/blog/go-allocation-hunting/?ref=refind
  - Кратко про сетевые протоколы в Golang: TCP, QUIC и UDP https://habr.com/ru/companies/otus/articles/830096/
  - Рассматриваем #golang каналы в комплексе https://www.dolthub.com/blog/2024-06-21-channel-three-ways/
  - No sleep until we build the ideal pub/sub library in Go; Автор рассматривает разные подходы к написанию pub/sub библиотеки на #golang; https://rauljordan.com/no-sleep-until-we-build-the-perfect-library-in-go/
  - Пишем сайт с риалтайм обновлениями с помощью Server-Sent Events, #golang и htmx https://threedots.tech/post/live-website-updates-go-sse-htmx
  - Avoiding Beginner Mistakes Hampering You to Scale Backend (Пример оптимизации #golang сервиса на 2 GB памяти и 1 CPU) https://dev.to/rikenshah/scaling-backend-to-1m-requests-with-just-2gb-ram-4m0c#optimization-7-avoid-overloading-goroutines
  - An Applied Introduction to eBPF with Go https://sazak.io/articles/an-applied-introduction-to-ebpf-with-go-2024-06-06
  - Golang: пакет bytes изнутри https://habr.com/ru/articles/828044/
  - Where and When to use Iota in Go https://www.gopherguides.com/articles/how-to-use-iota-in-golang
  - 4 iota enum examples https://yourbasic.org/golang/iota/ https://habr.com/ru/companies/nixys/articles/492056/
  - Golang: context изнутри https://habr.com/ru/articles/827544/
  - How To Use Contexts in Go https://www.digitalocean.com/community/tutorials/how-to-use-contexts-in-go
  - Writing an OS in Go: The Bootloader https://totallygamerjet.hashnode.dev/writing-an-os-in-go-the-bootloader
  - О массивах и слайсах в Go https://habr.com/ru/articles/739754/
  - Советы Golang: почему указатели на срезы полезны и как их игнорирование может привести к хитрым ошибкам https://habr.com/ru/articles/525940/
  - Суслик и пингвин: кодим на Go под Linux 
    - https://habr.com/ru/articles/811587/ 
    - https://web.archive.org/web/20240501135306/https://habr.com/ru/articles/811587/
  - Structured concurrency в языке Go https://habr.com/ru/companies/karuna/articles/816677/
  - Go 1.22: Интерактивные заметки к релизу https://habr.com/ru/articles/792242/
  - Tracking io.Copy Progress in Go https://hjr265.me/blog/tracking-io-copy-progress-in-go/
  - How to connect to SFTP in Go https://sftptogo.com/blog/go-sftp/
  - Golang Thread Pool And Scheduler https://medium.com/@ahmet9417/golang-thread-pool-and-scheduler-434dd094715a
  - Unlocking the Power of Functional Options Pattern in Go https://matheuspolitano.medium.com/unlocking-the-power-of-functional-options-pattern-in-go-087478f57be9
  - Как отправлять SMS через МТС Exolve и Go https://habr.com/ru/companies/exolve/articles/828370/
  - Why People are Angry over Go 1.23 Iterators https://www.gingerbill.org/article/2024/06/17/go-iterator-design/
  - Profiling in Go: A Practical Guide https://nyadgar.com/posts/go-profiling-like-a-pro/
  - Building my own Redis in Go - Part 1 https://sathwikreddygv.blog/building-my-own-redis-in-go-part-1
    - Building my own Redis in Go - Part 2 https://sathwikreddygv.blog/building-my-own-redis-in-go-part-2
    - Building my own Redis in Go - Part 3 https://sathwikreddygv.blog/building-my-own-redis-in-go-part-3
      - https://github.com/sathwikreddygv/redis-written-in-go
  - A comprehensive guide to file operations in Go https://www.honeybadger.io/blog/comprehensive-guide-to-file-operations-in-go/
  - List all files (recursively) in a directory https://yourbasic.org/golang/list-files-in-directory/
  - Weird things about GOLANG — Part 1 https://medium.com/@adityasonel/weird-things-about-golang-part-1-4139e97f2bd4
  - Weird things about GOLANG — Part 2 https://medium.com/@adityasonel/weird-things-about-golang-part-2-b2f1aa8d61e1
  - A Pattern for Optimizing Go https://www.splunk.com/en_us/blog/devops/a-pattern-for-optimizing-go-2.html
  - How to make Golang Zero Allocation Log Library https://medium.com/@muroon/the-reason-why-zap-and-zerolog-make-it-zero-allocation-3ee8f69f660
  - Поднимаем TLS для gRPC в Go https://tproger.ru/articles/podnimaem-tls-dlya-grpc-v-go
  - Golang - Goroutine, Channel, Worker Pool, Select, Mutex https://mgleon08.github.io/blog/2018/05/17/golang-goroutine-channel-worker-pool-select-mutex/
  - A Complete Guide to Logging in Go with Zerolog https://betterstack.com/community/guides/logging/zerolog/
  - Dockerizing a Golang API with MySQL and adding Docker Compose Support https://dev.to/pradumnasaraf/dockerizing-a-golang-api-with-mysql-and-adding-docker-compose-support-9b1
  - Разработчиками jepsen также был создан инструмент под названием maelstrom. Данный инструмент предназначен для изучения теоретических и практических аспектов распределенных систем. По указанной ссылке https://fly.io/dist-sys/1/ представлен комплексный учебный курс, посвященный распределенным системам и использованию maelstrom. 

### StackOverflow

- SSH
  - Golang, multiple commands in the same SSH Session https://stackoverflow.com/questions/76166288/golang-multiple-commands-in-the-same-ssh-session

### Блоги

- A Journey With Go https://medium.com/a-journey-with-go
- Alex Edwards https://www.alexedwards.net/blog/
- Alex Pliutau https://pliutau.com/
- Applied Go https://appliedgo.net/
- Ardan Labs https://www.ardanlabs.com/blog/
- Attila Olah https://attilaolah.eu/
- Brad Fitzpatrick http://bradfitz.com/
- Dave Cheney https://dave.cheney.net/
- DEV's Go Tag https://dev.to/t/go
- Digital Ocean's Go Series https://digitalocean.com/community/tutorial_series/how-to-code-in-go
- Dmitri Shuralyov https://dmitri.shuralyov.com/blog
- Eli Bendersky https://eli.thegreenplace.net/
- Fatih Arslan https://arslan.io/
- Gary Burd https://gary.burd.info/
- Go Ahead https://jbrandhorst.com/
- Go By Example https://gobyexample.com/
- Go Web Examples https://gowebexamples.com/
- Go Wiki Blogs https://github.com/golang/go/wiki/Blogs
- Go's Articles Wiki https://github.com/golang/go/wiki/Articles
- Goland https://blog.jetbrains.com/go/
- Golang Bot https://golangbot.com/
- Golang Code https://golangcode.com/
- Golang Programs https://golangprograms.com/
- Golang Weekly https://golangweekly.com/
- Golang.ch https://golang.ch/
- GolangNews https://golangnews.com/
- golangspec https://medium.com/golangspec
- Gopher Academy Blog https://blog.gopheracademy.com/
- Gopher Guides https://gopherguides.com/articles
- Hashnode's Go Tag https://hashnode.com/n/go
- Ian Lance Taylor https://www.airs.com/blog/
- Ilija Eftimov's Blog https://ieftimov.com/
- ITNEXT's Blog https://itnext.io/tagged/golang
- James Bowen https://blog.jbowen.dev/
- Janos Pasztor https://pasztor.at/
- junegunn https://junegunn.kr/
- Just For Func https://medium.com/justforfunc
- Katrina Owen http://whipperstacker.com/
- Ken Thompson https://github.com/ken
- Learn Go Programming https://blog.learngoprogramming.com/
- Learning the Go Programming Language https://medium.com/learning-the-go-programming-language
- Marcio Castilho http://marcio.io/
- Mark McGranaghan https://markmcgranaghan.com/
- Matt Layher https://mdlayher.com/blog/
- Matt Silverlock https://blog.questionable.services/
- mattn https://mattn.kaoriya.net/
- Miek Gieben https://miek.nl/
- Miki Tebeka https://www.353solutions.com/
- Mitchell Hashimoto http://mitchellh.com/
- Nate Finch https://npf.io/blog/
- Owen Ou https://owenou.com/
- Rob Pike https://github.com/robpike
- Robert Griesemer https://github.com/griesemer
- Russ Cox https://swtch.com/~rsc/
- Scott Mansfield http://blog.sgmansfield.com/
- Shubham Chadokar https://schadokar.dev/
- Sokohaka http://tdoc.info/en/blog/
- Steve Francia https://spf13.com/
- The Official Blog https://blog.golang.org/
- Tit Petric's Blog https://scene-si.org/
- Tutorial Edge https://tutorialedge.net/course/golang
- Various Stuff https://tidwall.com/
- Victor Vrantchan https://groob.io/
- Vincent Bernat https://vincent.bernat.ch/en
- Wandering Thoughts' Go Topic https://utcc.utoronto.ca/~cks/space/blog/__TopicGo
- William Kennedy http://www.goinggo.net/
- https://reintech.io/blog?technology=go
- https://www.codingexplorations.com/blog/category/golang
- https://nakabonne.dev/
- https://blog.gkomninos.com/series/webapp-using-golang
- https://webdevstation.com/
- https://www.atharvapandey.com/tags/golang
- https://www.sohamkamani.com/golang/
- https://alextonkonogov.ru/?cat=2
- Artem Kovardin https://kovardin.ru/tags/golang/
- https://blog.logrocket.com/tag/go/
- https://www.jetbrains.com/guide/tags/go/
- https://hashnode.com/n/go
- https://antonz.org/
- https://www.willem.dev
- https://boldlygo.tech
- https://bitfieldconsulting.com/posts
- https://threedots.tech/post/
- https://matttproud.com/blog/tags/go.html
- https://masteringbackend.com/posts/
- https://bytegoblin.io/?tag=GOLANG
- https://www.freecodecamp.org/news/tag/golang/
- https://thedevelopercafe.com/?category=go
- https://www.dolthub.com/blog/
- https://kmcd.dev/tags/golang/
- https://unskilled.blog/posts/
- https://riad.run/
- https://hjr265.me/tags/go/
- https://nathanleclaire.com/post/
- https://coffeebytes.dev/en/categories/go
- https://www.inanzzz.com/index.php/posts/go
- https://chettriyuvraj.github.io/blog
- https://lanre.wtf/blog
- https://jonfriesen.ca/articles/
- https://articles.singee.me/tag/Go
- https://eax.me/tag/golang/
- https://blog.cubieserver.de/tags/go/
- https://echorand.me/posts/
- https://programmingpercy.tech/blog/category/go/
- https://mauricio.github.io/

### Подкасты

- https://cupogo.dev/
- https://changelog.com/gotime

### Примеры приложений

- Clean Architecture Golang Example (kinda) https://github.com/ruslantsyganok/clean_arcitecture_golang_example
- [WIP] E-Commerce project using Hexagonal Architecture (Ports-and-adapters) as a proof-of-concept applying DDD in Go https://github.com/charly3pins/eShop
- Golang Clean Architecture REST API example https://github.com/AleksK1NG/Go-Clean-Architecture-REST-API
- Stock Analysis API https://github.com/shivamsouravjha/stock-backend
- https://github.com/gothinkster/golang-gin-realworld-example-app
- https://github.com/go-kit/examples/

### Видео

- Примеры приложений
  - Building a TCP Chat in Go https://www.youtube.com/watch?v=Sphme0BqJiY
  - nextjs 14, Go, Docker: Build a fullstack rest API in TypeScript and Go https://www.youtube.com/watch?v=429-r55KFmM
  - Creating Golang WebServer With Echo https://www.youtube.com/watch?v=_pww3NJuWnk&list=PLFmONUGpIk0YwlJMZOo21a9Q1juVrk4YY
- Конференции
  - Функциональное программирование и #golang. Доклад с GopherCon UK 2024 https://www.youtube.com/watch?v=OKlhUv8R1ag
  - GopherCon UK 2024 https://www.youtube.com/watch?v=hIKRmIotkhw&list=PLDWZ5uzn69ezR6D6FUj_iBSOyRc9xaZFP
- Обучающие видео
  - [s5 | 2024] Программирование на Go, Панасюк И.А., практика 7 https://www.youtube.com/watch?v=XQWxOIzGJlQ
  - Golang Tutorial for Beginners | Full Go Course https://www.youtube.com/watch?v=yyUHQIec83I
  - Synchronization in Golang - Complete Guide https://www.youtube.com/watch?v=Xf1j0FGAYUY
  - Golang / Go Crash Course 03 | Implementing Clean Architecture principles in our REST API https://www.youtube.com/watch?v=Yg_ae0UvCv4
- Подготовка к собеседованию
  - Golang 100 вопросов с собеседований. Подготовка Go разработчика Часть 1 https://www.youtube.com/watch?v=ZvaD-G5_3vQ
- Остальное
  - https://vk.com/video/playlist/-211870343_13
  - Go Clean Template | Чистая Архитектура и как её готовить, Михаил Непряхин https://www.youtube.com/watch?v=V6lQG6d5LgU
  - Configure Golang in Neovim https://www.youtube.com/watch?v=EgwiPok2nbU
  - Буквально 4 минуты про гуся. Goose - тулза для миграций на #golang https://www.youtube.com/watch?v=tyDan_pFUHE
- Чистая архитектура
  - Clean architecture in Go. How to organize a project structure? https://www.youtube.com/watch?v=goC-gCNWhS4
  - GO - Clean Architecture https://www.youtube.com/playlist?list=PL7Bs8ngpweC6KN8g1_LS4Be0bWXB23UKB
  - How To Structure Your Go App - Full Course [ Hex Arch + Tests ] https://www.youtube.com/watch?v=MpFog2kZsHk
  - Go Programming - Hexagonal Architecture https://www.youtube.com/watch?v=k3JZI-sQs2k
  - dotGo 2019 - Kat Zień - Achieving maintainability with hexagonal architecture https://www.youtube.com/watch?v=vKbVrsMnhDc

### Сайты со статьями

- https://yourbasic.org/
- https://www.gopherguides.com/

### Telegram

- https://t.me/kodikapusta

### Облачные хранилища, аналоги s3

- https://github.com/storj/storj
- https://github.com/minio/minio