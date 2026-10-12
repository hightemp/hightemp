# Чем заменить Moment.js: сравнение Day.js, date-fns, Luxon, Temporal и Intl

Moment.js часто оказывается в проекте ради нескольких операций: показать дату, прибавить месяц, разобрать строку из формы или вывести «три минуты назад». Сегодня для этих задач есть несколько подходов. Одни сохраняют привычные цепочки методов, другие работают с обычным `Date`, а Temporal предлагает отдельные типы для разных значений времени.

В этой статье сравним **Day.js, date-fns, Luxon, Temporal, js-joda и встроенный Intl**, посмотрим примеры и разберём ошибки при миграции.

**Срез информации — 12 октября 2026 года.** Примеры используют API Day.js 1.x, date-fns 4.x и Luxon 3.x. JavaScript-код с `import` рассчитан на ESM: сборщик либо Node.js с расширением `.mjs` или `"type": "module"` в `package.json`. Каждый пример рассматривается отдельно; устанавливать все библиотеки сразу не требуется.

## Короткий ответ: что выбрать

| Задача | С чего начать выбор |
|---|---|
| Показать дату из API на языке пользователя | `Intl.DateTimeFormat` |
| Вывести «5 минут назад», когда число и единица уже вычислены | `Intl.RelativeTimeFormat` |
| Перенести много привычного Moment-кода с цепочками методов | Day.js |
| Добавлять отдельные операции над `Date` и использовать модульные импорты | date-fns |
| Работать с датой и временем в явно заданной зоне, интервалами и длительностями | Luxon |
| Отделить календарную дату от момента времени и явно управлять неоднозначностью DST | Temporal, с проверкой поддержки или выбранным polyfill |
| Использовать модель, близкую к Java `java.time` | js-joda |

Это рекомендации по характеру API. Окончательный выбор зависит от форматов входных данных, поддержки runtime и правил предметной области.

## Что сейчас происходит с Moment.js

