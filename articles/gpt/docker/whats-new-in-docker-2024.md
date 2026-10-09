# Что нового в Docker за 2024 год: подкаталоги томов и новые действия Compose Watch

В течение 2024 года вышли Docker Engine 26 и 27, а Compose расширил режим Watch. Эти версии добавили несколько полезных возможностей для хранения данных, разработки и совместимости. Номер Docker Desktop при этом свой: например, Desktop 4.34 включает host networking, которого раньше не было в Docker Desktop.

## Engine 25: вложенные bind mounts стали read-only вместе с родительским

В Engine 25.0 изменилось поведение read-only bind mount на Linux с ядром 5.12 и новее: параметр read-only теперь распространяется и на вложенные mount points. Раньше каталог-монтирование мог выглядеть read-only, но файловая система, отдельно смонтированная внутри него, оставалась доступна на запись из контейнера.

Обычная форма остаётся простой:

~~~bash
docker run --mount type=bind,src=/srv/config,dst=/etc/app,readonly my-app
~~~

Это изменение полезно для снижения риска записи в host-файлы через вложенные mounts. Если существующая схема намеренно полагалась на прежнее поведение, Docker позволяет явно задать writable вложенные mounts через `bind-recursive=writable` в синтаксисе `--mount`. Сначала проверьте такие контейнеры на тестовом хосте; нужная опция не поддерживается коротким синтаксисом `-v`.

## Engine 26: подключать только часть именованного тома

В Engine 26 для volume mounts появилась опция `volume-subpath`. Она позволяет подключить к контейнеру не весь именованный том, а только один заранее созданный подкаталог. Это удобно, когда несколько контейнеров делят общий том, но каждому нужен доступ лишь к собственным данным.

```bash
docker volume create shared-logs
docker run --rm --mount src=shared-logs,dst=/logs alpine mkdir -p /logs/api /logs/worker
docker run --rm --mount src=shared-logs,dst=/var/log/app,volume-subpath=api alpine sh -c 'echo api > /var/log/app/example.log'
docker run --rm --mount src=shared-logs,dst=/var/log/app,volume-subpath=api alpine cat /var/log/app/example.log
```

Перед подключением нужный подкаталог должен существовать внутри тома, иначе команда завершится ошибкой. В примере API-контейнер видит `api/` по пути `/var/log/app`; соседний `worker/` ему не смонтирован.

Так можно держать логи нескольких приложений в одном именованном томе, не монтируя каждое приложение ко всему каталогу соседей. Для этого сначала создают общий том и подкаталоги, после чего каждому контейнеру монтируют только его собственный путь. Подкаталог тома ограничивает видимую часть этого mount; он сам по себе не изолирует контейнеры друг от друга по другим каналам.

## Исправление DNS-утечки из internal-сетей

Engine 25.0.5 и 26.0.0 исправили уязвимость CVE-2024-29018: запросы DNS от контейнеров, подключённых только к Docker-сети `internal`, в определённой конфигурации могли передаваться внешнему DNS-серверу хоста. Так происходило, в частности, когда на хосте работал локальный резолвер на loopback-адресе вроде `127.0.0.53`.

Сеть с параметром `internal: true` используют, когда backend-контейнерам не нужен обычный выход в Интернет. Обновление Engine здесь важно не только ради новых команд: оно меняет и защитное поведение сети. После обновления проверьте DNS-резолвинг приложений, использующих internal-сети и локальный DNS хоста.

Исправление ограничивает утечку имён, которые контейнеры пытаются разрешить через такой loopback-резолвер. Если workload в internal-сети должен разрешать внешние имена, настройте для него осознанный сетевой путь, а не полагайтесь на прежнюю пересылку запросов через DNS хоста.

В Engine 26 также удалили поддержку Docker Engine API ниже версии 1.24. Старые клиенты, плагины и SDK, которые обращались к демону через более ранний API, пришлось обновить.

## Compose Watch: перезапуск и команда после синхронизации

В Compose 2.32 у Watch появились действия `restart` и `sync+exec`. `restart` перезапускает контейнер после изменений; `sync+exec` сначала копирует выбранные файлы, затем запускает команду внутри контейнера. Параметр `exec.command` требует Compose 2.32.2 или новее.

```yaml
services:
  app:
    build: .
    develop:
      watch:
        - action: sync+exec
          path: ./config
          target: /srv/app/config
          exec:
            command: ./reload-config.sh
```

Так можно синхронизировать конфигурацию, а затем попросить процесс перечитать её. Подобные правила предназначены для внутреннего цикла разработки; при изменении зависимостей или системных пакетов нужно перестроить образ.

Действия решают разные задачи: `restart` перезапускает сервис после изменения, `sync+exec` выполняет заданную команду после копирования файлов. Например, можно синхронизировать конфигурацию и запустить скрипт перезагрузки сервера. Используйте `rebuild`, когда изменился Dockerfile или список системных/языковых зависимостей: синхронизация исходников не пересобирает образ.

## Docker Desktop: host networking стал доступен в стабильном режиме

В Docker Engine на Linux режим host networking существовал и раньше. В Docker Desktop он вышел из beta и стал общедоступным в версии 4.34; режим включается в Settings → Resources → Network. Сервис с `network_mode: host` использует сетевой стек хоста напрямую, поэтому сценарии с `localhost` отличаются от обычной bridge-сети.

```yaml
services:
  debug-tool:
    image: nicolaka/netshoot
    network_mode: host
```

При host networking не задают `ports`: контейнер использует порты host network, а не отдельное отображение портов. Включайте режим только когда приложению действительно нужно работать в сети хоста. Это функция Desktop и не требует её для обычных Docker Engine на VPS.

При таком режиме процесс контейнера занимает порты в сети хоста напрямую, поэтому конфликт портов возможен между контейнерами и программами host. На Desktop функция включается в Settings; на Docker Engine для Linux host network существовал раньше.

В Docker Desktop 4.29 экспериментально появилась интеграция Compose с synchronized file shares. Файлы рабочего каталога синхронизируются в кеш внутри VM, что помогает при больших проектах, где обычные bind mounts замедляют обмен тысячами файлов. Это функция Desktop, а не серверного Engine; условия доступности и планы подписки сверяйте с текущей документацией.

## Официальные источники

- [Docker Engine 26.0: релиз-ноты](https://docs.docker.com/engine/release-notes/26.0/)
- [Docker Engine 26.1: релиз-ноты](https://docs.docker.com/engine/release-notes/26.1/)
- [Docker Engine 27: релиз-ноты](https://docs.docker.com/engine/release-notes/27/)
- [Docker Engine 25: рекурсивные read-only bind mounts и другие изменения](https://docs.docker.com/engine/release-notes/25.0/)
- [Bind mounts: рекурсивный режим и read-only](https://docs.docker.com/engine/storage/bind-mounts/)
- [Volumes: подключение подкаталога](https://docs.docker.com/engine/storage/volumes/#mount-a-volume-subdirectory)
- [Compose Develop: действия Watch и требования к версиям](https://docs.docker.com/reference/compose-file/develop/)
- [Compose v2.32.0: изменения Watch](https://github.com/docker/compose/releases/tag/v2.32.0)
- [Host networking](https://docs.docker.com/engine/network/drivers/host/)
- [Synchronized file shares в Docker Desktop](https://docs.docker.com/desktop/features/synchronized-file-sharing/)
- [Docker Desktop: host networking, начиная с 4.34](https://docs.docker.com/desktop/release-notes/)
