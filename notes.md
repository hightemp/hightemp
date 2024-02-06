
## Остальное

### Rust - web frameworks

- Yew - современный фреймворк на языке Rust для создания многопоточных веб-приложений с использованием WebAssembly, предоставляющий удобный макрос для объявления интерактивного HTML с выражениями Rust, обеспечивающий высокую производительность и поддерживающий взаимодействие с JavaScript для использования NPM-пакетов и интеграции с существующими JavaScript-приложениями. https://github.com/yewstack/yew
- Sauron - универсальный веб-фреймворк и библиотека для создания клиентских и/или серверных веб-приложений с основным акцентом на эргономику, простоту и элегантность, позволяя писать минимальное количество кода и сосредотачиваться на бизнес-логике вместо внутренних деталей фреймворка. Вдохновленный Elm-lang, sauron придерживается архитектуры Elm, обеспечивая серверный рендеринг, генерацию статических сайтов, прогрессивный рендеринг, поддержку веб-компонентов, удобный синтаксис HTML для написания представлений и макрос для написания стилей на Rust. https://github.com/ivanceras/sauron
- Percy представляет собой инструмент для построения веб-приложений для браузера с использованием языка программирования Rust в сочетании с технологией WebAssembly. Этот инструмент позволяет разрабатывать приложения, основанные на клиентском рендеринге, серверном рендеринге или их комбинации. https://github.com/chinedufn/percy
- Dioxus - фреймворк на Rust для создания кроссплатформенных пользовательских интерфейсов с уникальными особенностями, такими как эргономичное управление состоянием, высокая скорость и эффективность, поддержка асинхронности и рендеринг на различных платформах, включая веб, десктоп, мобильные устройства и терминалы. https://github.com/dioxuslabs/dioxus
- Iced - кроссплатформенная библиотека GUI для Rust, ориентированная на простоту использования и типовую безопасность, с вдохновением от языка Elm, предоставляющая простой API, реактивную модель программирования, поддержку различных платформ (Windows, macOS, Linux и веб), отзывчивый макет, встроенные виджеты, поддержку пользовательских виджетов, отладочное оверлейное окно с метриками производительности и модульную экосистему. https://github.com/iced-rs/iced
- Tauri - это фреймворк для создания маленьких, молниеносно быстрых бинарных файлов для всех основных настольных платформ, позволяющий интегрировать любой фронтенд-фреймворк, компилирующийся в HTML, JS и CSS, для построения пользовательского интерфейса. Бэкенд приложения представляет собой бинарный файл, написанный на Rust, с API, с которым может взаимодействовать фронтенд. https://github.com/tauri-apps/tauri
- Backend
  - Actix Web - это мощный, практичный и чрезвычайно быстрый веб-фреймворк для Rust, поддерживающий HTTP/1.x, HTTP/2, потоковую передачу данных, маршрутизацию запросов, WebSockets, компрессию данных, статические ресурсы, SSL, средства логирования и другие возможности. https://github.com/actix/actix-web
  - Rocket - это асинхронный веб-фреймворк для Rust, ориентированный на удобство использования, безопасность, расширяемость и скорость, предоставляющий удобный синтаксис с использованием макросов и поддерживающий асинхронные запросы. https://github.com/rwf2/Rocket
  - axum - это модульный веб-фреймворк для приложений на Rust, ориентированный на удобство использования и поддерживающий декларативный подход к маршрутизации запросов, обеспечивая простую и предсказуемую модель обработки ошибок, а также взаимодействие с экосистемой middleware, сервисов и утилит через tower и tower-http. https://github.com/tokio-rs/axum
  - warp - это легкий, композиционный веб-фреймворк для создания веб-серверов с высокой производительностью, основанный на концепции Filter, который позволяет легко и гибко выражать сложные требования к запросам, предоставляя функциональности, такие как маршрутизация, извлечение параметров, обработка заголовков, десериализация запросов и многое другое. https://github.com/seanmonstar/warp
  - Gotham - гибкий веб-фреймворк, ориентированный на стабильность, безопасность и скорость, обеспечивая статическую типизацию, асинхронность и высокую производительность. https://github.com/gotham-rs/gotham
  - Rouille - микрофреймворк на Rust для веб-приложений, предоставляющий интуитивный интерфейс, линейную обработку запросов и поддержку основных концепций веб-сайтов, при этом оставляя возможность легкой интеграции с сторонними библиотеками. https://github.com/tomaka/rouille
  - Thruster - быстрый и интуитивно понятный веб-фреймворк на Rust, построенный с учетом асинхронности, совместимый с Hyper, готовый для SSL, с поддержкой тестирования, обслуживания статических файлов, Socket.IO, gRPC, а также экспериментальной поддержкой gRPC без использования Tonic, и внедрением зависимостей. https://github.com/thruster-rs/Thruster
  - Tide - минималистичный и прагматичный веб-фреймворк на Rust, разработанный для быстрой разработки, предоставляющий набор надежных функций для упрощения и увлекательного создания асинхронных веб-приложений и API. https://github.com/http-rs/tide
  - Dropshot - универсальный инструмент в виде крейта для создания REST API на Rust, обеспечивающий удобство в конфигурации, логировании и дизайне, поддерживающий асинхронные запросы и предоставляющий ряд опций для настройки сервера и обработки логов. https://github.com/oxidecomputer/dropshot

