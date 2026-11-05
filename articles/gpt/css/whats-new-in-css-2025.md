# Что нового в CSS за 2025 год: View Transitions, нативные UI и программируемые значения

В 2025 году CSS продолжил забирать на себя задачи интерфейсной логики: браузеры получили новые способы стилизации элементов управления, а Chromium — `if()`, custom functions и расширенный `attr()`. Одновременно зрелее стала совместимость ранее появившихся возможностей: same-document View Transitions, `::details-content` и `content-visibility`. [Baseline 2025](https://web.dev/baseline/2025), [CSS Wrapped 2025](https://chrome.dev/css-wrapped-2025/)

Это обзор внедрения, а не ежегодной редакции CSS. Поддержка сверена **5 ноября 2026 года**. Важное различие: функция могла впервые появиться в браузере в 2025 году и до сих пор не стать Baseline. Такие случаи ниже выделены явно.

## View Transitions: переход между состояниями интерфейса

В 2025 году переходы **внутри одного документа** достигли Baseline. CSS задаёт оформление снимков, а JavaScript сообщает момент обновления DOM:

```html
<button id="theme-toggle">Сменить тему</button>
```

```css
:root {
  color: #202124;
  background: #ffffff;
}

:root.dark {
  color: #edf0f5;
  background: #171a21;
}

::view-transition-old(root),
::view-transition-new(root) {
  animation-duration: 180ms;
}

@media (prefers-reduced-motion: reduce) {
  ::view-transition-old(root),
  ::view-transition-new(root) {
    animation: none;
  }
}
```

```javascript
document.querySelector('#theme-toggle').addEventListener('click', () => {
  const update = () => document.documentElement.classList.toggle('dark');

  if (!document.startViewTransition ||
      matchMedia('(prefers-reduced-motion: reduce)').matches) {
    update();
    return;
  }

  document.startViewTransition(() => { update(); });
});
```

Браузер делает снимки до и после обновления и строит переход между ними. `view-transition-name` позволяет выделить отдельные элементы, но имя должно быть уникальным среди одновременно участвующих элементов.

Бизнес-обновление выполняется и без эффекта: отсутствие API не должно блокировать смену экрана. Междокументные переходы с `@view-transition { navigation: auto; }` — отдельная возможность с собственной матрицей поддержки. Baseline для переходов в одном документе не распространяется на неё автоматически. [View Transition API](https://developer.mozilla.org/en-US/docs/Web/API/View_Transition_API)

## `content-visibility`: пропускать ненужную работу рендеринга

В длинном документе браузеру не всегда нужно сразу подробно отрисовывать каждый раздел:

```css
.article-section {
  content-visibility: auto;
  contain-intrinsic-size: auto 45rem;
}
```

`auto` позволяет пропустить часть layout/paint-работы для удалённого от viewport содержимого, сохраняя его логическое присутствие в документе. `contain-intrinsic-size` предоставляет оценку размеров; вариант `auto` позволяет использовать запомненный размер после рендера.

Это не виртуализация DOM: узлы, JavaScript и загруженные данные остаются в памяти. Плохая оценка высоты может вызвать сдвиги прокрутки. Не следует применять свойство ко всему подряд или считать его способом надёжно скрыть секретное содержимое. [content-visibility](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/content-visibility)

## `::details-content`: оформление содержимого раскрывающегося блока

Для доступа к части `<details>`, которая раскрывается под `<summary>`, появился отдельный псевдоэлемент:

```html
<details class="faq">
  <summary>Можно ли вернуть товар?</summary>
  <p>Да, условия возврата описаны в договоре.</p>
</details>
```

```css
.faq > summary {
  cursor: pointer;
  font-weight: 600;
}

.faq::details-content {
  background: #f8fafc;
  padding-inline: 1rem;
}
```

Не нужно вводить дополнительную обёртку только ради оформления всей раскрываемой области. Само раскрытие и клавиатурное взаимодействие предоставляет HTML.

Для анимации высоты нужны дополнительные возможности, например `interpolate-size`, поддержка которых остаётся отдельным вопросом. `::details-content` не означает, что любая анимация accordion теперь работает везде. [Справочник ::details-content](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Selectors/::details-content)

## Типизированный `attr()`: HTML-атрибут как CSS-значение

Старый вариант `content: attr(data-label)` существовал давно. Новость 2025 года — чтение атрибутов с типами и использование в других свойствах:

```html
<div class="tiles" data-columns="3">
  <article>Первая карточка</article>
  <article>Вторая карточка</article>
  <article>Третья карточка</article>
</div>
```

```css
.tiles {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1rem;
}

@supports (grid-template-columns: repeat(attr(data-columns type(<integer>), 1), 1fr)) {
  .tiles {
    grid-template-columns:
      repeat(attr(data-columns type(<integer>), 1), minmax(0, 1fr));
  }
}
```

Аргументы: имя атрибута, необязательный тип/единица и fallback после запятой. `type(<integer>)` разбирает число; `attr(data-width px, 100px)` добавляет единицу к числовому атрибуту.

Fallback срабатывает при отсутствии или невозможности разобрать типизированное значение. Но `0` — корректный integer, хотя для `repeat()` он непригоден: предметные ограничения входных данных нужно учитывать отдельно. Тип `<url>` в `attr()` не разрешён.

На дату проверки расширенный `attr()` ещё не Baseline. Поддержка старого `content: attr(...)` не доказывает поддержку типизированной формы. [attr(): типы и ограничения](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/attr)

## `if()`: условие непосредственно в значении

В Chromium 137 появилась функция, выбирающая значение по CSS-условию:

```html
<div class="alert" style="--tone: danger">Не удалось сохранить данные</div>
```

```css
.alert {
  background: #eef2ff;
}

@supports (background: if(style(--tone: danger): #fee2e2; else: #eef2ff)) {
  .alert {
    background: if(
      style(--tone: danger): #fee2e2;
      else: #eef2ff;
    );
  }
}
```

Условия проверяются по порядку, возвращается первая подходящая ветка. `else` задаёт запасной результат. Доступны `style()`, `media()` и `supports()`; ветки отделяются **точкой с запятой**.

В `if()` style-условие относится к элементу, для которого вычисляется значение. Это отличается от `@container style(...)`, проверяющего подходящего предка.

Функция не выполняет произвольный JavaScript и не заменяет application state. На ноябрь 2026 года поддержка остаётся ограниченной, поэтому основной вид компонента задан отдельным правилом вне `@supports`. [if()](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/if)

## `@function`: собственная функция возвращает CSS-значение

В Chromium 139 появились custom functions:

```css
@function --space(--factor <number>: 1) returns <length> {
  result: calc(var(--factor) * 0.25rem);
}

.experimental-card {
  padding: --space(4);
}
```

Функция `--space(4)` возвращает `1rem`. Имя и параметры начинаются с `--`; параметр читается через `var()`. После двоеточия можно задать default, `returns` ограничивает тип результата, `result` определяет возвращаемое значение.

Это не Sass-mixin: функция возвращает значение, а не вставляет произвольный набор деклараций в селектор. Она вычисляется браузером и может использовать CSS-контекст.

Возможность по-прежнему ограниченно поддерживается. Пример предназначен для отдельной экспериментальной ветки стилей; если функция не поддержана или вернула неподходящий тип, использовать её результат для обязательной геометрии нельзя. [@function](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@function)

## `text-box`: точнее выравнивать текст по метрикам шрифта

```css
@supports (text-box: trim-both cap alphabetic) {
  .section-title {
    text-box: trim-both cap alphabetic;
  }
}
```

`text-box` объединяет `text-box-trim` и `text-box-edge`. В примере избыточные пространства по краям текстового блока подрезаются с ориентирами на cap height и alphabetic baseline. Это помогает визуально совмещать заголовки, изображения и границы карточек.

Свойство работает с метриками текстового блока и не является универсальной заменой `line-height`. Проверяйте разные шрифты, языки и многострочный текст. Межбраузерной поддержки всей группы на дату статьи ещё нет. [text-box](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/text-box)

## `corner-shape`: форма углов кроме обычного скругления

```css
.app-tile {
  border-radius: 2rem;
  background: #dbeafe;
}

@supports (corner-shape: squircle) {
  .app-tile {
    corner-shape: squircle;
  }
}
```

`border-radius` задаёт область угла, `corner-shape` — форму: `round`, `bevel`, `scoop`, `notch`, `squircle` и другие варианты. При нулевом radius новую форму угла не будет видно. В неподдерживающем браузере останутся обычные скругления. Первое распространение относится к Chromium 139, а не ко всем браузерам 2025 года. [corner-shape](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/corner-shape)

## Нативные компоненты: какая часть здесь действительно CSS

Обзор CSS/UI 2025 включает и HTML API. Их полезно различать:

| Возможность | Что относится к CSS и что нужно учитывать |
| --- | --- |
| Customizable `<select>` | `appearance: base-select`, `::picker(select)` и другие hooks оформления; поддержка ограничена |
| CSS carousel | `::scroll-button()` и `::scroll-marker` создают элементы навигации вокруг scroll container; не универсальная замена любого carousel |
| Scroll-state queries | `@container scroll-state(...)` реагирует на stuck/snapped/другие поддерживаемые состояния контейнера; нужно проверять конкретное состояние |
| `shape()` | Более выразительные адаптивные формы; межбраузерный milestone наступил в 2026 году |
| `sibling-index()` / `sibling-count()` | Появились в Chromium в 2025 году, а Baseline достигли в 2026-м |
| Popover | Это HTML API; его Baseline milestone пришёлся на 2025 год |
| Invoker commands / `closedby` | HTML-механизмы управления действиями/закрытием, а не CSS-функции |

Например, стилизуемый select включается так:

```css
@supports (appearance: base-select) {
  select,
  select::picker(select) {
    appearance: base-select;
  }

  select::picker(select) {
    border: 1px solid #94a3b8;
    border-radius: 0.75rem;
  }
}
```

За пределами поддерживающей ветки сохраняйте обычный `<select>` с label и option. Встроенные widgets всё равно нужно проверять с клавиатурой и assistive technologies. [Обзор CSS/UI 2025](https://chrome.dev/css-wrapped-2025/)

## Что ещё стало доступнее

В общий Baseline-набор 2025 вошли `abs()`/`sign()`, `print-color-adjust`, `scrollbar-color`, оформление spelling/grammar text decorations и `view-transition-class`. При этом последнее свойство оформляет группы transition-псевдоэлементов, а не создаёт переход без соответствующего API.

## Что учитывать при внедрении

Главная ошибка — воспринимать список новых Chrome-возможностей как список одинаково готовых web-стандартов. На дату проверки `if()`, `@function`, `corner-shape`, `text-box` и CSS carousel всё ещё нельзя считать общим минимумом всех основных браузеров.

Кроме того, fallback внутри новой функции не помогает браузеру, который **не знает саму функцию**. Используйте отдельный базовый стиль и корректную feature detection. Декларации с `var()` могут стать невалидными лишь при вычислении значения, поэтому предыдущая декларация того же свойства не во всех случаях спасает от ошибки.

## Источники и продолжение

- [Baseline 2025](https://web.dev/baseline/2025).
- [CSS Wrapped 2025](https://chrome.dev/css-wrapped-2025/).
- [Спецификация CSS Functions and Mixins](https://drafts.csswg.org/css-mixins-1/).
- [WebDX web-features](https://github.com/web-platform-dx/web-features) — текущие статусы отдельных возможностей.

Предыдущая статья — [CSS 2024](whats-new-in-css-2024.md), следующая — [CSS 2026](whats-new-in-css-2026.md).
