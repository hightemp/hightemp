
### Коллекции

- https://github.com/VoltAgent/awesome-agent-skills
- https://playbooks.com/skills/
- https://lobehub.com/skills
- https://skillmd.ai/skills/
- https://skills.sh/
- https://github.com/anthropics/skills
- https://github.com/vercel-labs/agent-skills
- design
    - bencium-marketplace A Claude Code plugin marketplace with 13 skills for design, architecture, and productivity by bencium.io. https://github.com/bencium/bencium-marketplace

### Плагины

- Superpowers — agentic skills framework и методология разработки для coding agents, устанавливаемая как plugin/extension: набор composable skills и initial instructions, которые заставляют агента сначала уточнять задачу, формировать спецификацию, планировать реализацию, работать через git worktrees, TDD, subagent-driven development, code review и проверку завершения. Поддерживает Claude Code, Cursor, Codex, OpenCode, GitHub Copilot CLI и Gemini CLI. https://github.com/obra/superpowers

### Интсрументы для установки SKILL.md

- OpenSkills — универсальный CLI-загрузчик навыков (SKILL.md) для AI-агентов программирования (Claude Code, Cursor, Windsurf, Aider, Codex и др.), реализующий спецификацию Anthropic Agent Skills и позволяющий устанавливать, синхронизировать и загружать навыки из GitHub или локальных путей одной командой `npx openskills` https://github.com/numman-ali/openskills

### Скилы; SKILL.md

- Для разработки
    - Agent Skills — личная коллекция скилов Matt Pocock для планирования, разработки, TDD, triage, refactoring, GitHub workflow, pre-commit, Obsidian и написания новых skills. https://github.com/mattpocock/skills
    - Andrej Karpathy Skills — компактные guidelines/skill для Claude Code и Cursor по мотивам наблюдений Андрея Карпаты: думать перед кодингом, упрощать, делать точечные изменения и задавать проверяемые критерии успеха. https://github.com/forrestchang/andrej-karpathy-skills
- Создание скилов
    - Skill Creator https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md
- Промптинг
    - Prompt Master — Claude skill для генерации и улучшения промптов под разные AI-инструменты: определяет целевой инструмент, извлекает 9 измерений намерения (task, input, output, constraints, context, audience, memory, success criteria, examples), задаёт до 3 уточняющих вопросов, выбирает подходящий prompt framework, применяет safe techniques и делает token-efficiency audit. В README перечислены профили для Claude, ChatGPT/GPT-5.x, Gemini, Ollama/Qwen/local models, Claude Code, Cursor/Windsurf/Cline, Copilot, Devin/SWE-agent, Perplexity/SearchGPT, Midjourney/DALL-E/Stable Diffusion/ComfyUI, Sora/Runway, ElevenLabs, Zapier/Make/n8n и др. https://github.com/nidhinjs/prompt-master
- Проработка идей
    - grill-me — минималистичный скилл для жёсткого интервью по плану, идее или дизайну: задаёт вопросы по одному, проходит ветки решений до общего понимания и предлагает рекомендуемый ответ на каждый вопрос; если ответ можно найти в кодовой базе, сначала исследует проект. https://github.com/mattpocock/skills/tree/main/grill-me
- Маркетинг; SEO; CRO
    - Claude Ads — Claude Code skill для аудита и оптимизации paid advertising: Google, Meta, YouTube, LinkedIn, TikTok, Microsoft и Apple Ads, 250+ проверок, weighted scoring, parallel subagents, industry templates, creative audit, budget review и генерация отчётов. https://github.com/AgriciDaniel/claude-ads
    - Toprank — open-source Claude Code skills для SEO, SEM и Google Ads: Search Console, Google Ads и CMS-интеграции, SEO-анализ, ads audit, диагностика просадки трафика, контент-рекомендации и workflow-команды `/toprank:*`. https://github.com/nowork-studio/toprank
    - seo-audit — скилл для технического и on-page SEO-аудита сайта: проверяет crawlability/indexation, robots.txt, sitemap, canonical/noindex, архитектуру, Core Web Vitals, мобильную пригодность, мета-теги, заголовки, контент и структурированные данные с учётом ограничений `web_fetch`/`curl`. https://github.com/coreyhaines31/marketingskills/tree/main/skills/seo-audit
    - page-cro — скилл для conversion rate optimization маркетинговых страниц: анализирует ценностное предложение, headline, CTA, визуальную иерархию, trust signals, social proof, возражения, friction points и выдаёт quick wins, high-impact changes, test ideas и варианты copy. https://github.com/coreyhaines31/marketingskills/tree/main/skills/page-cro
