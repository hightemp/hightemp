
## Остальное

### Golang headless browser

- https://github.com/chromedp/chromedp

### Golang UI

- https://gioui.org/ Gio - библиотека для написания кроссплатформенных GUI-приложений с использованием языка Go, поддерживающая все основные платформы: Linux, macOS, Windows, Android, iOS, FreeBSD, OpenBSD и WebAssembly.
- https://github.com/fyne-io/fyne Fyne - простой в использовании набор инструментов для создания пользовательского интерфейса и API приложений, написанный на Go. Предназначен для разработки приложений, работающих на рабочих столах и мобильных устройствах с использованием единого исходного кода.
- https://github.com/wailsapp/wails Wails - создавайте настольные приложения с использованием Go и веб-технологий, объединяя код на Go и веб-интерфейс в единый бинарный файл для удобства разработки и использования.
- https://github.com/aarzilli/nucular Nucular - библиотека для создания GUI на Go с поддержкой mostly-immediate-mode, представляющая порт ранней версии nuklear. Важно учитывать, что проект подвержен изменениям, несовместимым с предыдущими версиями, и запросы функций без соответствующей реализации не обслуживаются.

### Rust UI

- https://github.com/slint-ui/slint/ - Slint - декларативный набор инструментов для построения нативных пользовательских интерфейсов для настольных и встроенных приложений, написанных на Rust, C++ или JavaScript, обеспечивая масштабируемость, легковесность, интуитивность и нативность на различных платформах, включая настольные ПК, встроенные системы и веб.

### Golang proxy

- https://github.com/elazarl/goproxy
- Go and Proxy Servers: Part 1 - HTTP Proxies  https://eli.thegreenplace.net/2022/go-and-proxy-servers-part-1-http-proxies/
- HTTP(S) прокси на Go в 100 строчек кода https://kovardin.ru/articles/go/https-proxy-golang/#
- Simple HTTP proxy with authorization on golang https://gist.github.com/hightemp/403acfae29b41101a27d12d0c108fb49
- Golang SSH Forward and Reverse Tunnel https://gist.github.com/hightemp/8dd52b757b8de46bd156866cc975003d
- A simple HTTP proxy by Golang  https://gist.github.com/hightemp/59bc214a35bc681df104142baa8541dc

### Тестирование почты

- https://testi.at/ - проверка рендринга шаблона в разных движках
- https://www.emailonacid.com/email-testing/
- https://proofjump.com/dark-mode-simulator/

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
