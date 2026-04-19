### Коллекции

- A selectively curated list of skills, agents, plugins, hooks, and other amazing tools for enhancing your Claude Code workflow. https://github.com/hesreallyhim/awesome-claude-code

### Шпаргалки

- Claude Code Cheat Sheet - регулярно обновляемая шпаргалка по Claude Code: горячие клавиши, slash-команды, MCP-серверы, `CLAUDE.md`, workflows, конфигурация, env vars, skills, agents, CLI-флаги и permission modes; на странице указаны текущая версия Claude Code и дата обновления. https://cc.storyfox.cz/

### Репозитории

- Claude Code Orchestrator Kit — профессиональный набор автоматизации и оркестрации для Claude Code, превращающий его в «оркестратор» с 39 специализированными AI-агентами, библиотекой навыков и slash-командами, авто-оптимизированной конфигурацией MCP и опциональными интеграциями трекинга задач Beads и мультиагентного менеджера Gastown для длительных сессий без потери контекста. https://github.com/maslennikov-ig/claude-code-orchestrator-kit https://www.npmjs.com/package/claude-code-orchestrator-kit https://github.com/steveyegge/beads https://github.com/steveyegge/gastown
- OwnYourCode — набор протоколов и команд для AI-менторинга разработки, где ИИ обучает, задаёт вопросы и проводит ревью, но весь код пишет разработчик, чтобы результат был понятным, расширяемым и «своим». https://github.com/DanielPodolsky/ownyourcode
- CCPM (Claude Code Project Manager) — обвес для Claude Code, который разбивает PRD на эпики и задачи в GitHub Issues и запускает параллельный рой автономных агентов в отдельных Git worktree для синхронной разработки без конфликтов. https://github.com/automazeio/ccpm

### Плагины

- Awesome Claude Code — PHP Architecture Toolkit: плагин для Claude Code с slash-командами, агентами, skills и hooks для аудита, генерации и документирования PHP-кода в DDD, CQRS, Event Sourcing, Clean/Hexagonal Architecture, PSR, тестах и code review. https://github.com/dykyi-roman/awesome-claude-code

### Альтернативы и порты Claude Code

- OpenClaude — open-source coding-agent CLI в стиле Claude Code для облачных и локальных моделей: поддерживает OpenAI-compatible API, OpenRouter, DeepSeek, Groq, Mistral, Gemini, GitHub Models, Codex, Ollama, LM Studio и другие бэкенды; сохраняет terminal-first workflow с bash/file read/write/edit, grep/glob, агентами, задачами, MCP, slash-командами, web search/fetch, streaming output и входными изображениями у провайдеров с vision. Может работать как headless gRPC-сервис с bidirectional streaming для интеграции в CI/CD, кастомные UI и удалённые клиенты. https://github.com/Gitlawb/openclaude
- Claw Code — публичная Rust-реализация `claw` CLI agent harness: собирается из исходников, содержит canonical workspace в `rust/`, команды для prompt/session/config/parity workflows, health-check через `claw doctor`, поддержку API-ключей провайдеров, документацию по parity/roadmap и не заявляет аффилиации с Anthropic. https://github.com/ultraworkers/claw-code

### Token Optimization; Утилиты для экономии токенов

- rtk — CLI-прокси на Rust, сокращающий потребление токенов LLM на 60–90% за счёт фильтрации, группировки и дедупликации вывода команд (git, cargo, pytest, docker и др.). Поддерживает авто-перехват команд через PreToolUse-хук Claude Code. https://github.com/rtk-ai/rtk
- caveman — skill/plugin для Claude Code и Codex, который сжимает стиль ответов до телеграфного «caveman mode», уменьшая расход output tokens, ускоряя ответы и добавляя режимы terse review/commit и сжатия memory/context-файлов. https://github.com/JuliusBrussee/caveman

### Loops; Ralph

- Awesome Ralph https://github.com/snwfdhmp/awesome-ralph
- The Ralph Playbook https://github.com/ClaytonFarr/ralph-playbook
- Choo Choo Ralph https://github.com/mj-meyer/choo-choo-ralph