- Редактура
    - ru-text — плагин/скилл для качества русского текста в AI-ассистентах: типографика, инфостиль, редактура, UX writing и деловая переписка; поддерживает Claude Code, Codex CLI, Notion, Cursor, GitHub Copilot, Gemini CLI, OpenClaw и другие платформы, включает команды проверки и оценки текста. https://github.com/talkstream/ru-text
    - humanizer-ru — Claude/AI-agent skill для редактуры русскоязычного AI-текста: выявляет и исправляет 25 паттернов машинной генерации, включая канцелярит, рекламный язык, общие выводы, следы Markdown, избыток тире и неестественные конструкции; устанавливается через Claude.ai, Claude Code или `npx skills add`. https://github.com/Vladimir-Human/humanizer-ru
    - humanizer — скилл для Claude Code, который делает AI-сгенерированный текст более естественным: ищет 24 признака машинного стиля, включая раздувание значимости, рекламные формулировки, размытые ссылки на экспертов, шаблонные противопоставления, тройные перечисления, избыток тире, эмодзи, чат-штампы и общие выводы; помогает переписать текст без потери смысла. https://github.com/softaworks/agent-toolkit/tree/main/skills/humanizer
- Фактчекинг
    - fact-checker — скилл для системной проверки утверждений и источников: выделяет фактологические claims, определяет нужный уровень доказательств, ранжирует источники по надежности, выставляет verdict от TRUE до UNVERIFIABLE и предлагает корректную формулировку при ошибках или недостатке контекста. https://github.com/Shubhamsaboo/awesome-llm-apps/tree/main/awesome_agent_skills/fact-checker
- MCP
    - mcp-builder — официальный скилл Anthropic для проектирования и сборки MCP-серверов под внешние API и сервисы: ведёт через исследование API, выбор покрытия endpoint/workflow tools, реализацию на TypeScript/Python, тестирование через MCP Inspector и подготовку evals. https://github.com/anthropics/skills/tree/main/skills/mcp-builder
- Кибербезопасность
    - Claude-Red — коллекция из 38 offensive security skills для Claude Skills: готовые `SKILL.md` по SQLi, XSS, SSRF, SSTI, XXE, IDOR, file upload, RCE, JWT/OAuth, shellcode, EDR evasion, exploit development, OSINT, fuzzing и AI security; предназначены для red team, bug bounty и security research. https://github.com/SnailSploit/Claude-Red
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
- PHP
    - Архитектура
        - PHP SOLID Architecture Guide https://mcpmarket.com/tools/skills/php-solid-architecture-guide
    - Остальное
        - Скил для обновления кода до php 8.* https://github.com/netresearch/php-modernization-skill
- Laravel
    - Рефакторинг
        - Laravel Code Refactorer https://mcpmarket.com/tools/skills/laravel-code-refactorer

### Статьи

- Основное
    - Skills для Claude Code: огромный гайд от инженера Anthropic https://habr.com/ru/articles/1011524/
- PHP
    - Awesome Claude Code: AI-помощник для PHP-архитектора https://habr.com/ru/articles/994090/
- Подборки
    - Top 8 Claude Skills for UI/UX Engineers https://snyk.io/articles/top-claude-skills-ui-ux-engineers/
