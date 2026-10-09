# Что нового в JavaScript за 2025 год: итераторы, Set и новые возможности Promise

ECMAScript 2025 — 16-я редакция стандарта, опубликованная в июне 2025 года. Она добавила цепочки для ленивой обработки итераторов, операции над множествами `Set`, несколько полезных улучшений регулярных выражений и новые API для Promise, JSON-модулей и чисел половинной точности. Здесь описаны изменения языка и стандартных встроенных объектов; доступность JSON-модулей также зависит от среды загрузки модулей.

## Цепочки для итераторов

Раньше для последовательной фильтрации и преобразования данных часто создавали промежуточные массивы. ES2025 добавил глобальный `Iterator` с методами `map()`, `filter()`, `take()`, `drop()`, `flatMap()` и другими:

    const names = Iterator.from(users)
        .filter(user => user.active)
        .map(user => user.name)
        .take(3)
        .toArray();

Цепочка обрабатывает элементы по одному и лениво: `filter()` и `map()` сами по себе не обходят все данные. Обработка начинается, когда вызывается завершающий метод вроде `toArray()`, `reduce()` или `forEach()`. Итератор одноразовый: после полного обхода его обычно нельзя начать заново.

Это особенно удобно, когда исходный набор большой или получается из генератора. Можно отфильтровать и преобразовать значения, не создавая отдельный массив на каждом шаге.

## Операции над множествами `Set`

ES2025 добавил математические операции над объектами `Set`: `union()`, `intersection()`, `difference()`, `symmetricDifference()`, а также проверки `isSubsetOf()`, `isSupersetOf()` и `isDisjointFrom()`.

    const required = new Set(['read', 'write']);
    const granted = new Set(['read', 'write', 'admin']);

    const missing = required.difference(granted);
    const effective = required.intersection(granted);
    const hasAllRequired = granted.isSupersetOf(required);

    console.log([...missing]);       // []
    console.log([...effective]);     // ['read', 'write']
    console.log(hasAllRequired);     // true

Методы возвращают новый `Set` и не меняют исходные множества. Для каждой операции можно передать другой set-like объект, если он предоставляет нужные свойства и методы.

## Экранирование текста для регулярного выражения

Если пользовательский текст нужно искать буквально, специальные символы регулярного выражения требуется экранировать. `RegExp.escape()` делает это без самодельной таблицы замен:

    const input = 'a+b';
    const exactMatch = new RegExp('^' + RegExp.escape(input) + '$');

    console.log(exactMatch.test('a+b')); // true
    console.log(exactMatch.test('aaab')); // false

Без экранирования знак `+` означает `один или больше предыдущего символа`, и шаблон будет искать не буквальную строку `a+b`.

## Флаги регулярного выражения внутри группы

Теперь модификаторы `i`, `m` и `s` можно включать или выключать локально для части выражения:

    const pattern = /prefix-(?i:javascript)-suffix/;

    console.log(pattern.test('prefix-JavaScript-suffix')); // true
    console.log(pattern.test('PREFIX-JAVASCRIPT-SUFFIX')); // false

В этом примере без учёта регистра сравнивается только слово `javascript`. Остальная часть регулярного выражения сохраняет исходный режим.

## Promise.try(): одинаковый Promise для синхронной и асинхронной функции

`Promise.try()` вызывает функцию и возвращает Promise, даже если функция возвращает обычное значение. Если она выбросит исключение синхронно, ошибка станет отклонением Promise:

    function parseConfig(text) {
        return JSON.parse(text);
    }

    Promise.try(() => parseConfig(source))
        .then(config => startApp(config))
        .catch(error => reportError(error));

Так проще поместить вызов, который может упасть ещё до возврата Promise, в одну цепочку обработки ошибок.

## JSON-модули и атрибуты импорта

В модулях можно импортировать JSON с атрибутом типа:

    import settings from './settings.json' with { type: 'json' };

Атрибут сообщает загрузчику, как интерпретировать файл. Конкретные поддерживаемые типы зависят от среды — например, браузера или Node.js. Это синтаксис ECMAScript, но наличие загрузчика JSON-модулей нужно проверить в целевой среде.

## Числа половинной точности

Новый тип `Float16Array` хранит числа в 16-битном формате с плавающей точкой. Это занимает меньше памяти, чем обычный `Float32Array`, ценой меньшей точности. Также добавлены `DataView.prototype.getFloat16()`, `setFloat16()` и `Math.f16round()`:

    const values = new Float16Array([1.337]);

    console.log(values[0]);        // 1.3369140625
    console.log(Math.f16round(1.337)); // 1.3369140625

Такой формат бывает полезен при работе с большими числовыми массивами, графикой и машинным обучением, если конкретная задача допускает потерю точности.

## Ещё одно изменение RegExp

Именованные группы в альтернативных ветках теперь могут повторно использовать одно имя, если эти ветки не могут совпасть с одним и тем же фрагментом:

    const datePattern =
        /^(?:(?<date>\d{4}-\d{2}-\d{2})|(?<date>\d{2}\/\d{2}\/\d{4}))$/;

    const match = datePattern.exec('2025-06-15');
    console.log(match.groups.date); // 2025-06-15

Это упрощает разбор разных форматов, когда результат в любом варианте нужен под одним именем. Регулярное выражение всё равно должно разделять варианты так, чтобы группы с одним именем не срабатывали одновременно.

## Официальные источники

- [Спецификация ECMAScript 2025](https://tc39.es/ecma262/2025/)
- [Завершённые предложения TC39 и годы публикации](https://github.com/tc39/proposals/blob/main/finished-proposals.md)
- [Iterator Helpers](https://github.com/tc39/proposal-iterator-helpers)
- [Новые методы Set](https://github.com/tc39/proposal-set-methods)
- [RegExp.escape](https://github.com/tc39/proposal-regex-escaping)
- [Регулярные выражения с локальными модификаторами](https://github.com/tc39/proposal-regexp-modifiers)
- [Promise.try](https://github.com/tc39/proposal-promise-try)
- [JSON Modules](https://github.com/tc39/proposal-json-modules)
- [Import Attributes](https://github.com/tc39/proposal-import-attributes)
- [Float16Array](https://github.com/tc39/proposal-float16array)
- [Повторяющиеся имена групп RegExp в разных альтернативах](https://github.com/tc39/proposal-duplicate-named-capturing-groups)
