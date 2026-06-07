
### Коллекции

- https://github.com/VoltAgent/awesome-agent-skills
- https://playbooks.com/skills/
- https://lobehub.com/skills
- https://skillmd.ai/skills/
- https://skills.sh/
- https://github.com/vercel-labs/agent-skills

### Плагины

- Superpowers — agentic skills framework и методология разработки для coding agents, устанавливаемая как plugin/extension: набор composable skills и initial instructions, которые заставляют агента сначала уточнять задачу, формировать спецификацию, планировать реализацию, работать через git worktrees, TDD, subagent-driven development, code review и проверку завершения. Поддерживает Claude Code, Cursor, Codex, OpenCode, GitHub Copilot CLI и Gemini CLI. https://github.com/obra/superpowers

### Интсрументы для установки SKILL.md

- OpenSkills — универсальный CLI-загрузчик навыков (SKILL.md) для AI-агентов программирования (Claude Code, Cursor, Windsurf, Aider, Codex и др.), реализующий спецификацию Anthropic Agent Skills и позволяющий устанавливать, синхронизировать и загружать навыки из GitHub или локальных путей одной командой `npx openskills` https://github.com/numman-ali/openskills

### Скилы; SKILL.md

- Для разработки
    - Agent Skills — личная коллекция скилов Matt Pocock для планирования, разработки, TDD, triage, refactoring, GitHub workflow, pre-commit, Obsidian и написания новых skills. https://github.com/mattpocock/skills
    - Andrej Karpathy Skills — компактные guidelines/skill для Claude Code и Cursor по мотивам наблюдений Андрея Карпаты: думать перед кодингом, упрощать, делать точечные изменения и задавать проверяемые критерии успеха. https://github.com/forrestchang/andrej-karpathy-skills
    - Modern Web Guidance — официальный набор agent skills и CLI от Google Chrome/Edge для современных веб-интерфейсов: подмешивает в coding agents знания о Web Platform, совместимости браузеров, производительности, accessibility, CSS/layout, Forms/UI, security и built-in AI; ставится через `npx modern-web-guidance@latest install`, `npx skills add GoogleChrome/modern-web-guidance` или provider-плагины. https://developer.chrome.com/docs/modern-web-guidance https://github.com/GoogleChrome/modern-web-guidance
- Создание скилов
    - SkillOpt — Microsoft Research оптимизатор natural-language skills для frozen LLM agents: гоняет задачи, собирает trajectories/tool calls/verifier feedback, предлагает bounded edits, пропускает изменения через validation gates и экспортирует переиспользуемый `best_skill.md`; README заявляет best/tied-best результат во всех 52 evaluated cells и приросты для direct chat, Codex loop и Claude Code; есть CLI, WebUI, PyPI-пакет и MIT-лицензия. https://microsoft.github.io/SkillOpt/ https://github.com/microsoft/SkillOpt
- Промптинг
    - Prompt Master — Claude skill для генерации и улучшения промптов под разные AI-инструменты: определяет целевой инструмент, извлекает 9 измерений намерения (task, input, output, constraints, context, audience, memory, success criteria, examples), задаёт до 3 уточняющих вопросов, выбирает подходящий prompt framework, применяет safe techniques и делает token-efficiency audit. В README перечислены профили для Claude, ChatGPT/GPT-5.x, Gemini, Ollama/Qwen/local models, Claude Code, Cursor/Windsurf/Cline, Copilot, Devin/SWE-agent, Perplexity/SearchGPT, Midjourney/DALL-E/Stable Diffusion/ComfyUI, Sora/Runway, ElevenLabs, Zapier/Make/n8n и др. https://github.com/nidhinjs/prompt-master
- Проработка идей
    - grill-me — минималистичный скилл для жёсткого интервью по плану, идее или дизайну: задаёт вопросы по одному, проходит ветки решений до общего понимания и предлагает рекомендуемый ответ на каждый вопрос; если ответ можно найти в кодовой базе, сначала исследует проект. https://github.com/mattpocock/skills/tree/main/grill-me
