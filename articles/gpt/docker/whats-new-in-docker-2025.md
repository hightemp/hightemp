# Что нового в Docker за 2025 год: защищённые порты, containerd store и SBOM

Docker Engine, Compose и Docker Desktop имеют независимые версии. В 2025 году вышли Engine 28 и 29, Compose 2.39 и Compose 5.0. Здесь — изменения, которые повлияли на доступность сервисов, хранение образов и сборку.

## Engine 28: безопаснее публиковать порт на localhost

В версиях Docker Engine до 28.0.0 порт, привязанный на хосте к `127.0.0.1`, при определённых условиях могли открыть другие устройства из того же L2-сегмента сети. То есть правило, предназначенное для локального прокси на сервере, не всегда ограничивало доступ только самим хостом.

Начиная с Engine 28 привязка работает как ожидалось:

```yaml
services:
  app:
    ports:
      - "127.0.0.1:8080:80"
```

Теперь запросы с других машин из локальной сети не должны попадать на этот опубликованный порт. Перед использованием такой схемы на старом сервере проверьте версию Engine и обновите её. Исключение — специальный opt-out **DOCKER_INSECURE_NO_IPTABLES_RAW=1**: он отключает часть сетевых правил Engine 28 и ослабляет эту защиту, поэтому не подходит для production.

В Engine 28 появился экспериментальный image mount: он подключает содержимое другого образа внутрь контейнера. В Engine 29.7 эту возможность вывели из экспериментального статуса.

Пока функция была экспериментальной, она уже позволяла вынести отладочные инструменты в отдельный образ и читать их из другого контейнера:

```bash
docker pull busybox:musl
docker run --rm \
  --mount type=image,source=busybox:musl,destination=/dbg \
  alpine /dbg/bin/echo "Tools mounted from another image"
```

Источник должен быть заранее загружен в локальное хранилище; Docker не делает pull автоматически при создании mount. Image mount доступен только для чтения и требует containerd image store. Образ BusyBox с musl подходит к Alpine по системной библиотеке; произвольный бинарник из другого дистрибутива может не запуститься из-за несовместимого dynamic linker.

## Engine 29: containerd image store для новых установок

В Engine 29.0 containerd image store стал хранилищем по умолчанию для свежих установок, кроме конфигураций с `userns-remap`. Обновлённые с более ранней версии демоны продолжают использовать прежнее хранилище, пока администратор не меняет настройку.

Новое хранилище использует containerd snapshotters вместо классических storage drivers. Оно умеет хранить локально multi-platform образы и image attestations для provenance и SBOM. При переключении между старым и новым хранилищем образы из неактивного backend остаются на диске, но перестают отображаться в обычных командах Docker. На образах также может вырасти потребление диска: containerd хранит как сжатые, так и распакованные слои.

На production-хосте учитывайте собственный путь хранения containerd. Если Docker настроен на нестандартный каталог данных, путь containerd туда автоматически не переносится. Перед переключением сохраните образы, которые существуют только локально, и оцените свободное место.

В Engine 29.0 подняли минимальную версию Engine API до `1.44`, поэтому старые SDK или панели могли перестать подключаться к демону. В Engine 29.3 этот порог понизили до `1.40` — подробности приведены в статье [за 2026 год](whats-new-in-docker-2026.md).

В том же Engine 29 Docker CLI лишился Docker Content Trust. Если ваши скрипты используют старые команды `docker trust` или переменную `DOCKER_CONTENT_TRUST`, проверьте и обновите процедуру проверки подписи до перехода на эту ветку.

Проверить, какое хранилище активно, можно так:

```bash
docker info -f '{{ .DriverStatus }}'
```

## Compose добавил provenance и SBOM в настройки build

Compose 2.39 научился передавать настройки provenance и SBOM в BuildKit. Provenance содержит сведения о происхождении и процессе сборки образа, а SBOM перечисляет его компоненты.

```yaml
services:
  app:
    build:
      context: .
      provenance: mode=max
      sbom: true
```

Эти аттестации полезны в цепочке поставки: их можно публиковать вместе с образом и проверять в registry. Они дают сборочные метаданные и список компонентов, но сами по себе не подтверждают отсутствие уязвимостей. Значение `mode=max` запрашивает более подробную provenance-аттестацию; включайте его после проверки, какие данные сборки будут опубликованы.

## Почему Compose перескочил с v2 на v5

В декабре 2025 вышел Docker Compose 5.0. Это версия CLI-плагина, а не версия YAML-файла. Нумерацию 3 и 4 пропустили, чтобы не смешивать версии Compose CLI с устаревшими номерами формата compose-файла. Поле верхнего уровня `version:` в современном compose.yaml объявлено устаревшим и игнорируется.

Ещё одно изменение Compose 5.0 касается сборки: встроенный builder убрали и делегировали сборки Docker Bake. Проекты и CI, которые вызывают `docker compose build`, должны использовать актуальный Buildx/Bake-плагин.

Bake описывает несколько целей сборки и может собирать их как единый набор. Для обычного проекта с одним сервисом команда Compose остаётся прежней; изменение касается backend, который выполняет сборку, и важно для сборочных параметров и CI. Старый Compose CLI нужно обновлять как plugin, не меняя формат файла на «Compose v5».

## Desktop-функция: запуск локальных моделей

В Docker Desktop 4.45 Docker Model Runner вышел в общедоступный статус. Он позволяет загружать и запускать модели локально, а приложениям обращаться к ним через API. Это возможность Docker Desktop; она не устанавливает модельный сервер на обычный Docker Engine для VPS.

Практический сценарий — разработчик поднимает локальную модель в Desktop и подключает к ней тестируемое приложение по HTTP API. Desktop управляет загрузкой и запуском моделей; контейнеры приложения могут обращаться к endpoint модели, пока обе стороны доступны в соответствующей Docker Desktop сети.

## Официальные источники

- [Docker Engine 28: релиз-ноты](https://docs.docker.com/engine/release-notes/28/)
- [Публикация портов и поведение localhost](https://docs.docker.com/engine/network/port-publishing/)
- [Docker Engine 29: релиз-ноты](https://docs.docker.com/engine/release-notes/29/)
- [Удалённые возможности Docker Engine, включая Docker Content Trust](https://docs.docker.com/engine/deprecated/)
- [Containerd image store: совместимость и миграция](https://docs.docker.com/engine/storage/containerd/)
- [Image mounts: синтаксис и ограничения](https://docs.docker.com/engine/storage/image-mounts/)
- [Compose Build: поля provenance и sbom](https://docs.docker.com/reference/compose-file/build/)
- [Compose v2.39.0](https://github.com/docker/compose/releases/tag/v2.39.0)
- [Compose v5.0.0 и причины новой нумерации](https://github.com/docker/compose/releases/tag/v5.0.0)
- [Верхнеуровневое поле version в Compose Specification](https://github.com/compose-spec/compose-spec/blob/main/spec.md#version-top-level-element)
- [Docker Bake](https://docs.docker.com/build/bake/)
- [Docker Desktop: релиз-ноты](https://docs.docker.com/desktop/release-notes/)
