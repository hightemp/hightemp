# Vue3: импорт и регистрация компонентов в Composition API

Источник: [Организация компонентов - Guide v2 — Vue.js](https://vuejs.org/v2/guide/components.html#Organizing-Components)

## Использование компонентов

Значения в области `<script setup>` также могут быть использованы непосредственно в качестве имен пользовательских тегов компонентов:

```javascript
<script setup>
import MyComponent from './MyComponent.vue'
</script>

<template>
  <MyComponent />
</template>
```

Думайте о `MyComponent` как о переменной. Если вы использовали JSX, то здесь ментальная модель схожа. Kebab-case эквивалент `<my-component>` также работает в шаблоне - однако регистрация компонентов в PascalCase наилучшим образом для поддержания последовательности. Это также помогает отличить от собственных пользовательских элементов.

## Динамические компоненты

Поскольку компоненты ссылаются как переменные, а не регистрируются под строковыми ключами, мы должны использовать динамическую привязку `:is` при использовании динамических компонентов внутри `<script setup>`:

```javascript
<script setup>
import Foo from './Foo.vue'
import Bar from './Bar.vue'
</script>

<template>
  <component :is="Foo" />
  <component :is="someCondition ? Foo : Bar" />
</template>
```

Обратите внимание, как компоненты могут быть использованы как переменные в тернарном выражении.

## Рекурсивные компоненты

SFC (однофайловые компоненты) могут неявно ссылаться на себя через имя файла. Например, файл с именем `FooBar.vue` может ссылаться на себя как `<FooBar/>` в своём шаблоне.

Обратите внимание, что это имеет более низкий приоритет, чем импортированные компоненты. Если у вас есть именованный импорт, который конфликтует с выведенным именем компонента, его можно переименовать через алиас:

```javascript
import { FooBar as FooBarChild } from './components'
```

## Компоненты с пространством имён

Вы можете использовать теги компонентов с точками, например, `<Foo.Bar>`, чтобы обращаться к компонентам, вложенным в свойства объекта. Это полезно, когда вы импортируете несколько компонентов из одного файла:

```javascript
<script setup>
import * as Form from './form-components'
</script>

<template>
  <Form.Input>
    <Form.Label>label</Form.Label>
  </Form.Input>
</template>
```

## Ленивая загрузка компонентов

В `<script setup>` вы можете просто лениво загружать компоненты:

```javascript
<script setup>
import { defineAsyncComponent } from 'vue'
const MyComponent = defineAsyncComponent(() => import('./MyComponent.vue'))
</script>

<template>
  <MyComponent />
</template>