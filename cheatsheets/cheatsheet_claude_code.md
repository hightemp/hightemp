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