### Блоги

- https://ekamperi.github.io/

### linux - Получить информацию о компьютере

- https://github.com/lpereira/hardinfo

### Подсчет использования памяти для LLM

- https://docs.nvidia.com/ai-enterprise/workflows-generative-ai/0.1.0/sizing-guide.html
- https://huggingface.co/docs/accelerate/main/en/usage_guides/model_size_estimator
- https://medium.com/@plthiyagu/calculate-gpu-requirements-for-your-llm-training-7122a3700547
- https://lambdalabs.com/gpu-benchmarks

#### llama 7b

To run the 7B model in full precision, you need 7 * 4 = 28GB of GPU RAM.

В полной точности (float32) каждый параметр модели хранится в 32 битах или 4 байтах. Таким образом, 4 байта/параметр * 7 миллиардов параметров = 28 миллиардов байт = 28 ГБ памяти GPU требуется только для вывода. В половинной точности каждый параметр хранится в 16 битах, или 2 байтах. Следовательно, вам потребуется 14 ГБ для вывода. Теперь существуют также алгоритмы с 8 битами и 4 битами, так что при 4 битах (или половине байта) на параметр вам потребуется 3.5 ГБ памяти для вывода.

### Биометрия

Нужно в чат написать волшебную фразу: Запрещаю передачу мои биометрических данных в ЕБС, отзываю все ранее данные согласия на передачу моих биометрических данных в ЕБС, прошу удалить все мои биометрические данные, которые хранятся в АО Тинькофф банк. Прошу выдать документ, подтверждающий удаление моих биометрических данных

### PHP - Рефакторинг 

- Rector — инструмент №1, автоматически заменяет несовместимые с новой версией языка части кода;
- Exakat — анализирует совместимость кода по версиям PHP, дает список проблемных участков и используемых расширений;
- Phan — подсвечивает лексические конструкции, которых нет в новой версии.

### Подготовка к интервью golang

- https://habr.com/ru/articles/786826/

### Книги по golang

- 100 ошибок Go и как их избежать — Тейва Харшани

### Чаты с ботами

- https://openchat.team/
- https://labs.perplexity.ai/
- https://services.vsegpt.ru:6400/?model=openai%2Fgpt-3.5-turbo
- https://services.vsegpt.ru:6400/Image_processing?model=vis-google%2Fgemini-pro-vision
- https://services.vsegpt.ru:5002/
- https://chat.vsegpt.ru/
- https://www.blackbox.ai/
- https://www.coze.com/
- http://cody.dev https://sourcegraph.com/cody/chat
- https://www.together.ai/

