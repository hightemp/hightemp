
### Репозитории

- Every Code — community-driven fork OpenAI Codex CLI для терминала: добавляет Auto Drive, Auto Review, browser/CDP integration, multi-agent команды `/plan`, `/solve`, `/code`, темы, MCP, sandbox/approval modes и оркестрацию Claude Code, Gemini CLI, Qwen Code, Antigravity CLI и OpenAI-compatible провайдеров. https://github.com/just-every/code

### Субагенты

- Awesome Codex Subagents — коллекция 171+ Codex-native subagents в `.toml` для разработки, языков, инфраструктуры, QA/security, data/AI, DX, product/business и доменных задач; ставятся в `~/.codex/agents/` или `.codex/agents/`, модели и sandbox mode указаны в конфигурации агента. https://github.com/VoltAgent/awesome-codex-subagents

### Скилы

- justdoit — standalone Codex skill, который превращает сырую задачу в execution pack: сначала сканирует проект, затем создаёт `plans.md`, `status.md` и `test-plan.md`, держит шаги dependency-safe и validation-first, формулирует предложение по исполнению человеческим языком и ждёт подтверждения перед переходом в execution mode. Устанавливается через `$skill-installer` из `skills/justdoit` или копированием в `~/.codex/skills/`. https://github.com/serejaris/justdoit

### Статьи

- Основное
    - Как устроен Codex https://habr.com/ru/companies/ods/articles/1001012/
- Мультиагентная оркестрация
    - Multi-Agent Orchestration With Codex — практическое руководство по уровням оркестрации Codex: subagents внутри сессии, custom agents, batch fan-out, параллельные запуски через Git worktrees и `codex exec`, а также always-on workflow с Symphony; включает готовый сценарий параллельного ревью и веб-исследования через MCP. https://www.firecrawl.dev/blog/codex-multi-agent-orchestration
- Планирование долгих задач
    - Using PLANS.md for multi-hour problem solving — официальный гайд OpenAI Cookbook по `PLANS.md`/ExecPlans для многочасовых задач в Codex: как через `AGENTS.md` задать living plan, self-contained milestones, decision log, progress и проверяемые acceptance criteria. https://developers.openai.com/cookbook/articles/codex_exec_plans
