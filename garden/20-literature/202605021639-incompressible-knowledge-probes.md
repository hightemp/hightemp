# Incompressible Knowledge Probes

Источник: https://arxiv.org/abs/2604.24827

PDF: https://arxiv.org/pdf/2604.24827

Автор: Bojie Li, Pine AI

Дата публикации: 2026-04-27

Версия: arXiv:2604.24827v1 [cs.LG]

Code: https://github.com/19PINE-AI/ikp

Companion: https://01.me/research/ikp

Дата обращения: 2026-05-02

## Ключевые идеи

- Статья предлагает оценивать скрытое число параметров закрытых LLM не через экономику инференса, а через фактическую ёмкость модели: сколько редких фактов она действительно хранит в параметрах и может воспроизвести без поиска.
- Главная гипотеза: reasoning и instruction-following можно сильнее сжимать, дистиллировать и улучшать архитектурой, а отдельные факты имеют энтропийную цену хранения. Поэтому длинный хвост фактов лучше отражает размер параметрической памяти модели, чем насыщенные reasoning-бенчмарки.
- `Incompressible Knowledge Probes` (`IKP`) - это набор из 1400 фактических вопросов в 7 уровнях редкости. Вопросы должны проверять именно stored factual knowledge, а не способность вывести ответ из общих правил.
- Автор калибрует лог-линейную зависимость между IKP score и total parameter count на 89 open-weight моделях от 135M до 1.6T параметров из 19 vendors. Получается сильная связь: `R2 = 0.917`.
- Для `Mixture-of-Experts` важнее total parameters, а не active parameters: total params лучше предсказывают фактическую ёмкость (`R2 = 0.79` против `0.51` для active params). Это логично, если знания распределены по полному набору экспертов, даже когда за один токен активируется только часть.
- На закрытые модели метод переносится как оценка effective knowledge capacity, а не как точное вскрытие реального raw parameter count. У safety-tuned моделей отказ отвечать на редкие вопросы может занижать оценку.
- Статья отдельно показывает, что hallucination/refusal profile может быть vendor signature: разные поставщики по-разному предпочитают отвечать неверно или отказываться на вопросах за пределами знания.
- Дополнительный результат: similarity wrong answers на редких фактах можно использовать как black-box fingerprint для различения weight-sharing siblings, post-training lineages и full retrains.

## Числа, которые стоит помнить

- 1400 factual probes, 7 tiers of obscurity.
- 89 open-weight calibration models, 188 evaluated models, 27 vendors.
- Leave-one-out validation: median fold error `1.59x`, `68.5%` моделей within `2x`, `87.6%` within `3x`.
- Оценки автора для frontier-моделей нужно читать как приближённые и условные: например, figure 1 даёт GPT-5.5 около `9.7T`, Claude Opus 4.6 около `5.3T`, Claude Sonnet 4.6 около `1.7T`, Gemini 2.5 Pro около `1.2T`.

## Ограничения

- Prediction interval широкий: примерно `3x` в каждую сторону, особенно выше 1T параметров, где мало open-weight anchor points.
- Safety tuning и refusal policy меняют score независимо от реального знания. Модель может знать факт, но отказаться отвечать, и тогда IKP даст нижнюю оценку.
- Retrieval augmentation может сломать интерпретацию: если модель отвечает через RAG или скрытый поиск, score уже не измеряет только parametric knowledge.
- Probe contamination остаётся риском: если конкретный набор вопросов попадёт в training data, результат будет завышен.
- Качество long-tail ground truth сложное: авторы отдельно аудировали Wikidata-based вопросы, потому что редкие факты часто страдают от устаревших, неоднозначных или спорных записей.
- Метод измеряет фактическую память, а не интеллект в целом. Хороший IKP score не означает лучшую reasoning-способность, coding ability или полезность в прикладной задаче.

## Что забрать в permanent notes

- Редкие фактические вопросы могут быть инструментом оценки параметрической памяти LLM, если исключить reasoning, retrieval и leakage.
- Оценки размера закрытых моделей через поведение API лучше называть оценками effective knowledge capacity, а не прямым измерением числа параметров.
- Для MoE-моделей знания могут масштабироваться с total parameters, даже если inference cost зависит от active parameters.
- Refusal policy и hallucination profile - это не шум вокруг оценки модели, а часть измеряемого поведения поставщика.
- Сатурация reasoning-бенчмарков не доказывает, что scaling перестал работать: возможно, они измеряют более сжимаемые способности, чем factual storage.

## Цитаты

- `Incompressible Knowledge Probes`
- `factual capacity`
- `refused but known`
- `effective knowledge capacity`

## Связи

- [Словарь терминов](../40-moc/glossary.md)
