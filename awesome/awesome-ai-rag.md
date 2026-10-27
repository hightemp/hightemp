# Awesome AI RAG

Каталог инструментов для Retrieval-Augmented Generation (RAG) — дополнение моделей внешним контекстом.

### Визуальный (pixel-native) RAG

- PixelRAG — визуальный RAG «конец веб-скрейпинга»: вместо того чтобы превращать веб-страницу в текст и терять разметку, рендерит её в скриншот и читает ответ прямо с пикселей с помощью vision-language модели. Индексирует страницу «как её видит человек» — сохраняются таблицы, чарты, layout, инфографика, которые обычный текстовый парсинг выбрасывает. Пайплайн: рендер страницы/PDF/картинки в тайлы (`pixelshot`) → `Qwen3-VL-Embedding` (LoRA-дообучена на скриншотах) → FAISS-индекс → поиск по визуальному сходству. Работает от Berkeley SkyLab/BAIR/NLP (Matei Zaharia, Joseph Gonzalez, Sewon Min и др.), есть arXiv-статья. По бенчмарку авторов превосходит текстовый RAG до 18,1% по точности (в т.ч. на тексто-центричных NQ/SimpleQA, мультимодальном MMSearch, шумных новостях LiveVQA, агентном MoNaCo), а сжатие изображения даёт до 3x экономии токенов. Готовый hosted-индекс 8,28M/30M скриншотов Wikipedia (`api.pixelrag.ai`, без ключа), промо можно на `pixelrag.ai`. Есть Claude Code-плагин `pixelbrowse` («дай Клоду глаза»): вместо fetch'а DOM Клод скриншотит страницу и смотрит на изображение. `pip install pixelrag`, Apache-2.0. https://github.com/StarTrail-org/PixelRAG https://pixelrag.ai https://arxiv.org/abs/2606.28344

- PixelRAG (Rust port) — независимый порт визуального RAG на Rust на ANN-подложке ruvector (HNSW + IVF-Flat). https://github.com/ruvnet/rupixel