### Workflow

- claude-code-workflows — набор плагинов для Claude Code, реализующий сквозные рабочие процессы AI-ассистируемой разработки (бэкенд, фронтенд, полный стек) с разделением на специализированных агентов для формулирования требований, проектирования, реализации и проверки качества. https://github.com/shinpr/claude-code-workflows

### Карьера; Job Search

- Career-Ops — open-source система поиска работы на базе Claude Code: slash-команда `/career-ops` с 14 режимами для оценки вакансий, сканирования job boards и career pages, генерации ATS-оптимизированных PDF-резюме под конкретную вакансию, batch processing, заполнения анкет, подготовки к интервью и TUI-dashboard для трекинга pipeline. https://github.com/santifer/career-ops

### Skills; Скилы

- avoid-ai-writing — скилл для Claude Code и OpenClaw, который анализирует текст на 36 типовых признаков AI-стиля и поддерживает два режима: аудит с пометкой подозрительных паттернов и рерайт для удаления найденных шаблонов. https://github.com/conorbronsdon/avoid-ai-writing
- Deep Research for Claude Code — скилл для анализа папок с документами (PDF, Word, PPTX и др.), извлечения текста, таблиц и координат элементов и генерации HTML-отчётов с проверяемыми ссылками на источники и расположение цитат в исходных файлах. https://github.com/jerryjliu/liteparse_samples
- last30days — skill/plugin для Claude Code и OpenClaw: команда `/last30days <тема>` запускает AI-agent search по Reddit, X/Twitter, YouTube, TikTok, Instagram, Hacker News, Polymarket, GitHub, Bluesky, Perplexity/web и другим источникам за последние 30 дней, ранжирует сигналы по engagement/ставкам/релевантности, объединяет повторы между платформами и синтезирует brief с источниками, цитатами и “Best Takes”. В zero-config режиме сразу работают Reddit comments, Hacker News, Polymarket и GitHub; X, YouTube, Bluesky, TikTok/Instagram/Threads/Pinterest и Perplexity подключаются через браузерные сессии, локальные утилиты или API-ключи. https://github.com/mvanhorn/last30days-skill

### Память

- Claude-Mem — plugin/SDK для постоянной памяти Claude Code, Gemini CLI, OpenCode и OpenClaw: автоматически собирает tool usage observations из сессий, сжимает их в семантические summaries и подмешивает релевантный контекст в будущие сессии; включает skill-based search, web viewer, privacy-теги и установку через `npx claude-mem install` или Claude Code plugin marketplace. https://github.com/thedotmack/claude-mem
- MemPalace — локальная open-source система долгосрочной памяти для Claude Code: ставится как Claude plugin, индексирует диалоги и проектные данные в ChromaDB без облака, организует память по принципу «дворца памяти» (wings/rooms/drawers), поддерживает семантический поиск, MCP-интеграцию и экспериментальную AAAK-компрессию; авторы заявляют 96.6% LongMemEval R@5 в raw mode. https://github.com/milla-jovovich/mempalace

### Статьи

- Основное
    - Что вы не знали о Claude Code: архитектура, управление и инженерные практики https://habr.com/ru/articles/1012412/
    - Claude Code: практический гайд по настройке, автоматизации и работе с контекстом https://habr.com/ru/articles/987094/
    - Проблема не в промпте: как Claude Code плывет на длинных задачах и как управлять контекстом https://habr.com/ru/articles/1004994/
    - LLM — не один большой «мозг», а команда ролей. Как собрать AI-workflow в Claude Code и уйти от вайб-коддинга https://habr.com/ru/articles/974924/
- Workflow
    - Как я перестал бояться Claude Code и научил его не ломать мои проекты https://habr.com/ru/articles/1013330/
- PHP
    - Awesome Claude Code: AI-помощник для PHP-архитектора https://habr.com/ru/articles/994090/ https://web.archive.org/web/20260216023741/https://habr.com/ru/articles/994090/
