# Что нового в JavaScript за 2026 год: точная сумма, async-коллекции и новые Map

ECMAScript 2026 — 17-я редакция стандарта JavaScript. Ecma International утвердила её 30 июня 2026 года. В выпуск вошли методы для работы с недостающими значениями в Map, точный сумматор чисел, асинхронное создание массивов и несколько утилит для JSON, ошибок и бинарных данных. [Страница стандарта ECMA-262](https://ecma-international.org/publications-and-standards/standards/ecma-262/)

Как и в предыдущих статьях, здесь рассматриваются изменения стандарта ECMAScript. Наличие функции в стандарте не означает, что она уже есть во всех браузерах и версиях Node.js.

## Заполнить Map только если ключа ещё нет

`Map.prototype.getOrInsert()` возвращает значение для ключа, а если ключа ещё нет — записывает значение по умолчанию. `getOrInsertComputed()` делает то же самое, но вычисляет значение лениво через callback:

    const groups = new Map();

    for (const event of events) {
        groups
            .getOrInsertComputed(event.type, () => [])
            .push(event);
    }

Массив создаётся только при первом событии данного типа. В старом варианте для этого нужно было отдельно вызывать `has()`, затем `get()` или `set()`. Аналогичные методы появились и у `WeakMap`.

## JSON.parse теперь может сообщить исходный текст значения

Обычный `JSON.parse()` преобразует число в JavaScript `Number`. Если в JSON записано целое число больше безопасного диапазона, часть точности теряется ещё до вызова reviver. В ES2026 reviver может получить третий аргумент — контекст с полем `source`, то есть исходный текст примитивного значения:

    const record = JSON.parse(
        '{"id": 9007199254740993}',
        (key, value, context) => {
            if (key === 'id') {
                return BigInt(context.source);
            }

            return value;
        },
    );

    console.log(record.id === 9007199254740993n); // true

Так можно точно разобрать большие целые числа, не полагаясь на уже округлённое значение `Number`. Контекст с исходным текстом предоставляется для примитивных значений; для объектов и массивов его нет.

С этим же предложением связаны `JSON.rawJSON()` и `JSON.isRawJSON()`. `rawJSON()` помечает проверенный фрагмент JSON, который `JSON.stringify()` вставит в результат как готовый JSON-текст:

    const encoded = JSON.stringify({
        id: JSON.rawJSON('9007199254740993'),
    });

    console.log(encoded); // {"id":9007199254740993}

Это помогает сериализовать точные числовые значения, которые нельзя безопасно представить как обычный JavaScript `Number`.

## Сложить числа с меньшей потерей точности

При сложении чисел с плавающей точкой промежуточное округление может потерять небольшие слагаемые. Новый `Math.sumPrecise()` принимает любой iterable чисел и вычисляет сумму алгоритмом, который минимизирует эту потерю:

    const values = [1e20, 0.1, -1e20];

    console.log(values.reduce((sum, value) => sum + value, 0)); // 0
    console.log(Math.sumPrecise(values));                       // 0.1

Метод принимает числа типа `Number`, а не `BigInt`. Для обычных коротких списков он может быть избыточен; полезен он там, где накапливаются многие значения с сильно разными порядками величин.

## Создать массив из асинхронного источника

`Array.fromAsync()` похож на `Array.from()`, но возвращает Promise и умеет собирать значения из async iterable, iterable или array-like источника. Значения и результаты callback дожидаются, прежде чем попасть в итоговый массив:

    const values = await Array.fromAsync([
        Promise.resolve('one'),
        Promise.resolve('two'),
    ]);

    console.log(values); // ['one', 'two']

Можно передать и функцию преобразования:

async function* readValues() {
    yield 2;
    yield 3;
}

const doubled = await Array.fromAsync(
    readValues(),
    async value => value * 2,
);

Это избавляет от ручного цикла `for await` в случаях, когда нужен именно массив всех результатов. Учитывайте, что функция собирает весь результат в память; для очень большого или бесконечного потока лучше обрабатывать итератор по частям.

## Склеить несколько итераторов

`Iterator.concat()` создаёт один iterator helper, последовательно выдающий элементы нескольких iterable:

    const values = Iterator.concat(
        [1, 2],
        new Set([3, 4]),
    ).toArray();

    console.log(values); // [1, 2, 3, 4]

Раньше для такой последовательности обычно писали генератор с несколькими `yield*`. Новый метод ленивый: он начинает обходить следующий источник, когда закончился предыдущий.

## Перевести Uint8Array в hex или Base64

Новые методы `Uint8Array` кодируют байты в строку Base64 или hex и декодируют их обратно:

    const bytes = Uint8Array.fromHex('4869');

    console.log(bytes.toHex());    // 4869
    console.log(bytes.toBase64()); // SGk=

    const decoded = Uint8Array.fromBase64('SGk=');
    console.log(decoded.toHex());  // 4869

`fromHex()` и `fromBase64()` создают массив байтов из строки. `toHex()` и `toBase64()` возвращают строковое представление. Для заполнения уже выделенного буфера также добавлены `setFromHex()` и `setFromBase64()`.

## Проверить, что значение — настоящий Error

`Error.isError()` проверяет, является ли значение объектом встроенной иерархии ошибок ECMAScript:

    Error.isError(new TypeError('bad'));              // true
    Error.isError({ name: 'Error', message: 'bad' }); // false

Это надёжнее проверки через `instanceof Error`, когда ошибка могла быть создана в другом JavaScript realm — например, внутри iframe. Объект, который просто имеет поля `name` и `message`, настоящей ошибкой от этого не становится.

## Что не следует относить к ES2026

`Temporal` — крупный API дат и времени — не входит в редакцию ES2026. В списке TC39 он указан среди завершённых предложений с ожидаемым годом публикации 2027. Поэтому в этой статье он не смешан с возможностями утверждённого стандарта 2026 года.

После появления в стандарте функции могут внедряться в браузеры и Node.js не одновременно. Проверяйте поддержку в целевых средах или используйте подходящий polyfill.

## Официальные источники

- [Страница стандарта ECMA-262, 17-я редакция — ECMAScript 2026](https://ecma-international.org/publications-and-standards/standards/ecma-262/)
- [ECMAScript 2026 в TC39](https://tc39.es/ecma262/2026/)
- [Завершённые предложения TC39 и ожидаемые годы публикации](https://github.com/tc39/proposals/blob/main/finished-proposals.md)
- [Upsert для Map и WeakMap](https://github.com/tc39/proposal-upsert)
- [JSON.parse: доступ к исходному тексту](https://github.com/tc39/proposal-json-parse-with-source)
- [Iterator.concat](https://github.com/tc39/proposal-iterator-sequencing)
- [Base64 и hex для Uint8Array](https://github.com/tc39/proposal-arraybuffer-base64)
- [Math.sumPrecise](https://github.com/tc39/proposal-math-sum)
- [Error.isError](https://github.com/tc39/proposal-is-error)
- [Array.fromAsync](https://github.com/tc39/proposal-array-from-async)
