# Fail2ban — блокировка повторных неудачных попыток входа

Fail2ban читает журнал службы, находит записи о неудачных попытках и блокирует адрес, когда событий становится слишком много. Например, можно временно закрыть доступ к SSH для IP, с которого за десять минут зафиксировано пять подходящих отказов.

## Установка

```bash
# Debian и Ubuntu
sudo apt install fail2ban

# Fedora
sudo dnf install fail2ban

fail2ban-client --version
```

`fail2ban-server` — процесс, который читает источник событий и применяет блокировки. `fail2ban-client` проверяет конфигурацию и управляет запущенным процессом. `fail2ban-regex` проверяет, какие строки распознаёт фильтр.

## Из чего состоит правило

| Понятие | Что означает |
| --- | --- |
| `jail` | Правило для службы. Объединяет источник журнала, фильтр, порог срабатывания и действие. Например, `[sshd]` для SSH |
| `filter` | Набор правил распознавания событий, обычно из `/etc/fail2ban/filter.d/`. `failregex` ищет строку об ошибке и выделяет IP |
| `backend` | Способ чтения журнала. `systemd` читает journal, `polling` следит за текстовыми файлами |
| `findtime` | Период, за который учитываются обнаруженные события для одного адреса |
| `maxretry` | Сколько событий для одного адреса требуется, чтобы применить блокировку |
| `bantime` | Длительность блокировки |
| `ignoreip` | Адреса или подсети, для которых правило пропускает блокировку |
| `action` и `banaction` | `action` задаёт, что сделать при бане и его снятии. `banaction` выбирает механизм блокировки для стандартного действия, например правило межсетевого экрана |

