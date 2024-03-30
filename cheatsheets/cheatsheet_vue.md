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


### Custom Directives

В скриптовой настройке вы можете определить пользовательскую директиву, просто дав ей имя в camelCase, начинающееся с `v`:

```html
<script setup>
const vRedBackground = {
  mounted: (el) => el.style.background = 'red',
}
</script>

<template>
  <input v-red-background />
</template>
```

С использованием API Опции:

```javascript
export default {
  setup() {
    // ...
  },
  directives: {
    redBackground: {
      mounted: (el) => el.style.background = 'red',
    },
  },
}
```

Регистрация директивы глобально:

```javascript
const app = createApp({})

// делаем `v-focus` доступным во всех компонентах
app.directive('redBackground', {
  mounted: (el) => el.style.background = 'red',
})
```

И поскольку очень часто возникает ситуация, когда логика для хуков `mounted` и `updated` одинакова, мы можем использовать функцию вместо объекта, которая будет выполняться для обоих:

```html
<script setup>
const vRedBackground = (el) => el.style.background = 'red';
</script>

<template>
  <input v-red-background />
</template>
```

### Deep Linking с Vue Router

Вы можете сохранить (частичное) состояние в URL, позволяющее перейти прямо к определенному состоянию на странице.

Например, вы можете загрузить страницу, где уже выбран фильтр диапазона даты:

`someurl.com/edit?date-range=last-week`

Это отлично подходит для частей вашего приложения, где пользователи могут делиться ссылками, а также для серверно-рендерингового приложения или для передачи большего объема информации между двумя приложениями, чем обычная ссылка.

Вы можете сохранить фильтры, значения поиска, открытые/закрытые модальные окна или позицию прокрутки в списке, что идеально подходит для бесконечной пагинации.

Получение значения запроса с помощью Vue Router работает так (это будет работать во многих фреймворках Vue, таких как Nuxt и Vuepress):

```javascript
// Composition API
const dateRange = useRoute().query.dateRange;

// Options API
const dateRange = this.$route.query.dateRange;
```

Чтобы изменить его, используйте компонент RouterLink и обновите запрос:

```html
<RouterLink :to="{
  query: {
    dateRange: newDateRange
  }
}">
```

### Деструктуризация в v-for

Вы знали, что можно использовать деструктуризацию в `v-for`?

```html
<li v-for="{ name, id } in users" :key="id">
  {{ name }}
</li>
```

Также известно, что можно получить индекс из `v-for`, используя кортеж:

```html
<li v-for="(movie, index) in [
  'Lion King',
  'Frozen',
  'The Princess Bride'
]">
  {{ index + 1 }} - {{ movie }}
</li>
```

Когда используется объект, можно также получить ключ:

```html
<li v-for="(value, key) in {
  name: 'Lion King',
  released: 2019,
  director: 'Jon Favreau',
}">
  {{ key }}: {{ value }}
</li>
```

Можно объединить эти два способа, получив и ключ, и индекс свойства:

```html
<li v-for="(value, key, index) in {
  name: 'Lion King',
  released: 2019,
  director: 'Jon Favreau',
}">
  #{{ index + 1 }}. {{ key }}: {{ value }}
</li>
```

### Глобальные компоненты

При регистрации компонента глобально вы можете использовать его в любом шаблоне без необходимости импорта:

```javascript
// Vue 3
import { createApp } from 'vue';
import GlobalComponent from './GlobalComponent.vue';

const app = createApp({});
app.component('GlobalComponent', GlobalComponent);
```

В Vue 2 глобальные компоненты регистрируются так:

```javascript
// Vue 2
import Vue from 'vue';
import GlobalComponent from './GlobalComponent.vue';

Vue.component('GlobalComponent', GlobalComponent);
```

Теперь вы можете использовать `GlobalComponent` в ваших шаблонах без дополнительных действий! Конечно, глобально зарегистрированные компоненты имеют свои преимущества и недостатки, поэтому используйте их с умеренностью.

### Ожидание обновления DOM с помощью nextTick

Vue предоставляет удобный способ ожидать завершения обновления DOM:

```javascript
// Выполните действие, которое приведет к повторному рендерингу Vue
changeTheDOM();

// Ожидайте завершения повторного рендеринга
await nextTick();

// Теперь можно проверить вновь созданный DOM
inspectTheDOM();
```

Если вы используете Options API, то код будет выглядеть так:

```javascript
await this.$nextTick();
```

"Тик" - это один цикл обновления. Сначала Vue слушает все изменения реактивности, затем производит обновления DOM в одной пакетной операции. Затем начинается следующий "тик".

Если вы внесли изменения в приложение, которые должны изменить отображение, необходимо дождаться следующего "тика", чтобы эти изменения отобразились.

### Упрощенный способ передачи множества пропов

Вместо передачи множества пропов в компонент по отдельности:

```html
<template>
  <User
    :name="user.name"
    :profile="user.profile"
    :twitter="user.twitter"
    :location="user.location"
    :framework="user.framework === 'Vue' ? 'Number one' : 'Number two'"
  />
</template>
```

Можно взять целый объект и автоматически привязать все его свойства к компоненту в качестве пропов:

```html
<template>
  <User v-bind="user" />
</template>

<script setup>
import User from './User.vue';

const user = {
  name: 'Anakin',
  profile: 'ani-profile.jpg',
  twitter: '@TatooineJedi',
  location: 'Undisclosed',
  framework: 'Vue',
};
</script>
```

### Vue to Web Component in 3 Easy Steps

Вот как можно создать веб-компоненты в Vue.

1. Создайте пользовательский элемент из компонента Vue с помощью `defineCustomElement`:

```javascript
import { defineCustomElement } from 'vue';
import MyVueComponent from './MyVueComponent.vue';

const customElement = defineCustomElement(MyVueComponent);
```

2. Зарегистрируйте пользовательский элемент в DOM:

```javascript
customElements.define('my-vue-component', customElement);
```

3. Используйте пользовательский элемент в HTML:

```html
<html>
<head></head>
<body>
<my-vue-component></my-vue-component>
</body>
</html>
```

Теперь у вас есть пользовательский веб-компонент, который не требует фреймворка и может работать нативно в браузере! Дополнительные подробности можно найти в документации.