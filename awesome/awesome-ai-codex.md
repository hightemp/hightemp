
### Скилы

- justdoit — standalone Codex skill, который превращает сырую задачу в execution pack: сначала сканирует проект, затем создаёт `plans.md`, `status.md` и `test-plan.md`, держит шаги dependency-safe и validation-first, формулирует предложение по исполнению человеческим языком и ждёт подтверждения перед переходом в execution mode. Устанавливается через `$skill-installer` из `skills/justdoit` или копированием в `~/.codex/skills/`. https://github.com/serejaris/justdoit

### Статьи

- Основное
    - Как устроен Codex https://habr.com/ru/companies/ods/articles/1001012/
- Планирование долгих задач
    - Using PLANS.md for multi-hour problem solving — официальный гайд OpenAI Cookbook по `PLANS.md`/ExecPlans для многочасовых задач в Codex: как через `AGENTS.md` задать living plan, self-contained milestones, decision log, progress и проверяемые acceptance criteria. https://developers.openai.com/cookbook/articles/codex_exec_plans
