### MCP

```bash
claude mcp list         # список серверов
claude mcp get my-sse   # детали сервера
```

### Как добавить MCP

#### Подключить SSE

##### базовый синтаксис

```bash
claude mcp add --transport sse <имя> <URL>
```

##### пример с auth-заголовком

```bash
export API_TOKEN="ваш_токен"
claude mcp add --transport sse my-sse https://example.com/mcp/sse \
  --header "Authorization: Bearer ${API_TOKEN}"
```

#### подключить HTTP

##### базовый синтаксис

```bash
claude mcp add --transport http <имя> <URL>
```

##### пример с Bearer

```bash
export API_TOKEN="ваш_токен"
claude mcp add --transport http my-http https://example.com/mcp \
  --header "Authorization: Bearer ${API_TOKEN}"
```

#### через JSON

```bash
claude mcp add-json my-sse \
'{"type":"sse","url":"https://example.com/mcp/sse","headers":{"Authorization":"Bearer ${API_TOKEN}"}}'
```

### Кэш промптов и расход лимитов

Сверено с документацией **12 октября 2026 года**. Claude Code автоматически кеширует повторяющийся префикс запроса на стороне сервера. Кешированное чтение оплачивается дешевле, но продолжает расходовать токены. TTL — допустимый интервал между обращениями к кешу; попадание обновляет срок жизни записи. [Механизм prompt caching](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#how-prompt-caching-works).

#### Какой TTL используется по умолчанию

| Запросы | Подписка Claude, включённое использование | API-ключ, usage credits или cloud provider |
|---|---|---|
| Основной разговор, включая `-p` и Agent SDK | 1 час | 5 минут |
| Субагенты и другие вспомогательные запросы | Обычно 5 минут; отдельные server-controlled helpers получают 1 час | 5 минут |

Обычный субагент создаёт собственный кеш: его системный промпт отличается от родительского. Долгая пауза может потребовать повторной записи большого контекста. [TTL основного разговора и помощников](https://code.claude.com/docs/en/prompt-caching#which-ttl-each-request-gets).

#### Включить часовой кеш субагентов

Добавьте ключ в существующий `~/.claude/settings.json`:

```json
{
  "subagentPromptCacheTtl": "1h"
}
```

Для обеих групп запросов:

```json
{
  "promptCacheTtl": "1h",
  "subagentPromptCacheTtl": "1h"
}
```

`promptCacheTtl` управляет основным разговором; `subagentPromptCacheTtl` — запросами вне него, включая субагентов, workflows и compaction. Принимаются только `"5m"` и `"1h"`. Обе настройки требуют **Claude Code 2.1.242+**. [Выбор TTL](https://code.claude.com/docs/en/prompt-caching#choose-the-ttl-yourself).

Существующие ключи файла сохраняйте. Для настройки одного проекта доступны `.claude/settings.json` и личный `.claude/settings.local.json`. [Файлы и приоритет настроек](https://code.claude.com/docs/en/settings).

#### Через переменные окружения

```bash
# Основной разговор, в том числе при использовании API-ключа:
export CLAUDE_CODE_PROMPT_CACHE_TTL=1h

# Субагенты и прочие вспомогательные запросы:
export CLAUDE_CODE_SUBAGENT_PROMPT_CACHE_TTL=1h

claude
```

Для одного запуска с часовым кешем помощников:

```bash
CLAUDE_CODE_SUBAGENT_PROMPT_CACHE_TTL=1h claude
```

Переменная основного разговора **не меняет TTL субагентов**. Переменная соответствующей группы приоритетнее её JSON-настройки. `FORCE_PROMPT_CACHING_5M=1` принудительно выбирает 5 минут для обеих групп и имеет более высокий приоритет. Общая альтернатива `ENABLE_PROMPT_CACHING_1H=1` запрашивает час для обеих групп, но уступает индивидуальным настройкам TTL. [Переменные окружения](https://code.claude.com/docs/en/env-vars).

Через gateway доступность зависит от передачи `cache_control` и нужных заголовков; поддержка часового TTL у cloud providers зависит от модели и платформы. [Ограничения подключения](https://code.claude.com/docs/en/prompt-caching#choose-the-ttl-yourself).

#### Насколько запись дороже чтения

Коэффициенты ниже показывают **цену операций Claude API** относительно обычной цены входных токенов:

| Операция | Множитель базовой цены input |
|---|---|
| Запись с TTL 5 минут | `1.25×` |
| Запись с TTL 1 час | `2×` |
| Чтение, стандартный коэффициент | `0.1×` |
| Чтение на Opus 5.5 / Sonnet 5.5 | `0.05×` |
| Чтение на Fable 5.1 / Mythos 5.1 | `0.025×` |

Отсюда для одинакового объёма токенов:

- При чтении `0.1×` пятиминутная запись дороже чтения в **12,5 раза**, часовая — в **20 раз**.
- На Opus 5.5 / Sonnet 5.5 соотношения составляют **25** и **40 раз**.
- На Fable 5.1 / Mythos 5.1 — **50** и **80 раз**.
- Сама часовая запись стоит в **1,6 раза** дороже пятиминутной: `2 / 1.25`.

Поэтому `1h` полезен при повторном использовании префикса после пауз больше пяти минут. При короткой работе без таких пауз повышенная цена записи может увеличить расход. [Тарифы prompt caching](https://platform.claude.com/docs/en/about-claude/pricing#prompt-caching).

TTL отсчитывается **от начала запроса**, записавшего или прочитавшего кеш. Например, четырёхминутная генерация оставляет около минуты до истечения пятиминутной записи. Изменение кешируемого префикса также вызывает промах независимо от выбранного TTL. [Срок жизни и совпадение префиксов](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#how-prompt-caching-works).

#### Как проверить фактическую работу

1. Посмотрите версию через `claude --version`.
2. В `/usage` проверьте `Prompt cache (main)`: долю попаданий, промахи и фактический TTL. Эта строка доступна с **2.1.251** и относится только к основному разговору.
3. Для помощников смотрите их JSONL-транскрипты: `~/.claude/projects/{project}/{sessionId}/subagents/agent-{agentId}.jsonl`.

Поля usage:

| Поле | Значение |
|---|---|
| `cache_read_input_tokens` | Токены, прочитанные из кеша |
| `cache_creation_input_tokens` | Всего токенов, записанных в кеш |
| `cache_creation.ephemeral_5m_input_tokens` | Запись с пятиминутным TTL |
| `cache_creation.ephemeral_1h_input_tokens` | Запись с часовым TTL |

Если транскрипт содержит `message.usage`, вывести только счётчики можно так:

```bash
jq -c '
  select(.type == "assistant" and .message.usage != null)
  | {
      message_id: .message.id,
      timestamp: .timestamp,
      cache_read: .message.usage.cache_read_input_tokens,
      cache_write: .message.usage.cache_creation_input_tokens,
      cache_creation: .message.usage.cache_creation
    }
' '/путь/к/agent-AGENT_ID.jsonl'
```

`ephemeral_1h_input_tokens > 0` подтверждает часовую **запись**. При чистом попадании новые записи могут быть нулевыми. При суммировании логов учитывайте повторяющиеся записи одного `message.id`, чтобы не посчитать один ответ несколько раз. [Usage API](https://platform.claude.com/docs/en/build-with-claude/prompt-caching#tracking-cache-performance), [транскрипты субагентов](https://code.claude.com/docs/en/sub-agents#resume-subagents), [статистика `/usage`](https://code.claude.com/docs/en/costs#prompt-cache-statistics).

#### Кеш и размер контекста

Часовой TTL уменьшает повторные записи после пауз, но большой контекст продолжает перечитываться на каждом шаге. Полезно давать агенту ограниченную задачу, сокращать вывод команд и передавать следующему агенту краткий отчёт: результат, изменённые файлы, проверки и оставшиеся вопросы. Новый агент тоже создаёт свой кеш, поэтому частоту перезапусков выбирайте по фактическому расходу. [Управление контекстом](https://code.claude.com/docs/en/costs#manage-context-proactively).

Упомянутые **20–25%** — частная оценка автора кейса. Для Pro/Max API-оценка в долларах не равна счёту подписки: ориентируйтесь на plan usage и разбивку расхода по субагентам в `/usage`. [Учёт использования подписки](https://code.claude.com/docs/en/costs#using-the-usage-command).
