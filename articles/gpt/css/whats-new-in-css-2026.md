# Что нового в CSS за 2026 год: @scope, style queries и межбраузерные scroll-анимации

В 2026 году многие давно обсуждаемые возможности дошли до общей поддержки основных браузеров: `@scope`, container style queries, `field-sizing`, `shape()`, `contrast-color()` и функции подсчёта siblings. В октябре к ним присоединились scroll-driven animations и типизированная арифметика. [Baseline 2026](https://web.dev/baseline/2026), [октябрьские релизы браузеров](https://web.dev/blog/web-platform-10-2026)

Это **срез на 5 ноября 2026 года**, а не итог всего года. CSS не выпускается одной ежегодной редакцией: часть функций впервые реализована раньше, а новость 2026 года — завершение межбраузерной поддержки. Beta/flag-only возможности не представлены здесь как общедоступный минимум.

## `@scope`: правила внутри заданного поддерева

Вместо длинных селекторов с повторяющимся префиксом можно задать область и её нижнюю границу:

```html
<article class="article">
  <p><a href="/guide">Ссылка внутри статьи</a></p>
  <aside class="embedded-widget">
    <a href="/promo">Ссылка самостоятельного виджета</a>
  </aside>
</article>
```

```css
@scope (.article) to (.embedded-widget) {
  a {
    color: #1d4ed8;
    text-underline-offset: 0.2em;
  }

  :scope {
    padding: 1rem;
  }
}
```

Правило `a` применяется внутри `.article`, но не к `.embedded-widget` и его содержимому. `:scope` обозначает корень области. Нижнюю границу можно не задавать.

Scope не создаёт Shadow DOM и не запрещает наследование: `color` или `font-family`, заданные предку, могут наследоваться дальше границы. Прелюдия `@scope` сама не прибавляет специфичность дочернему селектору. При равных условиях каскада и специфичности учитывается близость scope; это не способ безусловно перебить более сильное правило. [@scope](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@scope)

## Style queries: компонент реагирует на custom property предка

Size queries проверяют размеры контейнера. Style query может проверить значение custom property:

```html
<section class="notice-host" style="--tone: warning">
  <div class="notice">До окончания подписки осталось три дня</div>
</section>
```

```css
.notice-host {
  container-name: notice;
  --tone: neutral;
}

.notice {
  border: 1px solid #cbd5e1;
  padding: 1rem;
  background: #f8fafc;
}

@container notice style(--tone: warning) {
  .notice {
    border-color: #a16207;
    background: #fef3c7;
  }
}
```

Проверяется подходящий именованный **предок**, а стиль применяется к потомку. Для style query custom properties не требуется объявлять `container-type: inline-size`: такой тип нужен для size query, а не для этого примера.

Наличие style queries не означает, что браузер умеет сравнивать любое произвольное CSS-свойство. Подтверждённая здесь общая возможность — запросы custom properties. Для зарегистрированных свойств имеют значение их computed values и правила наследования. [Size и style queries](https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Containment/Container_size_and_style_queries)

## `field-sizing: content`: поле растёт вместе с содержимым

```html
<label for="comment">Комментарий</label>
<textarea id="comment" class="comment" rows="4"></textarea>
```

```css
.comment {
  box-sizing: border-box;
  inline-size: 100%;
  min-block-size: 6rem;
  max-block-size: 18rem;
  overflow: auto;
  resize: vertical;
}

@supports (field-sizing: content) {
  .comment {
    field-sizing: content;
  }
}
```

Поле подстраивает preferred size под текст. При ограниченной ширине textarea растёт по высоте; достигнув максимума, показывает прокрутку. В неподдерживающем браузере остаётся обычная textarea.

`fixed` — обычное поведение, `content` — размер по содержимому. У textarea в режиме `content` атрибуты `rows`/`cols` больше не задают preferred size; размеры ограничивают CSS. У подходящих input аналогично теряет эту роль `size`, а placeholder тоже может влиять на размер.

Явная фиксированная высота способна помешать ожидаемому росту. Для input без min-width поле может сузиться практически до курсора. [field-sizing](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/field-sizing)

## `contrast-color()`: выбрать чёрный или белый текст

```css
.label {
  --label-background: #ffdb7a;
  background: var(--label-background);
  color: #000000;
}

@supports (color: contrast-color(red)) {
  .label {
    color: contrast-color(var(--label-background));
  }
}
```

Функция принимает цвет и возвращает **black либо white** с большим контрастом относительно него. Она не генерирует произвольный акцентный цвет и не подбирает целую доступную палитру.

Для полупрозрачного фона, изображения или градиента нужно учитывать фактический фон после композиции. Алгоритмический выбор одного из двух цветов не заменяет оценку читаемости мелкого текста, состояния focus и остальных требований доступности. [contrast-color()](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/color_value/contrast-color)

## `shape()`: геометрия, которая зависит от размеров элемента

`path()` задаёт SVG-подобную строку пути. `shape()` позволяет выражать контур CSS-значениями, включая проценты, `calc()` и custom properties:

```css
.banner {
  --wave: 2rem;
  min-block-size: 12rem;
  background: #dbeafe;
  clip-path: polygon(0 0, 100% 0, 100% 90%, 0 100%);
}

@supports (clip-path: shape(from 0 0, line to 100% 0, line to 0 100%, close)) {
  .banner {
    clip-path: shape(
      from 0 0,
      line to 100% 0,
      line to 100% calc(100% - var(--wave)),
      curve to 0 calc(100% - var(--wave)) with 50% 100%,
      close
    );
  }
}
```

`from` задаёт начальную точку; `line to` — прямой сегмент, `curve to ... with ...` — кривую с управляющей точкой, `close` замыкает контур. Есть дополнительные команды для дуг, относительных и других сегментов.

Такой контур следует размерам баннера. Обрезка затрагивает отображаемое содержимое, поэтому важный текст и focus outline не стоит бездумно помещать в обрезаемую часть. Первые реализации относятся к 2025 году, а межбраузерный milestone — к 2026-му. [shape()](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/basic-shape/shape)

## `sibling-index()` и `sibling-count()`: позиция без атрибута из шаблона

```html
<ul class="palette">
  <li>Один</li>
  <li>Два</li>
  <li>Три</li>
</ul>
```

```css
.palette > li {
  background: #dbeafe;
}

@supports (background: hsl(calc((sibling-index() - 1) * 360 / sibling-count()) 60% 85%)) {
  .palette > li {
    background: hsl(
      calc((sibling-index() - 1) * 360 / sibling-count()) 60% 85%
    );
  }
}
```

Обе функции не принимают аргументов. `sibling-index()` возвращает позицию элемента, начиная с **1**; `sibling-count()` — количество соседних элементов **включая сам элемент**. Формула равномерно распределяет hues по цветовому кругу.

Считаются элементы DOM, а не только `.palette > li`: добавленный сосед другого типа тоже влияет на результат. Текстовые узлы не считаются, а `display: none` сам по себе не удаляет элемент из порядка siblings. Это не аналог `:nth-child(... of selector)` с фильтром. [sibling-index()](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/sibling-index), [sibling-count()](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/sibling-count)

## Scroll-driven animations: общий milestone в октябре

В октябре Firefox 159 включил поддержку по умолчанию, и основная группа scroll-driven animations достигла Baseline. Теперь прогресс анимации можно привязать к прокрутке, а не к прошедшему времени. [Релизное подтверждение](https://web.dev/blog/web-platform-10-2026)

```html
<div class="reading-progress" aria-hidden="true"></div>
```

```css
.reading-progress {
  display: none;
}

@keyframes reading-progress {
  from { transform: scaleX(0); }
  to { transform: scaleX(1); }
}

@supports (animation-timeline: scroll()) {
  @media (prefers-reduced-motion: no-preference) {
    .reading-progress {
      display: block;
      position: fixed;
      inset: 0 0 auto;
      block-size: 0.25rem;
      background: #2563eb;
      transform-origin: left;
      animation: reading-progress linear both;
      animation-timeline: scroll(root block);
      z-index: 10;
    }
  }
}
```

`scroll(root block)` связывает timeline с блочной прокруткой корневого scroll container. `view()` описывает другой случай: движение элемента через его scrollport. Именованные timelines можно объявлять через `scroll-timeline` и `view-timeline`.

`animation-timeline` стоит **после** `animation`, потому что shorthand сбрасывает timeline. Одного Baseline-статуса группы недостаточно для любых расширений: ranges, новые selectors и более сложные комбинации проверяют отдельно. Эффект не должен быть единственным источником важной информации. [animation-timeline](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/animation-timeline)

## Типизированная арифметика: из двух длин получить число

В 2026 году общей стала поддержка деления совместимых типизированных величин:

```css
.headline {
  font-size: clamp(1.5rem, 3vw, 3rem);
}

@supports (font-size: calc((100vw / 1px) * 1rem)) {
  .headline {
    --viewport-pixels: calc(100vw / 1px);
    font-size: clamp(1.5rem, calc(var(--viewport-pixels) * 0.002rem), 3rem);
  }
}
```

`100vw / 1px` возвращает число CSS-пикселей ширины viewport без единицы. Умножив число на другую единицу, можно получить значение нужного типа. Это не количество физических пикселей дисплея.

Типы всё равно должны согласовываться: свойство размера не принимает квадрат длины, а деление на несовместимую величину не становится осмысленным только от наличия `calc()`. [Typed arithmetic](https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Values_and_units/Using_typed_arithmetic)

## `progress()` и `alpha()`: ещё две полезные функции

`progress(value, start, end)` вычисляет относительную позицию значения:

```css
.preview {
  --position: progress(30, 0, 100); /* 0.3 */
  --full: progress(150, 0, 100);   /* 1: по умолчанию результат ограничен */
}
```

Результат — `<number>`, обычно от 0 до 1. Все три аргумента должны иметь совместимый тип; допускаются вычисления. В актуальном синтаксисе есть необязательный `no-clamp` перед первым аргументом, без запятой после него. Поддержку этого дополнения нужно сверять отдельно от базовой функции. [progress()](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/progress)

`alpha()` изменяет прозрачность, сохраняя цветовые каналы:

```css
.swatch {
  --brand: oklch(65% 0.17 250 / 0.8);
  background: alpha(from var(--brand) / calc(alpha * 0.5));
}
```

Итоговая alpha здесь `0.4`. После `from` передаётся исходный цвет; после `/` — новая alpha или выражение с исходным `alpha`. Другие каналы через эту функцию не редактируются. Обе базовые функции достигли Baseline в сентябре 2026 года. [alpha()](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/color_value/alpha)

## Остальные изменения: не смешивать готовность разных возможностей

| Возможность | Состояние и смысл на дату статьи |
| --- | --- |
| `:open` | Baseline 2026: выбор элементов с поддерживаемым открытым состоянием; не эквивалент `:popover-open` |
| Custom Highlight API + `::highlight()` | Общая поддержка в 2026; ranges регистрируются JavaScript, CSS задаёт оформление |
| `light-dark()` для изображений | Отдельное дополнение 2026 года к цветовой форме функции |
| `rcap`, `rch`, `rex`, `ric` | Единицы по метрикам **корневого** шрифта |
| `text-indent: hanging / each-line` | Дополнительное управление отступами строк |
| `image-rendering: crisp-edges` | Межбраузерное расширение управления масштабированием изображений |
| `random()` | Новые реализации в стабильных браузерах, но общей поддержки всех основных движков ещё нет |
| `margin-trim` | Развитие реализаций, не общий Baseline-минимум |
| `@supports at-rule(...)` | Более точная проверка at-rules, с собственной ограниченной поддержкой |
| Grid lanes | Развивающийся layout; синтаксис и совместимость нужно проверять, это не универсальный готовый masonry |

Последние четыре строки нельзя считать обещанием одинакового поведения во всех браузерах. Для новых функций типичный набор — простой base style, точечная проверка и контроль реальной матрицы поддержки. [Обзор октября](https://web.dev/blog/web-platform-10-2026)

## Откуда взяты даты поддержки

Даты сверены с MDN, web.dev и [WebDX web-features](https://github.com/web-platform-dx/web-features), включая [снимок данных версии 3.45.0](https://unpkg.com/web-features@3.45.0/data.json). `baseline_low_date` обозначает достижение Newly available, а не год первой реализации или публикации спецификации. Данные обзорной страницы web.dev могут обновляться с задержкой относительно свежего браузерного релиза.

Newly available описывает актуальные основные браузеры; Widely available — прохождение дополнительных 30 месяцев. Корпоративный браузер старой версии, WebView и встроенный браузер приложения требуют отдельного внимания. `@supports` проверяет распознавание синтаксиса и не заменяет проверку поведения.

## Источники и остальные статьи

- [Baseline 2026](https://web.dev/baseline/2026).
- [Новое в стабильных браузерах в октябре 2026](https://web.dev/blog/web-platform-10-2026).
- [CSS Conditional Rules](https://drafts.csswg.org/css-conditional-5/) — container queries.
- [CSS Scroll-driven Animations](https://drafts.csswg.org/scroll-animations-1/).
- [Как определяется Baseline](https://web.dev/baseline).

Другие обзоры серии: [2023](whats-new-in-css-2023.md), [2024](whats-new-in-css-2024.md), [2025](whats-new-in-css-2025.md).