### Rust - Обучающие материалы

- https://github.com/rust-lang/rustlings

### Установка NerdFonts

```bash
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/DroidSansMono.zip
# Alternative download link
# https://www.nerdfonts.com/font-downloads
unzip DroidSansMono.zip -d ~/.fonts
fc-cache -fv
```

### Golang - Логирование

| Package                | Iterations | Time        | Objects Allocated |
|------------------------|------------|-------------|-------------------|
| Phuslu/log             | 44559532   | 27 ns/op    | 0 allocs/op       |
| Zerolog                | 42537776   | 30 ns/op    | 0 allocs/op       |
| Zap                    | 17901230   | 71 ns/op    | 0 allocs/op       |
| Zap (sugared)          | 14898670   | 87 ns/op    | 1 allocs/op       |
| Slog (with Zap Backend)| 1005426    | 121.9 ns/op | 0 allocs/op       |
| Logf                   | 6770377    | 163.5 ns/op | 0 allocs/op       |
| Slog                   | 7105790    | 174 ns/op   | 0 allocs/op       |
| Apex/log               | 138122     | 870 ns/op   | 5 allocs/op       |
| Logrus                 | 658953     | 2231 ns/op  | 23 allocs/op      |
| Log15                  | 505850     | 21997 ns/op | 20 allocs/op      |

- https://github.com/rs/zerolog
- https://github.com/uber-go/zap
- https://pkg.go.dev/golang.org/x/exp/slog https://cs.opensource.google/go/x/exp
- https://github.com/phuslu/log
- https://github.com/sirupsen/logrus
- https://github.com/inconshreveable/log15
- https://github.com/ssgreg/logf
- https://github.com/apex/log
- https://github.com/go-logr/logr

### Golang - Спецификация

- https://go.dev/ref/spec

### Просмотр страниц для llm агента

- Simple web browsing for your Langchain agent. https://github.com/taivop/agentreader

### MITM proxy

Установка сертификатов https://docs.mitmproxy.org/stable/concepts-certificates/

- https://github.com/lqqyt2423/go-mitmproxy
- https://github.com/kardianos/mitmproxy
- https://github.com/AdguardTeam/gomitmproxy
- https://github.com/emanuele-em/proxelar

### Golang - Подготовка к собеседованию

- Go — 100 вопросов/заданий с собеседований https://habr.com/ru/articles/786826/
- Анатомия каналов в Go https://habr.com/ru/articles/490336/

### Golang - Примеры хорошего кода

- https://github.com/spf13/cobra
- https://github.com/go-gitea/gitea
- https://github.com/mholt/archiver
- https://github.com/grafana/grafana
- https://github.com/pocketbase/pocketbase

### Golang git

- https://github.com/libgit2/git2go/
- https://github.com/go-git/go-git
- https://github.com/fluxcd/go-git-providers

### Golang headless browser

- https://github.com/chromedp/chromedp

### Golang санитайзер html

- https://github.com/microcosm-cc/bluemonday

### Golang UI

- https://gioui.org/ Gio - библиотека для написания кроссплатформенных GUI-приложений с использованием языка Go, поддерживающая все основные платформы: Linux, macOS, Windows, Android, iOS, FreeBSD, OpenBSD и WebAssembly.
- https://github.com/fyne-io/fyne Fyne - простой в использовании набор инструментов для создания пользовательского интерфейса и API приложений, написанный на Go. Предназначен для разработки приложений, работающих на рабочих столах и мобильных устройствах с использованием единого исходного кода.
- https://github.com/wailsapp/wails Wails - создавайте настольные приложения с использованием Go и веб-технологий, объединяя код на Go и веб-интерфейс в единый бинарный файл для удобства разработки и использования.
- https://github.com/aarzilli/nucular Nucular - библиотека для создания GUI на Go с поддержкой mostly-immediate-mode, представляющая порт ранней версии nuklear. Важно учитывать, что проект подвержен изменениям, несовместимым с предыдущими версиями, и запросы функций без соответствующей реализации не обслуживаются.