- Маркетинг; SEO; CRO
    - seo-audit — скилл для технического и on-page SEO-аудита сайта: проверяет crawlability/indexation, robots.txt, sitemap, canonical/noindex, архитектуру, Core Web Vitals, мобильную пригодность, мета-теги, заголовки, контент и структурированные данные с учётом ограничений `web_fetch`/`curl`. https://github.com/coreyhaines31/marketingskills/tree/main/skills/seo-audit
    - page-cro — скилл для conversion rate optimization маркетинговых страниц: анализирует ценностное предложение, headline, CTA, визуальную иерархию, trust signals, social proof, возражения, friction points и выдаёт quick wins, high-impact changes, test ideas и варианты copy. https://github.com/coreyhaines31/marketingskills/tree/main/skills/page-cro
- Редактура
    - ru-text — плагин/скилл для качества русского текста в AI-ассистентах: типографика, инфостиль, редактура, UX writing и деловая переписка; поддерживает Claude Code, Codex CLI, Notion, Cursor, GitHub Copilot, Gemini CLI, OpenClaw и другие платформы, включает команды проверки и оценки текста. https://github.com/talkstream/ru-text
    - editorial-skill-for-natural-russian-business-writing — редакторская система для естественного русского делового письма: убирает нейрояз, канцелярит, карьерные штампы и синтетическую гладкость, сохраняя факты, намерение и профессиональный тон; включает правила, справочник паттернов, примеры, проверочные кейсы и адаптеры для Codex, Claude Code, ChatGPT и Gemini. https://github.com/ValentinAvramko/editorial-skill-for-natural-russian-business-writing
    - humanizer-ru — Claude/AI-agent skill для редактуры русскоязычного AI-текста: выявляет и исправляет 25 паттернов машинной генерации, включая канцелярит, рекламный язык, общие выводы, следы Markdown, избыток тире и неестественные конструкции; устанавливается через Claude.ai, Claude Code или `npx skills add`. https://github.com/Vladimir-Human/humanizer-ru
- Фактчекинг
    - fact-checker — скилл для системной проверки утверждений и источников: выделяет фактологические claims, определяет нужный уровень доказательств, ранжирует источники по надежности, выставляет verdict от TRUE до UNVERIFIABLE и предлагает корректную формулировку при ошибках или недостатке контекста. https://github.com/Shubhamsaboo/awesome-llm-apps/tree/main/awesome_agent_skills/fact-checker
- Генерация иконок
    - favicon
        - favicon https://lobehub.com/ru/skills/andrehfp-tinyplate-favicon
    - swift
        - How to Build swift-app-icons Agent Skill https://skillmd.ai/how-to-build/swift-app-icons/
    - Остальное
        - icon-generation skill https://playbooks.com/skills/michaelboeding/skills/icon-generation
        - app-icon-generator skill https://playbooks.com/skills/dexploarer/claudius-skills/app-icon-generator
        - app-icon-generator https://lobehub.com/ru/skills/dexploarer-claudius-skills-app-icon-generator
        - app-icon https://skills.sh/code-with-beto/skills/app-icon
- UI/UX
    - UI UX Pro Max https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
    - imagegen-frontend-web — скилл для генерации отдельных горизонтальных image references для секций лендингов и маркетинговых сайтов: задаёт Awwwards-level арт-дирекшен, композиционное разнообразие, единый visual system, full-bleed/background-image подходы и правило «одна секция — одно изображение». https://github.com/Leonxlnx/taste-skill/blob/main/skills/imagegen-frontend-web/SKILL.md
- PHP
    - Архитектура
        - PHP SOLID Architecture Guide https://mcpmarket.com/tools/skills/php-solid-architecture-guide
    - Остальное
        - Скил для обновления кода до php 8.* https://github.com/netresearch/php-modernization-skill
- Laravel
    - Рефакторинг
        - Laravel Code Refactorer https://mcpmarket.com/tools/skills/laravel-code-refactorer
