# Codex: справочник config.toml

**Срез — 12 октября 2026 года.** Здесь собраны все ключи из опубликованного Configuration Reference и все достижимые поля официальной JSON Schema: **1014 записей**, включая вложенные таблицы, шаблоны имён, старые названия и технические настройки. Повторяющиеся структуры hooks описаны через `<Event>`, словари — через `<name>`, элементы массивов — через `[]`. Старые profiles перечислены отдельным шаблоном с допустимыми полями.

Источники: [Configuration Reference](https://learn.chatgpt.com/docs/config-file/config-reference), [JSON Schema](https://learn.chatgpt.com/docs/config-schema.json), [Config basics](https://learn.chatgpt.com/docs/config-file/config-basic), [Advanced Config](https://learn.chatgpt.com/docs/config-file/config-advanced), [Sample Config](https://learn.chatgpt.com/docs/config-file/config-sample), [Hooks](https://learn.chatgpt.com/docs/hooks), [Permissions](https://learn.chatgpt.com/docs/permissions).

Схема содержит внутренние и экспериментальные поля. Если публичного объяснения поведения нет, это явно отмечено: по одному названию ключа нельзя установить его эффект. Открытые таблицы допускают произвольные имена; каталог описывает опубликованные поля и формы записи, а не неизвестные внутренние настройки каждого клиента.

## Навигация

- [Файлы, приоритет и синтаксис](#config-basics)
- [Короткие примеры](#examples)
- [Модели, контекст и инструкции](#models)
- [Подтверждения и автопроверка](#approval)
- [Команды, песочница и окружение](#execution)
- [Permission profiles](#permissions)
- [Субагенты и роли](#agents)
- [Провайдеры моделей](#providers)
- [MCP](#mcp)
- [Приложения](#apps)
- [Плагины и marketplaces](#plugins)
- [Навыки](#skills)
- [Память и цели](#memories)
- [Инструменты и web search](#tools)
- [Браузер и Computer Use](#browser)
- [Hooks](#hooks)
- [OpenTelemetry](#otel)
- [TUI и все клавиатурные действия](#tui)
- [Структурированные features](#features)
- [Технические флаги без публичного описания](#technical-flags)
- [Хранение, вход и служебное состояние](#storage)
- [Realtime, cloud и orchestrator](#realtime)
- [Desktop](#desktop)
- [Legacy-профили](#legacy-profiles)

<a id="config-basics"></a>

## Файлы, приоритет и синтаксис

### Где хранится конфигурация

- Пользовательская: `$CODEX_HOME/config.toml`, обычно `~/.codex/config.toml`.
- Проектная: `.codex/config.toml`; загружается только для доверенного проекта.
- Выбранный профиль: `$CODEX_HOME/<profile-name>.config.toml`.
- Системная на Unix: `/etc/codex/config.toml`.
- Управляемые требования организации: отдельный `requirements.toml`; его ограничения могут запрещать значения пользовательской конфигурации.

Приоритет обычных значений, от высшего к низшему: CLI / `--config` → доверенная проектная конфигурация, ближайшая к рабочему каталогу → выбранный файл профиля → пользовательская → cloud-managed defaults → системная → встроенные значения. У требований организации отдельные правила приоритета. [Configuration precedence](https://learn.chatgpt.com/docs/config-file/config-basic#configuration-precedence).

Проектный файл не может переопределять некоторые host-настройки: например, провайдеры, endpoint, `notify`, профили и OTel. Их задают в пользовательском или разрешённом управляемом слое. Применимость к CLI, IDE, desktop и Work Cloud различается. [Область действия настроек](https://learn.chatgpt.com/docs/config-file/config-reference#configtoml).

### Как читать таблицы

- `boolean` — `true` / `false`; `integer` — целое; `number` — число; `string` — строка.
- `table` — TOML-таблица; `array<T>` — массив; `map<string, T>` — словарь строковых ключей.
- `<name>` заменяется настоящим ID, ролью, доменом или путём. В одном ключе несколько `<name>` могут обозначать разные объекты: плагин, его MCP-сервер и инструмент.
- `[]` в пути обозначает элемент массива таблиц; это обозначение справочника, а не буквальная часть ключа TOML.
- `S` означает поле, найденное в JSON Schema сверх таблицы Configuration Reference. Такое поле может быть внутренним, экспериментальным или совместимым старым.
- `default схемы` — буквально опубликованный default JSON Schema. Runtime может выбирать дополнительное значение в зависимости от клиента, модели или backend; такие известные значения указаны в описании.
- `—` означает отсутствие отдельного опубликованного schema default/ограничения в этой строке. Это не означает, что runtime вообще не имеет стандартного поведения.
- JSON `null` обычно представляет неуказанную опцию. **В TOML нет литерала `null`**. Пропускайте необязательный ключ; способы явного отключения вроде `[]` указаны для конкретных параметров.

### Подключить схему в редакторе

Добавьте первой строкой TOML:

```toml
#:schema https://developers.openai.com/codex/config-schema.json
```

С расширением Even Better TOML это даёт подсказки типов и диагностику. Schema validation проверяет форму файла; доступность модели, экспериментальной функции и ограничения организации проверяются отдельно. [Подключение схемы](https://learn.chatgpt.com/docs/config-file/config-reference).

Для проверки фактически применённых настроек в CLI используйте `/status` и `/debug-config`. Флаг запуска `--strict-config` превращает неизвестные ключи в ошибки. Настройки VS Code вида `chatgpt.*` принадлежат редактору и в `config.toml` не записываются. [Developer settings](https://learn.chatgpt.com/docs/developer-settings).

### Корневые значения и таблицы

```toml
# Корневые параметры пишутся до начала вложенной таблицы.
model_reasoning_effort = "high"
approval_policy = "on-request"

[agents]
max_concurrent_threads_per_session = 64
```

После `[agents]` следующий обычный ключ относится к `agents`, пока не началась другая таблица. Путь или ID с точками лучше заключать в кавычки:

```toml
[projects."/home/user/project"]
trust_level = "trusted"
```

<a id="examples"></a>

## Короткие примеры

### Контекст 1 млн токенов

```toml
model_context_window = 1000000
model_auto_compact_token_limit = 900000
```

Пример применим только к модели и backend, которые действительно предоставляют соответствующее окно. Первый параметр сообщает размер окна, второй задаёт порог сжатия. Значение 900000 здесь оставляет запас; это пример, а не универсальный стандарт. Указание миллиона в конфигурации само не меняет возможности модели. [Контекст и лимиты](https://learn.chatgpt.com/docs/config-file/config-reference).

### Максимальное количество субагентов

```toml
[agents]
max_concurrent_threads_per_session = 64
```

Это максимум одновременно открытых потоков созданных агентов, **без основного потока**. Стандарт без явной настройки выбирает backend; 64 не является универсальным default. Для V2 есть также `features.multi_agent_v2.max_concurrent_threads_per_session`, а V1-глубина `agents.max_depth` на V2 не действует.

### Современный профиль

Отдельный файл `~/.codex/deep-review.config.toml`:

```toml
model_reasoning_effort = "high"
approval_policy = "on-request"
```

Выбор профиля:

```bash
codex --profile deep-review
```

С версии 0.134.0 для этого не используются `[profiles.deep-review]` и корневой `profile`. [Profiles](https://learn.chatgpt.com/docs/config-file/config-advanced#profiles).

### MCP по HTTP

```toml
[mcp_servers.openaiDeveloperDocs]
url = "https://developers.openai.com/mcp"
enabled = true
```

### Hooks и массивы таблиц

```toml
[[hooks.PreToolUse]]
matcher = "^Bash$"

[[hooks.PreToolUse.hooks]]
type = "command"
command = "/absolute/path/to/check-command"
timeout = 30
```

Это форма записи группы и её обработчика; замените команду своим исполняемым обработчиком. Hooks могут также храниться в отдельном `hooks.json`. [Формат hooks](https://learn.chatgpt.com/docs/hooks).

## Полный каталог опубликованных параметров

В таблицах ниже объединены справочник и схема. Повторяющиеся поля export-протоколов перечислены по конкретным путям; разные варианты обработчиков hooks сведены к общей структуре с пояснением обязательных полей.

<a id="models"></a>

## Модели, контекст и инструкции

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `compact_prompt` | `string` | Текст собственного промпта сжатия истории. | — |
| `daybreak` | `boolean` | Предпочтение Daybreak для новых сессий и неинтерактивных шагов; подробный контракт в схеме не раскрыт. | S |
| `developer_instructions` | `string` | Дополнительные инструкции уровня developer, включаемые в сессию. | — |
| `experimental_compact_prompt_file` | `string` | Экспериментальный файл с промптом сжатия истории. | — |
| `experimental_instructions_file` | `string` | Устаревшее имя файла инструкций; официальный справочник требует заменить его на `model_instructions_file`. | alias/legacy |
| `include_apps_instructions` | `boolean` | Добавлять developer-блок `<apps_instructions>`. | S |
| `include_collaboration_mode_instructions` | `boolean` | Добавлять developer-блок `<collaboration_mode>`. | S |
| `include_environment_context` | `boolean` | Добавлять пользовательский блок `<environment_context>`. | S |
| `include_permissions_instructions` | `boolean` | Добавлять developer-блок `<permissions instructions>`. | S |
| `instructions` | `string` | Зарезервированное поле; для инструкций используйте `AGENTS.md` или `model_instructions_file`. | — |
| `model` | `string` | Модель для новых запусков; имя должно быть доступно вашей учётной записи или рабочему пространству. | — |
| `model_auto_compact_token_limit` | `integer` | Порог токенов для автоматического сжатия истории; без настройки берётся значение модели. | — |
| `model_auto_compact_token_limit_scope` | `"total" / "body_after_prefix"` | Область подсчёта порога сжатия: `total` — весь активный контекст, стандартный вариант; `body_after_prefix` — прирост после сохранённого префикса окна сжатия. | — |
| `model_catalog_json` | `string` | Путь к JSON-каталогу моделей, читаемому при запуске; может переопределяться файлом выбранного профиля. | — |
| `model_context_window` | `integer` | Доступное модели окно контекста в токенах. Настройка сама не увеличивает лимит модели или сервиса. | — |
| `model_instructions_file` | `string` | Файл, заменяющий встроенные инструкции модели. Это отдельный механизм от проектного `AGENTS.md`. | — |
| `model_post_turn_compact_threshold_percent` | `integer` | Порог сжатия после финального ответа в процентах доступного контекста, 0–100. Отсутствие или 0 отключает это сжатие; обычные лимиты продолжают действовать. | ≥0; ≤100; S |
| `model_provider` | `string` | Идентификатор провайдера; стандартное значение — `openai`. | — |
| `model_reasoning_effort` | `string` | Уровень reasoning, поддерживаемый моделью и клиентом; например `low`, `medium`, `high`, `xhigh`, `max`, `ultra`. | длина ≥ 1 |
| `model_reasoning_summary` | `"auto" / "concise" / "detailed" / "none"` | Детальность краткого описания reasoning: автоматически, кратко, подробно или без summary. | — |
| `model_supports_reasoning_summaries` | `boolean` | Документированное переопределение отправки reasoning metadata. В текущей опубликованной схеме ключ отсутствует; проверьте поддержку вашей версии. | — |
| `model_verbosity` | `"low" / "medium" / "high"` | Детальность текста ответа, если её поддерживают выбранные модель и API; без настройки используется стандарт модели/preset. | — |
| `oss_provider` | `string` | Локальный провайдер для `--oss`: LM Studio или Ollama; без значения Codex предлагает выбор. | — |
| `personality` | `"none" / "friendly" / "pragmatic"` | Стиль общения: `none`, `friendly`, `pragmatic`; действует для моделей с поддержкой personality и может переопределяться в сессии. | — |
| `plan_mode_reasoning_effort` | `string` | Переопределение reasoning для Plan mode; без него используется встроенный preset этого режима. | длина ≥ 1 |
| `project_doc_fallback_filenames` | `array<string>` | Дополнительные имена файлов инструкций, если `AGENTS.md` отсутствует. | default схемы: [] |
| `project_doc_max_bytes` | `integer` | Максимум байтов проектных инструкций, читаемых при построении контекста `AGENTS.md`. | default схемы: 32768; ≥0 |
| `project_root_markers` | `array<string>` | Файлы-маркеры корня проекта при обходе родительских каталогов. | — |
| `review_model` | `string` | Модель для `/review`; без переопределения используется модель текущей сессии. | — |

<a id="approval"></a>

## Подтверждения и автоматическая проверка

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `approval_policy` | `"on-request" / table / "never"` | Политика запросов подтверждения: `on-request`, `never` или таблица `granular`. `untrusted` больше не поддерживается; `on-failure` устарел. Политика подтверждений сама не меняет права песочницы. | — |
| `approval_policy.granular` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `approval_policy.granular.mcp_elicitations` | `boolean` | Разрешает показывать запросы уточнения MCP вместо автоматического отказа. | — |
| `approval_policy.granular.request_permissions` | `boolean` | Разрешает запросы инструмента `request_permissions`; в схеме стандартное значение — `false`. | default схемы: false |
| `approval_policy.granular.rules` | `boolean` | Разрешает показывать подтверждения, вызванные правилами execpolicy с действием `prompt`. | — |
| `approval_policy.granular.sandbox_approval` | `boolean` | Разрешает показывать запросы расширения прав песочницы; `false` приводит к автоматическому отказу. | — |
| `approval_policy.granular.skill_approval` | `boolean` | Разрешает подтверждения выполнения скриптов навыков; в схеме стандартное значение — `false`. | default схемы: false |
| `approvals_reviewer` | `"user" / "auto_review" / "guardian_subagent"` | Кто рассматривает запросы: `user` — пользователь, стандартный вариант; `auto_review` — специальный проверяющий агент. Права песочницы от этого не расширяются. | — |
| `auto_review` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `auto_review.circuit_break_action` | `"default" / "strict"` | Режим прерывания circuit breaker: `default` — предупреждение и остановка; `strict` дополнительно записывает структурированную ошибку, которую старые клиенты могут не понимать. | S |
| `auto_review.conversation_history_max_output_tokens` | `integer` | Лимит ответа history-tool Guardian до поправки сериализации; стандартно 4000 токенов, более строгий родительский лимит сохраняется. | ≥1; S |
| `auto_review.experimental_conversation_history_prompt` | `string` | Экспериментальная замена инструкций получения истории при включённых history tools и Apps; пустое значение оставляет встроенный промпт. | S |
| `auto_review.experimental_policy_template` | `string` | Экспериментальная полная замена шаблона Guardian с placeholder политики организации. | S |
| `auto_review.extra_policy` | `string` | Дополнительная Markdown-политика автопроверки. Управляемая `guardian_extra_policy` приоритетнее; пустое значение игнорируется. | — |
| `auto_review.policy` | `string` | Локальная Markdown-политика автоматического рассмотрения запросов. Управляемая `guardian_policy_config` приоритетнее; пустое значение игнорируется. | — |

<a id="execution"></a>

## Команды, песочница и окружение

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `allow_login_shell` | `boolean` | Разрешает запуск login shell; стандартно `true`. При `false` запрос `login = true` отклоняется, а неуказанный `login` означает обычную оболочку. | — |
| `background_terminal_max_timeout` | `integer` | Максимальное ожидание пустого poll `write_stdin`; стандартно 300000 мс, то есть 5 минут. Старое имя — `background_terminal_timeout`. | ≥0 |
| `background_terminal_timeout` | `integer` | Старое имя, заменённое `background_terminal_max_timeout`; используйте новое имя. | alias/legacy |
| `experimental_use_unified_exec_tool` | `boolean` | Старое включение unified exec; предпочтителен `features.unified_exec`. | — |
| `sandbox_mode` | `"read-only" / "workspace-write" / "danger-full-access"` | Режим песочницы для команд: только чтение, запись в рабочую область или полный доступ. | — |
| `sandbox_workspace_write` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `sandbox_workspace_write.exclude_slash_tmp` | `boolean` | Исключает `/tmp` из доступных для записи корней. | default схемы: false |
| `sandbox_workspace_write.exclude_tmpdir_env_var` | `boolean` | Исключает каталог из `$TMPDIR` из доступных для записи корней. | default схемы: false |
| `sandbox_workspace_write.network_access` | `boolean` | Разрешает исходящие сетевые подключения команд в режиме `workspace-write`. | default схемы: false |
| `sandbox_workspace_write.writable_roots` | `array<string>` | Дополнительные каталоги, доступные для записи в режиме `workspace-write`. | default схемы: [] |
| `shell_environment_policy` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `shell_environment_policy.exclude` | `array<string>` | Старые шаблоны исключения переменных; для новых настроек предпочтителен `filters`. | — |
| `shell_environment_policy.experimental_use_profile` | `boolean` | Использовать профиль пользовательской оболочки при запуске subprocess. | — |
| `shell_environment_policy.filters` | `map<string, "include" / "exclude">` | Регистронезависимые шаблоны окружения со значениями `include`/`exclude`. Include создаёт allowlist и не восстанавливает исключённое. Не смешивайте с legacy-массивами в одном слое. | — |
| `shell_environment_policy.ignore_default_excludes` | `boolean` | При `true` сохраняет переменные с KEY/SECRET/TOKEN до остальных фильтров; стандартно `true`. Для автоматического исключения таких имён задайте `false`. | — |
| `shell_environment_policy.include_only` | `array<string>` | Старый allowlist переменных; не смешивайте с `filters` в одном слое. | — |
| `shell_environment_policy.inherit` | `"core" / "all" / "none"` | База наследуемого окружения subprocess: `all`, ограниченное `core` или `none`. | — |
| `shell_environment_policy.set` | `map<string, string>` | Явные переменные окружения после исключений; include-фильтры всё ещё могут удалить их. | — |
| `windows` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `windows.sandbox` | `"elevated" / "unelevated" / "mxc"` | Реализация песочницы Windows. Явный `mxc` вызывает ошибку, если MXC недоступен или запрещён; автоматический выбор с резервным вариантом настраивается через `features.prefer_mxc`. | — |

<a id="permissions"></a>

## Именованные permission profiles

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `default_permissions` | `string` | Имя permission profile. Встроенные: `:read-only`, `:workspace`, `:danger-full-access`; пользовательский требует `[permissions.<name>]`. Не смешивайте с `sandbox_mode`/`sandbox_workspace_write`. | — |
| `permissions` | `table` | Именованные permission profiles; структура раскрыта по шаблону `permissions.<name>`. | S |
| `permissions.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `permissions.<name>.description` | `string` | Описание permission profile; описание родителя через `extends` не наследуется. | — |
| `permissions.<name>.extends` | `string` | Родительский профиль: другой именованный, `:read-only` или `:workspace`. `:danger-full-access`, неизвестные родители и циклы запрещены. | — |
| `permissions.<name>.filesystem` | `table` | Файловые разрешения по абсолютным путям, glob или специальным токенам, например `:minimal` и `:workspace_roots`. | — |
| `permissions.<name>.filesystem.":workspace_roots".<name>` | `"read" \| "write" \| "deny"` | Правила относительно каждого workspace root: `.` означает корень, glob может задавать подкаталоги и запреты. | — |
| `permissions.<name>.filesystem.<name>` | `"read" \| "write" \| "deny" \| table` | Право пути/glob: чтение, запись, запрет чтения или вложенная таблица правил. | — |
| `permissions.<name>.filesystem.glob_scan_max_depth` | `integer` | Глубина разворачивания deny-read glob на платформах со снимком путей; при настройке минимум 1. | ≥1 |
| `permissions.<name>.network` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `permissions.<name>.network.allow_local_binding` | `boolean` | Расширенный доступ к локальной/частной сети. По схеме MXC стандартно требует `true`; другие executor обычно используют `false`. Точные разрешения отдельных локальных адресов возможны и при `false`. | — |
| `permissions.<name>.network.allow_upstream_proxy` | `boolean` | Разрешает upstream proxy для профиля. | — |
| `permissions.<name>.network.dangerously_allow_all_unix_sockets` | `boolean` | Разрешает любые Unix-сокеты вместо ограниченного списка. | — |
| `permissions.<name>.network.dangerously_allow_non_loopback_proxy` | `boolean` | Разрешает сетевому proxy слушать адрес за пределами loopback. | — |
| `permissions.<name>.network.domains` | `table` | Доменные правила команд, действующие при активном proxy. Exact host, `*.domain`, `**.domain`, `*`; `deny` приоритетнее. Не ограничивают web search, приложения или MCP. | — |
| `permissions.<name>.network.domains.<name>` | `allow \| deny` | Разрешение либо запрет конкретного доменного шаблона. | — |
| `permissions.<name>.network.enable_socks5` | `boolean` | Включает SOCKS5 для профиля. | — |
| `permissions.<name>.network.enable_socks5_udp` | `boolean` | Разрешает UDP через SOCKS5 профиля. | — |
| `permissions.<name>.network.enabled` | `boolean` | Сеть команд профиля. Сам флаг не запускает proxy; без него или управляемого proxy доступ прямой, а доменные правила не применяются. | — |
| `permissions.<name>.network.mitm` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `permissions.<name>.network.mitm.actions` | `map<string, table>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `permissions.<name>.network.mitm.actions.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `permissions.<name>.network.mitm.actions.<name>.inject_request_headers` | `array<table>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | default схемы: []; S |
| `permissions.<name>.network.mitm.actions.<name>.inject_request_headers[]` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `permissions.<name>.network.mitm.actions.<name>.inject_request_headers[].name` | `string` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | default схемы: ""; S |
| `permissions.<name>.network.mitm.actions.<name>.inject_request_headers[].prefix` | `string` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | S |
| `permissions.<name>.network.mitm.actions.<name>.inject_request_headers[].secret_env_var` | `string` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | S |
| `permissions.<name>.network.mitm.actions.<name>.inject_request_headers[].secret_file` | `string` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | S |
| `permissions.<name>.network.mitm.actions.<name>.strip_request_headers` | `array<string>` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | default схемы: []; S |
| `permissions.<name>.network.mitm.hooks` | `map<string, table>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `permissions.<name>.network.mitm.hooks.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `permissions.<name>.network.mitm.hooks.<name>.action` | `array<string>` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | S |
| `permissions.<name>.network.mitm.hooks.<name>.body` | `произвольное значение` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | S |
| `permissions.<name>.network.mitm.hooks.<name>.headers` | `map<string, array<string>>` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | S |
| `permissions.<name>.network.mitm.hooks.<name>.host` | `string` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | S |
| `permissions.<name>.network.mitm.hooks.<name>.methods` | `array<string>` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | S |
| `permissions.<name>.network.mitm.hooks.<name>.path_prefixes` | `array<string>` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | S |
| `permissions.<name>.network.mitm.hooks.<name>.query` | `map<string, array<string>>` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | S |
| `permissions.<name>.network.mode` | `"limited" / "full"` | Режим proxy subprocess: `limited` или `full`. | — |
| `permissions.<name>.network.proxy_url` | `string` | HTTP listener сетевого proxy профиля. | — |
| `permissions.<name>.network.socks_url` | `string` | SOCKS5 endpoint профиля. | — |
| `permissions.<name>.network.unix_sockets` | `table` | Таблица разрешений Unix-сокетов сетевого proxy. | — |
| `permissions.<name>.network.unix_sockets.<name>` | `allow \| deny` | Добавляет абсолютный путь сокета через `allow` или запрещает его через `deny`. | — |
| `permissions.<name>.workspace_roots` | `table` | Дополнительные workspace roots профиля, к которым применяются правила `:workspace_roots` вместе с runtime-корнями. | — |
| `permissions.<name>.workspace_roots.<name>` | `boolean` | Добавляет путь в workspace roots при `true`; `false` оставляет запись неактивной. | — |

<a id="agents"></a>

## Субагенты и роли

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `agents` | `table` | Настройки субагентов и пользовательские роли. Имена скалярных настроек зарезервированы и не могут быть именами ролей. | — |
| `agents.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `agents.<name>.config_file` | `string` | Файл TOML настроек роли; относительный путь считается от файла конфигурации, объявляющего роль. | — |
| `agents.<name>.description` | `string` | Описание роли, показываемое Codex при выборе и создании агента. | — |
| `agents.<name>.nickname_candidates` | `array<string>` | Возможные псевдонимы агентов этой роли. | S |
| `agents.default_subagent_model` | `string` | Стандартная модель субагента; явный выбор при создании приоритетнее. | — |
| `agents.default_subagent_reasoning_effort` | `string` | Стандартный reasoning effort субагента; явный выбор при создании приоритетнее. | длина ≥ 1 |
| `agents.enabled` | `boolean` | Включает инструменты работы с субагентами; стандартно `true`. Включённый backend `features.multi_agent_v2` имеет приоритет. | — |
| `agents.interrupt_message` | `boolean` | Записывать видимое модели сообщение о прерывании агента; стандартно `true`. | — |
| `agents.max_concurrent_threads_per_session` | `integer` | Число одновременно открытых потоков созданных агентов, без основного потока. Если не задано, используется стандартный лимит выбранного backend. | ≥1 |
| `agents.max_depth` | `integer` | Максимальная глубина вложения потоков V1; backend V2 игнорирует настройку. | S |
| `agents.max_threads` | `number` | Старое имя `agents.max_concurrent_threads_per_session`. | — |

<a id="providers"></a>

## Провайдеры моделей, AWS и gateway OAuth

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `model_providers` | `map<string, table>` | Пользовательские провайдеры в дополнение к встроенным; зарезервированные ID нельзя переопределять. | S |
| `model_providers.<name>` | `table` | Определение провайдера. Идентификаторы встроенных `openai`, `ollama`, `lmstudio` зарезервированы. | — |
| `model_providers.<name>.auth` | `table` | Получение bearer-токена внешней командой. Несовместимо с `env_key`, прямым токеном и `requires_openai_auth`. | — |
| `model_providers.<name>.auth.args` | `array<string>` | Аргументы команды получения токена. | default схемы: [] |
| `model_providers.<name>.auth.command` | `string` | Команда получения токена; должна вывести токен в stdout. | — |
| `model_providers.<name>.auth.cwd` | `string` | Рабочий каталог команды получения токена. | — |
| `model_providers.<name>.auth.refresh_interval_ms` | `integer` | Период упреждающего обновления токена; стандартно 300000 мс. `0` — обновлять только после ошибки аутентификации. | default схемы: 300000; ≥0 |
| `model_providers.<name>.auth.timeout_ms` | `integer` | Timeout команды токена; стандартно 5000 мс. | default схемы: 5000; ≥1 |
| `model_providers.<name>.aws` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `model_providers.<name>.aws.auth_refresh` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `model_providers.<name>.aws.auth_refresh.args` | `array<string>` | Аргументы обновления AWS credentials. | default схемы: []; S |
| `model_providers.<name>.aws.auth_refresh.command` | `string` | Программа обновления AWS credentials, запускается напрямую без shell. | S |
| `model_providers.<name>.aws.auth_refresh.timeout_ms` | `integer` | Timeout обновления AWS credentials; по схеме стандартно 300000 мс. | default схемы: 300000; ≥1; S |
| `model_providers.<name>.aws.credential_export` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `model_providers.<name>.aws.credential_export.args` | `array<string>` | Аргументы программы экспорта AWS credentials. | default схемы: []; S |
| `model_providers.<name>.aws.credential_export.command` | `string` | Программа экспорта AWS signing credentials вместо стандартной AWS SDK credential chain; запускается без shell. | S |
| `model_providers.<name>.aws.credential_export.timeout_ms` | `integer` | Timeout экспорта AWS credentials; по схеме стандартно 30000 мс. | default схемы: 30000; ≥1; S |
| `model_providers.<name>.aws.profile` | `string` | AWS profile; без значения применяется стандартная цепочка AWS SDK. | S |
| `model_providers.<name>.aws.region` | `string` | AWS region для endpoint провайдера. | S |
| `model_providers.<name>.base_url` | `string` | Базовый URL API провайдера. | — |
| `model_providers.<name>.capabilities` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `model_providers.<name>.capabilities.external_web_access` | `boolean` | Разрешена ли hosted web search возможность обращаться к live web. | S |
| `model_providers.<name>.capabilities.remote_compaction` | `"unsupported" / "v2"` | `unsupported` выбирает локальное сжатие; `v2` отправляет `compaction_trigger` через Responses. Отсутствие сохраняет стандарт провайдера. | S |
| `model_providers.<name>.env_http_headers` | `map<string, string>` | HTTP-заголовки из переменных окружения, если значения доступны. | — |
| `model_providers.<name>.env_key` | `string` | Имя переменной окружения с API-ключом. | — |
| `model_providers.<name>.env_key_instructions` | `string` | Подсказка о настройке API-ключа провайдера. | — |
| `model_providers.<name>.experimental_bearer_token` | `string` | Bearer-токен непосредственно в конфигурации; документация рекомендует вместо этого `env_key`. | — |
| `model_providers.<name>.gateway_oauth` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `model_providers.<name>.gateway_oauth.authorization_url` | `string` | Authorization URL дополнительного OAuth шлюза; подробный контракт в публичном справочнике не раскрыт. | S |
| `model_providers.<name>.gateway_oauth.client_id` | `string` | Client ID дополнительного OAuth шлюза. | S |
| `model_providers.<name>.gateway_oauth.delivery` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `model_providers.<name>.gateway_oauth.delivery.kind` | `"header" / "cookie"` | Передача credentials шлюза в HTTP-заголовке (`header`) или cookie (`cookie`). | S |
| `model_providers.<name>.gateway_oauth.delivery.name` | `string` | Имя заголовка либо cookie для credentials шлюза. | S |
| `model_providers.<name>.gateway_oauth.delivery.scheme` | `string` | Схема заголовка аутентификации шлюза; стандартно `Bearer`. | default схемы: "Bearer"; S |
| `model_providers.<name>.gateway_oauth.redirect_port` | `integer` | Redirect-порт OAuth шлюза; детали выбора порта в публичном справочнике не уточнены. | ≥0; S |
| `model_providers.<name>.gateway_oauth.resource` | `string` | Resource дополнительного OAuth шлюза. | S |
| `model_providers.<name>.gateway_oauth.scopes` | `array<string>` | Scopes дополнительного OAuth шлюза. | default схемы: []; S |
| `model_providers.<name>.gateway_oauth.token_url` | `string` | Token URL дополнительного OAuth шлюза. | S |
| `model_providers.<name>.http_headers` | `map<string, string>` | Статические HTTP-заголовки API. | — |
| `model_providers.<name>.model_catalog_url` | `string` | Полный URL Codex-native каталога моделей. Без него OpenAI discovery использует backend Codex, если inference endpoint не переопределён через `base_url`. | S |
| `model_providers.<name>.name` | `string` | Отображаемое имя провайдера. | default схемы: "" |
| `model_providers.<name>.query_params` | `map<string, string>` | Дополнительные query-параметры запросов API. | — |
| `model_providers.<name>.request_max_retries` | `integer` | Повторные попытки HTTP-запроса; стандартно 4. | ≥0 |
| `model_providers.<name>.requires_openai_auth` | `boolean` | Использует OpenAI-аутентификацию; стандартно `false` для пользовательского провайдера. | default схемы: false |
| `model_providers.<name>.stream_idle_timeout_ms` | `integer` | Допустимое бездействие SSE-потока; стандартно 300000 мс. | ≥0 |
| `model_providers.<name>.stream_max_retries` | `integer` | Повторные попытки после разрыва SSE-потока; стандартно 5. | ≥0 |
| `model_providers.<name>.supports_standalone_web_search` | `boolean` | Объявляет совместимый standalone web search endpoint; стандартно `false`. Само объявление не включает экспериментальный standalone search. | default схемы: false |
| `model_providers.<name>.supports_websockets` | `boolean` | Поддерживает ли провайдер WebSocket-транспорт Responses API. | default схемы: false |
| `model_providers.<name>.websocket_connect_timeout_ms` | `integer` | Timeout одной попытки подключения WebSocket в миллисекундах. | ≥0; S |
| `model_providers.<name>.wire_api` | `"responses"` | Протокол провайдера: поддерживается только `responses`, он же применяется при отсутствии значения. | default схемы: "responses" |
| `model_providers.amazon-bedrock.aws.profile` | `string` | AWS profile встроенного провайдера `amazon-bedrock`. | — |
| `model_providers.amazon-bedrock.aws.region` | `string` | AWS region встроенного провайдера `amazon-bedrock`. | — |

<a id="mcp"></a>

## MCP и корпоративная аутентификация

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `mcp_enterprise_managed_auth` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `mcp_enterprise_managed_auth.idp` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `mcp_enterprise_managed_auth.idp.client_id` | `string` | Public OAuth client ID общего корпоративного Identity Provider. | S |
| `mcp_enterprise_managed_auth.idp.issuer` | `string` | Issuer корпоративного OAuth для discovery и проверки identity; независим от credentials аккаунта Codex. | S |
| `mcp_oauth_callback_port` | `integer` | Глобальный listener-порт MCP OAuth; серверный порт приоритетнее. Без настройки ОС выбирает свободный временный порт. | ≥0 |
| `mcp_oauth_callback_url` | `string` | Глобальный базовый URL MCP OAuth callback. Добавление server ID зависит от регистрации и issuer identification. Порт в URL не выбирает listener-порт. | — |
| `mcp_oauth_credentials_store` | `"auto" / "file" / "keyring"` | Хранилище OAuth credentials MCP: автоматический выбор, файл или keyring. | — |
| `mcp_optional_startup_grace_ms` | `integer` | Общее ожидание необязательных MCP-серверов при первом каталоге инструментов: стандартно 1000 мс. `0` означает ожидание индивидуального startup timeout каждого сервера. | ≥0 |
| `mcp_servers` | `map<string, table>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `mcp_servers.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `mcp_servers.<name>.args` | `array<string>` | Аргументы команды MCP-сервера. | — |
| `mcp_servers.<name>.auth` | `"oauth" / "chatgpt" / "ema_auth"` | Резервный способ аутентификации после явных токенов и заголовков: `oauth`, стандартно, или `chatgpt` для доверенного first-party origin с последующим OAuth fallback. Отсутствие найденных credentials допускает соединение без аутентификации. | — |
| `mcp_servers.<name>.bearer_token_env_var` | `string` | Имя переменной окружения с bearer-токеном HTTP MCP-сервера. | — |
| `mcp_servers.<name>.command` | `string` | Команда запуска MCP-сервера с транспортом stdio. | — |
| `mcp_servers.<name>.cwd` | `string` | Рабочий каталог MCP-процесса. | — |
| `mcp_servers.<name>.default_tools_approval_mode` | `"auto" / "prompt" / "writes" / "approve"` | Стандартный режим подтверждения инструментов этого MCP-сервера. | — |
| `mcp_servers.<name>.disabled_tools` | `array<string>` | Список запрещённых инструментов; применяется после `enabled_tools`. | — |
| `mcp_servers.<name>.enabled` | `boolean` | Включает сервер; позволяет отключить его, сохранив настройки. | — |
| `mcp_servers.<name>.enabled_tools` | `array<string>` | Список разрешённых инструментов MCP-сервера. | — |
| `mcp_servers.<name>.env` | `map<string, string>` | Явно заданные переменные окружения MCP-процесса. | — |
| `mcp_servers.<name>.env_http_headers` | `map<string, string>` | Соответствия имён HTTP-заголовков переменным окружения. | — |
| `mcp_servers.<name>.env_vars` | `array<string / table>` | Дополнительно передаваемые переменные окружения. Строка означает `source = "local"`; объект может задавать `local` или `remote`. `remote` доступен только для удалённого stdio через executor. | — |
| `mcp_servers.<name>.env_vars[]` | `string / table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `mcp_servers.<name>.env_vars[].name` | `string` | Имя передаваемой переменной окружения в объектной записи `env_vars`. | S |
| `mcp_servers.<name>.env_vars[].source` | `string` | Источник переменной: `local` или `remote`; ограничения удалённого stdio см. у `env_vars`. | S |
| `mcp_servers.<name>.environment_id` | `string` | Служебный идентификатор среды MCP. Тип опубликован, правила использования в справочнике не раскрыты. | S |
| `mcp_servers.<name>.experimental_environment` | `local \| remote` | Экспериментальное расположение MCP: `local` или `remote`. Удалённый stdio запускается executor-средой; удалённое размещение Streamable HTTP ещё не реализовано. | — |
| `mcp_servers.<name>.http_headers` | `map<string, string>` | Статические HTTP-заголовки запросов MCP. | — |
| `mcp_servers.<name>.http_headers_helper` | `string` | Локальная команда, печатающая JSON заголовков; только для локально подключённого HTTP MCP. Явные bearer-токены и OAuth приоритетнее её Authorization. | — |
| `mcp_servers.<name>.name` | `string` | Старое отображаемое имя MCP-сервера, сохранённое для совместимости. | S |
| `mcp_servers.<name>.oauth` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `mcp_servers.<name>.oauth.authorization_server_issuer` | `string` | Ожидаемый issuer authorization server для Enterprise Managed Auth token exchange. | S |
| `mcp_servers.<name>.oauth.callback_port` | `integer` | Фиксированный listener-порт OAuth этого сервера; приоритетнее глобального порта. Для loopback URL с явным портом укажите такой же listener-порт. | ≥0 |
| `mcp_servers.<name>.oauth.callback_url` | `string` | Callback конкретного сервера. Его использование и добавление server ID зависят от регистрации клиента и поддержки issuer identification; не выводите номер listener-порта из URL. | — |
| `mcp_servers.<name>.oauth.client_id` | `string` | Заранее зарегистрированный OAuth client ID этого MCP-сервера. | — |
| `mcp_servers.<name>.oauth.client_secret` | `string` | OAuth client secret заранее зарегистрированного клиента для token exchange. | S |
| `mcp_servers.<name>.oauth_resource` | `string` | Необязательный OAuth resource из RFC 8707 для MCP login. | — |
| `mcp_servers.<name>.omit_tools_from` | `array<"code_mode" / "deferred" / "direct">` | Список поверхностей, из которых исключаются инструменты MCP-сервера; допустимые поверхности перечислены в типе. | S |
| `mcp_servers.<name>.required` | `boolean` | При `true` ошибка инициализации включённого сервера прерывает запуск или возобновление. | — |
| `mcp_servers.<name>.scopes` | `array<string>` | OAuth scopes, запрашиваемые при входе в MCP-сервер. | — |
| `mcp_servers.<name>.startup_readiness` | `"connection" / "catalog"` | `connection` требует живого соединения; `catalog` допускает валидный кеш каталога при подключении в фоне. Вызов инструмента всё равно требует актуального соединения. | S |
| `mcp_servers.<name>.startup_timeout_ms` | `integer` | Alias startup timeout в миллисекундах. | ≥0 |
| `mcp_servers.<name>.startup_timeout_sec` | `number` | Timeout старта MCP-сервера в секундах; стандартно 10. | — |
| `mcp_servers.<name>.supports_parallel_tool_calls` | `boolean` | Поле поддержки параллельных вызовов MCP. Тип есть в схеме, подробная семантика и стандарт не опубликованы. | S |
| `mcp_servers.<name>.tool_input_schema_max_bytes` | `integer` | Порог сжатия UTF-8 схемы входа MCP-инструмента; стандартно 5000 байт. Явный лимит также учитывается Code Mode; больший порог сохраняет больше описаний параметров. | ≥1; S |
| `mcp_servers.<name>.tool_timeout_sec` | `number` | Timeout вызова MCP-инструмента в секундах; стандартно 60. | — |
| `mcp_servers.<name>.tools` | `map<string, table>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `mcp_servers.<name>.tools.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `mcp_servers.<name>.tools.<name>.approval_mode` | `"auto" / "prompt" / "writes" / "approve"` | Переопределение режима подтверждения одного MCP-инструмента. | — |
| `mcp_servers.<name>.tools.<name>.output_token_limit` | `integer` | Бюджет вывода одного MCP-инструмента до стандартной 20-процентной поправки сериализации; приоритетнее стандартного бюджета модели. | ≥1 |
| `mcp_servers.<name>.url` | `string` | URL MCP-сервера с транспортом Streamable HTTP. | — |

<a id="apps"></a>

## Приложения и предложения инструментов

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `apps` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `apps.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `apps.<name>.approvals_reviewer` | `"user" / "auto_review" / "guardian_subagent"` | Проверяющий запросов этого приложения; приоритетнее `apps._default.approvals_reviewer`. | — |
| `apps.<name>.default_tools_approval_mode` | `"auto" / "prompt" / "writes" / "approve"` | Режим подтверждения инструментов этого приложения; индивидуальное правило инструмента приоритетнее. | — |
| `apps.<name>.default_tools_enabled` | `boolean` | Доступность инструментов приложения по умолчанию; индивидуальное правило инструмента приоритетнее. | — |
| `apps.<name>.destructive_enabled` | `boolean` | Разрешает или блокирует инструменты данного приложения с признаком разрушительных действий. | — |
| `apps.<name>.enabled` | `boolean` | Включает конкретное приложение/коннектор; стандартно `true`. | default схемы: true |
| `apps.<name>.links` | `map<string, table>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `apps.<name>.links.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `apps.<name>.links.<name>.approvals_reviewer` | `"user" / "auto_review" / "guardian_subagent"` | Проверяющий для отдельного подключённого аккаунта; приоритетнее настройки приложения. `guardian_subagent` — совместимое старое имя `auto_review`. | S |
| `apps.<name>.links.<name>.default_tools_approval_mode` | `"auto" / "prompt" / "writes" / "approve"` | Режим подтверждения отдельного аккаунта приложения; индивидуальный инструмент приоритетнее. | S |
| `apps.<name>.omit_tools_from` | `array<"code_mode" / "deferred" / "direct">` | Поверхности модели, где нужно скрыть инструменты коннектора: значения перечислены в типе. Пустой массив очищает это исключение; отсутствие сохраняет нижний слой. | S |
| `apps.<name>.open_world_enabled` | `boolean` | Разрешает или блокирует инструменты данного приложения с доступом к внешнему миру. | — |
| `apps.<name>.tools` | `map<string, table>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `apps.<name>.tools.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `apps.<name>.tools.<name>.approval_mode` | `"auto" / "prompt" / "writes" / "approve"` | Режим подтверждения конкретного инструмента приложения. | — |
| `apps.<name>.tools.<name>.enabled` | `boolean` | Включает конкретный инструмент приложения, например `repos/list`. | — |
| `apps._default` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `apps._default.approvals_reviewer` | `"user" / "auto_review" / "guardian_subagent"` | Проверяющий запросов приложений по умолчанию; без значения наследует корневой `approvals_reviewer`. | — |
| `apps._default.default_tools_approval_mode` | `"auto" / "prompt" / "writes" / "approve"` | Стандартный режим подтверждения инструментов приложений без индивидуальных переопределений. | — |
| `apps._default.destructive_enabled` | `boolean` | Разрешение инструментов приложений с `destructive_hint = true` по умолчанию. | — |
| `apps._default.enabled` | `boolean` | Доступность приложений по умолчанию, если нет индивидуального правила. | default схемы: true |
| `apps._default.open_world_enabled` | `boolean` | Разрешение инструментов приложений с `open_world_hint = true` по умолчанию. | — |
| `apps_mcp_product_sku` | `string` | SKU продукта в запросах Codex Apps MCP, которыми управляет host. | S |
| `tool_suggest` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tool_suggest.disabled_tools` | `array<table>` | Коннекторы или плагины, исключённые из предложений; элементы также содержат `type` и `id`. | default схемы: [] |
| `tool_suggest.disabled_tools[]` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tool_suggest.disabled_tools[].id` | `string` | Идентификатор коннектора или плагина в записи предложения. | S |
| `tool_suggest.disabled_tools[].type` | `"connector" / "plugin"` | Тип предлагаемого объекта: коннектор или плагин. | S |
| `tool_suggest.discoverables` | `array<table>` | Дополнительные коннекторы или плагины для предложений инструментов. Каждый элемент содержит `type` (`connector` или `plugin`) и `id`. | default схемы: [] |
| `tool_suggest.discoverables[]` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tool_suggest.discoverables[].id` | `string` | Идентификатор коннектора или плагина в записи предложения. | S |
| `tool_suggest.discoverables[].type` | `"connector" / "plugin"` | Тип предлагаемого объекта: коннектор или плагин. | S |

<a id="plugins"></a>

## Плагины и marketplaces

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `marketplaces` | `map<string, table>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `marketplaces.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `marketplaces.<name>.last_revision` | `string` | Служебная Git-ревизия последнего успешно активированного marketplace. | S |
| `marketplaces.<name>.last_updated` | `string` | Служебная отметка последнего успешного добавления/обновления marketplace. | S |
| `marketplaces.<name>.ref` | `string` | Необязательная ветка, тег или commit Git-marketplace. | — |
| `marketplaces.<name>.source` | `string` | Git URL либо абсолютный путь локального marketplace с `.agents/plugins/marketplace.json`. | — |
| `marketplaces.<name>.source_type` | `"git" / "local"` | Источник marketplace: Git или локальный каталог; поддерживается в системном, управляемом, пользовательском и доверенном проектном слоях. | — |
| `marketplaces.<name>.sparse_paths` | `array<string>` | Пути sparse checkout; включите каталог marketplace и используемые локальные плагины. | — |
| `plugins` | `map<string, table>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `plugins.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `plugins.<name>.enabled` | `boolean` | Включает локальный плагин с ключом `plugin-name@marketplace-name`. Доверенный проект может переопределять нижние слои; refresh может устанавливать/обновлять и отключённые плагины. Не отменяет состояние workspace-managed plugins. | default схемы: true |
| `plugins.<name>.mcp_servers` | `map<string, table>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `plugins.<name>.mcp_servers.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `plugins.<name>.mcp_servers.<name>.default_tools_approval_mode` | `"auto" / "prompt" / "writes" / "approve"` | Стандартное подтверждение инструментов MCP-сервера плагина. | — |
| `plugins.<name>.mcp_servers.<name>.disabled_tools` | `array<string>` | Запрещённые инструменты; применяются после списка разрешённых. | — |
| `plugins.<name>.mcp_servers.<name>.enabled` | `boolean` | Включает MCP-сервер установленного плагина без правки manifest. | default схемы: true |
| `plugins.<name>.mcp_servers.<name>.enabled_tools` | `array<string>` | Разрешённые инструменты MCP-сервера плагина. | — |
| `plugins.<name>.mcp_servers.<name>.tools` | `map<string, table>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `plugins.<name>.mcp_servers.<name>.tools.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `plugins.<name>.mcp_servers.<name>.tools.<name>.approval_mode` | `"auto" / "prompt" / "writes" / "approve"` | Подтверждение одного MCP-инструмента плагина. | — |
| `plugins.<name>.mcp_servers.<name>.tools.<name>.output_token_limit` | `integer` | Бюджет вывода MCP-инструмента плагина до стандартной поправки сериализации. | ≥1; S |

<a id="skills"></a>

## Навыки

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `skills` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `skills.bundled` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `skills.bundled.enabled` | `boolean` | Включает bundled skills; стандартно `true`. | default схемы: true; S |
| `skills.config` | `array<table>` | Массив индивидуальных настроек включения навыков. | — |
| `skills.config[]` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `skills.config[].enabled` | `boolean` | Включает или отключает указанный навык. | — |
| `skills.config[].name` | `string` | Выбор навыка по имени вместо селектора пути; правила разрешения совпадений в схеме не уточнены. | S |
| `skills.config[].path` | `string` | Путь к каталогу навыка с `SKILL.md`. | — |
| `skills.include_instructions` | `boolean` | Добавлять автоматический блок инструкций навыков в шаги. | S |
| `skills.max_context_tokens` | `integer` | Бюджет каталога доступных навыков. Стандартно 2% окна модели; явно заданное значение ограничивается 10000 токенами. | ≥1 |

<a id="memories"></a>

## Память и цели

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `goals` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `goals.max_goal_token_budget` | `integer` | Максимальный бюджет цели, одновременно стандартный бюджет новых целей. | ≥1; S |
| `memories` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `memories.consolidation_model` | `string` | Модель глобальной консолидации памяти. | — |
| `memories.dedicated_tools` | `boolean` | Публикует отдельные инструменты памяти через extension tool surface. | S |
| `memories.disable_on_external_context` | `boolean` | Исключать из генерации памяти сессии с внешним контекстом, включая MCP, web search и tool search; стандартно `false`. Старое имя — `memories.no_memories_if_mcp_or_web_search`. | — |
| `memories.dual_write` | `boolean` | Генерирует обе версии памяти, используя выбранную версию для контекста. | S |
| `memories.extract_model` | `string` | Модель извлечения воспоминаний из отдельной сессии. | — |
| `memories.generate_memories` | `boolean` | Сохранять новые сессии как входные данные генерации памяти; стандартно `true`. | — |
| `memories.max_raw_memories_for_consolidation` | `integer` | Максимум последних сырых воспоминаний для консолидации: стандартно 256, верхний предел 4096. | ≥1; ≤4096 |
| `memories.max_rollout_age_days` | `integer` | Максимальный возраст сессии для генерации памяти: стандартно 30 дней, диапазон 0–90. | — |
| `memories.max_rollouts_per_startup` | `integer` | Максимум кандидатов для обработки при одном запуске: стандартно 16, предел 128. | ≥1; ≤128 |
| `memories.max_unused_days` | `integer` | Допустимое число дней без использования воспоминания: стандартно 30, диапазон 0–365. | — |
| `memories.min_rate_limit_remaining_percent` | `integer` | Минимальный остаток лимитов использования для запуска генерации памяти: стандартно 25%, диапазон 0–100. | ≥0; ≤100 |
| `memories.min_rollout_idle_hours` | `integer` | Минимальное время бездействия сессии до генерации памяти: стандартно 6 часов, диапазон 1–48. | — |
| `memories.no_memories_if_mcp_or_web_search` | `boolean` | Старое имя `memories.disable_on_external_context`; alias указан в справочнике. | alias/legacy |
| `memories.use_memories` | `boolean` | Подставлять существующую память в будущие сессии; стандартно `true`. | — |
| `memories.version` | `"v1" / "v2"` | Версия pipeline памяти: `v1`, стандартно, либо `v2`. | S |

<a id="tools"></a>

## Инструменты и web search

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tool_output_token_limit` | `integer` | Бюджет отдельного вывода инструмента, сохраняемого в истории. | ≥0 |
| `tools` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tools.experimental_request_user_input` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tools.experimental_request_user_input.enabled` | `boolean` | Включение экспериментального request_user_input; по схеме стандартно `true`. | default схемы: true; S |
| `tools.update_plan` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tools.update_plan.enabled` | `boolean` | Включение инструмента update_plan; по схеме стандартно `false`. | default схемы: false; S |
| `tools.view_image` | `boolean` | Включает локальный просмотр изображения инструментом `view_image`. | — |
| `tools.web_search` | `table` | Настройка инструмента поиска: переключатель или таблица с размером контекста, доменами и примерным местоположением. Эти домены не являются правилами сети shell/MCP/коннекторов. | — |
| `tools.web_search.allowed_domains` | `array<string>` | Домены, которыми ограничивается сам инструмент web search; не сетевой firewall команд. | S |
| `tools.web_search.context_size` | `"low" / "medium" / "high"` | Размер контекста поиска: `low`, `medium`, `high`. | S |
| `tools.web_search.location` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tools.web_search.location.city` | `string` | Примерный город пользователя для результатов поиска. | S |
| `tools.web_search.location.country` | `string` | Примерная страна пользователя для результатов поиска. | S |
| `tools.web_search.location.region` | `string` | Примерный регион пользователя для результатов поиска. | S |
| `tools.web_search.location.timezone` | `string` | Часовой пояс пользователя для результатов поиска. | S |
| `web_search` | `"disabled" / "cached" / "indexed" / "live"` | Режим поиска: `disabled`, `cached` (стандартно), `indexed`, `live`. Cached использует индекс без внешнего web-доступа; indexed допускает внешнее получение через индекс; live разрешает live retrieval. При полном доступе стандарт может стать `live`. | — |

<a id="browser"></a>

## Браузер и Computer Use

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `browser_use` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `browser_use.allow_history_access` | `boolean` | При `false` ограничивает доступ к истории браузера; управляемые требования могут закрепить запрет. | — |
| `browser_use.default_origin_policy` | `table` | Правила браузера по умолчанию: `access`, `uploads`, `downloads`, `full_cdp_access`, каждое со значением `allow` или `deny`. | — |
| `browser_use.default_origin_policy.access` | `"allow" / "deny"` | Разрешает либо запрещает доступ к origin; область определяется родительской таблицей origin/default policy. | S |
| `browser_use.default_origin_policy.downloads` | `"allow" / "deny"` | Разрешает либо запрещает скачивание файлов; область определяется родительской таблицей origin/default policy. | S |
| `browser_use.default_origin_policy.full_cdp_access` | `"allow" / "deny"` | Разрешает либо запрещает полный CDP-доступ; область определяется родительской таблицей origin/default policy. | S |
| `browser_use.default_origin_policy.uploads` | `"allow" / "deny"` | Разрешает либо запрещает загрузку файлов на сайт; область определяется родительской таблицей origin/default policy. | S |
| `browser_use.origins` | `map<string, table>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `browser_use.origins.<name>` | `table` | Правила для конкретного origin: схема HTTP/HTTPS, хост и необязательный порт, без пути, query и fragment. Локальные значения не отменяют управляемые запреты. | — |
| `browser_use.origins.<name>.access` | `"allow" / "deny"` | Разрешает либо запрещает доступ к origin; область определяется родительской таблицей origin/default policy. | S |
| `browser_use.origins.<name>.downloads` | `"allow" / "deny"` | Разрешает либо запрещает скачивание файлов; область определяется родительской таблицей origin/default policy. | S |
| `browser_use.origins.<name>.full_cdp_access` | `"allow" / "deny"` | Разрешает либо запрещает полный CDP-доступ; область определяется родительской таблицей origin/default policy. | S |
| `browser_use.origins.<name>.uploads` | `"allow" / "deny"` | Разрешает либо запрещает загрузку файлов на сайт; область определяется родительской таблицей origin/default policy. | S |
| `computer_use` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `computer_use.default_app_access` | `"allow" / "deny"` | Доступ Computer Use к приложениям по умолчанию. Правила приложения уточняют его; управляемый запрет нельзя ослабить локально. | — |
| `computer_use.macos` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `computer_use.macos.bundle_ids` | `map<string, "allow" / "deny">` | Доступ к приложениям macOS по bundle ID. | — |
| `computer_use.windows` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `computer_use.windows.always_allowed_app_ids` | `array<string>` | Сохранённые идентификаторы Windows-приложений, открываемых без запроса. Остальные требуют подтверждения; список также управляется интерфейсом desktop-приложения. | — |
| `computer_use.windows.aumids` | `map<string, "allow" / "deny">` | Доступ к пакетным приложениям Windows по Application User Model ID. | — |
| `computer_use.windows.exes` | `array<table>` | Правила исполняемых файлов Windows. Обязательны `publisher_name`, `product_name`, `access`; `binary_name` необязателен. | — |
| `computer_use.windows.exes[]` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `computer_use.windows.exes[].access` | `"allow" / "deny"` | Разрешение или запрет совпавшего Windows executable. | S |
| `computer_use.windows.exes[].binary_name` | `string` | Необязательное имя binary в правиле executable. | S |
| `computer_use.windows.exes[].product_name` | `string` | Обязательное имя продукта в правиле executable. | S |
| `computer_use.windows.exes[].publisher_name` | `string` | Обязательное имя издателя в правиле executable. | S |

<a id="hooks"></a>

## Lifecycle hooks

`<Event>`: `Interrupt`, `PermissionRequest`, `PostCompact`, `PostToolUse`, `PreCompact`, `PreToolUse`, `SessionEnd`, `SessionStart`, `Stop`, `SubagentStart`, `SubagentStop`, `UserPromptSubmit`.

При `command` обязательны `type` и `command`; при `mcp_tool` — `type`, `server`, `tool`. Поля других вариантов не следует смешивать. [Hooks guide](https://learn.chatgpt.com/docs/hooks).

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `hooks` | `table` | Inline-конфигурация lifecycle hooks; структура событий совпадает с `hooks.json`. | — |
| `hooks.<Event>` | `array<table>` | Массив matcher-групп выбранного lifecycle-события; список событий приведён перед таблицей. | default схемы: [] |
| `hooks.<Event>[]` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `hooks.<Event>[].hooks` | `array<table>` | Массив обработчиков группы. Поддерживаются `command` и `mcp_tool`; `prompt` и `agent` разбираются, но пропускаются. | default схемы: [] |
| `hooks.<Event>[].hooks[]` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `hooks.<Event>[].hooks[].additionalContextLimit` | `integer` | Порог размера `additionalContext` для переноса на диск и короткого preview; стандартно 2500 токенов, `0` передаёт весь контекст модели. | ≥0 |
| `hooks.<Event>[].hooks[].async` | `boolean` | Запускает command-hook в фоне; стандартно `false`. `SessionEnd` всегда выполняется синхронно. | default схемы: false |
| `hooks.<Event>[].hooks[].command` | `string` | Команда command-hook; обязательна при `type = "command"`. | S |
| `hooks.<Event>[].hooks[].commandWindows` | `string` | Команда hook специально для Windows. Принимается также TOML-alias `command_windows`. | — |
| `hooks.<Event>[].hooks[].command_windows` | `string` | TOML-alias `commandWindows`, команда hook для Windows. | alias/legacy |
| `hooks.<Event>[].hooks[].input` | `table` | Таблица аргументов MCP-hook; без настройки пустая. | S |
| `hooks.<Event>[].hooks[].server` | `string` | Имя настроенного MCP-сервера; обязательно для `mcp_tool`. | S |
| `hooks.<Event>[].hooks[].statusMessage` | `string` | Необязательный текст, показываемый во время hook. | S |
| `hooks.<Event>[].hooks[].timeout` | `integer` | Timeout активного выполнения в секундах: обычно 600; SessionEnd и Interrupt стандартно 1, максимум 3. | ≥0; S |
| `hooks.<Event>[].hooks[].tool` | `string` | Имя MCP-инструмента; обязательно для `mcp_tool`. | S |
| `hooks.<Event>[].hooks[].type` | `"command" / "mcp_tool" / "prompt" / "agent"` | Вариант обработчика. `command` и `mcp_tool` исполняются; `prompt` и `agent` пока разбираются, но пропускаются. | S |
| `hooks.<Event>[].matcher` | `string` | Условие/regex отбора события; смысл зависит от события. Без matcher группа применяется ко всем его вариантам. | S |
| `hooks.state` | `map<string, table>` | Служебное сохраняемое состояние hooks. | S |
| `hooks.state.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `hooks.state.<name>.enabled` | `boolean` | Служебное сохранённое включение hook. | S |
| `hooks.state.<name>.trusted_hash` | `string` | Служебный hash доверенного hook; правила его вычисления публично не уточнены. | S |

<a id="otel"></a>

## OpenTelemetry

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `otel` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.environment` | `string` | Метка окружения OpenTelemetry; стандартно `dev`. | — |
| `otel.exporter` | `"none" / "statsig" / table` | Экспортёр журналов OpenTelemetry: выключение или настройка OTLP HTTP/gRPC. | — |
| `otel.exporter.<name>.endpoint` | `string` | Endpoint экспортёра журналов. | — |
| `otel.exporter.<name>.headers` | `map<string,string>` | Статические заголовки экспортёра журналов. | — |
| `otel.exporter.<name>.protocol` | `binary \| json` | Формат OTLP/HTTP: protobuf `binary` или `json`. | — |
| `otel.exporter.<name>.tls.ca-certificate` | `string` | Путь CA-сертификата TLS экспортёра журналов. | — |
| `otel.exporter.<name>.tls.client-certificate` | `string` | Путь клиентского сертификата TLS экспортёра журналов. | — |
| `otel.exporter.<name>.tls.client-private-key` | `string` | Путь приватного клиентского ключа TLS экспортёра журналов. | — |
| `otel.exporter.otlp-grpc` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.exporter.otlp-grpc.endpoint` | `string` | Адрес получателя соответствующего OTLP-экспортёра. | S |
| `otel.exporter.otlp-grpc.headers` | `map<string, string>` | Статические заголовки соответствующего экспортёра. | S |
| `otel.exporter.otlp-grpc.tls` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.exporter.otlp-grpc.tls.ca-certificate` | `string` | Путь доверенного CA-сертификата TLS. | S |
| `otel.exporter.otlp-grpc.tls.client-certificate` | `string` | Путь клиентского сертификата TLS. | S |
| `otel.exporter.otlp-grpc.tls.client-private-key` | `string` | Путь приватного клиентского ключа TLS. | S |
| `otel.exporter.otlp-http` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.exporter.otlp-http.endpoint` | `string` | Адрес получателя соответствующего OTLP-экспортёра. | S |
| `otel.exporter.otlp-http.headers` | `map<string, string>` | Статические заголовки соответствующего экспортёра. | S |
| `otel.exporter.otlp-http.protocol` | `"binary" / "json"` | Формат OTLP/HTTP: binary или JSON; к gRPC не относится. | S |
| `otel.exporter.otlp-http.tls` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.exporter.otlp-http.tls.ca-certificate` | `string` | Путь доверенного CA-сертификата TLS. | S |
| `otel.exporter.otlp-http.tls.client-certificate` | `string` | Путь клиентского сертификата TLS. | S |
| `otel.exporter.otlp-http.tls.client-private-key` | `string` | Путь приватного клиентского ключа TLS. | S |
| `otel.log_agent_responses` | `boolean` | Экспортировать финальные ответы основного агента и субагентов в OTLP-журнал; стандартно `false`, текст ограничен 64 КиБ. | S |
| `otel.log_guardian_assessments` | `boolean` | Экспортировать завершённые оценки Guardian в OTLP-журнал; стандартно `false`, текст обоснования ограничен 64 КиБ. | S |
| `otel.log_user_prompt` | `boolean` | Разрешает экспорт исходного текста пользовательских промптов в OTel-журналы. | — |
| `otel.metrics_exporter` | `"none" / "statsig" / table` | Экспортёр метрик; стандартно `statsig`. | — |
| `otel.metrics_exporter.otlp-grpc` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.metrics_exporter.otlp-grpc.endpoint` | `string` | Адрес получателя соответствующего OTLP-экспортёра. | S |
| `otel.metrics_exporter.otlp-grpc.headers` | `map<string, string>` | Статические заголовки соответствующего экспортёра. | S |
| `otel.metrics_exporter.otlp-grpc.tls` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.metrics_exporter.otlp-grpc.tls.ca-certificate` | `string` | Путь доверенного CA-сертификата TLS. | S |
| `otel.metrics_exporter.otlp-grpc.tls.client-certificate` | `string` | Путь клиентского сертификата TLS. | S |
| `otel.metrics_exporter.otlp-grpc.tls.client-private-key` | `string` | Путь приватного клиентского ключа TLS. | S |
| `otel.metrics_exporter.otlp-http` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.metrics_exporter.otlp-http.endpoint` | `string` | Адрес получателя соответствующего OTLP-экспортёра. | S |
| `otel.metrics_exporter.otlp-http.headers` | `map<string, string>` | Статические заголовки соответствующего экспортёра. | S |
| `otel.metrics_exporter.otlp-http.protocol` | `"binary" / "json"` | Формат OTLP/HTTP: binary или JSON; к gRPC не относится. | S |
| `otel.metrics_exporter.otlp-http.tls` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.metrics_exporter.otlp-http.tls.ca-certificate` | `string` | Путь доверенного CA-сертификата TLS. | S |
| `otel.metrics_exporter.otlp-http.tls.client-certificate` | `string` | Путь клиентского сертификата TLS. | S |
| `otel.metrics_exporter.otlp-http.tls.client-private-key` | `string` | Путь приватного клиентского ключа TLS. | S |
| `otel.span_attributes` | `map<string, string>` | Дополнительные атрибуты каждого экспортируемого trace span. | S |
| `otel.tool_result` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.tool_result.max_bytes` | `integer` | Максимум UTF-8 байтов результата инструмента до уведомления об обрезке; стандартно 2048. | default схемы: 2048; ≥0; S |
| `otel.trace_exporter` | `"none" / "statsig" / table` | Экспортёр трассировок OpenTelemetry. | — |
| `otel.trace_exporter.<name>.endpoint` | `string` | Endpoint экспортёра трассировок. | — |
| `otel.trace_exporter.<name>.headers` | `map<string,string>` | Статические заголовки экспортёра трассировок. | — |
| `otel.trace_exporter.<name>.protocol` | `binary \| json` | Формат OTLP/HTTP для трассировок. | — |
| `otel.trace_exporter.<name>.tls.ca-certificate` | `string` | Путь CA-сертификата TLS экспортёра трассировок. | — |
| `otel.trace_exporter.<name>.tls.client-certificate` | `string` | Путь клиентского сертификата TLS экспортёра трассировок. | — |
| `otel.trace_exporter.<name>.tls.client-private-key` | `string` | Путь приватного клиентского ключа TLS экспортёра трассировок. | — |
| `otel.trace_exporter.otlp-grpc` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.trace_exporter.otlp-grpc.endpoint` | `string` | Адрес получателя соответствующего OTLP-экспортёра. | S |
| `otel.trace_exporter.otlp-grpc.headers` | `map<string, string>` | Статические заголовки соответствующего экспортёра. | S |
| `otel.trace_exporter.otlp-grpc.tls` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.trace_exporter.otlp-grpc.tls.ca-certificate` | `string` | Путь доверенного CA-сертификата TLS. | S |
| `otel.trace_exporter.otlp-grpc.tls.client-certificate` | `string` | Путь клиентского сертификата TLS. | S |
| `otel.trace_exporter.otlp-grpc.tls.client-private-key` | `string` | Путь приватного клиентского ключа TLS. | S |
| `otel.trace_exporter.otlp-http` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.trace_exporter.otlp-http.endpoint` | `string` | Адрес получателя соответствующего OTLP-экспортёра. | S |
| `otel.trace_exporter.otlp-http.headers` | `map<string, string>` | Статические заголовки соответствующего экспортёра. | S |
| `otel.trace_exporter.otlp-http.protocol` | `"binary" / "json"` | Формат OTLP/HTTP: binary или JSON; к gRPC не относится. | S |
| `otel.trace_exporter.otlp-http.tls` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.trace_exporter.otlp-http.tls.ca-certificate` | `string` | Путь доверенного CA-сертификата TLS. | S |
| `otel.trace_exporter.otlp-http.tls.client-certificate` | `string` | Путь клиентского сертификата TLS. | S |
| `otel.trace_exporter.otlp-http.tls.client-private-key` | `string` | Путь приватного клиентского ключа TLS. | S |
| `otel.tracestate` | `map<string, map<string, string>>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `otel.tracestate.<name>` | `map<string, string>` | Поле есть в опубликованной схеме; подробное назначение и runtime-стандарт публично не описаны. | S |

<a id="tui"></a>

## Терминальный интерфейс

Привязка — строка (`"ctrl-a"`, chord `"ctrl-x ctrl-s"`) или массив альтернатив. `[]` убирает привязку и не возвращается к global/default; неуказанное действие наследует стандарт. Для редакторского `yank` и Vim `yank_line` используются соответствующие внутренние буферы.

### Общие настройки TUI

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tui` | `table` | Настройки терминального интерфейса Codex. | — |
| `tui.agents_overview_grouping` | `"project" / "status" / "model"` | Последняя выбранная группировка Agent Command Center: проект, статус или модель. | default схемы: "project"; S |
| `tui.alternate_screen` | `"auto" / "always" / "never"` | Использование alternate screen: `auto`, `always`, `never`; стандартно `auto`. Справочник отдельно отмечает обход Zellij ради scrollback; поведение зависит от клиента. | default схемы: "auto" |
| `tui.animations` | `boolean` | Анимации приветствия, shimmer и spinner; стандартно включены. | default схемы: true |
| `tui.auto_recap` | `boolean` | Автоматическое резюме разговора при потере фокуса терминала; стандартно `true`. Ручной `/recap` доступен и при выключении. | default схемы: true; S |
| `tui.copy_on_select` | `"auto" / "always" / "never"` | Копирование выделения при отпускании мыши: `always`, `never` или терминал-зависимый `auto`. Tmux/Zellij и неизвестные терминалы обычно копируют; подробные исключения перечислены в схеме. | default схемы: "auto"; S |
| `tui.disable_paste_burst` | `boolean` | Отключает распознавание быстрой вставки и буферизацию вводимых символов; приоритетнее старого корневого флага. Стандартно `false`. | S |
| `tui.effects` | `table` | Отдельные визуальные эффекты; для них также требуется `tui.animations = true`. | S |
| `tui.effects.effort` | `boolean` | Анимация изменения reasoning effort. | default схемы: true; S |
| `tui.effects.progress` | `boolean` | Анимация индикаторов активности и загрузки. | default схемы: true; S |
| `tui.effects.shimmer` | `boolean` | Перелив текста статуса и загрузки. | default схемы: true; S |
| `tui.effects.starfield` | `boolean` | Анимация звёздного фона composer. | default схемы: true; S |
| `tui.effects.title` | `boolean` | Мигание индикатора заголовка терминала при ожидании пользователя. | default схемы: true; S |
| `tui.effects.welcome` | `boolean` | Анимация приветствия. | default схемы: true; S |
| `tui.fullscreen_transcript` | `boolean` | Собственный полноэкранный transcript с прокруткой, выделением и поиском; стандартно включён, ограничения alternate screen приоритетнее. | default схемы: true; S |
| `tui.keymap` | `table` | Привязки клавиш по контекстам. Контекст приоритетнее global; пустой массив убирает привязку, отсутствие наследует стандарт. | S |
| `tui.model_availability_nux` | `map<string, integer>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tui.model_availability_nux.<name>` | `integer` | Служебное состояние стартовых подсказок, индексируемое именем модели. | ≥0 |
| `tui.mouse_scroll_speed` | `number` | Множитель прокрутки мышью: стандартно 1.0; положительные дроби замедляют, значения больше 1 ускоряют. | S |
| `tui.notification_condition` | `"unfocused" / "always"` | Уведомлять только при потере фокуса (`unfocused`, стандартно) или всегда. | default схемы: "unfocused" |
| `tui.notification_method` | `"auto" / "osc9" / "bel"` | Способ уведомления терминала: `auto`, OSC 9 или BEL; стандартно `auto`. | default схемы: "auto" |
| `tui.notifications` | `boolean / array<string>` | Включение уведомлений TUI; массив ограничивает их перечисленными событиями. | default схемы: true |
| `tui.pet` | `string` | Предварительно выбранный pet ID; пользовательские pets находятся в `$CODEX_HOME/pets/<pet-id>/pet.json`. | S |
| `tui.pet_anchor` | `"composer" / "screen-bottom"` | Вертикальная привязка pet: `composer`, стандартно, либо низ физического экрана `screen-bottom`. | default схемы: "composer"; S |
| `tui.question_esc_back` | `boolean` | Escape возвращает из асинхронного вопроса в composer с сохранением черновика; стандартно `true`. | default схемы: true; S |
| `tui.raw_output_mode` | `boolean` | Начинать с raw scrollback для копирования; стандартно `false`, переключается через `/raw` или стандартное `alt-r`. | default схемы: false |
| `tui.rendering` | `table` | Способы отображения Markdown, математики и диаграмм. | S |
| `tui.rendering.lists` | `boolean` | Unicode-оформление маркеров Markdown и task lists. | default схемы: true; S |
| `tui.rendering.math` | `boolean` | Unicode-отображение математических выражений. | default схемы: true; S |
| `tui.rendering.mermaid` | `boolean` | Отображение Mermaid-блоков как диаграмм. | default схемы: true; S |
| `tui.rendering.tables` | `boolean` | Отображение pipe tables, включая таблицы внутри Markdown fences. | default схемы: true; S |
| `tui.resume_cwd` | `"current" / "session"` | Рабочий каталог при resume/fork: текущий или сохранённый в сессии. Без значения при несовпадении каталогов предлагается выбор. | — |
| `tui.right_click_paste` | `"auto" / "on" / "off"` | Fallback вставки правой кнопкой: `auto` для Windows/WSL/Linux, `on` также для macOS, `off` оставляет вставку терминалу. Не читает clipboard через SSH или распознанный VS Code terminal. | default схемы: "auto"; S |
| `tui.screen_reader_detection_done` | `boolean` | Служебная отметка попытки определения screen reader; любое сохранённое значение пропускает повторную попытку. | S |
| `tui.session_picker_view` | `"comfortable" / "dense"` | Плотность списка resume/fork: `comfortable` или `dense`. | S |
| `tui.show_server_version_notice` | `boolean` | Информационные уведомления о различии версий app-server; стандартно включены. Ошибки совместимости не отключает. | default схемы: true; S |
| `tui.show_tooltips` | `boolean` | Подсказки начального экрана TUI; стандартно включены. | default схемы: true |
| `tui.status_line` | `array<string>` | Упорядоченный список элементов нижней статусной строки. Без настройки стандартно `model-with-reasoning`, `context-remaining`, `current-dir`; `[]` скрывает строку. JSON-литерала `null` в TOML нет. | — |
| `tui.status_line_use_colors` | `boolean` | Цвета статусной строки из активной темы; стандартно включены. | default схемы: true; S |
| `tui.terminal_resize_reflow_max_rows` | `integer` | Лимит последних строк для replay при resize. Без значения используется терминал-зависимый стандарт; 0 сохраняет все строки. | ≥0; S |
| `tui.terminal_title` | `array<string>` | Элементы заголовка терминала; стандартно `spinner`, `project`; `[]` очищает заголовок. JSON-литерала `null` в TOML нет. | — |
| `tui.theme` | `string` | Тема подсветки синтаксиса, имя в kebab-case. | — |
| `tui.vim_mode_default` | `boolean` | Начинать composer в Vim normal mode; стандартно `false`, режим можно переключить через `/vim`. | default схемы: false |

### Клавиши: <name>

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tui.keymap.<name>.<name>` | `string \| array<string>` | Общая форма привязки контекста и действия; допустимые конкретные пары полностью перечислены в следующих таблицах. | — |

### Клавиши: agents

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tui.keymap.agents` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tui.keymap.agents.archive` | `string / array<string>` | Клавиши действия «архивировать задачу» в контексте `agents`. | S |
| `tui.keymap.agents.delete` | `string / array<string>` | Клавиши действия «удалить задачу» в контексте `agents`. | S |
| `tui.keymap.agents.fork` | `string / array<string>` | Клавиши действия «создать ветвление сессии» в контексте `agents`. | S |
| `tui.keymap.agents.hide` | `string / array<string>` | Клавиши действия «скрыть задачу» в контексте `agents`. | S |
| `tui.keymap.agents.new_task` | `string / array<string>` | Клавиши действия «создать задачу» в контексте `agents`. | S |
| `tui.keymap.agents.new_worktree` | `string / array<string>` | Клавиши действия «создать worktree» в контексте `agents`. | S |
| `tui.keymap.agents.rename` | `string / array<string>` | Клавиши действия «переименовать задачу» в контексте `agents`. | S |
| `tui.keymap.agents.resume` | `string / array<string>` | Клавиши действия «возобновить задачу» в контексте `agents`. | S |
| `tui.keymap.agents.search` | `string / array<string>` | Клавиши действия «искать задачи» в контексте `agents`. | S |
| `tui.keymap.agents.stop` | `string / array<string>` | Клавиши действия «остановить задачу» в контексте `agents`. | S |
| `tui.keymap.agents.toggle_grouping` | `string / array<string>` | Клавиши действия «переключить группировку задач» в контексте `agents`. | S |
| `tui.keymap.agents.toggle_pin` | `string / array<string>` | Клавиши действия «закрепить или открепить задачу» в контексте `agents`. | S |

### Клавиши: approval

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tui.keymap.approval` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tui.keymap.approval.approve` | `string / array<string>` | Клавиши действия «одобрить действие» в контексте `approval`. | S |
| `tui.keymap.approval.approve_for_prefix` | `string / array<string>` | Клавиши действия «одобрить команды с этим префиксом» в контексте `approval`. | S |
| `tui.keymap.approval.approve_for_session` | `string / array<string>` | Клавиши действия «одобрить на текущую сессию» в контексте `approval`. | S |
| `tui.keymap.approval.cancel` | `string / array<string>` | Клавиши действия «отменить текущий выбор или режим» в контексте `approval`. | S |
| `tui.keymap.approval.decline` | `string / array<string>` | Клавиши действия «отклонить запрос» в контексте `approval`. | S |
| `tui.keymap.approval.deny` | `string / array<string>` | Клавиши действия «запретить действие» в контексте `approval`. | S |
| `tui.keymap.approval.open_fullscreen` | `string / array<string>` | Клавиши действия «открыть полный экран» в контексте `approval`. | S |
| `tui.keymap.approval.open_thread` | `string / array<string>` | Клавиши действия «открыть связанную сессию» в контексте `approval`. | S |

### Клавиши: chat

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tui.keymap.chat` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tui.keymap.chat.decrease_reasoning_effort` | `string / array<string>` | Клавиши действия «уменьшить reasoning effort» в контексте `chat`. | S |
| `tui.keymap.chat.edit_queued_message` | `string / array<string>` | Клавиши действия «редактировать сообщение в очереди» в контексте `chat`. | S |
| `tui.keymap.chat.increase_reasoning_effort` | `string / array<string>` | Клавиши действия «увеличить reasoning effort» в контексте `chat`. | S |
| `tui.keymap.chat.interrupt_turn` | `string / array<string>` | Клавиши действия «прервать текущий шаг» в контексте `chat`. | S |
| `tui.keymap.chat.next_permission_mode` | `string / array<string>` | Клавиши действия «следующий режим разрешений» в контексте `chat`. | S |
| `tui.keymap.chat.previous_permission_mode` | `string / array<string>` | Клавиши действия «предыдущий режим разрешений» в контексте `chat`. | S |
| `tui.keymap.chat.prompt_stack_back` | `string / array<string>` | Клавиши действия «вернуться по стеку промптов» в контексте `chat`. | S |
| `tui.keymap.chat.skip_question` | `string / array<string>` | Клавиши действия «пропустить вопрос» в контексте `chat`. | S |
| `tui.keymap.chat.toggle_voice` | `string / array<string>` | Клавиши действия «переключить голосовой ввод» в контексте `chat`. | S |
| `tui.keymap.chat.toggle_voice_mute` | `string / array<string>` | Клавиши действия «переключить отключение микрофона» в контексте `chat`. | S |

### Клавиши: composer

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tui.keymap.composer` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tui.keymap.composer.history_search_next` | `string / array<string>` | Клавиши действия «следующее совпадение истории ввода» в контексте `composer`. | S |
| `tui.keymap.composer.history_search_previous` | `string / array<string>` | Клавиши действия «предыдущее совпадение истории ввода» в контексте `composer`. | S |
| `tui.keymap.composer.queue` | `string / array<string>` | Клавиши действия «поставить сообщение в очередь» в контексте `composer`. | S |
| `tui.keymap.composer.submit` | `string / array<string>` | Клавиши действия «отправить сообщение» в контексте `composer`. | S |
| `tui.keymap.composer.toggle_shortcuts` | `string / array<string>` | Клавиши действия «показать или скрыть подсказки клавиш» в контексте `composer`. | S |

### Клавиши: editor

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tui.keymap.editor` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tui.keymap.editor.delete_backward` | `string / array<string>` | Клавиши действия «удалить символ перед курсором» в контексте `editor`. | S |
| `tui.keymap.editor.delete_backward_word` | `string / array<string>` | Клавиши действия «удалить слово перед курсором» в контексте `editor`. | S |
| `tui.keymap.editor.delete_forward` | `string / array<string>` | Клавиши действия «удалить символ после курсора» в контексте `editor`. | S |
| `tui.keymap.editor.delete_forward_word` | `string / array<string>` | Клавиши действия «удалить слово после курсора» в контексте `editor`. | S |
| `tui.keymap.editor.insert_newline` | `string / array<string>` | Клавиши действия «вставить перевод строки» в контексте `editor`. | S |
| `tui.keymap.editor.kill_line_end` | `string / array<string>` | Клавиши действия «вырезать до конца строки во внутренний буфер» в контексте `editor`. | S |
| `tui.keymap.editor.kill_line_start` | `string / array<string>` | Клавиши действия «вырезать до начала строки во внутренний буфер» в контексте `editor`. | S |
| `tui.keymap.editor.kill_whole_line` | `string / array<string>` | Клавиши действия «вырезать строку во внутренний буфер» в контексте `editor`. | S |
| `tui.keymap.editor.move_down` | `string / array<string>` | Клавиши действия «переместиться вниз» в контексте `editor`. | S |
| `tui.keymap.editor.move_left` | `string / array<string>` | Клавиши действия «переместиться влево» в контексте `editor`. | S |
| `tui.keymap.editor.move_line_end` | `string / array<string>` | Клавиши действия «перейти к концу строки» в контексте `editor`. | S |
| `tui.keymap.editor.move_line_start` | `string / array<string>` | Клавиши действия «перейти к началу строки» в контексте `editor`. | S |
| `tui.keymap.editor.move_right` | `string / array<string>` | Клавиши действия «переместиться вправо» в контексте `editor`. | S |
| `tui.keymap.editor.move_up` | `string / array<string>` | Клавиши действия «переместиться вверх» в контексте `editor`. | S |
| `tui.keymap.editor.move_word_left` | `string / array<string>` | Клавиши действия «перейти на слово влево» в контексте `editor`. | S |
| `tui.keymap.editor.move_word_right` | `string / array<string>` | Клавиши действия «перейти на слово вправо» в контексте `editor`. | S |
| `tui.keymap.editor.yank` | `string / array<string>` | Клавиши действия «вставить внутренний буфер редактора» в контексте `editor`. | S |

### Клавиши: global

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tui.keymap.global` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tui.keymap.global.clear_terminal` | `string / array<string>` | Клавиши действия «очистить терминал» в контексте `global`. | S |
| `tui.keymap.global.copy` | `string / array<string>` | Клавиши действия «скопировать выделенное» в контексте `global`. | S |
| `tui.keymap.global.find_transcript` | `string / array<string>` | Клавиши действия «искать в transcript» в контексте `global`. | S |
| `tui.keymap.global.focus_activity` | `string / array<string>` | Клавиши действия «перевести фокус на активность» в контексте `global`. | S |
| `tui.keymap.global.open_agents` | `string / array<string>` | Клавиши действия «открыть обзор агентов» в контексте `global`. | S |
| `tui.keymap.global.open_external_editor` | `string / array<string>` | Клавиши действия «открыть внешний редактор» в контексте `global`. | S |
| `tui.keymap.global.open_transcript` | `string / array<string>` | Клавиши действия «открыть transcript» в контексте `global`. | S |
| `tui.keymap.global.queue` | `string / array<string>` | Клавиши действия «поставить сообщение в очередь» в контексте `global`. | S |
| `tui.keymap.global.submit` | `string / array<string>` | Клавиши действия «отправить сообщение» в контексте `global`. | S |
| `tui.keymap.global.toggle_fast_mode` | `string / array<string>` | Клавиши действия «переключить Fast mode» в контексте `global`. | S |
| `tui.keymap.global.toggle_raw_output` | `string / array<string>` | Клавиши действия «переключить raw output» в контексте `global`. | S |
| `tui.keymap.global.toggle_shortcuts` | `string / array<string>` | Клавиши действия «показать или скрыть подсказки клавиш» в контексте `global`. | S |
| `tui.keymap.global.toggle_side_conversation` | `string / array<string>` | Клавиши действия «переключить боковой разговор» в контексте `global`. | S |
| `tui.keymap.global.toggle_vim_mode` | `string / array<string>` | Клавиши действия «переключить Vim mode» в контексте `global`. | S |

### Клавиши: list

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tui.keymap.list` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tui.keymap.list.accept` | `string / array<string>` | Клавиши действия «подтвердить выбор» в контексте `list`. | S |
| `tui.keymap.list.cancel` | `string / array<string>` | Клавиши действия «отменить текущий выбор или режим» в контексте `list`. | S |
| `tui.keymap.list.jump_bottom` | `string / array<string>` | Клавиши действия «перейти в конец» в контексте `list`. | S |
| `tui.keymap.list.jump_top` | `string / array<string>` | Клавиши действия «перейти в начало» в контексте `list`. | S |
| `tui.keymap.list.move_down` | `string / array<string>` | Клавиши действия «переместиться вниз» в контексте `list`. | S |
| `tui.keymap.list.move_left` | `string / array<string>` | Клавиши действия «переместиться влево» в контексте `list`. | S |
| `tui.keymap.list.move_right` | `string / array<string>` | Клавиши действия «переместиться вправо» в контексте `list`. | S |
| `tui.keymap.list.move_up` | `string / array<string>` | Клавиши действия «переместиться вверх» в контексте `list`. | S |
| `tui.keymap.list.page_down` | `string / array<string>` | Клавиши действия «страница вниз» в контексте `list`. | S |
| `tui.keymap.list.page_up` | `string / array<string>` | Клавиши действия «страница вверх» в контексте `list`. | S |

### Клавиши: pager

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tui.keymap.pager` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tui.keymap.pager.close` | `string / array<string>` | Клавиши действия «закрыть окно просмотра» в контексте `pager`. | S |
| `tui.keymap.pager.close_transcript` | `string / array<string>` | Клавиши действия «закрыть transcript» в контексте `pager`. | S |
| `tui.keymap.pager.find` | `string / array<string>` | Клавиши действия «открыть поиск» в контексте `pager`. | S |
| `tui.keymap.pager.half_page_down` | `string / array<string>` | Клавиши действия «прокрутить вниз на полстраницы» в контексте `pager`. | S |
| `tui.keymap.pager.half_page_up` | `string / array<string>` | Клавиши действия «прокрутить вверх на полстраницы» в контексте `pager`. | S |
| `tui.keymap.pager.jump_bottom` | `string / array<string>` | Клавиши действия «перейти в конец» в контексте `pager`. | S |
| `tui.keymap.pager.jump_top` | `string / array<string>` | Клавиши действия «перейти в начало» в контексте `pager`. | S |
| `tui.keymap.pager.page_down` | `string / array<string>` | Клавиши действия «страница вниз» в контексте `pager`. | S |
| `tui.keymap.pager.page_up` | `string / array<string>` | Клавиши действия «страница вверх» в контексте `pager`. | S |
| `tui.keymap.pager.scroll_down` | `string / array<string>` | Клавиши действия «прокрутить вниз» в контексте `pager`. | S |
| `tui.keymap.pager.scroll_up` | `string / array<string>` | Клавиши действия «прокрутить вверх» в контексте `pager`. | S |

### Клавиши: vim_normal

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tui.keymap.vim_normal` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tui.keymap.vim_normal.append_after_cursor` | `string / array<string>` | Клавиши действия «перейти к вставке после курсора» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.append_line_end` | `string / array<string>` | Клавиши действия «перейти к вставке в конце строки» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.cancel_operator` | `string / array<string>` | Клавиши действия «отменить Vim-оператор» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.change_to_line_end` | `string / array<string>` | Клавиши действия «заменить текст до конца строки» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.delete_char` | `string / array<string>` | Клавиши действия «удалить символ в Vim» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.delete_to_line_end` | `string / array<string>` | Клавиши действия «удалить до конца строки» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.enter_insert` | `string / array<string>` | Клавиши действия «перейти в Vim insert mode» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.enter_replace_mode` | `string / array<string>` | Клавиши действия «перейти в Vim replace mode» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.find_backward` | `string / array<string>` | Клавиши действия «найти символ назад» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.find_forward` | `string / array<string>` | Клавиши действия «найти символ вперёд» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.insert_line_start` | `string / array<string>` | Клавиши действия «перейти к вставке в начале строки» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.jump_bottom` | `string / array<string>` | Клавиши действия «перейти в конец» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.jump_top` | `string / array<string>` | Клавиши действия «перейти в начало» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.move_down` | `string / array<string>` | Клавиши действия «переместиться вниз» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.move_left` | `string / array<string>` | Клавиши действия «переместиться влево» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.move_line_end` | `string / array<string>` | Клавиши действия «перейти к концу строки» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.move_line_start` | `string / array<string>` | Клавиши действия «перейти к началу строки» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.move_right` | `string / array<string>` | Клавиши действия «переместиться вправо» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.move_up` | `string / array<string>` | Клавиши действия «переместиться вверх» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.move_word_backward` | `string / array<string>` | Клавиши действия «перейти к предыдущему слову» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.move_word_end` | `string / array<string>` | Клавиши действия «перейти к концу слова» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.move_word_forward` | `string / array<string>` | Клавиши действия «перейти к следующему слову» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.open_line_above` | `string / array<string>` | Клавиши действия «создать строку выше и начать ввод» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.open_line_below` | `string / array<string>` | Клавиши действия «создать строку ниже и начать ввод» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.paste_after` | `string / array<string>` | Клавиши действия «вставить после курсора в Vim» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.redo` | `string / array<string>` | Клавиши действия «повторить отменённое изменение» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.repeat_last_change` | `string / array<string>` | Клавиши действия «повторить последнее Vim-изменение» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.replace_char` | `string / array<string>` | Клавиши действия «заменить символ» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.start_change_operator` | `string / array<string>` | Клавиши действия «начать Vim-оператор изменения» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.start_delete_operator` | `string / array<string>` | Клавиши действия «начать Vim-оператор удаления» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.start_yank_operator` | `string / array<string>` | Клавиши действия «начать Vim-оператор копирования» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.substitute_char` | `string / array<string>` | Клавиши действия «заменить символ и начать ввод» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.till_backward` | `string / array<string>` | Клавиши действия «перейти до символа назад» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.till_forward` | `string / array<string>` | Клавиши действия «перейти до символа вперёд» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.undo` | `string / array<string>` | Клавиши действия «отменить изменение» в контексте `vim_normal`. | S |
| `tui.keymap.vim_normal.yank_line` | `string / array<string>` | Клавиши действия «скопировать строку во внутренний Vim-буфер» в контексте `vim_normal`. | S |

### Клавиши: vim_operator

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tui.keymap.vim_operator` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tui.keymap.vim_operator.cancel` | `string / array<string>` | Клавиши действия «отменить текущий выбор или режим» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.delete_line` | `string / array<string>` | Клавиши действия «удалить строку» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_down` | `string / array<string>` | Клавиши действия «Vim-движение оператора вниз» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_find_backward` | `string / array<string>` | Клавиши действия «Vim-движение к найденному символу назад» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_find_forward` | `string / array<string>` | Клавиши действия «Vim-движение к найденному символу вперёд» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_jump_bottom` | `string / array<string>` | Клавиши действия «Vim-движение оператора в конец» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_jump_top` | `string / array<string>` | Клавиши действия «Vim-движение оператора в начало» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_left` | `string / array<string>` | Клавиши действия «Vim-движение оператора влево» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_line_end` | `string / array<string>` | Клавиши действия «Vim-движение оператора к концу строки» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_line_start` | `string / array<string>` | Клавиши действия «Vim-движение оператора к началу строки» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_right` | `string / array<string>` | Клавиши действия «Vim-движение оператора вправо» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_till_backward` | `string / array<string>` | Клавиши действия «Vim-движение до символа назад» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_till_forward` | `string / array<string>` | Клавиши действия «Vim-движение до символа вперёд» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_up` | `string / array<string>` | Клавиши действия «Vim-движение оператора вверх» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_word_backward` | `string / array<string>` | Клавиши действия «Vim-движение оператора к предыдущему слову» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_word_end` | `string / array<string>` | Клавиши действия «Vim-движение оператора к концу слова» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.motion_word_forward` | `string / array<string>` | Клавиши действия «Vim-движение оператора к следующему слову» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.select_around_text_object` | `string / array<string>` | Клавиши действия «выбрать Vim text object вместе с границами» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.select_inner_text_object` | `string / array<string>` | Клавиши действия «выбрать внутренность Vim text object» в контексте `vim_operator`. | S |
| `tui.keymap.vim_operator.yank_line` | `string / array<string>` | Клавиши действия «скопировать строку во внутренний Vim-буфер» в контексте `vim_operator`. | S |

### Клавиши: vim_search

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tui.keymap.vim_search` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tui.keymap.vim_search.backward` | `string / array<string>` | Клавиши действия «искать назад» в контексте `vim_search`. | S |
| `tui.keymap.vim_search.forward` | `string / array<string>` | Клавиши действия «искать вперёд» в контексте `vim_search`. | S |
| `tui.keymap.vim_search.next` | `string / array<string>` | Клавиши действия «следующее совпадение поиска» в контексте `vim_search`. | S |
| `tui.keymap.vim_search.previous` | `string / array<string>` | Клавиши действия «предыдущее совпадение поиска» в контексте `vim_search`. | S |

### Клавиши: vim_text_object

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `tui.keymap.vim_text_object` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `tui.keymap.vim_text_object.backtick` | `string / array<string>` | Клавиши действия «выбрать текст в обратных кавычках» в контексте `vim_text_object`. | S |
| `tui.keymap.vim_text_object.big_word` | `string / array<string>` | Клавиши действия «выбрать WORD как Vim text object» в контексте `vim_text_object`. | S |
| `tui.keymap.vim_text_object.braces` | `string / array<string>` | Клавиши действия «выбрать текст в фигурных скобках» в контексте `vim_text_object`. | S |
| `tui.keymap.vim_text_object.brackets` | `string / array<string>` | Клавиши действия «выбрать текст в квадратных скобках» в контексте `vim_text_object`. | S |
| `tui.keymap.vim_text_object.cancel` | `string / array<string>` | Клавиши действия «отменить текущий выбор или режим» в контексте `vim_text_object`. | S |
| `tui.keymap.vim_text_object.double_quote` | `string / array<string>` | Клавиши действия «выбрать текст в двойных кавычках» в контексте `vim_text_object`. | S |
| `tui.keymap.vim_text_object.parentheses` | `string / array<string>` | Клавиши действия «выбрать текст в круглых скобках» в контексте `vim_text_object`. | S |
| `tui.keymap.vim_text_object.single_quote` | `string / array<string>` | Клавиши действия «выбрать текст в одинарных кавычках» в контексте `vim_text_object`. | S |
| `tui.keymap.vim_text_object.word` | `string / array<string>` | Клавиши действия «выбрать слово как Vim text object» в контексте `vim_text_object`. | S |

<a id="features"></a>

## Документированные и структурированные features

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `features` | `table` | Централизованные переключатели функций. Табличные варианты и технические флаги перечислены отдельно. | S |
| `features.apps` | `boolean` | Интеграции приложений; стабильный флаг, стандартно включён. Сетевой proxy команд не фильтрует трафик приложений и коннекторов. | — |
| `features.apps_mcp_path_override` | `boolean / table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `features.apps_mcp_path_override.enabled` | `boolean` | Включение родительской возможности; наличие поля в схеме не гарантирует доступность функции в данном клиенте. | S |
| `features.apps_mcp_path_override.path` | `string` | Поле есть в опубликованной схеме; подробное назначение и runtime-стандарт публично не описаны. | S |
| `features.code_mode` | `boolean / table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `features.code_mode.default_exec_yield_time_ms` | `integer` | Стандартный yield timeout исполнения Code Mode в миллисекундах. | ≥0; S |
| `features.code_mode.direct_only_tool_namespaces` | `array<string>` | Пространства имён, которые Code Mode может вызывать только напрямую. | — |
| `features.code_mode.enabled` | `boolean` | Включает Code Mode; функция в разработке, стандартно выключена. | — |
| `features.code_mode.excluded_tool_namespaces` | `array<string>` | Пространства имён инструментов, исключённые из вложенных инструкций и исполнения Code Mode. | — |
| `features.code_mode.experimental_show_cell_overhead` | `boolean` | Экспериментальный вывод времени handler, host и накладных расходов в ответах ячеек; формат может измениться. | S |
| `features.code_mode.tool_input_schema_max_bytes` | `integer` | Лимит UTF-8 для выводимого типа входа инструмента; минимум и стандарт 16000 байт. Для MCP не ниже явно заданного серверного лимита. | ≥1; S |
| `features.code_mode_host` | `boolean / table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `features.code_mode_host.disable_in_process_fallback` | `boolean` | При недоступном standalone host запрещает fallback исполнения Code Mode внутри процесса. | S |
| `features.code_mode_host.enabled` | `boolean` | Включение родительской возможности; наличие поля в схеме не гарантирует доступность функции в данном клиенте. | S |
| `features.codex_hooks` | `boolean` | Устаревший alias `features.hooks`; используйте новое имя. | S |
| `features.context_management` | `boolean / table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `features.context_management.experimental_mode` | `boolean` | Экспериментальная настройка управления контекстом; функция сейчас недоступна. | — |
| `features.current_time_reminder` | `boolean / table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `features.current_time_reminder.clock_source` | `"system" / "external"` | Источник текущего времени: системный или внешний; подробный runtime-контракт в схеме не пояснён. | S |
| `features.current_time_reminder.delivery_mode` | `"any_inference" / "after_user_or_tool_output"` | `any_inference` допускает напоминание перед любым inference после интервала; другой вариант ограничивает его границами нового входа. Точные имена вариантов перечислены в типе. | S |
| `features.current_time_reminder.enabled` | `boolean` | Включение родительской возможности; наличие поля в схеме не гарантирует доступность функции в данном клиенте. | S |
| `features.current_time_reminder.reminder_interval_seconds` | `integer` | Интервал напоминаний текущего времени в секундах. | ≥0; S |
| `features.current_time_reminder.sleep_tool` | `boolean` | Публикует `clock.sleep`, прерываемый новым пользовательским вводом. | S |
| `features.enable_request_compression` | `boolean` | Сжатие потоковых request bodies через zstd при поддержке провайдером; стандартно включено. | — |
| `features.fast_mode` | `boolean` | Выбор service tier в TUI, включая Fast при поддержке моделью; стандартно включён. | — |
| `features.goals` | `boolean` | Сохраняемые цели и автоматическое продолжение работы; стандартно включены. | — |
| `features.guardianv2` | `boolean / table` | Экспериментальные настройки промпта, подтверждений и контекста Guardian v2. | S |
| `features.guardianv2.async_classifier_conversation_token_limit` | `integer` | Сбрасывает сохранённую async-историю при превышении оценки размера следующего запроса; стандартно 100000 токенов. Лимит входа модели сохраняется. | ≥1; S |
| `features.guardianv2.async_classifier_mode` | `"snapshot" / "conversation"` | Экспериментальный режим async-классификатора; без настройки берётся стандарт модели, затем snapshots. | S |
| `features.guardianv2.classifier_instructions` | `string` | Служебные инструкции классификатора Guardian v2; подробный публичный контракт не опубликован. | S |
| `features.guardianv2.enabled` | `boolean` | Включение родительской возможности; наличие поля в схеме не гарантирует доступность функции в данном клиенте. | S |
| `features.guardianv2.free_guardian` | `boolean` | Поле совместимости; оплатой Guardian теперь управляет backend. | S |
| `features.guardianv2.max_action_tokens` | `integer` | Служебный токенный предел действия Guardian v2; схема задаёт границы, подробная семантика не описана. | ≥100; ≤100000; S |
| `features.guardianv2.max_classifier_instruction_tokens` | `integer` | Служебный предел токенов инструкций классификатора; границы указаны в схеме. | ≥100; ≤100000; S |
| `features.guardianv2.max_parent_compaction_tokens` | `integer` | Служебный предел родительского сжатого контекста Guardian; границы указаны в схеме. | ≥100; ≤100000; S |
| `features.guardianv2.max_tool_call_lag` | `integer` | Служебный предел отставания обработки tool calls; единицы и алгоритм в справочнике не раскрыты. | ≥0; S |
| `features.guardianv2.persist_scores` | `boolean` | Сохраняет проверенные действия и оценки риска в rollout для диагностики. | S |
| `features.guardianv2.reasoning_effort` | `string` | Непустой reasoning effort, поддерживаемый выбранной моделью Guardian. | длина ≥ 1; S |
| `features.guardianv2.reuse_parent_compaction` | `boolean` | Служебное переиспользование родительского сжатого контекста; детали в публичном справочнике не раскрыты. | S |
| `features.guardianv2.review_scope` | `table` | Категории tool calls, доступные классификатору Guardian v2. | S |
| `features.guardianv2.review_scope.computer_use_only` | `boolean` | Ограничивает async-классификацию и быстрые одобрения инструментами browser/computer use. | S |
| `features.guardianv2.review_scope.sandboxed_exec_commands` | `boolean` | Включает shell-команды песочницы в классификацию Guardian v2. | S |
| `features.guardianv2.review_threshold` | `number` | Служебный порог Guardian v2 от 0 до 1; правила принятия решения в справочнике не опубликованы. | ≥0; ≤1; S |
| `features.guardianv2.thread_context` | `boolean` | Устаревшее игнорируемое поле; thread-owned контекст Guardian включён всегда. | S |
| `features.guardianv2.transcript` | `table` | Лимиты и дополнительные источники transcript Guardian v2. | S |
| `features.guardianv2.transcript.include_images` | `boolean` | Включает последние screenshots из сообщений и настроенных outputs. | S |
| `features.guardianv2.transcript.max_message_entry_tokens` | `integer` | Служебный токенный предел одного сообщения transcript; схема задаёт границы. | ≥100; ≤100000; S |
| `features.guardianv2.transcript.max_message_transcript_tokens` | `integer` | Служебный токенный предел сообщений transcript; схема задаёт границы. | ≥100; ≤100000; S |
| `features.guardianv2.transcript.max_recent_non_user_entries` | `integer` | Служебный максимум последних непользовательских записей transcript. | ≥1; S |
| `features.guardianv2.transcript.max_tool_entry_tokens` | `integer` | Служебный токенный предел одного результата инструмента transcript. | ≥100; ≤100000; S |
| `features.guardianv2.transcript.max_tool_transcript_tokens` | `integer` | Служебный токенный предел результатов инструментов transcript. | ≥100; ≤100000; S |
| `features.guardianv2.transcript.sources` | `array<"tool_calls" / "tool_outputs" / "reasoning">` | Источники transcript; допустимые варианты перечислены в типе схемы. | S |
| `features.guardianv2.transcript_mode` | `"line" / "json"` | Кодирование transcript: `line`, стандартно, — строки с номерами и ролями; альтернативный вариант содержит host metadata и JSON-экранированный текст. | S |
| `features.hooks` | `boolean` | Lifecycle hooks из `hooks.json` или `[hooks]`. Старое имя `features.codex_hooks` — устаревший alias. | — |
| `features.memories` | `boolean` | Включает Memories; экспериментальная возможность, стандартно выключена. | — |
| `features.multi_agent` | `boolean` | Инструменты взаимодействия субагентов; стабильный флаг, стандартно включён. | — |
| `features.multi_agent_v2` | `boolean / table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `features.multi_agent_v2.default_wait_timeout_ms` | `integer` | Служебный стандартный timeout ожидания V2 в миллисекундах; допустимые границы заданы схемой. | ≥0; ≤3600000; S |
| `features.multi_agent_v2.disable_direct_message` | `boolean` | Отключает прямые сообщения модели; создание агентов и автоматическое получение результатов сохраняются. | S |
| `features.multi_agent_v2.enabled` | `boolean` | Включение родительской возможности; наличие поля в схеме не гарантирует доступность функции в данном клиенте. | S |
| `features.multi_agent_v2.expose_spawn_agent_model_overrides` | `boolean` | Публикует `model` и `reasoning_effort` в инструменте создания V2-агента и добавляет соответствующие инструкции. | S |
| `features.multi_agent_v2.hide_spawn_agent_metadata` | `boolean` | Служебный флаг скрытия spawn metadata; публичная семантика не описана. | S |
| `features.multi_agent_v2.max_concurrent_threads_per_session` | `integer` | Лимит одновременно открытых потоков backend V2; минимум 1. | ≥1; S |
| `features.multi_agent_v2.max_wait_timeout_ms` | `integer` | Максимальный timeout ожидания V2 в миллисекундах. | ≥0; ≤3600000; S |
| `features.multi_agent_v2.message_board_in_memory` | `boolean` | Хранить message board тренировочной сессии в памяти, включая ephemeral sessions. | S |
| `features.multi_agent_v2.message_board_remote` | `table` | Использовать удалённую доску сессии, предоставленную research host. | S |
| `features.multi_agent_v2.message_board_remote.bearer_token` | `string` | Credentials доски, переданные прямым runtime override. | S |
| `features.multi_agent_v2.message_board_remote.bearer_token_env_var` | `string` | Имя переменной окружения с credentials вместо прямого bearer token. | S |
| `features.multi_agent_v2.message_board_remote.url` | `string` | URL удалённой message board; публичный контракт подключения не описан. | S |
| `features.multi_agent_v2.min_wait_timeout_ms` | `integer` | Минимальный timeout ожидания V2 в миллисекундах. | ≥0; ≤3600000; S |
| `features.multi_agent_v2.multi_agent_mode_hint_text` | `string` | Служебный текст подсказки режима V2; публичная семантика не описана. | S |
| `features.multi_agent_v2.non_code_mode_only` | `boolean` | Служебное ограничение V2 вне Code Mode; точные условия применения не описаны. | S |
| `features.multi_agent_v2.root_agent_usage_hint_text` | `string` | Служебная подсказка использования V2 для основного агента. | S |
| `features.multi_agent_v2.subagent_developer_instructions` | `string` | Заменяет наследуемые developer instructions субагентов, если у роли нет собственных. | S |
| `features.multi_agent_v2.subagent_usage_hint_text` | `string` | Служебная подсказка использования V2 для субагента. | S |
| `features.multi_agent_v2.tool_namespace` | `string` | Namespace инструментов V2; ограничения длины и допустимых символов заданы схемой. | длина ≥ 1; длина ≤ 64; pattern: ^[a-zA-Z0-9_-]+$; S |
| `features.multi_agent_v2.usage_hint_enabled` | `boolean` | Совместимое старое поле; значение игнорируется. | S |
| `features.multi_agent_v2.usage_hint_text` | `string` | Служебный общий текст подсказки V2. | S |
| `features.multi_agent_v2.wait_agent_enabled` | `boolean` | Публикует инструмент ожидания `wait_agent` backend V2. | S |
| `features.network_proxy` | `boolean / table` | Экспериментальный proxy для сетевых подключений команд; стандартно выключен. Нужен для применения доменных правил permission profiles, если proxy не включён управляющими требованиями. Не фильтрует web search, приложения и MCP. | — |
| `features.network_proxy.allow_local_binding` | `boolean` | Разрешает более широкий доступ к локальной/частной сети; стандартно `false`. Точное разрешение IP или localhost может работать и при `false`. | — |
| `features.network_proxy.allow_upstream_proxy` | `boolean` | Разрешает цепочку через upstream proxy из окружения; стандартно `true`. | — |
| `features.network_proxy.credential_broker` | `boolean` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | S |
| `features.network_proxy.credentials` | `map<string, table>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `features.network_proxy.credentials.<name>` | `table` | Семейство credentials из окружения для внедрения proxy. | S |
| `features.network_proxy.credentials.<name>.auth` | `array<"bearer" / "token" / "basic" / "header">` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | default схемы: []; S |
| `features.network_proxy.credentials.<name>.env` | `array<string>` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | default схемы: []; S |
| `features.network_proxy.credentials.<name>.header` | `string` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | S |
| `features.network_proxy.credentials.<name>.patterns` | `array<string>` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | default схемы: []; S |
| `features.network_proxy.credentials.<name>.prefix` | `string` | Служебное поле сетевого MITM/credential broker. В схеме опубликован тип; подробный контракт в публичном справочнике не раскрыт. | S |
| `features.network_proxy.credentials.<name>.url_prefix_from_env` | `string` | Переменная окружения с дополнительным URL-префиксом или хостом. | S |
| `features.network_proxy.credentials.<name>.url_prefixes` | `array<string>` | Разрешённые URL-префиксы внедрения. Loopback-хост без схемы означает HTTP; другие хосты без схемы — HTTPS. | default схемы: []; S |
| `features.network_proxy.dangerously_allow_all_unix_sockets` | `boolean` | Разрешает любые Unix-сокеты вместо списка разрешённых; стандартно `false`. | — |
| `features.network_proxy.dangerously_allow_non_loopback_proxy` | `boolean` | Разрешает listener за пределами loopback; стандартно `false`. | — |
| `features.network_proxy.domains` | `map<string, "allow" / "deny">` | Доменные правила proxy: точный хост, `*.example.com` для поддоменов, `**.example.com` вместе с основным доменом, `*` для общего разрешения. `deny` приоритетнее; без правил внешние адресаты не разрешены. | — |
| `features.network_proxy.enable_socks5` | `boolean` | Включает SOCKS5 listener; стандартно `true`. | — |
| `features.network_proxy.enable_socks5_udp` | `boolean` | Разрешает UDP через SOCKS5; стандартно `true`. | — |
| `features.network_proxy.enabled` | `boolean` | Включить proxy при разрешённой сети команд; стандартно `false`. Без него доменные правила профиля не применяются. | — |
| `features.network_proxy.mode` | `"limited" / "full"` | Поле есть в опубликованной схеме; подробное назначение и runtime-стандарт публично не описаны. | S |
| `features.network_proxy.proxy_url` | `string` | HTTP listener proxy; стандартно `http://127.0.0.1:3128`. | — |
| `features.network_proxy.socks_url` | `string` | SOCKS5 listener; в опубликованной конфигурации стандартно `http://127.0.0.1:8081`. | — |
| `features.network_proxy.unix_sockets` | `map<string, "allow" / "deny">` | Правила Unix-сокетов proxy; добавляйте разрешённые пути через `allow`. | — |
| `features.non_prefixed_mcp_tool_names` | `boolean / table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `features.non_prefixed_mcp_tool_names.enabled` | `boolean` | Включение родительской возможности; наличие поля в схеме не гарантирует доступность функции в данном клиенте. | S |
| `features.non_prefixed_mcp_tool_names.server_names` | `array<string>` | MCP-серверы, чьи инструменты публикуются без старого префикса `mcp__`. | S |
| `features.personality` | `boolean` | Управление стилем общения personality; стандартно включено. | — |
| `features.prefer_mxc` | `boolean` | Предпочитать MXC на Windows при поддержке и разрешении политикой; иначе сохранить legacy-песочницу. CLI стандартно выключает флаг, desktop может включать rollout-настройкой. Ошибка команды не вызывает fallback. | — |
| `features.prevent_idle_sleep` | `boolean` | Не давать компьютеру засыпать во время активного шага; экспериментальный флаг, стандартно выключен. | — |
| `features.remote_plugin` | `boolean` | Удалённый каталог плагинов; стандартно включён. | — |
| `features.rollout_budget` | `boolean / table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `features.rollout_budget.enabled` | `boolean` | Включает учёт бюджета rollout; функция в разработке, стандартно выключена. При включении обязателен `limit_tokens`. | — |
| `features.rollout_budget.limit_tokens` | `integer` | Положительный лимит токенов бюджета rollout. | ≥1 |
| `features.rollout_budget.prefill_token_weight` | `number` | Конечный неотрицательный вес входных токенов при учёте бюджета; стандартно `1.0`. | ≥0 |
| `features.rollout_budget.reminder_at_remaining_tokens` | `array<integer>` | Остатки взвешенных токенов, при пересечении которых показываются напоминания. | S |
| `features.rollout_budget.reminder_interval_tokens` | `integer` | Интервал напоминаний о бюджете; стандартно 10% `limit_tokens`, минимум 1 токен. | — |
| `features.rollout_budget.sampling_token_weight` | `number` | Конечный неотрицательный вес токенов генерации при учёте бюджета; стандартно `1.0`. | ≥0 |
| `features.shell_snapshot` | `boolean` | Снимок окружения shell для ускорения повторных запусков; стандартно включён. | — |
| `features.shell_tool` | `boolean` | Стандартный инструмент shell для команд; стабилен, стандартно включён. | — |
| `features.skill_mcp_dependency_install` | `boolean` | Запрос и установка недостающих MCP-зависимостей навыков; стандартно включены. | — |
| `features.sleep_tool` | `boolean / table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `features.sleep_tool.enabled` | `boolean` | Включение родительской возможности; наличие поля в схеме не гарантирует доступность функции в данном клиенте. | S |
| `features.sleep_tool.mode` | `"model_driven" / "always_on"` | Выбор sleep при включённой функции: `model_driven` сохраняет старые model/clock defaults; `always_on` регистрирует sleep независимо от них. | S |
| `features.token_budget` | `boolean / table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `features.token_budget.auto_compact_fallback_buffer_tokens` | `integer` | Дополнительные токены после порога сжатия для резервного сохранения заметок. | ≥1; S |
| `features.token_budget.auto_compact_fallback_prompt` | `string` | Developer message перед автоматической сменой окна контекста. | длина ≤ 2000; S |
| `features.token_budget.enabled` | `boolean` | Включение родительской возможности; наличие поля в схеме не гарантирует доступность функции в данном клиенте. | S |
| `features.token_budget.guidance_message` | `string` | Инструкции, добавляемые в metadata окна контекста в developer message. | длина ≤ 2000; S |
| `features.token_budget.reminder_message_template` | `string` | Шаблон напоминания; `{n_remaining}` заменяется остатком токенов до автоматического сжатия. | длина ≥ 1; длина ≤ 2000; S |
| `features.token_budget.reminder_threshold_tokens` | `integer` | Остаток токенов до сжатия, при котором показывается напоминание завершить работу. | ≥1; S |
| `features.token_budget.use_history_notes_extension` | `boolean` | Публикует встроенное расширение истории и заметок. | S |
| `features.tool_registry` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `features.tool_registry.error_on_tool_collisions` | `boolean` | Завершает шаг ошибкой, если несколько инструментов имеют одинаковое итоговое имя. | S |
| `features.tool_registry.turn_metadata_includes_tool_info` | `boolean` | Добавляет достоверные сведения об инструментах в metadata запроса шага. | S |
| `features.unified_exec` | `boolean` | Единый инструмент исполнения команд с PTY; стабилен, стандартно включён, кроме Windows. | — |
| `features.web_search` | `boolean` | Устаревший переключатель поиска; используйте корневой `web_search`. | — |
| `features.web_search_cached` | `boolean` | Устаревший флаг: при неуказанном `web_search` значение `true` выбирает `cached`. | — |
| `features.web_search_request` | `boolean` | Устаревший флаг: при неуказанном `web_search` значение `true` выбирает `live`. | — |

<a id="technical-flags"></a>

## Технические флаги без публичного описания

Ниже перечислены **все оставшиеся простые флаги из схемы**, включая внутренние и совместимые старые имена. Их наличие в JSON Schema подтверждает форму записи, но не раскрывает назначение, maturity, поддержку backend или default. Автоматически включать весь список не следует.

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `features.agent_message_board` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.analytics_plan_history` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.api_key_cyber_access_programs` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.api_key_model_discovery` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.apply_patch_freeform` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.apply_patch_preserve_line_endings` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.apply_patch_streaming_events` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.auth_elicitation` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.background_paginated_rollout_migration` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.bedrock_setup_wizard` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.browser_annotation_api` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.browser_use` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.browser_use_external` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.browser_use_full_cdp_access` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.chronicle` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.cli_daybreak` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.code_mode_buffered_exec` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.code_mode_interrupt` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.code_mode_only` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.code_mode_only_strict_3p_tools` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.code_mode_prewarm` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.code_mode_tool_search` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.codex_apps_mcp_2026_07_28` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.codex_git_commit` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.collab` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.collaboration_modes` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.compaction_image_budget` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.computer_use` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.concurrent_reasoning_summaries` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.connectors` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.content_item_kinds` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.cwd_relative_turn_diffs` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.daemon_auto_start` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.default_mode_request_user_input` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.defer_mailbox_preemption` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.deferred_executor` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.deferred_tool_world_state` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.elevated_windows_sandbox` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.enable_experimental_windows_sandbox` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.enable_fanout` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.enable_mcp_apps` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.exec_permission_approvals` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.executed_tool_call_metadata` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.executor_capability_discovery` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.experimental_use_unified_exec_tool` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.experimental_windows_sandbox` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.external_agent_memory_import` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.external_migration` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.guardian_approval` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.guardian_conversation_history_tools` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.guardian_enhanced_node_repl_transcripts` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.guardian_ext` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.guardian_node_repl_transcript_images` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.guardian_reuse_parent_compaction` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.guardian_root_handoff_context` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.guardianv2_decisions_comparison` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.image_detail_original` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.image_generation` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.image_resize_notice` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.imagegenext` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.in_app_browser` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.in_app_chat` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.in_app_dictation` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.in_app_local_automation` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.in_app_updates` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.in_app_voice` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.incremental_tools` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.instant_interrupt` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.item_ids` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.js_repl` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.js_repl_tools_only` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.local_thread_store_compression` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.local_thread_store_shared_compression` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.login_shell_package_path` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.mcp_2026_07_28` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.mcp_oauth_refresh_coordination` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.memory_tool` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.mentions_v2` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.model_catalog_in_context` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.multi_agent_mode` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.multi_agent_v2_dynamic_tools` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.nonfatal_clock_read_errors` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.omit_app_server_notification_media` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.plugin_hooks` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.plugin_sharing` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.plugins` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.powershell_shell_version` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.psp` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.realtime_conversation` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.reasoning_effort_override` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.recommended_plugins` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.remote_compaction_v2` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.remote_control` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.remote_models` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.request_permissions` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.request_permissions_tool` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.request_rule` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.resize_all_images` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.respect_system_proxy` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.responses_websockets` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.responses_websockets_v2` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.retain_client_developer_messages` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.runtime_metrics` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.search_tool` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.secret_auth_storage` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.send_async_message` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.send_message_to_user_async` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.shell_snapshot_v2` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.shell_zsh_fork` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.skill_env_var_dependency_prompt` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.skill_search` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.skip_host_skill_discovery` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.sqlite` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.stable_environment_tools` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.standalone_web_search` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.steer` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.step_model_switching` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.system_proxy_fallback` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.telepathy` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.terminal_resize_reflow` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.terminal_visualization_instructions` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.tool_call_mcp_elicitation` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.tool_search` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.tool_search_always_defer_mcp_tools` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.tool_suggest` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.transcript_v2` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.tui_app_server` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.ultrafast_mode` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.unavailable_dummy_tools` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.unbounded_connection_retries` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.undo` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.unified_exec_tty` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.unified_exec_zsh_fork` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.unified_image_budget` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.use_agent_identity` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.use_legacy_landlock` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.use_linux_sandbox_bwrap` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.use_xaa` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.view_image` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.windows_sandbox_service` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.workspace_dependencies` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.workspace_owner_usage_nudge` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.worktrees` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |
| `features.write_stdin_approval` | `boolean` | Технический флаг. В Configuration Reference и JSON Schema не пояснены назначение, стадия готовности и стандартное значение. | S |

<a id="storage"></a>

## Хранение, вход и служебное состояние

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `allow_symlinked_codex_home` | `boolean` | На macOS разрешает writable roots внутри `$CODEX_HOME` проходить через symlink, включая изменяемые цели за его пределами. Сам не даёт права записи; читается из пользовательского host config при старте. Стандартно `false`; Linux/Windows не затрагивает. | S |
| `analytics` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `analytics.enabled` | `boolean` | Включает аналитику для машины или профиля. При отсутствии применяется стандартное поведение клиента. | — |
| `chatgpt_base_url` | `string` | Базовый URL для потока ChatGPT login. | — |
| `check_for_update_on_startup` | `boolean` | Проверять обновления Codex при запуске. | — |
| `cli_auth_credentials_store` | `"file" / "keyring" / "auto" / "ephemeral"` | Хранилище credentials CLI: файл, системный keyring, автоматический выбор или временное хранилище `ephemeral`. | — |
| `disable_paste_burst` | `boolean` | Старое корневое отключение распознавания быстрой вставки TUI; вложенное `tui.disable_paste_burst` приоритетнее. | — |
| `experimental_thread_store` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `experimental_thread_store.type` | `"local"` | Экспериментальный backend хранилища сессий; в схеме допускается только `local`, настройка помечена «do not use». | S |
| `feedback` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `feedback.enabled` | `boolean` | Разрешает отправку обратной связи через `/feedback`; стандартно `true`. | — |
| `file_opener` | `"vscode" / "vscode-insiders" / "windsurf" / "cursor" / "none"` | Редактор для перехода по ссылкам на файлы: стандартно `vscode`; `none` отключает интеграцию. | — |
| `forced_chatgpt_workspace_id` | `string / array<string>` | Ограничивает вход конкретным ChatGPT workspace. Схема также допускает список UUID. | — |
| `forced_login_method` | `"chatgpt" / "api"` | Ограничивает способ входа: ChatGPT или API. | — |
| `ghost_snapshot` | `table` | Legacy-настройки для загрузки старых файлов; перечисленные поля больше не оказывают эффекта. | S |
| `ghost_snapshot.disable_warnings` | `boolean` | Старое поле совместимости; больше не оказывает эффекта. | S |
| `ghost_snapshot.ignore_large_untracked_dirs` | `integer` | Старое поле совместимости; больше не оказывает эффекта. | S |
| `ghost_snapshot.ignore_large_untracked_files` | `integer` | Старое поле совместимости; больше не оказывает эффекта. | S |
| `hide_agent_reasoning` | `boolean` | Скрывает reasoning-события в TUI и выводе `codex exec`. | default схемы: false |
| `history` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `history.max_bytes` | `integer` | Максимальный размер файла истории в байтах; старые записи удаляются первыми. | ≥0 |
| `history.persistence` | `"save-all" / "none"` | Сохранение CLI-истории в `history.jsonl`: `save-all` или `none`. | default схемы: "save-all" |
| `log_dir` | `string` | Каталог журналов; стандартно `$CODEX_HOME/log`. Явная настройка также включает текстовый журнал TUI `codex-tui.log`. | — |
| `notice` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `notice.external_config_migration_prompts` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `notice.external_config_migration_prompts.home` | `boolean` | Служебное скрытие home-level уведомлений переноса внешней конфигурации. | S |
| `notice.external_config_migration_prompts.home_last_prompted_at` | `integer` | Служебная отметка времени последнего home-level уведомления переноса. | S |
| `notice.external_config_migration_prompts.project_last_prompted_at` | `map<string, integer>` | Служебная карта путей проектов и времени последнего уведомления переноса. | S |
| `notice.external_config_migration_prompts.projects` | `map<string, boolean>` | Служебная карта проектов, отказавшихся от уведомлений переноса. | S |
| `notice.fast_default_opt_out` | `boolean` | Служебная отметка отказа от управляемых Codex fast defaults. | S |
| `notice.hide_full_access_warning` | `boolean` | Служебная отметка принятого предупреждения полного доступа. | — |
| `notice.hide_gpt-5.1-codex-max_migration_prompt` | `boolean` | Служебная отметка миграционного уведомления gpt-5.1-codex-max. | — |
| `notice.hide_gpt5_1_migration_prompt` | `boolean` | Служебная отметка миграционного уведомления GPT-5.1. | — |
| `notice.hide_rate_limit_model_nudge` | `boolean` | Служебное отключение напоминания сменить модель при rate limit. | — |
| `notice.hide_world_writable_warning` | `boolean` | Служебная отметка предупреждения Windows о world-writable каталогах. | — |
| `notice.model_migrations` | `map<string, string>` | Служебные подтверждённые миграции моделей: старое имя → новое. | — |
| `notify` | `array<string>` | Внешняя команда уведомлений: исполняемый файл и аргументы. Codex передаёт ей JSON с событием. | — |
| `openai_base_url` | `string` | Переопределение базового URL встроенного провайдера `openai`. | — |
| `projects` | `map<string, table>` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `projects.<name>` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `projects.<name>.trust_level` | `"trusted" / "untrusted"` | Доверие проекту: `trusted` или `untrusted`. Недоверенный проект не загружает проектные `.codex/` слои конфигурации, hooks и rules. | — |
| `responses_api_metadata` | `map<string, string>` | Ограниченная служебная metadata продукта для каждого Responses API запроса; не произвольное поле управления моделью. | S |
| `service_tier` | `string` | Предпочтительный service tier. `fast` преобразуется в значение запроса `priority`; доступность других значений зависит от модели. | — |
| `show_raw_agent_reasoning` | `boolean` | Показывает raw reasoning, только если модель действительно его выдаёт. | — |
| `sqlite_home` | `string` | Каталог SQLite-состояния для задач агентов и возобновляемых операций. | — |
| `suppress_unstable_features_warning` | `boolean` | Скрывает предупреждение о включённых нестабильных возможностях. | — |
| `thread_unload_delay_secs` | `integer` | Задержка выгрузки неактивного app-server thread без подписчиков; стандартно 60 с, 0 — сразу. Изменение применяется после рестарта app-server. | ≥0; S |
| `windows_wsl_setup_acknowledged` | `boolean` | Служебная отметка Windows onboarding; ключ есть в справочнике, но отсутствует в текущей схеме. | — |

<a id="realtime"></a>

## Realtime, cloud и orchestrator

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `audio` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `audio.microphone` | `string` | Строковая настройка выбора микрофона realtime voice; формат идентификатора в схеме не пояснён. | S |
| `audio.microphone_channel` | `integer / array<integer>` | Канал или массив каналов микрофона с нумерацией от 1; без настройки смешиваются все входные каналы. | ≥1; S |
| `audio.speaker` | `string` | Строковая настройка выбора устройства воспроизведения realtime voice; формат идентификатора в схеме не пояснён. | S |
| `cloud` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `cloud.skills` | `table` | Настройки облачных навыков; по схеме разрешены по умолчанию, но host должен предоставить cloud provider. | S |
| `cloud.skills.enabled` | `boolean` | Включает облачные навыки при наличии соответствующего provider. | S |
| `experimental_realtime_start_instructions` | `string` | Служебная экспериментальная замена стартовых realtime developer instructions; схема помечает «do not use». | S |
| `experimental_realtime_webrtc_call_base_url` | `string` | Служебный URL создания WebRTC realtime call по HTTP; не меняет WebSocket URL. Схема помечает «do not use». | S |
| `experimental_realtime_ws_backend_prompt` | `string` | Служебная замена инструкций realtime WebSocket-транспорта, без изменения обычных промптов; «do not use». | S |
| `experimental_realtime_ws_base_url` | `string` | Служебный URL realtime WebSocket `/v1/realtime`; не меняет обычный HTTP провайдера; «do not use». | S |
| `experimental_realtime_ws_model` | `string` | Служебная модель/snapshot realtime WebSocket; «do not use». | S |
| `experimental_realtime_ws_startup_context` | `string` | Служебная замена стартового контекста realtime; пустая строка отключает его добавление; «do not use». | S |
| `orchestrator` | `table` | Функции, которыми управляет orchestrator. | S |
| `orchestrator.mcp` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `orchestrator.mcp.enabled` | `boolean` | Включение MCP со стороны orchestrator; подробные условия применения в публичном справочнике не раскрыты. | S |
| `orchestrator.skills` | `table` | Старое поле без эффекта; вместо него применяется `cloud.skills`. | S |
| `orchestrator.skills.enabled` | `boolean` | Старое поле совместимости без эффекта; используйте `cloud.skills.enabled`. | S |
| `realtime` | `table` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. | S |
| `realtime.transport` | `"webrtc" / "websocket"` | Экспериментальный realtime-транспорт: WebRTC или WebSocket; родительская настройка помечена «do not use». | S |
| `realtime.type` | `"conversational" / "transcription"` | Экспериментальный режим realtime: разговор или транскрипция. | S |
| `realtime.version` | `"v1" / "v2" / "v3"` | Экспериментальная версия realtime pipeline; допустимые значения даны в типе. | S |
| `realtime.voice` | `"alloy" / "arbor" / "ash" / "ballad" / "breeze" / "cedar" / "coral" / "cove" / "echo" / "ember" / "juniper" / "maple" / "marin" / "sage" / "shimmer" / "sol" / "spruce" / "vale" / "verse"` | Экспериментальный выбор голоса realtime; допустимые имена даны в типе. | S |

<a id="desktop"></a>

## Desktop и обработчики файлов

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `desktop` | `table` | Служебная таблица desktop-настроек с открытой структурой; ниже перечислены публично описанные обработчики файлов. | S |
| `desktop.custom_file_handlers.<name>` | `table` | Пользовательский обработчик меню Open in desktop-приложения; поддерживается только в пользовательской конфигурации. | — |
| `desktop.custom_file_handlers.<name>.args` | `array<string>` | Аргументы обработчика перед входным файлом; стандартно пустой массив. | — |
| `desktop.custom_file_handlers.<name>.command` | `string` | Команда или путь исполняемого файла обработчика; обязательны. | — |
| `desktop.custom_file_handlers.<name>.icon` | `string` | Иконка: bundled asset, Base64 data URL, file URI или абсолютный путь; обязательна. При неподдерживаемом источнике используется иконка VS Code. | — |
| `desktop.custom_file_handlers.<name>.input` | `path \| json_argument \| json_stdin` | Передача входа: путь, JSON-аргумент или JSON через stdin; стандартно `path`. | — |
| `desktop.custom_file_handlers.<name>.label` | `string` | Отображаемое название обработчика Open in; обязательно. | — |
| `desktop.custom_file_handlers.<name>.supports_ssh` | `boolean` | Предлагать обработчик для SSH-workspace; стандартно `false`. | — |

<a id="legacy-profiles"></a>

## Legacy-профили

С Codex **0.134.0** используются отдельные `$CODEX_HOME/<name>.config.toml`, выбираемые через `--profile`. Старые ключи ниже сохранены в схеме, но современный CLI не использует их как механизм выбора профиля. [Миграция профилей](https://learn.chatgpt.com/docs/config-file/config-advanced#profiles).

| Параметр | Тип / допустимые значения | Описание | Default / ограничения |
|---|---|---|---|
| `profile` | `string` | Legacy-селектор `[profiles]`, оставшийся в схеме. С Codex 0.134.0 больше не поддерживается; используйте `--profile` с отдельным файлом. | S |
| `profiles` | `map<string, table>` | Legacy-профили внутри config.toml. С Codex 0.134.0 `--profile` их не читает; переносите в `$CODEX_HOME/<name>.config.toml`. | S |

### Поля старого `profiles.<name>` из схемы

Совпадающие поля используют описания корневых параметров. В legacy-профиле `tui` содержит **только `session_picker_view`**; полный корневой keymap сюда не переносится. Вложенные `features`, `tools`, `analytics`, `windows` и granular approval повторяют соответствующие структуры схемы.

| Путь в старом профиле | Описание |
|---|---|
| `profiles.<name>.analytics` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. |
| `profiles.<name>.approval_policy` | Политика запросов подтверждения: `on-request`, `never` или таблица `granular`. `untrusted` больше не поддерживается; `on-failure` устарел. Политика подтверждений сама не меняет права песочницы. |
| `profiles.<name>.approvals_reviewer` | Кто рассматривает запросы: `user` — пользователь, стандартный вариант; `auto_review` — специальный проверяющий агент. Права песочницы от этого не расширяются. |
| `profiles.<name>.chatgpt_base_url` | Базовый URL для потока ChatGPT login. |
| `profiles.<name>.experimental_compact_prompt_file` | Экспериментальный файл с промптом сжатия истории. |
| `profiles.<name>.experimental_use_unified_exec_tool` | Старое включение unified exec; предпочтителен `features.unified_exec`. |
| `profiles.<name>.features` | Централизованные переключатели функций. Табличные варианты и технические флаги перечислены отдельно. |
| `profiles.<name>.include_apps_instructions` | Добавлять developer-блок `<apps_instructions>`. |
| `profiles.<name>.include_collaboration_mode_instructions` | Добавлять developer-блок `<collaboration_mode>`. |
| `profiles.<name>.include_environment_context` | Добавлять пользовательский блок `<environment_context>`. |
| `profiles.<name>.include_permissions_instructions` | Добавлять developer-блок `<permissions instructions>`. |
| `profiles.<name>.model` | Модель для новых запусков; имя должно быть доступно вашей учётной записи или рабочему пространству. |
| `profiles.<name>.model_catalog_json` | Путь к JSON-каталогу моделей, читаемому при запуске; может переопределяться файлом выбранного профиля. |
| `profiles.<name>.model_instructions_file` | Файл, заменяющий встроенные инструкции модели. Это отдельный механизм от проектного `AGENTS.md`. |
| `profiles.<name>.model_provider` | Идентификатор провайдера; стандартное значение — `openai`. |
| `profiles.<name>.model_reasoning_effort` | Уровень reasoning, поддерживаемый моделью и клиентом; например `low`, `medium`, `high`, `xhigh`, `max`, `ultra`. |
| `profiles.<name>.model_reasoning_summary` | Детальность краткого описания reasoning: автоматически, кратко, подробно или без summary. |
| `profiles.<name>.model_verbosity` | Детальность текста ответа, если её поддерживают выбранные модель и API; без настройки используется стандарт модели/preset. |
| `profiles.<name>.oss_provider` | Локальный провайдер для `--oss`: LM Studio или Ollama; без значения Codex предлагает выбор. |
| `profiles.<name>.personality` | Стиль общения: `none`, `friendly`, `pragmatic`; действует для моделей с поддержкой personality и может переопределяться в сессии. |
| `profiles.<name>.plan_mode_reasoning_effort` | Переопределение reasoning для Plan mode; без него используется встроенный preset этого режима. |
| `profiles.<name>.sandbox_mode` | Режим песочницы для команд: только чтение, запись в рабочую область или полный доступ. |
| `profiles.<name>.service_tier` | Предпочтительный service tier. `fast` преобразуется в значение запроса `priority`; доступность других значений зависит от модели. |
| `profiles.<name>.tools` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. |
| `profiles.<name>.tui` | Настройки терминального интерфейса Codex. |
| `profiles.<name>.web_search` | Режим поиска: `disabled`, `cached` (стандартно), `indexed`, `live`. Cached использует индекс без внешнего web-доступа; indexed допускает внешнее получение через индекс; live разрешает live retrieval. При полном доступе стандарт может стать `live`. |
| `profiles.<name>.windows` | Таблица или набор структурированных настроек; вложенные поля перечислены в этом разделе. |
| `profiles.<name>.tui.session_picker_view` | Legacy-переопределение плотности списка resume/fork: `comfortable` или `dense`. |

## Границы справочника и обновление

Каталог объединяет **298 записей** таблицы `config.toml` официального справочника и поля схемы с **102 корневыми свойствами**. Одинаковые подструктуры обобщены шаблонами; в число 1014 входят контейнеры и совместимые старые названия. Legacy-профили дополнительно раскрыты отдельной таблицей.

В текущем срезе между схемой и текстом документации есть различия: например, справочник упоминает `model_supports_reasoning_summaries` и `windows_wsl_setup_acknowledged`, которых нет в опубликованной схеме. В обратную сторону схема содержит технические флаги без публичного описания. Оба случая отмечены; наличие записи не обещает работоспособность в каждой версии Codex.

Для обновления сверяйте Configuration Reference и JSON Schema вместе, затем страницы соответствующей возможности. Особое внимание требуется при изменении профилей, approval policies, permissions, MCP и experimental features. `requirements.toml` — самостоятельный административный формат; его отдельные поля здесь не смешиваются с `config.toml`.

SHA-256 использованного снимка JSON Schema:

```text
7933a70506e753a6e98c16800d2a76770b2af2b7295491f8f0b8e713e952027e
```

Примеры показывают синтаксис конфигурации. Сведения сверены со справочником и схемой; выполнение всех возможных комбинаций настроек не проверялось.
