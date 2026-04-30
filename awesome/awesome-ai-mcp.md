### Коллекции и каталоги

- https://github.com/punkpeye/awesome-mcp-servers
- https://github.com/punkpeye/awesome-mcp-clients
- MCP.so — каталог и поисковик по популярным MCP-серверам. https://mcp.so/
- MCP Market — каталог MCP-серверов и смежных инструментов. https://mcpmarket.com/
- https://glama.ai/mcp/servers
- https://www.mcp.pizza/
- Smithery — платформа и каталог для подключения и публикации MCP-серверов. https://smithery.ai/
- AWS Labs MCP — набор специализированных MCP-серверов для AWS. https://github.com/awslabs/mcp
- Официальная коллекция серверов MCP. https://github.com/modelcontextprotocol/servers

### Платформы, хабы и интеграции

- GitMCP — превращает GitHub-репозиторий в remote MCP endpoint для Claude, Cursor, Windsurf, VS Code и других клиентов. https://gitmcp.io/
- Context7 — сервис и MCP-сервер с актуальной документацией и примерами кода для библиотек и API. https://context7.com/
- Toolbox by Smithery — сервер/хаб интеграций, который дает агентам доступ к тысячам сервисов через единый MCP-интерфейс. https://smithery.ai/server/@smithery/toolbox
- CopilotKit MCP — гайд и компоненты для подключения своего приложения к любому MCP-серверу. https://docs.copilotkit.ai/learn/connect-mcp-servers
- MCP Studio — инструмент для создания, тестирования и публикации собственных MCP-плагинов/серверов. Ссылка из списка сейчас выглядит нестабильной. https://mcp.getflow.dev/
- Mcpify.ai — no-code платформа для создания MCP-серверов; на сайте есть предупреждение о закрытии сервиса. https://mcpify.ai/

### Серверы MCP

- API и сервисы
    - OpenAPI MCP Server — подключение HTTP/REST API через OpenAPI 3 spec. https://github.com/snaggle-ai/openapi-mcp-server
    - Docker MCP — управление контейнерами Docker через MCP. https://github.com/QuantGeekDev/docker-mcp
    - Postman MCP Server — работа с Postman API, коллекциями и окружениями. https://github.com/delano/postman-mcp-server
    - Exa MCP Server — веб-поиск, code search и research через Exa. https://github.com/exa-labs/exa-mcp-server
- Браузер, десктоп и UI-автоматизация
    - Playwright MCP — официальный MCP-сервер Microsoft для браузерной автоматизации через structured accessibility snapshots. https://github.com/microsoft/playwright-mcp
    - mcp-playwright — MCP-сервер на Playwright для browser automation и web scraping. https://github.com/executeautomation/mcp-playwright
    - Browser MCP — инструмент для автоматизации браузера и рутинных действий через MCP. https://browsermcp.io/
    - Midscene MCP — MCP-сервис Midscene для автоматизации веб-интерфейсов и UI-взаимодействий. https://midscenejs.com/mcp
    - Chrome DevTools MCP — сервер для интеграции с Chrome DevTools Protocol и отладки веб-приложений. https://github.com/benjaminr/chrome-devtools-mcp
    - Computer Control MCP — управление мышью, клавиатурой, OCR и desktop automation через MCP. https://github.com/AB498/computer-control-mcp
    - Talk to Figma MCP — интеграция Cursor/Claude Code с Figma для чтения и изменения дизайна напрямую. https://github.com/grab/cursor-talk-to-figma-mcp
- Память, код и контекст
    - OpenMemory — единый memory layer для Cursor, Claude, Windsurf и других MCP-клиентов. https://github.com/mem0ai/mem0/tree/main/openmemory
    - Claude Context — MCP-плагин/сервер для semantic code search, который подаёт релевантный контекст из большой кодовой базы в Claude Code, Codex CLI, Gemini CLI, Cursor, Cline, Roo Code и другие AI coding agents; хранит индекс в Milvus/Zilliz и помогает не грузить целые директории в контекст модели на каждый запрос. https://github.com/zilliztech/claude-context
    - claude-context-local — 100% локальная альтернатива Claude Context для semantic code search через MCP: использует EmbeddingGemma и FAISS, не требует API-ключей и облачной векторной БД, хранит embeddings и индекс на машине пользователя и даёт privacy-first codebase context для Claude Code. https://github.com/FarhanAliRaza/claude-context-local
- Безопасность
    - HexStrike AI — MCP-фреймворк для пентеста и security automation с 150+ инструментами и автономными агентами. https://github.com/0x4m4/hexstrike-ai

### Инструменты разработки

- MCP Inspector — официальный инструмент для тестирования и отладки MCP-серверов. https://github.com/modelcontextprotocol/inspector

### Курсы

- Hugging Face MCP Course — официальный курс по MCP с практикой и сертификацией. https://huggingface.co/learn/mcp-course/unit0/introduction
- Model Context Protocol (MCP) Curriculum for Beginners — вводный open-source курс Microsoft с примерами на C#, Java, JavaScript, Rust, Python и TypeScript. https://github.com/microsoft/mcp-for-beginners



### Статьи

- Основное
    - API для LLM: разбираем по пунктам, как устроен и как работает протокол MCP https://habr.com/ru/companies/bitrix/articles/965410/?ysclid=mi30eo9oju538844336
    - Model Context Protocol (MCP) – универсальный протокол для взаимодействия с ИИ, и почему это замечательно https://habr.com/ru/articles/899088/
    - Как работают серверы MCP: компоненты, логика и архитектура https://habr.com/ru/articles/925320/
    - Как обезопасить Spring AI MCP сервер с помощью OAuth2 https://habr.com/ru/companies/spring_aio/articles/901360/
    - Test a Remote MCP Server https://developers.cloudflare.com/agents/guides/test-remote-mcp-server/
