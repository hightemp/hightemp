# Инструменты мониторинга и диагностики Linux

Колонка «Тип» показывает, как работать с инструментом. CLI — команда в терминале, TUI — интерфейс в терминале, как у `htop`, GUI — веб-интерфейс или приложение с окном. Сервис работает в фоне, его результаты можно смотреть в другом инструменте. Колонка «Серверов» показывает, для скольких машин удобен инструмент.

| Категория | Инструмент | Тип | Серверов | Для чего нужен | Заметка |
| --- | --- | --- | --- | --- | --- |
| Базовое | [top, free, vmstat, ps (procps-ng)](https://gitlab.com/procps-ng/procps) | CLI/TUI | 1 и больше | Процессы, память, очередь на процессор, подкачка | Есть почти везде · [Шпаргалка по vmstat](utils/cheatsheet_vmstat.md) |
| Базовое | [sysstat (sar, mpstat, pidstat, iostat)](https://github.com/sysstat/sysstat) | CLI | 1 и больше | Метрики сейчас и история за прошлые часы и дни (sar) | [Шпаргалка по sar](utils/cheatsheet_sar.md) |
| Базовое | [journalctl (systemd)](https://github.com/systemd/systemd) | CLI | 1 и больше | Логи служб и ядра |  |
| Базовое | [iproute2 (ip, ss)](https://wiki.linuxfoundation.org/networking/iproute2) | CLI | 1 и больше | Интерфейсы, счётчики ошибок, соединения |  |
| Базовое | df, du | CLI | 1 и больше | Занятое место и inode (df -i) |  |
| Консоль | [htop](https://github.com/htop-dev/htop) | TUI | 1 и больше | Удобная замена top |  |
| Консоль | [btop](https://github.com/aristocratos/btop) | TUI | 1 и больше | Процессор, память, диск и сеть на одном экране |  |
| Консоль | [atop](https://github.com/Atoptool/atop) | TUI | 1 и больше | Как top, но пишет историю и умеет открывать её задним числом |  |
| Консоль | [Glances](https://github.com/nicolargo/glances) | TUI/GUI | 1 и больше | Всё на одном экране, есть веб-режим |  |
| Консоль | [ncdu](https://dev.yorhel.nl/ncdu) | TUI | 1 и больше | Что занимает место на диске |  |
| Консоль | [iotop-c](https://github.com/Tomas-M/iotop) | TUI | 1 и больше | Какой процесс нагружает диск |  |
| Консоль | [smartmontools (smartctl)](https://github.com/smartmontools/smartmontools) | CLI | 1 и больше | Здоровье диска по SMART |  |
| Консоль | [NetHogs](https://github.com/raboof/nethogs) | TUI | 1 и больше | Какой процесс занимает сеть |  |
| Консоль | [iftop](https://www.ex-parrot.com/~pdw/iftop/) | TUI | 1 и больше | С кем и на какой скорости идёт трафик |  |
| Консоль | [mtr](https://github.com/traviscross/mtr) | CLI/TUI | 1 и больше | Путь до хоста и потери на каждом участке | [Шпаргалка по mtr](utils/cheatsheet_mtr.md) |
| Консоль | [tcpdump](https://www.tcpdump.org/) | CLI | 1 и больше | Посмотреть сетевые пакеты | [Шпаргалка по tcpdump](utils/cheatsheet_tcpdump.md) |
| Глубокая диагностика | [strace](https://github.com/strace/strace) | CLI | 1 и больше | Какие системные вызовы делает процесс | [Шпаргалка по strace](utils/cheatsheet_strace.md) |
| Глубокая диагностика | [lsof](https://github.com/lsof-org/lsof) | CLI | 1 и больше | Какие файлы и порты открыты процессом | [Шпаргалка по lsof](utils/cheatsheet_lsof.md) |
| Глубокая диагностика | [perf](https://perf.wiki.kernel.org/) | CLI | 1 и больше | Профилирование процессора и ядра |  |
| Глубокая диагностика | [bpftrace](https://github.com/bpftrace/bpftrace) | CLI | 1 и больше | Своя трассировка ядра на лету (eBPF) |  |
| Глубокая диагностика | [bcc-tools](https://github.com/iovisor/bcc) | CLI | 1 и больше | Готовые eBPF-утилиты (opensnoop, biolatency и другие) |  |
| Контейнеры | docker stats | CLI | 1 и больше | Процессор, память и сеть контейнеров |  |
| Контейнеры | [ctop](https://github.com/bcicen/ctop) | TUI | 1 и больше | top для контейнеров |  |
| Контейнеры | [lazydocker](https://github.com/jesseduffield/lazydocker) | TUI | 1 и больше | Управление и просмотр контейнеров в терминале |  |
| Контейнеры | [cAdvisor](https://github.com/google/cadvisor) | сервис + GUI | 1 и больше | Метрики контейнеров | Часто работает вместе с Prometheus |
| Всё в одном | [Cockpit](https://github.com/cockpit-project/cockpit) | GUI | 1 и больше | Веб-панель управления и мониторинга сервера |  |
| Всё в одном | [Netdata](https://github.com/netdata/netdata) | GUI | 1 и больше | Сотни метрик с секундной детализацией из коробки | Есть режим для нескольких серверов |
| Всё в одном | [Monit](https://mmonit.com/monit/) | сервис + GUI | 1 и больше | Следит за службами и перезапускает упавшие |  |
| Всё в одном | [Uptime Kuma](https://github.com/louislam/uptime-kuma) | GUI | 1 и больше | Проверка снаружи: сайт открывается, порт отвечает, оповещение, если нет |  |
| Метрики и оповещения | [Prometheus](https://github.com/prometheus/prometheus) | сервис | много | Сбор и хранение метрик | Очень часто используется |
| Метрики и оповещения | [node_exporter](https://github.com/prometheus/node_exporter) | сервис | много | Агент: отдаёт метрики Linux-сервера для Prometheus | Ставится на каждый сервер |
| Метрики и оповещения | [blackbox_exporter](https://github.com/prometheus/blackbox_exporter) | сервис | много | Проверка снаружи: HTTP, TCP, ping |  |
| Метрики и оповещения | [Alertmanager](https://github.com/prometheus/alertmanager) | сервис | много | Оповещения: группирует и отправляет в Telegram, почту, Slack |  |
| Метрики и оповещения | [Grafana](https://github.com/grafana/grafana) | GUI | много | Графики и дашборды, умеет и оповещения | Очень часто используется |
| Метрики и оповещения | [VictoriaMetrics](https://github.com/VictoriaMetrics/VictoriaMetrics) | сервис | много | Хранилище метрик, совместимо с Prometheus, легче при больших объёмах |  |
| Метрики и оповещения | [Thanos](https://github.com/thanos-io/thanos) | сервис | много | Долгое хранение и объединение нескольких Prometheus |  |
| Метрики и оповещения | [Grafana Mimir](https://github.com/grafana/mimir) | сервис | очень много | Масштабируемое хранилище метрик |  |
| Метрики и оповещения | [Telegraf](https://github.com/influxdata/telegraf) | сервис | много | Универсальный агент сбора метрик | Часто в паре с [InfluxDB](https://github.com/influxdata/influxdb) |
| Метрики и оповещения | [Zabbix](https://github.com/zabbix/zabbix) | сервис + GUI | много | Всё в одном: сбор, хранение, графики, оповещения | Классический вариант |
| Метрики и оповещения | [Nagios Core](https://github.com/NagiosEnterprises/nagioscore) | сервис + GUI | много | Проверка доступности и оповещения | Один из старейших |
| Метрики и оповещения | [Icinga 2](https://github.com/Icinga/icinga2) | сервис + GUI | много | Развитие идей Nagios |  |
| Метрики и оповещения | [Checkmk](https://github.com/Checkmk/checkmk) | сервис + GUI | много | Всё в одном, много готовых проверок |  |
| Логи | [Elasticsearch](https://github.com/elastic/elasticsearch), [Logstash](https://github.com/elastic/logstash), [Kibana](https://github.com/elastic/kibana) (ELK) | сервис + GUI | много | Хранение, обработка и поиск по логам | Очень часто используется |
| Логи | [OpenSearch](https://github.com/opensearch-project/OpenSearch) | сервис + GUI | много | форк Elasticsearch |  |
| Логи | [Grafana Loki](https://github.com/grafana/loki) | сервис | много | Хранилище логов, смотрится через Grafana | Очень часто используется |
| Логи | [Graylog](https://github.com/Graylog2/graylog2-server) | сервис + GUI | много | Сбор логов и поиск по ним |  |
| Агенты | [Grafana Alloy](https://github.com/grafana/alloy) | сервис | много | Собирает логи, метрики и трейсы | Пришёл на смену [Promtail](https://community.grafana.com/t/promtail-is-now-end-of-life-eol-how-to-migrate-to-grafana-alloy-for-existing-loki-server-deployments/162087) и [Grafana Agent](https://grafana.com/docs/agent/latest/about/), они закрыты, но, возможно, в старых инфрах вы встретитесь с этим. |
| Агенты | [Vector](https://github.com/vectordotdev/vector) | сервис | много | Агент и обработчик логов и метрик |  |
| Агенты | [Fluent Bit](https://github.com/fluent/fluent-bit) | сервис | много | Лёгкий агент для логов и метрик |  |
| Трейсы | [OpenTelemetry](https://github.com/open-telemetry/opentelemetry-collector) | сервис | много | Стандарт и коллектор для метрик, логов и трейсов |  |
| Трейсы | [Jaeger](https://github.com/jaegertracing/jaeger) | сервис + GUI | много | Хранение и просмотр трейсов |  |
| Трейсы | [Grafana Tempo](https://github.com/grafana/tempo) | сервис | много | Хранилище трейсов, смотрится через Grafana |  |
| Трейсы | [Zipkin](https://github.com/openzipkin/zipkin) | сервис + GUI | много | Хранение и просмотр трейсов |  |
| Хранилище | [ClickHouse](https://github.com/ClickHouse/ClickHouse) | сервис | много | Колоночная база данных. Сама мониторингом не занимается, но на ней строят хранилища логов, метрик и трейсов | Например, [SigNoz](https://github.com/SigNoz/signoz) |

Источник — [Linux: Мониторинг. Что смотреть, зачем и какие есть инструменты](https://habr.com/ru/companies/ruvds/articles/1095070/).
