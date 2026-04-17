
### Loops

- Repo Task Proof Loop https://github.com/DenisSergeevitch/repo-task-proof-loop

### Репозитории

- Агентные фреймворки
    - Agentic Orchestrator — готовый к production-использованию, агностический к модели фреймворк оркестрации многоагентных рабочих процессов разработки программного обеспечения, реализующий фиксированные цепочки задач (от написания спецификации до ревью кода) с поддержкой контрольных точек, валидации качества и возобновляемого выполнения через state.json https://github.com/gbFinch/agentic-orchestration
    - Get Shit Done (GSD) — lightweight meta-prompting, context engineering и spec-driven development system для coding agents, который борется с context rot через planning/context structure, XML prompt formatting, subagent orchestration, state management и quality gates. Ставится через `npx get-shit-done-cc@latest`, поддерживает Claude Code, OpenCode, Gemini CLI, Codex, Copilot, Cursor, Windsurf, Cline, Qwen Code и др.; для Claude Code 2.1.88+ устанавливается как skills (`skills/gsd-*/SKILL.md`), для старых версий — как slash commands. https://github.com/gsd-build/get-shit-done
    - Automagik Genie — локальный AI companion и MCP toolkit для Claude Code, Codex и других MCP-совместимых coding tools: принимает задачи на естественном языке, оркестрирует специализированных агентов, поддерживает параллельные workstreams и расширяется через markdown-агентов, spells, workflows и collectives. https://github.com/automagik-dev/genie
    - OwnPilot — privacy-first self-hosted платформа для личного AI-ассистента с автономными агентами: поддерживает OpenAI, Anthropic, Google, Zhipu, OpenRouter, Perplexity, Groq, Together, Fireworks, DeepInfra, Cerebras, fal.ai, любые OpenAI-compatible endpoints и локальные Ollama/LM Studio/LocalAI/vLLM; включает 250+ встроенных инструментов в 32 категориях, MCP client/server, Telegram и WhatsApp connectivity, browser automation, voice pipeline, personal data/memory, multi-agent crews, subagents, Claw agents с изолированными workspace и возможностью создавать sandboxed JavaScript tools во время работы. https://github.com/ownpilot/OwnPilot
    - Paperclip — open-source оркестратор для «zero-human companies»: Node.js сервер и React UI для управления командами AI-агентов, бизнес-целями, оргструктурами, бюджетами, governance, heartbeat-задачами, audit log и dashboard для контроля работы и затрат. https://github.com/paperclipai/paperclip
    - Phantom — open-source AI co-worker на Claude Agent SDK, которому выделяют отдельную VM/компьютер с Docker, shell-доступом, Qdrant/Ollama-памятью и MCP-сервером: агент работает через Slack/Telegram/Email/Webhook/CLI, ставит софт, поднимает базы и сервисы, строит дашборды/API/страницы, создаёт и сохраняет собственные MCP-инструменты, имеет encrypted credential collection, email identity, persistent memory и self-evolution после сессий через LLM-валидацию. При self-hosted запуске авторы рекомендуют выделенную VM, потому что Docker socket даёт контейнеру root-equivalent доступ к Docker daemon. https://github.com/ghostwright/phantom https://www.ghostwright.dev/phantom
- Worktree и изолированные окружения
    - agent-worktree — CLI для Git worktree workflow под AI coding agents: создаёт изолированные worktree для параллельной разработки, умеет `snap mode` для запуска `claude`, `codex` и других команд, затем помогает проверить изменения, смержить и очистить worktree. https://github.com/nekocode/agent-worktree
- Дизайн
    - Awesome DESIGN.md — коллекция готовых DESIGN.md-файлов с дизайн-системами популярных сайтов; файл можно положить в проект, чтобы coding agents генерировали UI в заданном стиле. https://github.com/VoltAgent/awesome-design-md/tree/main
    - AI Website Cloner Template — reusable Next.js 16/React 19/Tailwind v4/shadcn/ui шаблон для восстановления сайта в чистую кодовую базу через AI coding agents: команда `/clone-website` снимает скриншоты, извлекает дизайн-токены и ассеты, пишет спецификации компонентов, запускает параллельных builder-агентов и делает visual diff. Поддерживает Claude Code, Codex CLI, OpenCode, Copilot, Cursor, Windsurf, Gemini CLI, Cline, Roo Code, Continue, Amazon Q, Augment и Aider; использовать для своих сайтов, миграций, восстановления утраченного исходного кода или обучения. https://github.com/JCodesMore/ai-website-cloner-template
- Остальное
    - Inkeep Agents: Платформа для создания и управления ИИ-агентами, поддерживающая полную двустороннюю синхронизацию между визуальным конструктором без кода и TypeScript SDK для совместной работы технических и нетехнических специалистов. https://github.com/inkeep/agents
    - Vibe Kanban — локальная kanban-панель для планирования задач и запуска coding agents в отдельных workspaces с отдельной веткой, терминалом и dev-сервером; поддерживает ревью diff-ов с inline-комментариями, preview приложения и переключение между Claude Code, Codex, Gemini CLI, Amp и другими агентами. https://github.com/BloopAI/vibe-kanban

### Книги

- Agentic Engineering Patterns https://simonwillison.net/guides/agentic-engineering-patterns/

### Заметки

```
текущая фаза записана в PLAN.md;
активный шаг лежит в TODO.md;
выносить факты в EVIDENCE.md
решения - в DECISIONS.md
```
