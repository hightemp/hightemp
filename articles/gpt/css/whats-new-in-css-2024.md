# Что нового в CSS за 2024 год: типизированные переменные, темы и transitions появления

В 2024 году межбраузерными стали `@property`, относительные цвета, `light-dark()`, `@starting-style` и `transition-behavior`. Продолжилось развитие anchor positioning и анимации размеров до `auto`, но эти возможности нельзя считать одинаково поддерживаемыми. [Baseline 2024](https://web.dev/baseline/2024)

CSS развивается отдельными модулями, поэтому год здесь означает важный этап внедрения или совместимости. Сведения сверены **5 ноября 2026 года**. В конце отдельно отмечены функции, которые появились в браузерных релизах 2024 года, но всё ещё требуют проверки поддержки.

## `@property`: у custom property появился контракт

Обычная custom property хранит последовательность CSS-токенов. Регистрация через `@property` задаёт тип, начальное значение и наследование:

```css
@property --angle {
  syntax: "<angle>";
  inherits: false;
  initial-value: 0deg;
}

.color-wheel {
  --angle: 0deg;
  background: conic-gradient(from var(--angle), #2563eb, #ec4899, #2563eb);
  animation: turn 6s linear infinite;
}

@keyframes turn {
  to { --angle: 360deg; }
}

@media (prefers-reduced-motion: reduce) {
  .color-wheel { animation: none; }
}
```

Браузер знает, что `--angle` является углом, и интерполирует значение. Без регистрации произвольная custom property не получает такую непрерывную анимацию сама по себе.

| Дескриптор | Смысл |
| --- | --- |
| `syntax` | Разрешённый тип, например `"<angle>"`, `"<color>"`, `"<length>"` или `"*"` |
| `inherits` | Наследуется ли значение потомками |
| `initial-value` | Начальное значение зарегистрированного свойства |

`syntax` и `inherits` обязательны. Для типизированного свойства нужен независимый от контекста `initial-value`: `10px` подходит, `2em` зависит от шрифта и не подходит. Исключение — `syntax: "*"`, где initial value можно не задавать.

Custom properties существовали задолго до 2024 года. Новость года — завершение основной межбраузерной поддержки **регистрации** свойств. [@property и его ограничения](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@property)

## Относительные цвета: получить вариант от существующего токена

`color-mix()` смешивает цвета, а relative color syntax позволяет прочитать каналы исходного цвета и изменить нужные:

```css
:root {
  --brand: #5273e8;
}

.button {
  background: #3b55b8;
}

@supports (color: oklch(from red l c h)) {
  .button {
    background: oklch(from var(--brand) calc(l - 0.08) c h);
  }
}
```

После `from` задаётся исходный цвет. Он переводится в выбранное пространство; `l`, `c`, `h` становятся его каналами. В примере светлота уменьшена, chroma и hue сохранены. Значение `l` внутри вычисления — число, поэтому используется `0.08`, а не механическое вычитание «8».

Можно менять RGB/HSL/OKLCH и alpha-канал. Это помогает строить производные design tokens, но формула сама не гарантирует контраст текста и одинаковый визуальный результат на любом экране. [Relative colors](https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Colors/Using_relative_colors)

## `light-dark()`: два значения под выбранную цветовую схему

```css
:root {
  color-scheme: light dark;
}

body {
  color: #202124;
  background: #ffffff;
  color: light-dark(#202124, #edf0f5);
  background: light-dark(#ffffff, #171a21);
}

html[data-theme="dark"] {
  color-scheme: dark;
}

html[data-theme="light"] {
  color-scheme: light;
}
```

Первый аргумент используется в светлой схеме, второй — в тёмной. При `color-scheme: light dark` браузер может учитывать предпочтение пользователя; явная схема на элементе позволяет переопределить выбор.

Функция не создаёт переключатель темы и не сохраняет его состояние. Она выбирает значение для уже определённой схемы. В этом разделе речь о **цветовой форме** `light-dark()`; поддержка изображений в этой функции — отдельное более позднее дополнение. [light-dark()](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/color_value/light-dark)

## `@starting-style`: старт для впервые показанного элемента

Обычный transition требует предыдущего состояния. У только что вставленного элемента или элемента, вышедшего из `display: none`, его может не быть. `@starting-style` задаёт стартовые значения:

```css
.notice {
  opacity: 1;
  translate: 0 0;
  transition: opacity 200ms, translate 200ms;
}

@starting-style {
  .notice {
    opacity: 0;
    translate: 0 0.5rem;
  }
}

@media (prefers-reduced-motion: reduce) {
  .notice { transition: none; }
}
```

При первом показе уведомление переходит от starting style к обычному стилю. Блок расположен после обычного правила намеренно: `@starting-style` сам не повышает специфичность и участвует в каскаде.

Это механизм **transitions**, а не обязательная часть `@keyframes`. Он не откладывает удаление DOM-узла: если приложение сразу вызвало `remove()`, CSS не сохраняет узел ради exit-эффекта. [@starting-style](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@starting-style)

## `transition-behavior`: переходы дискретных свойств

`display` не может плавно пройти промежуточные состояния между `block` и `none`. `allow-discrete` разрешает участвовать в transition дискретным свойствам:

```css
.notice {
  opacity: 1;
  transition: opacity 200ms;
  transition: opacity 200ms, display 200ms allow-discrete;
}

.notice.is-hidden {
  opacity: 0;
  display: none;
}
```

При скрытии `display` переключается в `none` в конце эффекта, а при показе — в видимое значение в начале. Для entry-перехода opacity дополнительно нужен `@starting-style` из предыдущего примера.

Это специальное поведение `display`/`content-visibility`; нельзя предполагать тот же момент переключения для любого дискретного свойства. `allow-discrete` также не означает плавную интерполяцию самого `display`. [transition-behavior](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/transition-behavior)

## Типографика: `text-wrap: balance`

```css
.hero-title {
  max-inline-size: 24ch;
  text-wrap: balance;
}
```

Браузер старается сбалансировать длину строк заголовка, чтобы не оставить одно короткое слово в последней строке. Это не выравнивание по ширине: межсловные пробелы не должны растягиваться как при `text-align: justify`.

`balance` подходит прежде всего небольшим текстовым блокам; движки ограничивают объём балансируемого текста. Для длинного текста существует `pretty`, но его поддержку проверяют **отдельно**: наличие `text-wrap` или `balance` не означает поддержку всех значений. [text-wrap](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/text-wrap)

## Управление полосой прокрутки и выравнивание block

Два свойства стали межбраузерно доступными в конце года:

```css
html {
  scrollbar-gutter: stable;
}

.log-window {
  overflow: auto;
  scrollbar-width: thin;
}
```

`scrollbar-gutter: stable` резервирует место для классической полосы прокрутки и помогает избежать сдвига ширины страницы при её появлении. Overlay-scrollbars могут не занимать такого места. `scrollbar-width` выбирает обычную/тонкую полосу или её отсутствие, а не точную ширину в пикселях. Скрытие полосы ухудшает обнаруживаемость прокрутки. [scrollbar-gutter](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/scrollbar-gutter)

`align-content` начал работать и в обычном block layout:

```css
.empty-state {
  min-block-size: 12rem;
  align-content: center;
}
```

Содержимое центрируется по блочной оси при наличии свободного пространства. Не нужно превращать каждый такой контейнер в Flexbox; для других задач Flex/Grid остаются полезными. [align-content](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/align-content)

## Anchor positioning: новое направление с отдельной проверкой поддержки

В 2024 году Chromium начал поставлять позиционирование одного элемента относительно другого. Ниже используется актуальное имя `position-area`; в ранних материалах встречается старое `inset-area`.

```html
<button class="help-button" popovertarget="help">Условия доставки</button>
<div id="help" class="help-popover" popover>
  Доставка занимает от двух до пяти дней.
</div>
```

```css
.help-popover {
  max-inline-size: min(20rem, calc(100vw - 2rem));
}

@supports (anchor-name: --help) and (position-area: bottom) {
  .help-button {
    anchor-name: --help;
  }

  .help-popover {
    position: fixed;
    position-anchor: --help;
    position-area: bottom;
    position-try-fallbacks: flip-block;
    inset: auto;
    margin: 0.5rem;
  }
}
```

`anchor-name` именует кнопку, `position-anchor` выбирает anchor, `position-area` задаёт область размещения, а `position-try-fallbacks` — альтернативу при нехватке места. Без anchor positioning остаётся стандартное позиционирование popover.

**Popover — HTML API**, а не новая CSS-директива. Его общий Baseline milestone относится к 2025 году. Поддержку anchor positioning, отдельных fallback-свойств и popover проверяют независимо; один `@supports` проверяет синтаксис, но не все нюансы поведения. [Anchor positioning](https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Anchor_positioning)

## Анимация до `auto`: ещё не универсальная возможность

В Chrome 129 появился `interpolate-size`:

```css
.expander {
  interpolate-size: allow-keywords;
  block-size: 0;
  overflow: clip;
  transition: block-size 250ms;
}

.expander.is-open {
  block-size: auto;
}
```

Он разрешает интерполяцию между числовым размером и поддерживаемым intrinsic-значением. Переход **между двумя intrinsic keywords** этим не включается. Свойство наследуется; лучше ограничить его нужным компонентом.

`calc-size()` нужен для вычислений с intrinsic-размером. Оба механизма на дату проверки остаются с ограниченной поддержкой. Пример показывает только изменение размера: семантика раскрытия, скрытие интерактивных потомков и управление фокусом решаются отдельно. [interpolate-size](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/interpolate-size)

## Другие изменения года

Межбраузерную поддержку получили `backdrop-filter`, `font-size-adjust`, `round()`/`mod()`/`rem()`, `paint-order`, `:state()` для custom elements, части настройки печатной страницы и вертикальных form controls. Cross-document View Transitions начали распространяться, но их готовность не совпадает с переходами внутри одного документа. [Обзор реализаций 2024](https://chrome.dev/css-wrapped-2024/)

## Источники и продолжение

- [Baseline 2024](https://web.dev/baseline/2024).
- [CSS Wrapped 2024](https://chrome.dev/css-wrapped-2024/) — также включает возможности с ограниченной поддержкой.
- [Спецификация регистрации custom properties](https://drafts.css-houdini.org/css-properties-values-api-1/).
- [WebDX web-features](https://github.com/web-platform-dx/web-features) — данные о совместимости.

Предыдущая статья — [CSS 2023](whats-new-in-css-2023.md), следующая — [CSS 2025](whats-new-in-css-2025.md).