Настройки пакета находятся в `/etc/fail2ban/jail.conf`. Для своих изменений удобно использовать `/etc/fail2ban/jail.d/*.local`. Сначала загружаются `jail.conf` и `jail.d/*.conf`, затем `jail.local` и `jail.d/*.local`. Списки файлов в `jail.d` читаются по алфавиту. Более поздняя настройка переопределяет одноимённую более раннюю настройку. [Руководство jail.conf(5)](https://manpages.debian.org/trixie/fail2ban/jail.conf.5.en.html)

## Настроить защиту SSH

### SSH пишет в systemd journal

Сохрани пример в `/etc/fail2ban/jail.d/sshd.local`.

```ini
[sshd]
enabled = true
port = 22
backend = systemd
findtime = 10m
maxretry = 5
bantime = 1h
ignoreip = 127.0.0.1/8 ::1
```

При такой конфигурации пять событий за десять минут приводят к бану на час. Подставь фактический порт SSH. При действии, которое ограничивает бан заданными портами, `port` используется для правила межсетевого экрана. Если администратор подключается со стабильного доверенного IP, его можно добавить в `ignoreip` через пробел.

Для `backend = systemd` фильтр выбирает записи журнала по `journalmatch`. Посмотри, какое имя службы используется на твоей системе. На Debian и Ubuntu обычно встречается `ssh.service`, в других дистрибутивах — `sshd.service`.

```bash
sudo journalctl -u ssh.service --since '30 minutes ago'
sudo fail2ban-regex systemd-journal sshd
```

Если установка использует `sshd.service`, подставь это имя в `journalctl`. Вторую команду удобно использовать для проверки штатного фильтра по журналу. [Штатный фильтр sshd](https://github.com/fail2ban/fail2ban/blob/master/config/filter.d/sshd.conf) · [Руководство fail2ban-regex(1)](https://manpages.debian.org/trixie/fail2ban/fail2ban-regex.1.en.html)

### SSH пишет в текстовый журнал

Если записи идут в `/var/log/auth.log`, в той же секции `[sshd]` выбери файловый источник.

```ini
backend = polling
logpath = /var/log/auth.log
```

`logpath` задаёт фактический путь к файлу. Например, в конфигурациях семейства RHEL журнал SSH может быть в `/var/log/secure`. Сначала убедись, что в выбранном файле действительно появляются записи от SSH.

```bash
sudo fail2ban-regex --print-all-matched /var/log/auth.log sshd
```

### Проверить и применить конфигурацию

```bash
# Первый запуск в системе с systemd после успешной проверки
sudo fail2ban-client -t && sudo systemctl enable --now fail2ban

sudo fail2ban-client ping
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

`-t` проверяет конфигурацию. Если служба уже запущена, после правки можно перечитать конфигурацию успешным выполнением двух команд.

```bash
sudo fail2ban-client -t && sudo fail2ban-client reload
```

`status` показывает активные jail, а `status sshd` — его счётчики и список заблокированных адресов. Для уже существующего jail можно перечитать только его настройки командой `sudo fail2ban-client reload sshd`. [Руководство fail2ban-client(1)](https://manpages.debian.org/trixie/fail2ban/fail2ban-client.1.en.html)

## Проверить фильтр на тестовом журнале

Пример создаёт временный файл с одной строкой SSH. `fail2ban-regex` должен найти одно совпадение. Он читает журнал независимо от запущенного сервиса и сам не добавляет правила блокировки.

```bash
fail2ban_demo_log=$(mktemp) || exit 1
printf '%s\n' 'Jan  2 12:00:00 lab sshd[4242]: Failed password for invalid user example from 192.0.2.10 port 51234 ssh2' > "$fail2ban_demo_log"

fail2ban-regex --print-all-matched "$fail2ban_demo_log" sshd
rm -- "$fail2ban_demo_log"
```

`sshd` — имя фильтра. В итогах смотри `matched`, `missed` и совпавшие строки. Если фильтр видит событие, а текущий jail его пропускает, сравни источник журнала и период, за который накопились события.

## Посмотреть бан и снять его

```bash
sudo fail2ban-client get sshd banip
sudo fail2ban-client get sshd bantime
sudo fail2ban-client get sshd findtime
sudo fail2ban-client get sshd maxretry
sudo fail2ban-client get sshd ignoreip

sudo fail2ban-client set sshd unbanip 192.0.2.10  # снять бан в jail sshd
sudo fail2ban-client set sshd banip 192.0.2.10    # вручную заблокировать адрес
```

`Currently banned` показывает число адресов, которые сейчас заблокированы этим правилом. `Banned IP list` перечисляет их. Ручное снятие бана в `sshd` относится только к этому jail. Если адрес заблокирован и другим jail, проверь его отдельно.

## Если правило не срабатывает

| Симптом | Что проверить |
| --- | --- |
| `sshd` отсутствует в `status` | Посмотри результат `fail2ban-client -t` и итоговую конфигурацию `fail2ban-client -d`. Сверь, что в секции `[sshd]` включено `enabled = true` |
| Журнал службы содержит отказы, а фильтр их пропускает | Проверь строки через `fail2ban-regex`. Для `systemd` посмотри активное условие командой `sudo fail2ban-client get sshd journalmatch` |
| Фильтр находит события, а IP отсутствует в списке банов | Сверь `findtime`, `maxretry` и `ignoreip`. События должны относиться к одному адресу и попадать в настроенный период |
| IP в списке банов, а подключение проходит | Посмотри `sudo fail2ban-client get sshd actions`, фактический порт и журналы Fail2ban. Проверь, применяется ли правило межсетевого экрана на пути этого трафика |
| Служба не запускается | Посмотри `sudo journalctl -u fail2ban --since '30 minutes ago'`. Для запущенного сервиса `sudo fail2ban-client get logtarget` покажет, куда пишутся сообщения о банах и ошибках действия |

За обратным прокси проверь, какой IP оказывается в журнале службы. Fail2ban применяет действие к найденному адресу. Для опубликованных портов контейнера отдельно проверь, что трафик проходит через цепочку межсетевого экрана, в которой действует блокировка.

## Пример для HTTP-аутентификации NGINX

Если отказы встроенной HTTP-аутентификации NGINX попадают в `/var/log/nginx/error.log`, можно включить штатный jail. Подставь свой путь к журналу и фактические порты.

```ini
[nginx-http-auth]
enabled = true
port = http,https
backend = polling
logpath = /var/log/nginx/error.log
```

```bash
sudo fail2ban-regex --print-all-matched /var/log/nginx/error.log nginx-http-auth
sudo fail2ban-client -t
```

Для неудачных входов в само приложение используй фильтр, который распознаёт записи о входе в журнале приложения. [Штатный фильтр nginx-http-auth](https://github.com/fail2ban/fail2ban/blob/master/config/filter.d/nginx-http-auth.conf)

## Источники

- [Официальный репозиторий Fail2ban](https://github.com/fail2ban/fail2ban)
- [jail.conf(5), настройки jail и порядок чтения файлов](https://manpages.debian.org/trixie/fail2ban/jail.conf.5.en.html)
- [fail2ban-client(1), управление сервисом](https://manpages.debian.org/trixie/fail2ban/fail2ban-client.1.en.html)
- [fail2ban-regex(1), проверка фильтров](https://manpages.debian.org/trixie/fail2ban/fail2ban-regex.1.en.html)