### Rust UI

- https://github.com/slint-ui/slint/ - Slint - декларативный набор инструментов для построения нативных пользовательских интерфейсов для настольных и встроенных приложений, написанных на Rust, C++ или JavaScript, обеспечивая масштабируемость, легковесность, интуитивность и нативность на различных платформах, включая настольные ПК, встроенные системы и веб.
- https://github.com/DioxusLabs/dioxus - Dioxus - портативный, производительный и удобный фреймворк для создания кроссплатформенных пользовательских интерфейсов на Rust, поддерживающий веб, десктоп, статические сайты, мобильные приложения, TUI и другие платформы, с акцентом на разработчико-ориентированный опыт и поддержкой множества уникальных возможностей.
- https://github.com/emilk/egui - egui - простая, быстрая и универсальная библиотека немедленного режима для создания графического интерфейса на Rust, поддерживающая веб, нативное окружение и ваши любимые игровые движки. egui стремится быть самой простой в использовании библиотекой графического интерфейса на Rust и самым простым способом создать веб-приложение на Rust.
- Vizia — декларативный фреймворк для создания графических пользовательских интерфейсов (GUI) на языке программирования Rust, обеспечивающий кроссплатформенность, реактивность, гибкие макеты, стиль с использованием CSS, анимации, встроенные представления и темы, доступность, локализацию, ускоренный рендеринг с использованием GPU, и поддержку разработки аудио-плагинов. https://github.com/vizia/vizia

### Golang proxy

- https://github.com/snail007/goproxy
- https://github.com/elazarl/goproxy
- https://github.com/google/martian
- Go and Proxy Servers: Part 1 - HTTP Proxies  https://eli.thegreenplace.net/2022/go-and-proxy-servers-part-1-http-proxies/
- HTTP(S) прокси на Go в 100 строчек кода https://kovardin.ru/articles/go/https-proxy-golang/#
- Simple HTTP proxy with authorization on golang https://gist.github.com/hightemp/403acfae29b41101a27d12d0c108fb49
- Golang SSH Forward and Reverse Tunnel https://gist.github.com/hightemp/8dd52b757b8de46bd156866cc975003d
- A simple HTTP proxy by Golang  https://gist.github.com/hightemp/59bc214a35bc681df104142baa8541dc

### Тестирование почты

- https://testi.at/ - проверка рендринга шаблона в разных движках
- https://www.emailonacid.com/email-testing/
- https://proofjump.com/dark-mode-simulator/

### base64 img encoder

- https://www.base64-image.de/

### Прокси

- https://multiproxy.org/all_proxy.htm

### Поисковые системы

- https://searx.thegpm.org/
- https://search.brave.com/
- https://duckduckgo.com/
- https://www.startpage.com
- https://www.ecosia.org/
- https://metager.org/

### Проверка ip с помощью API

- `curl 'https://api.ipify.org?format=json'`
- `curl ipinfo.io/43.241.71.120/privacy?token=$TOKEN`
- `curl http://ip-api.com/json/?fields=61439`
- `curl http://ip-api.com/json/24.48.0.1`
- `curl https://ipapi.co/8.8.8.8/json/`

### Проверка ботов(браузера)

- bot.sannysoft.com - показывает общие параметры вашего клиента и проводит некоторые тесты;
- whatismybrowser.com - показывает соответствует ли сообщаемый браузер истинному;
- abrahamjuliot.github.io/creepjs - способен обнаружить методы скрытия.

### Мок-сервера

