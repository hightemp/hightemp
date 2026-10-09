# Что нового в JavaScript за 2024 год: группировка, память и новые возможности RegExp

ECMAScript 2024 — 15-я редакция стандарта языка, опубликованная в июне 2024 года. В неё вошли группировка элементов, управляемые буферы памяти, асинхронное ожидание атомарных операций и улучшенная обработка Unicode-строк.

## Группировка элементов по ключу

`Object.groupBy()` и `Map.groupBy()` разбивают массив на группы по результату callback-функции:

    const orders = [
        { status: 'new', id: 1 },
        { status: 'paid', id: 2 },
        { status: 'new', id: 3 },
    ];

    const byStatus = Object.groupBy(orders, order => order.status);

    console.log(byStatus.new.map(order => order.id)); // [1, 3]
    console.log(byStatus.paid.map(order => order.id)); // [2]

`Object.groupBy()` использует строковые или символьные ключи. `Map.groupBy()` сохраняет ключи как есть, поэтому callback может вернуть объект или другой тип:

    const byOwner = Map.groupBy(files, file => file.owner);
    const ownedByAda = byOwner.get(ada);

Это избавляет от ручного создания групп через `reduce()`. Обе функции возвращают отдельную структуру с массивами элементов, исходный массив не меняют.

## Буферы, размер которых можно изменить

`ArrayBuffer` теперь можно создать с максимальным размером, а затем расширить или передать владение его памятью новому буферу:

    const buffer = new ArrayBuffer(8, { maxByteLength: 32 });

    buffer.resize(16);
    console.log(buffer.byteLength); // 16

    const moved = buffer.transfer(8);
    console.log(moved.byteLength);  // 8
    console.log(buffer.byteLength); // 0: старый буфер отсоединён

Это полезно для кода, который заранее знает верхнюю границу данных, но не их точный размер. `SharedArrayBuffer` получил похожую возможность роста через `grow()` и настройку `maxByteLength`; в отличие от `ArrayBuffer`, его можно только увеличивать, не уменьшать.

## `Promise.withResolvers()`: создать promise и получить его управляющие функции

`Promise.withResolvers()` возвращает объект с тремя полями: `promise`, `resolve` и `reject`. Это удобно, когда promise создаётся в одном месте, а завершается позже — например, при обработке события:

    function createTask() {
        const { promise, resolve, reject } = Promise.withResolvers();
        return { promise, resolve, reject };
    }

    const task = createTask();
    task.resolve('готово'); // вызвать позже, когда задача завершится
    task.promise.then(value => console.log(value)); // готово

До этого для сохранения `resolve` и `reject` приходилось объявлять внешние переменные и присваивать их внутри executor-функции конструктора `Promise`.

## Новый режим `v` для регулярных выражений

Флаг `v` добавляет в символьные классы операции над множествами Unicode: пересечение, исключение и вложенные классы. Это позволяет точнее задавать, какие символы или последовательности нужны:

    const greekLetters = /^[\p{Script_Extensions=Greek}&&\p{Letter}]+$/v;

    console.log(greekLetters.test('λ')); // true

Например, здесь символ должен одновременно относиться к греческому письму и к категории букв. Флаг `v` также позволяет использовать свойства Unicode, значением которых являются целые строки, например некоторые категории emoji.

## Проверка корректности Unicode-строк

Строки JavaScript хранят последовательности кодовых единиц UTF-16, поэтому в них иногда встречаются одиночные суррогаты — половина пары, не образующая корректный Unicode-символ. ES2024 добавил проверку `isWellFormed()` и исправляющую копию `toWellFormed()`:

    const input = 'Ada\uD800';

    console.log(input.isWellFormed()); // false
    console.log(input.toWellFormed()); // Ada�

Это полезно перед передачей строки в системы, которые ожидают корректный Unicode. `toWellFormed()` заменяет некорректные одиночные суррогаты на символ замены `U+FFFD`, не меняя исходную строку.

## `Atomics.waitAsync()`: ждать изменения общей памяти без блокировки потока

`Atomics.wait()` останавливает поток до изменения значения в общей памяти. Новый `Atomics.waitAsync()` вместо этого возвращает результат, который можно дождаться через `await`:

    async function waitForChange(sharedArray) {
        const result = Atomics.waitAsync(sharedArray, 0, 0, 1000);

        if (result.async) {
            return await result.value; // `ok` или `timed-out`
        }

        return result.value; // например, `not-equal`
    }

    const sharedArray = new Int32Array(new SharedArrayBuffer(4));
    waitForChange(sharedArray).then(console.log);

Это нужно прежде всего worker-коду, который синхронизируется через `SharedArrayBuffer`. Ожидание может завершиться уведомлением `Atomics.notify()`, несовпадением ожидаемого значения или тайм-аутом.

## Что проверить при переходе

- Методы `toSorted()`, `toReversed()` и `toSpliced()` возвращают копию, а старые `sort()`, `reverse()` и `splice()` по-прежнему меняют массив на месте.
- `Object.groupBy()` подходит для групп со строковыми или символьными ключами; если ключи — объекты, используйте `Map.groupBy()`.
- Для изменяемых буферов задавайте `maxByteLength` при создании. У `SharedArrayBuffer` расширение доступно только при создании его как `growable`.
- Проверьте поддержку флага `v` в нужной среде выполнения, если приложение запускается на старых браузерах или версиях Node.js.

## Официальные источники

- [Спецификация ECMAScript 2024](https://tc39.es/ecma262/2024/)
- [Array Grouping](https://github.com/tc39/proposal-array-grouping)
- [Resizable and growable ArrayBuffers](https://github.com/tc39/proposal-resizablearraybuffer)
- [RegExp v flag with set notation and properties of strings](https://github.com/tc39/proposal-regexp-v-flag)
- [Promise.withResolvers()](https://github.com/tc39/proposal-promise-with-resolvers)
- [Atomics.waitAsync()](https://github.com/tc39/proposal-atomics-wait-async)
- [Well-Formed Unicode Strings](https://github.com/tc39/proposal-is-usv-string)
