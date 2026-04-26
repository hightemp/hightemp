# Open Claw

### Репозитории

- ClawRouter — agent-native LLM router для OpenClaw: маршрутизация запросов между 41+ моделями, OpenClaw plugin/security manifests, free/no-key режим для части моделей, smart routing/cost optimization и x402/USDC payments для автономных агентов. https://github.com/BlockRunAI/ClawRouter
- OpenClaw-RL — Apache-2.0 фреймворк для онлайн-обучения OpenClaw/agentic-моделей из живых взаимодействий: оборачивает self-hosted модель в OpenAI-compatible API, собирает next-state сигналы из ответов пользователя, tool outputs, terminal/GUI/SWE-сред и параллельно обновляет политику без остановки serving. Поддерживает Binary RL/GRPO, Hindsight-Guided OPD и combined method, LoRA, запуск на локальных GPU или через Tinker, а также scalable RL для terminal, GUI, SWE и tool-call агентов; в отчёте авторы показывают рост personalization score Qwen3-4B с 0.17 до 0.81 после 16 update steps и параллелизацию до 128 terminal environments. https://github.com/Gen-Verse/OpenClaw-RL https://arxiv.org/pdf/2603.10165 https://neurohive.io/ru/frameworki/openclaw-rl-ii-agent-kotoryj-obuchaetsya-s-podkrepleniem-v-processe-dialoga/