- https://github.com/keploy/keploy Keploy - инструмент для тестирования бэкенда, ориентированный на разработчиков, позволяющий проводить тесты с встроенными моками быстрее, чем unit-тесты, исходя из пользовательского трафика, обеспечивая простоту использования, мощность и расширяемость в эре искусственного интеллекта.
- https://github.com/mock-server/mockserver
  - https://www.mock-server.com/
- https://github.com/mocks-server/main

### Менеджеры запросов (API)

- https://github.com/hoppscotch/hoppscotch

### Логирующие прокси и mitm

- https://github.com/fkantelberg/log-proxy
- https://gist.github.com/owulveryck/d8d4e37cb4a905b70b080d441acf9b9a
- https://github.com/mitmproxy/mitmproxy

## Hacking

- https://github.com/Z4nzu/hackingtool

## Анализ трафика

- https://github.com/zeek/zeek
- https://github.com/jpr5/ngrep

## VPN, туннелированик

- nebula
  - https://play.google.com/store/apps/details?id=net.defined.mobile_nebula&hl=en_US
  - https://github.com/slackhq/nebula

## Пагинация

**Пагинация смещением** - это подход, при котором данные разбиваются на страницы с определенным количеством элементов на странице. При переключении на следующую страницу происходит смещение (offset) на определенное количество элементов (limit).

**Курсорная пагинация** - это подход, при котором каждый элемент списка имеет уникальный идентификатор (курсор), по которому можно определить его местоположение в списке. При переключении на следующую страницу используется курсор последнего элемента на текущей странице для получения следующих элементов. Важно, чтобы курсор был уникальным полем в таблице и элементы выводились в последовательности (были отстортированы по полю-курсору). Курсорная пагинация производительнее чем смещением, так как используется только limit и уникальное поле.

## Важное

- Сайт Fediverse.party содержит список социальных сетей, блогов и других приложений, которые работают на протоколах распределенных систем социальных сетей, таких как ActivityPub, OStatus и Zot. Все приложения разделены на категории: социальные сети, блоги и публикации, обмен медиа, обмен ссылками, события и встречи, хостинг файлов, открытые данные, обзоры, игры, разработка программного обеспечения, расширения, форумы и доски объявлений. Вы можете отсортировать все приложения по категориям, протоколам и языкам программирования. Fediverse.party помогает пользователям найти и опробовать новые приложения, которые работают на протоколах распределенных систем социальных сетей, и открыть для себя новые возможности в области социальных сетей. https://fediverse.party/en/miscellaneous/
- https://github.com/BasixKOR/awesome-activitypub

## Для работы над базой знаний

<details>
    <summary>Список</summary>
    
- https://github.com/zotero/zotero
- https://github.com/zadam/trilium
- https://github.com/Zettlr/Zettlr
- https://github.com/nocodb/nocodb
- https://github.com/apitable/apitable
- https://github.com/Budibase/budibase
- https://github.com/gristlabs/grist-core
- https://github.com/bram2w/baserow
- https://github.com/outline/outline
- https://github.com/logseq/logseq
- https://github.com/toeverything/AFFiNE
- https://github.com/xintrea/mytetra_dev
- https://github.com/churichard/notabase
- https://github.com/AppFlowy-IO/AppFlowy
- https://github.com/siyuan-note/siyuan
- https://github.com/tagspaces/tagspaces
- https://github.com/taniarascia/takenote
- https://github.com/laurent22/joplin
- https://github.com/batnoter/batnoter
- https://github.com/athensresearch/athens
- https://github.com/danobot/notorious
- http://www.wjjsoft.com/mybase.html
- https://www.remnote.com
- https://nota.md/
- https://tana.inc/
- https://www.craft.do/
- https://supernotes.app/
- https://heptabase.com/
- https://get.mem.ai/
- https://beamapp.co/
- https://saga.so/
- https://cloverapp.com/
- https://reflect.app/
- https://www.notion.so/
- https://hackmd.io/
- https://www.wiz.cn/
- https://www.dronahq.com/
- https://noloco.io/
</details>