Moment.js остаётся **legacy-проектом в режиме поддержки**. В обновлении политики от **17 августа 2026 года** команда подтвердила приоритет совместимости и отсутствие планов расширять пользовательские возможности. При этом она допускает технические изменения: упаковку, типы, сборку и исправления, требующие major-версии. Moment 3.0 больше не исключается, но срок его выпуска не объявлен. Поэтому распространённое утверждение «версии 3 никогда не будет» уже устарело. [Актуальная политика поддержки Moment.js](https://momentjs.com/news/).

Миграция особенно полезна, когда хочется уменьшить клиентскую сборку, избавиться от изменения общих объектов или точнее описать модель времени. В существующем приложении разумно сначала найти конкретную пользу и оценить стоимость перехода.

### Почему изменяемость важна

Методы Moment вроде `add()` изменяют исходный объект:

```js
import moment from 'moment';

const createdAt = moment('2026-10-12');
const expiresAt = createdAt.add(7, 'days');

console.log(createdAt.format('YYYY-MM-DD')); // 2026-10-19
console.log(expiresAt === createdAt);        // true
```

Если исходная дата нужна дальше, в Moment приходится использовать `clone()`:

```js
const original = moment('2026-10-12');
const expiresAt = original.clone().add(7, 'days');
```

Большинство рассматриваемых альтернатив возвращают новое значение. Это удобно, но при миграции нужно сохранять результат вызова: старый код мог полагаться на изменение объекта. [Манипуляции и клонирование в Moment.js](https://momentjs.com/docs/#/manipulating/).

## Сначала определитесь, что означает дата

Выбор библиотеки не исправляет ошибку в модели данных.

| Значение | Пример | Что нужно сохранить |
|---|---|---|
| Момент на временной шкале | Оплата прошла `2026-10-12T06:00:00Z` | UTC timestamp или строку с явным смещением |
| Календарная дата | Дата рождения `1990-05-20` | Год, месяц и день без часового пояса |
| Локальные дата и время | Пользователь ввёл `2026-10-12 09:00` | Компоненты и отдельно правила, в какой зоне их интерпретировать |
| Дата и время в зоне | Приём в `Europe/Berlin` | Местные компоненты, IANA-зону и правило разрешения неоднозначности |
| Количество времени | 90 минут или один календарный месяц | Единицы и смысл операции |

Например, «каждый день в 09:00 по Берлину» требует правила повторения и зоны. Один UTC timestamp не описывает такое расписание полностью. А день рождения обычно не нужно превращать в полночь UTC.

**Смещение `+03:00` и зона `Europe/Moscow` несут разную информацию.** Смещение задаёт разницу с UTC, а IANA-зона содержит правила, которые могут зависеть от даты. [Модель времени и часовых поясов Temporal](https://tc39.es/proposal-temporal/docs/timezone.html).

## Сравнительная таблица

| Вариант | Основная модель | Изменяет исходное значение | IANA-зоны | Разбор своего формата | Главная особенность |
|---|---|---|---|---|---|
| Moment.js | Обёртка над `Date` | Обычно да | Через Moment Timezone | Да | Привычный API существующих приложений |
| Day.js | Объект с цепочками методов | По умолчанию нет | Плагины `utc` и `timezone` | Плагин `customParseFormat` | Похож на Moment по стилю вызовов |
| date-fns | Отдельные функции над `Date` и его расширениями | Функции преобразования возвращают новое значение | В 4.x — `@date-fns/tz` | `parse()` | Можно выбирать нужные функции |
| Luxon | `DateTime`, `Duration`, `Interval` | Нет | Встроенная поддержка через `Intl` | `DateTime.fromFormat()` | Зона является частью `DateTime` |
| Temporal | `Instant`, `PlainDate`, `ZonedDateTime` и другие типы | Нет | `ZonedDateTime` | Стандартные строки и поля; произвольных масок нет | Разные типы для разных смыслов времени |
| js-joda | `LocalDate`, `Instant`, `ZonedDateTime`, `Period` и другие | Нет | Пакет `@js-joda/timezone` | `DateTimeFormatter` | Подход, близкий к `java.time` |
| `Date` + `Intl` | `Date` хранит момент, `Intl` форматирует | `Date` изменяем | Для отображения — `Intl.DateTimeFormat` | У `Intl` нет парсера дат | Для отображения можно обойтись без npm-библиотеки |

Для Day.js в таблице указано стандартное поведение без плагина `BadMutable`. У date-fns неизменяемость относится к функциям библиотеки: полученный `Date` по-прежнему можно изменить его собственными сеттерами.

Основа сравнения: [Day.js: добавление](https://day.js.org/docs/en/manipulate/add), [date-fns: описание проекта](https://github.com/date-fns/date-fns), [Luxon: обзор API](https://moment.github.io/luxon/#/tour), [типы Temporal](https://tc39.es/proposal-temporal/docs/), [js-joda: модель и пакеты](https://github.com/js-joda/js-joda), [Intl.DateTimeFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat).

## 1. Date и Intl: когда библиотека вообще не нужна

### Показать дату в нужной локали и зоне

Если API уже отдаёт однозначное время с `Z` или смещением, для отображения часто достаточно встроенного форматтера:

```js
const paidAt = new Date('2026-10-12T06:00:00Z');

const formatter = new Intl.DateTimeFormat('ru-RU', {
    timeZone: 'Europe/Moscow',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    hourCycle: 'h23',
});

console.log(formatter.format(paidAt));
// Дата 12.10.2026, время 09:00; оформление зависит от runtime.
```

Первый параметр задаёт локаль, второй — компоненты и правила отображения. `timeZone` влияет на представление, а значение `paidAt` остаётся прежним. Форматтер удобно создать один раз и использовать для списка записей. [Конструктор Intl.DateTimeFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/DateTimeFormat).

Для человекочитаемого вывода можно выбрать `dateStyle` и `timeStyle`. Для машинного обмена используйте согласованный формат вроде ISO-строки: локализованный текст может содержать разные разделители и пробелы.

### Вывести относительное время

```js
const relative = new Intl.RelativeTimeFormat('ru', {
    numeric: 'auto',
});

console.log(relative.format(-5, 'minute')); // 5 минут назад
console.log(relative.format(1, 'day'));     // завтра
```

`format(value, unit)` принимает уже вычисленные число и единицу. Отрицательное число означает прошлое, положительное — будущее. `numeric: 'auto'` разрешает слова вроде «завтра»; `'always'` предпочитает числовое выражение.

Форматтер сам не выбирает между минутами, часами и месяцами и не вычисляет разницу двух дат. Правила округления и перехода между единицами остаются в приложении. [Intl.RelativeTimeFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/RelativeTimeFormat).

**Когда выбирать:** списки заказов, даты публикаций, локализованный вывод уже известного момента. Для календарных вычислений и разбора пользовательских масок понадобится другой инструмент.

## 2. Day.js: привычный стиль Moment

Day.js удобен, когда в проекте много цепочек `add().startOf().format()`. Сходство API облегчает перенос, но совместимость нужно проверять по используемым методам и плагинам.

```bash
npm install dayjs@1
```

### Форматирование и добавление дней

```js
import dayjs from 'dayjs';
import 'dayjs/locale/ru.js';

const createdAt = dayjs('2026-10-12').locale('ru');
const expiresAt = createdAt.add(7, 'day');

console.log(createdAt.format('YYYY-MM-DD')); // 2026-10-12
console.log(expiresAt.format('DD.MM.YYYY')); // 19.10.2026
console.log(expiresAt.format('D MMMM YYYY')); // 19 октября 2026
```

`add(amount, unit)` возвращает новый объект. `format(mask)` использует токены Day.js; привычные `YYYY`, `MM`, `DD` совпадают с основными токенами Moment. `.locale('ru')` задаёт локаль конкретному объекту после загрузки её модуля. [Добавление](https://day.js.org/docs/en/manipulate/add), [локаль экземпляра](https://day.js.org/docs/en/i18n/instance-locale).

### Строгий разбор строки из формы

```js
import dayjs from 'dayjs';
import customParseFormat from 'dayjs/plugin/customParseFormat.js';

dayjs.extend(customParseFormat);

const good = dayjs('12.10.2026', 'DD.MM.YYYY', true);
const bad = dayjs('31.02.2026', 'DD.MM.YYYY', true);

console.log(good.isValid()); // true
console.log(bad.isValid());  // false
```

Параметры здесь — строка, маска и флаг строгого разбора. Без строгого режима некоторые выходящие за границы значения могут нормализоваться. Для локализованных названий месяцев можно передать локаль перед флагом: `dayjs(text, mask, 'ru', true)`. [CustomParseFormat](https://day.js.org/docs/en/plugin/custom-parse-format), [проверка валидности](https://day.js.org/docs/en/parse/is-valid).

### Работа с часовым поясом

```js
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc.js';
import timezone from 'dayjs/plugin/timezone.js';

dayjs.extend(utc);
dayjs.extend(timezone);

const appointment = dayjs.tz('2026-10-12 09:00', 'Europe/Moscow');
const sameInstant = appointment.tz('America/New_York');

console.log(appointment.toISOString()); // 2026-10-12T06:00:00.000Z
console.log(sameInstant.format('YYYY-MM-DD HH:mm Z'));
// 2026-10-12 02:00 -04:00
```

`dayjs.tz(text, zone)` интерпретирует местное время в указанной зоне. `.tz(zone)` на готовом объекте меняет представление того же момента. Вариант `.tz(zone, true)` сохраняет местные часы и меняет сам момент — используйте его только когда требуется именно такая операция.

Есть важное отличие от Moment: после `dayjs.tz.setDefault()` обычный `dayjs(value)` продолжает использовать системную зону. Настройка применяется к вызовам `dayjs.tz(value)` без явной зоны. Пример выше показывает интерпретацию времени; он не заменяет строгую проверку входной формы. [Timezone](https://day.js.org/docs/en/plugin/timezone).

**Когда выбирать:** постепенная миграция Moment-кода и интерфейсные задачи с привычным API. Заранее составьте список плагинов: относительное время, интервальные сравнения, длительности и дополнительные токены подключаются отдельно.

## 3. date-fns: отдельные функции над Date

date-fns подходит, когда удобнее импортировать операции вроде `addDays`, `format` и `parse`, чем создавать объект с цепочкой методов. Функции преобразования возвращают новые значения и работают с обычным `Date`, а также поддерживаемыми расширениями этого типа. Модульная структура позволяет сборщику исключать неиспользуемый код. [Описание date-fns](https://github.com/date-fns/date-fns).

```bash
npm install date-fns@4
```

### Форматирование и арифметика

```js
import { addDays, format } from 'date-fns';
import { ru } from 'date-fns/locale';

// В числовом конструкторе Date месяцы начинаются с нуля: 9 — октябрь.
const createdAt = new Date(2026, 9, 12);
const expiresAt = addDays(createdAt, 7);

console.log(format(createdAt, 'yyyy-MM-dd')); // 2026-10-12
console.log(format(expiresAt, 'dd.MM.yyyy')); // 19.10.2026
console.log(format(expiresAt, 'd MMMM yyyy', { locale: ru }));
// 19 октября 2026
```

Основные параметры:

- `addDays(date, amount, options?)` — исходная дата, число календарных дней и необязательные настройки контекста.
- `format(date, mask, options?)` — дата, маска и настройки, например `locale` и контекст зоны `in`.
- Результат `addDays()` — новое значение даты, результат `format()` — строка.

При обычном `Date` календарные операции и форматирование используют системную зону. Ниже покажем, как задать её явно. [Документация format в исходниках date-fns 4](https://github.com/date-fns/date-fns/blob/v4.1.0/src/format/index.ts).

### Разбор пользовательской строки

```js
import { format, isValid, parse } from 'date-fns';

function parseDateInput(text) {
    const mask = 'dd.MM.yyyy';
    const referenceDate = new Date(2000, 0, 1);
    const value = parse(text, mask, referenceDate);

    if (!isValid(value) || format(value, mask) !== text) {
        throw new RangeError('Ожидается существующая дата в формате ДД.ММ.ГГГГ');
    }

    return value;
}

console.log(format(parseDateInput('12.10.2026'), 'yyyy-MM-dd'));
// 2026-10-12

// parseDateInput('31.02.2026'); // RangeError из нашей функции
// parseDateInput('1.2.2026');   // RangeError: строка не соответствует маске точно
```

Сигнатура — `parse(text, mask, referenceDate, options?)`. Третий аргумент обязателен: он даёт контекст для недостающих компонентов. Здесь полная дата передана явно, а фиксированная опорная дата делает пример воспроизводимым.

При неудачном разборе обычно получается `Invalid Date`; неправильные токены или несовместимые настройки могут вызвать исключение. Проверка обратным форматированием обеспечивает точное соответствие нашей цифровой маске. Такая проверка рассчитана на выбранный формат формы. [Контракт parse](https://github.com/date-fns/date-fns/blob/v4.1.0/src/parse/index.ts).

### Часовые пояса в date-fns 4

Старые сравнения часто утверждают, что date-fns не умеет работать с зонами. Для **4.x** это уже неполное описание: есть официальный пакет `@date-fns/tz` и контекст вычислений `in`. [Анонс поддержки зон в date-fns 4](https://blog.date-fns.org/v40-with-time-zone-support/).

```bash
npm install @date-fns/tz@1
```

```js
import { addDays, format } from 'date-fns';
import { TZDate, tz } from '@date-fns/tz';

const start = new TZDate(2026, 2, 7, 12, 0, 0, 'America/New_York');
const nextDay = addDays(start, 1);

console.log(format(nextDay, 'yyyy-MM-dd HH:mm XXX'));
// 2026-03-08 12:00 -04:00

const instant = new Date('2026-10-12T06:00:00Z');

console.log(format(instant, 'yyyy-MM-dd HH:mm XXX', {
    in: tz('Europe/Moscow'),
}));
// 2026-10-12 09:00 +03:00
```

`TZDate` выполняет календарные операции в своей зоне. Его конструктор похож на `Date`, но принимает зону последним аргументом; месяцы тоже считаются от нуля. `tz(zone)` создаёт контекст для поддерживающих его функций date-fns. При смешивании дат из разных зон явный `in` помогает задать правила вычисления независимо от порядка аргументов. [API @date-fns/tz](https://github.com/date-fns/tz).

Отдельный пакет сообщества `date-fns-tz` тоже существует. Его `formatInTimeZone`, `fromZonedTime` и другие функции относятся к другому API. При чтении примеров проверяйте название пакета и совместимость версий. [date-fns-tz](https://github.com/marnusw/date-fns-tz).

### Главное отличие токенов

В date-fns календарная дата записывается **`yyyy-MM-dd`**. Moment-маска `YYYY-MM-DD` означает другие поля: год нумерации недель и день года. Некоторые такие токены защищены от случайного использования и вызывают ошибку без специальных опций. Не включайте эти опции просто ради сохранения старой маски. [Unicode tokens в date-fns](https://github.com/date-fns/date-fns/blob/v4.1.0/docs/unicodeTokens.md).

**Когда выбирать:** приложения, где уже используется `Date`, нужны отдельные операции и важны управляемые импорты. Для календарной даты без времени обычный `Date` требует дисциплины; посмотрите также на `Temporal.PlainDate` и `js-joda.LocalDate`.

## 4. Luxon: DateTime с зоной, длительности и интервалы

Luxon предлагает неизменяемый `DateTime`, в котором связаны момент, часовой пояс и локаль. Это удобно для бронирований, отчётов по местным датам и приложений, работающих в нескольких регионах. [Обзор Luxon](https://moment.github.io/luxon/#/tour).

```bash
npm install luxon@3
```

Для TypeScript в ветке 3.x обычно подключают отдельные определения. Это описано в [руководстве по установке Luxon](https://moment.github.io/luxon/#/install):

```bash
npm install --save-dev @types/luxon
```

### Создание и преобразование

```js
import { DateTime } from 'luxon';

const appointment = DateTime.fromISO('2026-10-12T09:00', {
    zone: 'Europe/Moscow',
    locale: 'ru',
});

console.log(appointment.toFormat('dd.MM.yyyy HH:mm')); // 12.10.2026 09:00
console.log(appointment.toUTC().toISO()); // 2026-10-12T06:00:00.000Z
console.log(appointment.setZone('America/New_York').toFormat('HH:mm'));
// 02:00
```

`fromISO(text, options?)` разбирает ISO-строку. Для строки без смещения `zone` задаёт её интерпретацию. Для строки с явным смещением момент уже определён; по умолчанию результат представляется в целевой зоне. Опция `setZone: true` позволяет сохранить фиксированное смещение из входной строки.

`setZone(zone)` сохраняет момент, меняя его представление. Вариант `{ keepLocalTime: true }` сохраняет местные часы, поэтому меняет момент. IANA-зоны Luxon обрабатывает через `Intl`, без отдельной поставки своей базы зон. [Часовые пояса Luxon](https://moment.github.io/luxon/#/zones).

### Парсинг и ошибка в дате

```js
import { DateTime } from 'luxon';

const value = DateTime.fromFormat('31.02.2026', 'dd.MM.yyyy', {
    zone: 'Europe/Moscow',
});

console.log(value.isValid); // false
console.log(value.invalidReason);
console.log(value.invalidExplanation);
```

`fromFormat(text, mask, options?)` использует собственные токены Luxon. Обычно неудачный разбор даёт невалидный `DateTime`, а не исключение: проверяйте свойство `isValid`. В Luxon также можно включить `Settings.throwOnInvalid`, поэтому правила ошибок должны быть согласованы внутри приложения. [Разбор строк](https://moment.github.io/luxon/#/parsing), [валидность](https://moment.github.io/luxon/#/validity).

### День и 24 часа — разные операции

В Нью-Йорке 8 марта 2026 года начинается летнее время. Если взять полдень предыдущего дня, результаты будут такими:

```js
import { DateTime } from 'luxon';

const start = DateTime.fromISO('2026-03-07T12:00', {
    zone: 'America/New_York',
});

const calendarDay = start.plus({ days: 1 });
const exactHours = start.plus({ hours: 24 });

console.log(calendarDay.toFormat('yyyy-MM-dd HH:mm ZZ'));
// 2026-03-08 12:00 -04:00

console.log(exactHours.toFormat('yyyy-MM-dd HH:mm ZZ'));
// 2026-03-08 13:00 -04:00

console.log(calendarDay.diff(start, 'hours').hours); // 23
```

`plus({ days: 1 })` выполняет календарную операцию в зоне. `plus({ hours: 24 })` добавляет заданное количество прошедшего времени. Этот выбор должен следовать требованиям: срок жизни токена и «завтра в то же местное время» могут означать разные вещи. [Календарная и временная арифметика Luxon](https://moment.github.io/luxon/#/math).

### Интервал с открытым правым концом

```js
import { DateTime, Interval } from 'luxon';

const start = DateTime.fromISO('2026-10-12', { zone: 'Europe/Moscow' });
const end = start.plus({ days: 1 });
const period = Interval.fromDateTimes(start, end);

console.log(period.contains(start)); // true
console.log(period.contains(end));   // false
console.log(period.length('hours')); // 24 для этой даты и зоны
```

Luxon-интервал имеет вид `[start, end)`: начало включено, конец исключён. Для выборки записей за день это соответствует условию `created_at >= start AND created_at < end`. Такая граница не зависит от предположения о точности последней миллисекунды дня. [Interval API](https://moment.github.io/luxon/api-docs/index.html#interval).

Для количества времени есть `Duration`:

```js
import { Duration } from 'luxon';

const duration = Duration.fromObject({ hours: 1, minutes: 30 });

console.log(duration.as('minutes')); // 90
console.log(duration.toISO());       // PT1H30M
```

Перевод часов в минуты однозначен. Для календарных месяцев перевод в прошедшие часы требует контекста конкретных дат; отдельно согласуйте правило такого вычисления. [Duration API](https://moment.github.io/luxon/api-docs/index.html#duration).

**Когда выбирать:** если хочется связанного API для времени, зон, длительностей и интервалов. Luxon не имеет отдельного типа календарной даты без времени; для такой модели полезно рассмотреть Temporal или js-joda. Проверяйте поддержку `Intl` и нужных локалей в целевой среде.

## 5. Temporal: отдельный тип для каждого смысла времени

Temporal — новый стандартный API JavaScript. На дату статьи предложение находится на **Stage 4**. Нативная реализация уже есть, например, в Firefox 139+, Chrome 144+ и Node.js 26. Для других версий и браузеров проверяйте фактическую совместимость; наличие Stage 4 само по себе не обеспечивает поддержку у всех пользователей. [Статус и реализации Temporal](https://github.com/tc39/proposal-temporal#status), [включение по умолчанию в Node.js 26](https://nodejs.org/en/blog/release/v26.0.0), [таблица совместимости](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Temporal#browser_compatibility).

### Основные типы

| Тип | Что представляет | Пример применения |
|---|---|---|
| `Temporal.Instant` | Точный момент на временной шкале | Создание записи, оплата, дедлайн |
| `Temporal.PlainDate` | Календарная дата без времени и зоны | Дата рождения, дата документа |
| `Temporal.PlainTime` | Время суток без даты и зоны | Время открытия магазина |
| `Temporal.PlainDateTime` | Дата и местное время без зоны | Ввод из формы до выбора зоны |
| `Temporal.ZonedDateTime` | Момент, зона и календарные компоненты | Приём или событие в конкретном регионе |
| `Temporal.Duration` | Набор единиц длительности | 90 минут или период для календарной операции |

Объекты Temporal неизменяемы. Вместо скрытого предположения о зоне API требует выбрать подходящий тип и явно выполнить нужное преобразование. [Обзор типов](https://tc39.es/proposal-temporal/docs/).

### Как подключить

При нативной поддержке доступен `globalThis.Temporal`. Для среды без неё можно использовать отдельную реализацию, например:

```bash
npm install @js-temporal/polyfill@0.5
```

```js
import { Temporal } from '@js-temporal/polyfill';
```

Этот пакет экспортирует `Temporal`, но сам не добавляет его в глобальный объект. Ниже используется явный импорт. Polyfill входит в размер сборки, а его версию и соответствие текущему API нужно проверять отдельно. [Подключение @js-temporal/polyfill](https://github.com/js-temporal/temporal-polyfill).

### Прибавить месяц к календарной дате

```js
import { Temporal } from '@js-temporal/polyfill';

const invoiceDate = Temporal.PlainDate.from('2026-01-31');
const nextMonth = invoiceDate.add({ months: 1 });

console.log(invoiceDate.toString()); // 2026-01-31
console.log(nextMonth.toString());   // 2026-02-28

// В феврале нет 31-го числа. Можно потребовать ошибку:
// invoiceDate.add({ months: 1 }, { overflow: 'reject' }); // RangeError
```

`add(duration, options?)` принимает единицы изменения. По умолчанию `overflow: 'constrain'` ограничивает результат допустимым днём месяца. `'reject'` требует исключение, если подходящего дня нет. Это правило полезно согласовать для подписок и платежей. [Temporal.PlainDate.add](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Temporal/PlainDate/add).

Строка `Temporal.PlainDate.from('2026-02-30')` вызывает `RangeError`. При создании из объекта стандартное поведение другое: компоненты могут ограничиваться допустимыми значениями. Для строгой проверки полей передавайте `Temporal.PlainDate.from(fields, { overflow: 'reject' })`. [Temporal.PlainDate.from](https://tc39.es/proposal-temporal/docs/plaindate.html#from).

### Перевести момент в локальное представление

```js
import { Temporal } from '@js-temporal/polyfill';

const paidAt = Temporal.Instant.from('2026-10-12T06:00:00Z');
const inMoscow = paidAt.toZonedDateTimeISO('Europe/Moscow');

console.log(inMoscow.toString());
// 2026-10-12T09:00:00+03:00[Europe/Moscow]

console.log(inMoscow.toPlainDate().toString()); // 2026-10-12
console.log(inMoscow.toInstant().equals(paidAt)); // true
```

`Instant.from(text)` требует строку с определённым моментом, то есть с `Z` или смещением. `toZonedDateTimeISO(zone)` добавляет правила зоны для отображения и календарных операций. Обычную ISO-строку без `[Zone]` не следует передавать напрямую в `ZonedDateTime.from()`; для такого ввода подходит путь через `Instant`. [Temporal.ZonedDateTime](https://tc39.es/proposal-temporal/docs/zoneddatetime.html).

### Явно разрешить неоднозначное время

При осеннем переводе часов местное время может наступить дважды. Например, в Нью-Йорке **1 ноября 2026 года в 01:30** есть два разных момента:

```js
import { Temporal } from '@js-temporal/polyfill';

const fields = {
    timeZone: 'America/New_York',
    year: 2026,
    month: 11,
    day: 1,
    hour: 1,
    minute: 30,
};

const earlier = Temporal.ZonedDateTime.from(fields, {
    disambiguation: 'earlier',
});

const later = Temporal.ZonedDateTime.from(fields, {
    disambiguation: 'later',
});

console.log(earlier.toInstant().toString()); // 2026-11-01T05:30:00Z
console.log(later.toInstant().toString());   // 2026-11-01T06:30:00Z

// Если приложение требует уточнения пользователя:
// Temporal.ZonedDateTime.from(fields, { disambiguation: 'reject' });
// RangeError
```

Опции `disambiguation`:

- `'earlier'` — более ранний вариант.
- `'later'` — более поздний вариант.
- `'reject'` — исключение при повторяющемся или пропущенном местном времени.
- `'compatible'` — стандартное поведение: ранний вариант при повторении часов, поздний при пропуске.

При весеннем переходе некоторые местные значения вообще не существуют; `reject` позволяет обнаружить и такой ввод. Не путайте эту настройку с `overflow`, который проверяет границы календарных компонентов. [Опции ZonedDateTime.from](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Temporal/ZonedDateTime/from).

### Чего Temporal не делает

Temporal не предоставляет Moment-подобный парсер произвольной маски `DD.MM.YYYY` и не выбирает автоматически фразу «три минуты назад». Для пользовательских форм нужны контролируемое извлечение полей или отдельный парсер, для относительного вывода — `Intl.RelativeTimeFormat` и правило выбора единиц.

Стандартные строки создаются через `toString()`, локализованный вывод — через поддерживаемые типом методы и `Intl`. Строка с зоной в квадратных скобках использует расширенный формат: проверьте, умеют ли её читать backend, БД и сторонние API. Для поля, которое передаёт только момент, обычно подходит `toInstant().toString()`. [Строки, сериализация и форматирование Temporal](https://tc39.es/proposal-temporal/docs/strings.html).

**Когда выбирать:** новые модули, где важно явно различать дату, момент и локальное время. Перед внедрением оцените поддержку runtime, размер polyfill и адаптеры для компонентов, ожидающих `Date`.

## 6. js-joda: модель java.time в JavaScript

js-joda использует отдельные неизменяемые типы: `LocalDate`, `LocalTime`, `LocalDateTime`, `Instant`, `ZonedDateTime`. Есть и разделение количества времени: `Duration` для временных единиц, `Period` для календарных. Такой подход знаком командам, работающим с Java. [Описание модели js-joda](https://github.com/js-joda/js-joda).

```bash
npm install @js-joda/core
```

```js
import { LocalDate, Period } from '@js-joda/core';

const documentDate = LocalDate.parse('2026-01-31');
const nextMonth = documentDate.plus(Period.ofMonths(1));

console.log(documentDate.toString()); // 2026-01-31
console.log(nextMonth.toString());    // 2026-02-28
```

`LocalDate` хранит календарную дату без времени и зоны. Поэтому сохранение `toString()` не требует промежуточного перевода в UTC. Разбор несуществующей ISO-даты вызывает исключение. [LocalDate](https://js-joda.github.io/js-joda/manual/LocalDate.html).

Для IANA-зон подключают отдельный пакет:

```bash
npm install @js-joda/timezone
```

```js
import { ZonedDateTime } from '@js-joda/core';
import '@js-joda/timezone';

const appointment = ZonedDateTime.parse(
    '2026-10-12T09:00:00+03:00[Europe/Moscow]',
);

console.log(appointment.toInstant().toString());
// 2026-10-12T06:00:00Z
```

В отличие от Luxon, пакет зон js-joda поставляет данные IANA. Их объём и обновление нужно учитывать отдельно. Локализованное форматирование также вынесено в пакеты локалей. [ZonedDateTime и подключение зон](https://js-joda.github.io/js-joda/manual/ZonedDateTime.html), [форматирование](https://js-joda.github.io/js-joda/manual/formatting.html).

**Когда выбирать:** доменная логика с календарными датами и периодами, особенно если на backend уже используется `java.time`. Если код переносится в среду с Temporal, сравните эти модели до добавления ещё одной зависимости.

## Как сравнивать размер и скорость

Цифры из таблиц «библиотека весит 2 КБ» часто относятся к минимальному ядру в конкретной конфигурации. Итог зависит от импортов, плагинов, локалей, базы зон, polyfill и сборщика.

| Вариант | Что влияет на поставляемый код |
|---|---|
| Moment.js | Ядро, локали и при необходимости Moment Timezone с данными зон |
| Day.js | Компактное ядро, выбранные плагины и локали |
| date-fns | Использованные функции и локали; отдельно расширения для зон |
| Luxon | Код библиотеки; данные локалей и IANA-зон берутся из `Intl` целевой среды |
| Temporal | При нативной реализации npm-код не нужен; polyfill добавляет код в приложение |
| js-joda | Ядро, выбранная сборка данных зон и локали |
| `Intl` | Для нативного API не добавляется npm-зависимость; в старых или ограниченных средах могут понадобиться polyfill и данные |

Moment исторически плохо подходит для исключения неиспользуемого кода; date-fns строится вокруг отдельных функций, а Day.js — подключаемых возможностей. Эти свойства помогают оценить кандидатов, но не дают готового размера вашей сборки. [Позиция Moment о размере](https://momentjs.com/news/), [структура date-fns](https://github.com/date-fns/date-fns), [плагины Day.js](https://day.js.org/docs/en/plugin/plugin), [варианты данных зон js-joda](https://github.com/js-joda/js-joda/tree/main/packages/timezone).

Практический способ сравнения — взять одинаковые реальные сценарии, включить production-сборку и измерить размер добавленного JS после одинакового сжатия. Отдельно оценить начальную загрузку и отложенные чанки. Для скорости имеет смысл измерять свою операцию: разбор, календарное вычисление или форматирование списка. Универсального победителя по одному синтетическому циклу выбрать нельзя.

## Что ломается при миграции

### 1. Результат операции перестали присваивать

```js
import moment from 'moment';
import dayjs from 'dayjs';

const oldDate = moment('2026-10-12');
oldDate.add(1, 'day'); // oldDate изменился.

const date = dayjs('2026-10-12');
const tomorrow = date.add(1, 'day'); // date остался прежним.
```

Та же идея относится к Luxon и Temporal. При переносе ищите вызовы преобразований, результат которых игнорируется, и случаи, где несколько переменных ссылаются на один Moment-объект.

### 2. Маски скопировали буквально

| Компонент | Moment / Day.js | date-fns | Luxon |
|---|---|---|---|
| Календарный год | `YYYY` | `yyyy` | `yyyy` |
| Месяц с ведущим нулём | `MM` | `MM` | `MM` |
| День месяца с ведущим нулём | `DD` | `dd` | `dd` |
| Часы в 24-часовом формате | `HH` | `HH` | `HH` |
| Смещение вида `+03:00` | `Z` | `xxx` | `ZZ` |
| Буквальный текст | `[text]` | `'text'` | `'text'` |

Даже совпадающее название токена не гарантирует одинаковую семантику во всех библиотеках. Особенно внимательно переносите номер недели, год недели, день недели и локализованные сокращения. У Temporal нет аналогичной маски для произвольного форматирования. [Day.js format](https://day.js.org/docs/en/display/format), [Unicode tokens date-fns](https://github.com/date-fns/date-fns/blob/v4.1.0/docs/unicodeTokens.md), [форматирование Luxon](https://moment.github.io/luxon/#/formatting).

### 3. Календарную дату превратили в момент

Стандартная строка без времени в `new Date('2026-10-12')` интерпретируется как полночь UTC. При показе в Америке местная дата может оказаться предыдущей. ISO-строка с временем, но без смещения, например `2026-10-12T00:00:00`, интерпретируется как системное местное время.

У date-fns `parseISO('2026-10-12')` по умолчанию создаёт местную дату. Поэтому замена одного способа разбора другим может изменить timestamp даже при одинаковой входной строке. Для дня рождения или даты документа проще сохранить модель календарной даты. [Правила Date.parse](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/parse), [parseISO date-fns](https://github.com/date-fns/date-fns/blob/v4.1.0/src/parseISO/index.ts).

### 4. Прибавление месяца заменили фиксированным числом суток

Месяц может содержать 28, 29, 30 или 31 день. А один местный день при смене смещения не всегда равен 24 часам. Согласуйте требования отдельно для подписок, сроков оплаты, расписаний и TTL.

Есть ещё тонкость: последовательное прибавление месяца к 31 января может дать 28 февраля, а затем 28 марта. Если требуется «последний день каждого месяца» или «тот же день, а при его отсутствии последний», это правило нужно хранить и применять явно. Одной цепочки прибавлений недостаточно для всех вариантов расписания. [Правила календарных вычислений](https://moment.github.io/luxon/#/math).

### 5. Проверили календарную валидность, но пропустили проблему зоны

Успешный разбор числа, месяца и года ещё не означает, что местное время существует в выбранной зоне. Во время DST оно может отсутствовать или повторяться. В API, который нормализует такой ввод, `isValid` не обязательно сообщает о сдвиге часов.

Для бронирований задавайте правило явно: отклонять ввод, выбирать вариант или просить пользователя уточнить. В Temporal для этого есть `disambiguation`. В других библиотеках нужно разбирать их конкретное поведение. [Неоднозначность местного времени](https://tc39.es/proposal-temporal/docs/timezone.html).

### 6. Изменили глобальную локаль во время обработки запроса

В сервере с несколькими пользователями язык одного запроса не должен менять вывод другого. Предпочитайте локаль экземпляра Day.js, опцию `{ locale }` date-fns, настройки конкретного Luxon `DateTime` или отдельный `Intl`-форматтер. Инициализацию общих плагинов выполняйте при старте приложения.

Также задавайте зону явно там, где результат должен совпадать при SSR и в браузере. Данные `Intl` зависят от runtime; локализованная строка не подходит для стабильного машинного идентификатора.

### 7. Убрали прямой импорт, но Moment остался в сборке

Проверьте дерево зависимостей и отчёт сборщика: Moment может оставаться внутри date picker, графика или другой библиотеки. При таком переходе временно поставляются обе реализации. Замена только собственного кода не гарантирует уменьшения итогового JS.

## Практический порядок перехода

1. **Составьте список использования Moment.** Отдельно отметьте форматирование, парсинг, арифметику, зоны, локали, длительности и плагины.
2. **Определите смысл данных.** Где хранится момент, где календарная дата, где местное время и расписание.
3. **Зафиксируйте ожидаемое поведение.** Конец месяца, високосный год, граница года недели, невалидный ввод, DST, разные зоны сервера и браузера.
4. **Выберите инструмент по этим сценариям.** Иногда для отображения достаточно `Intl`, а для календарной логики нужен другой API.
5. **Создайте небольшой прикладной модуль.** Например, функции показа даты заказа, разбора даты формы и вычисления периода отчёта. Не обязательно воспроизводить в нём весь API Moment.
6. **Переносите по одному сценарию.** Сравнивайте результаты, отдельно пересматривая ошибки старой реализации.
7. **Проверьте границы приложения.** JSON, БД, UI-компоненты, TypeScript-типы, SSR и используемые runtime.
8. **Измерьте итоговую сборку и удалите ненужное.** Включая старые локали, плагины, Moment Timezone и транзитивные зависимости, если их можно заменить.

### Чек-лист выбора

- [ ] Понятно, какие значения являются моментами, а какие — календарными датами.
- [ ] Поддерживаются необходимые браузеры, Node.js и мобильные runtime.
- [ ] Определены нужные плагины, локали, данные зон и polyfill.
- [ ] Входные строки имеют явный контракт и проверяются после разбора.
- [ ] Перенесены маски, включая недели, экранирование текста и смещения.
- [ ] Согласовано поведение конца месяца и переходов DST.
- [ ] Учтена изменяемость старого кода.
- [ ] Сериализация совместима с backend и БД.
- [ ] Локаль и зона не зависят случайно от окружения.
- [ ] Оценены собственные сценарии и production-сборка.

## Какой вариант предпочесть

Для простого отображения начните с **Intl**. Если основная задача — перенос привычного Moment-кода, первым кандидатом будет **Day.js**. Если приложение уже опирается на `Date` и нужны отдельные операции, рассмотрите **date-fns**.

Для связанной работы с зонами и интервалами удобен **Luxon**. Если в предметной области важно строго разделить дату, момент и местное время, начните сравнение с **Temporal**; его внедрение зависит от целевой среды и выбранной реализации. **js-joda** подходит командам, которым близок API `java.time` и нужна такая модель в JavaScript.

При миграции сохраните ясные правила данных: что означает дата, в какой зоне выполняется операция и что делать с неоднозначным вводом. Именно эти решения определяют корректность результата.
