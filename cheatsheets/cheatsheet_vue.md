### Следующий тик: Ожидание обновления DOM

Vue предоставляет нам удобный способ подождать, пока DOM завершит обновление:

```javascript
// Выполните действие, которое заставит Vue перерисовать
changeTheDOM();
// Ожидание завершения перерисовки
await nextTick();
// Теперь мы можем проверить только что обновленный DOM
inspectTheDOM();
```

Или, если вы используете Options API:

```javascript
await this.$nextTick();
```

Тик представляет собой один цикл отрисовки. Сначала Vue слушает любые изменения реактивности, затем выполняет несколько обновлений DOM пакетом. Затем начинается следующий тик.
Если вы обновляете что-то в своем приложении, что изменит то, что отображается, вам нужно подождать до следующего тика, прежде чем эти изменения будут видны.

### Private properties with script setup

```javascript
export default {
  expose: ['makeItPublic'],
  data() {
    return {
      privateData: 'Keep me a secret!',
    };
  },
  computed: {
    makeItPublic() {
      return this.privateData.toUpperCase();
    },
  },
};
```

```vue
<script setup>
import { ref, computed, defineExpose } from 'vue';

const privateData = ref('Keep me a secret!');
const makeItPublic = computed(() => privateData.value.toUpperCase());

// We don't need to import this because it's a compiler macro
defineExpose({ makeItPublic });
</script>

```

### Функции h и Render
При использовании функции **render** вместо шаблонов, вы будете часто использовать функцию **h**:

```html
<script setup>
import { h } from 'vue';
const render = () => h('div', {}, 'Hello Wurld');
</script>
```

С **Options API**, функция **render** работает точно так же, просто немного иначе определяется:

```html
<script>
import { h } from 'vue';
export default {
  render() {
    return h('div', {}, 'Hello Wurld');
  }
}
</script>
```

Она создает VNode (виртуальный узел), объект, который Vue внутренне использует для отслеживания обновлений и того, что он должен отрисовывать.

Первый аргумент - это имя элемента HTML или компонент (который может быть асинхронным, если вы хотите):

```html
<script setup>
import { h } from 'vue';
import MyComponent from './MyComponent.vue';
const render = () => h(MyComponent, {}, []);
</script>
```

#### 5 Забытых особенностей

Второй аргумент - это список свойств, атрибутов и обработчиков событий:

```html
<script setup>
import { h } from 'vue';
import MyComponent from './MyComponent.vue';
const render = () => h(MyComponent, {
  class: 'text-blue-400',
  title: 'Компонент - великий',
  onClick() {
    console.log('Кликнули!');
  },
}, []);
</script>
```

Третий аргумент - это либо строка для текстового узла, массив дочерних VNodes, либо объект для определения слотов:

```html
<script setup>
import { h } from 'vue';
import MyComponent from './MyComponent.vue';
const render = () => h(MyComponent, {}, [
  'Простой текстовый узел',
  h('span', {}, 'Текст внутри элемента <span>'),
]);
</script>
```

Эти функции **render** по сути то, что происходит "под капотом", когда Vue компилирует ваши компоненты с одиночным файлом для выполнения в браузере.

Но, написав функцию **render** самостоятельно, вы больше не ограничены тем, что можно сделать в шаблоне. У вас есть полная мощь JavaScript у вас на пальцах.

Это только малая часть того, что могут сделать функции **render** и **h**. Прочтите больше об этом онлайн.

### Директивы в функциях рендеринга

Vue поставляется со специальными методами, которые помогают вам использовать пользовательские директивы на ваших узлах VNodes:

```javascript
<script setup>
import { resolveDirective, withDirectives, h } from 'vue';
// Найдите уже зарегистрированную директиву по имени
const focusDirective = resolveDirective('focus');
// Оберните кнопку директивой
const render = () => withDirectives(
  h('button', {}, []),
  // Массив директив для применения
  [
    [focusDirective]
  ]
);
</script>
```

Функции рендеринга определяются немного по-другому при использовании API Опций:

```javascript
import { resolveDirective, withDirectives, h } from 'vue';
export default {
  render() {
    // Найдите уже зарегистрированную директиву по имени
    const focusDirective = resolveDirective('focus');
    // Оберните кнопку директивой
    return withDirectives(
      h('button', {}, []),
      // Массив директив для применения
      [
        [focusDirective]
      ]
    );
  }
}
```

Дополнительную информацию о использовании `withDirectives` вы можете найти в документации.