# Разобраться с запуском self-hosted LLM

Источник: https://lushbinary.com/blog/kimi-k2-6-self-hosting-guide-vllm-sglang-ktransformers/

Идея: понять, как поднимать self-hosted LLM в своём контуре и как выбирать стек serving под конкретную задачу.

Что разобрать:

- чем отличаются `vLLM`, `SGLang` и `KTransformers`
- какие требования к GPU / VRAM и как на них влияет `INT4` / `QAT`
- когда self-hosting имеет смысл относительно API
- что в статье привязано к `Kimi K2.6`, а что можно обобщить на другие open-source LLM
- как оформлять reasoning / `thinking` / `instant` режимы в production

Следующий шаг:

- после разбора вынести source-specific детали в `20-literature/`, а устойчивые выводы — в `30-permanent/`
