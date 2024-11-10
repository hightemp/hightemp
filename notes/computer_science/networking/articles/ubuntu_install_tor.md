# Tor: Анонимное Сетевое Соединение

**[Tor](https://www.torproject.org/ "https://www.torproject.org/")** — система, позволяющая устанавливать анонимное сетевое соединение, защищённое от прослушивания. Рассматривается как анонимная сеть, предоставляющая передачу данных в зашифрованном виде.

В данной статье будет рассмотрена работа через Tor с обычными браузерами, что не гарантирует анонимность. Если вы хотите большей безопасности, установите Tor согласно [данной официальной инструкции](https://www.torproject.org/docs/tor-doc-unix.html.en "https://www.torproject.org/docs/tor-doc-unix.html.en").

## Установка Tor

Устанавливаем необходимые пакеты:

```bash
sudo apt-get install tor tor-geoipdb privoxy 
```

Если вам нужна последняя версия Tor (например, для обфускации трафика), установите пакеты из официальных репозиториев согласно [данной инструкции](https://www.torproject.org/docs/debian.html.en#ubuntu "https://www.torproject.org/docs/debian.html.en#ubuntu").

## Настройка

Создайте резервную копию базовой конфигурации для privoxy:

```bash
sudo mv /etc/privoxy/config /etc/privoxy/config.backup 
sudo gedit /etc/privoxy/config 
```

Вставьте и сохраните следующее содержимое:

```plaintext
# Generally, this file goes in /etc/privoxy/config
#
# Tor listens as a SOCKS5 proxy here:
forward-socks5 / 127.0.0.1:9050 .
confdir /etc/privoxy
logdir /var/log/privoxy
actionsfile default.action   # Main actions file
actionsfile user.action      # User customizations
filterfile default.filter
 
# Don't log interesting things, only startup messages, warnings and errors
logfile logfile
debug   4096 # Startup banner and warnings
debug   8192 # Errors - *we highly recommended enabling this*
  
user-manual /usr/share/doc/privoxy/user-manual
listen-address  127.0.0.1:8118
toggle  1
enable-remote-toggle 0
enable-edit-actions 0
enable-remote-http-toggle 0
buffer-limit 4096
```

Перезапустите службу:

```bash
sudo service privoxy restart 
```

Настройте Tor в браузере. Для Firefox удобно использовать [данное дополнение](https://addons.mozilla.org/ru/firefox/addon/mm3-proxyswitch "https://addons.mozilla.org/ru/firefox/addon/mm3-proxyswitch").

Использовать torbutton для свежих версий Firefox не рекомендуется (torbutton предназначен для версий Firefox, включаемых в состав Tor Browser Bundle). Скачать torbutton можно по следующим ссылкам:

- [Все версии](https://www.torproject.org/torbutton/index.html.en "https://www.torproject.org/torbutton/index.html.en")
- [Текущая версия stable](https://www.torproject.org/dist/torbutton/torbutton-current.xpi "https://www.torproject.org/dist/torbutton/torbutton-current.xpi")

Для быстрого переключения в любом браузере можно использовать любое дополнение, предназначенное для переключения прокси (**proxy switcher**). 

> Для Google Chrome единственным работоспособным расширением оказалось [Proxy SwitchySharp](https://chrome.google.com/webstore/detail/proxy-switchysharp/dpplabbmogkhghncfbfdeeokoefdjegm "https://chrome.google.com/webstore/detail/proxy-switchysharp/dpplabbmogkhghncfbfdeeokoefdjegm").

## Проверка

В настройках прокси укажите следующие параметры:

- **Узел**: 127.0.0.1
- **Порт**: 9050

Переключите прокси в браузере и проверьте, видит ли вас Большой Брат:

- [Tor Check](https://check.torproject.org/ "https://check.torproject.org/")
- [2ip.ru](http://2ip.ru/ "http://2ip.ru/")
- [Yandex Internet](http://internet.yandex.ru/ "http://internet.yandex.ru/")

## Получение нового НИМа (смена конечной ноды Tor)

Если вас не устроила текущая выходная нода, её можно [менять с помощью скрипта](https://stem.torproject.org/faq.html#how-do-i-request-a-new-identity-from-tor "https://stem.torproject.org/faq.html#how-do-i-request-a-new-identity-from-tor").

```bash
sudo apt install empty-expect telnet
```

Задайте пароль `_new_tor_password_` для доступа к Tor по telnet:

```bash
tor --hash-password 'new_tor_password'
```

Добавьте в конфигурацию Tor следующие строки:

```bash
sudo nano /etc/tor/torrc
```

```plaintext
ControlPort 9051
HashedControlPassword 16:47015F09825889D86059FF44D9562496912AC67CD0EB93DAA25427F194
```

Создайте скрипт для автоматической смены НИМа:

```bash
#!/bin/sh
# Автоматическая смена НИМа в Tor
empty -f -i torin -o torout telnet 127.0.0.1 9051
empty -s -o torin "AUTHENTICATE \"new_tor_password\"\n"
empty -s -o torin "signal NEWNYM\n"
empty -s -o torin "quit\n"
```

> Обратите внимание: ваш пароль хранится в скрипте в открытом виде! Дайте ему права на выполнение и запускайте при необходимости.

## Работа с Onion-ресурсами

Внутри сети Tor доступны ресурсы в псевдо-доменной зоне `.onion`. Список данных ресурсов можно увидеть [здесь](http://thehiddenwiki.org/ "http://thehiddenwiki.org/") (может потребоваться соединение через Tor).

### Настройки браузеров для работы с onion-ресурсами

#### Mozilla Firefox 

Перейдите в **about:config**, найдите параметр `network.proxy.socks_remote_dns` и установите его значение в `true`.

Эта настройка определяет, будет ли DNS-запросы, осуществляемые с использованием SOCKS-прокси, отправляться на удаленный SOCKS-сервер или обрабатываться на локальном компьютере.

#### Chromium/Google Chrome 

Перейдите в **Настройки**, выберите «**Показать дополнительные настройки**» и сделайте пункт «**Предсказывать сетевые действия для ускорения загрузки страниц**» неактивным.

## Использование PAC-файла для упрощения доступа к onion-ресурсам

С помощью [PAC-файла](https://en.wikipedia.org/wiki/Proxy_auto-config "https://en.wikipedia.org/wiki/Proxy_auto-config") можно настроить доступ к определённым доменным именам с помощью конкретных прокси.

```javascript
function FindProxyForURL(url, host) {
    if (dnsDomainIs(host, ".i2p")) {
        return "PROXY 127.0.0.1:4444";
    }        
    if (dnsDomainIs(host, ".onion")) {
        return "SOCKS5 127.0.0.1:9050";
    } else {
        return "DIRECT";
    }
}
```

## Обход блокировки Tor

Существует два основных метода блокировки Tor: блокировка известных IP-адресов узлов Tor и глубокий анализ трафика. Рекомендуется [обфусцировать](https://www.torproject.org/projects/obfsproxy-debian-instructions.html.en#instructions "https://www.torproject.org/projects/obfsproxy-debian-instructions.html.en#instructions") трафик и использовать [мосты](https://www.torproject.org/docs/bridges "https://www.torproject.org/docs/bridges").

## Обфускация трафика

Обновите Tor до [последней stable-версии](https://www.torproject.org/docs/debian.html.en#ubuntu "https://www.torproject.org/docs/debian.html.en#ubuntu") и установите утилиту для обфускации, например, **obfs4proxy**.

```bash
sudo nano /etc/apt/sources.list 
```

Добавьте строку:

```plaintext
deb http://deb.torproject.org/torproject.org obfs4proxy main 
```

Обновите информацию о репозиториях:

```bash
sudo apt update 
```

Установите пакет:

```bash
sudo apt-get install obfs4proxy 
```

Замените содержимое файла **/etc/tor/torrc** следующим:

```plaintext
SocksPort 9050
ORPort auto
BridgeRelay 1
Exitpolicy reject *:*
ExtORPort auto

ServerTransportPlugin obfs4 exec /usr/bin/obfs4proxy
```

Перезапустите Tor:

```bash
sudo service tor restart
```

## Использование мостов

Для получения мостов посетите [эту страницу](https://bridges.torproject.org/bridges?transport=obfs4 "https://bridges.torproject.org/bridges?transport=obfs4") или отправьте письмо на адрес **bridges@bridges.torproject.org** с темой **get transport obfs4**.

Затем измените файл **/etc/tor/torrc** следующим образом:

```plaintext
UseBridges 1

SocksPort 9050
Exitpolicy reject *:*
ExtORPort auto

ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy managed
bridge obfs4 111.111.111.113:2222 FF7652873C326B0AF41587409E88C8612B8FE654 cert=fP23efkIrlPawTerdcUpN3Uatrh9jQcP0UpnPkfcfge5WiPP1mVffEfgesGgAgnBO97lOA iat-mode=0
```

Перезапустите Tor:

```bash
sudo service tor restart
```

## Использование Tor через IPv6

Установите IPv4-IPv6 туннель Miredo:

```bash
sudo apt install miredo
```

> Проверьте работоспособность:

```bash
ping6 ipv6.google.com
```

Теперь измените файл конфигурации Tor:

- Для **Tor Browser** удалите всё содержимое файла `torrc` в `/path/to/tor/tor-browser_en-US/Browser/TorBrowser/Data/Tor/` и вставьте:

```plaintext
ClientUseIPv4 0
```

- Для установленного пакета Tor измените конфиг **/etc/tor/torrc**:

```plaintext
ClientUseIPv4 0
SocksPort 9050
Exitpolicy reject *:*
ExitPolicy reject6 *:* 
ExtORPort auto
ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy managed
```

Это запрещает Tor подключаться к IPv4-адресам, которые могут блокироваться вашим провайдером.

[tor](https://help.ubuntu.ru/tag/tor?do=showtag&tag=tor "tag:tor"), [Безопасность](https://help.ubuntu.ru/tag/%D0%B1%D0%B5%D0%B7%D0%BE%D0%BF%D0%B0%D1%81%D0%BD%D0%BE%D1%81%D1%82%D1%8C?do=showtag&tag=%D0%91%D0%B5%D0%B7%D0%BE%D0%BF%D0%B0%D1%81%D0%BD%D0%BE%D1%81%D1%82%D1%8C "tag:безопасность")