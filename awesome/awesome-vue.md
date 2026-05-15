
### Коллекции

- https://github.com/vuejs/awesome-vue
- https://github.com/sonicoder86/awesome-vue-3
- https://github.com/Cyanhall/awesome-vue
- https://awesome-vue.js.org/resources/official-resources.html
- https://github.com/iampaul83/awesome-vue
- https://github.com/rmjordas/awesome-vue

### Фреймворки; Библиотеки компонент

- **Frappe UI** – UI‑библиотека для Vue 3 от проекта Frappe  
  https://github.com/frappe/frappe-ui  
- **Vuetify** – Material Design component framework для Vue.js  
  https://vuetifyjs.com/ https://github.com/vuetifyjs/vuetify  
- **Quasar** – High‑performance responsive framework для website, PWA & mobile app  
  https://quasar.dev/ https://github.com/quasarframework/quasar  
- **PrimeVue** – Rich set of open source UI components  
  https://primevue.org/ https://github.com/primefaces/primevue  
- **Element Vue 3 UI** library, основанная на Element UI  
  https://element-plus.org/ https://github.com/element-plus/element-plus  
- **Naive UI** – Vue 3 component library с полной кастомизацией  
  https://www.naiveui.com/en-US/os-theme https://github.com/tusen-ai/naive-ui  
- **Ant Design Vue** – Enterprise‑class UI design language  
  https://antdv.com/components/overview https://github.com/vueComponent/ant-design-vue  
- **BootstrapVue** – Bootstrap components для Vue.js  
  https://bootstrap-vue.org/ https://github.com/bootstrap-vue/bootstrap-vue  
- **Chakra UI Vue** – Simple, modular and accessible component library  
  https://vue.chakra-ui.com/ https://github.com/chakra-ui/chakra-ui-vue  
- **Flowbite Vue** – Vue components, построенные на Tailwind CSS  
  https://flowbite.com/docs/components/vue/index.html/ https://github.com/themesberg/flowbite  
- **Equal UI** – Vue UI component library, построенная на Tailwind CSS  
  https://equal-ui.github.io/Equal/ https://github.com/Equal-UI/Equal  
- **Buefy** – Lightweight UI components, основанные на Bulma  
  https://buefy.org/ https://github.com/buefy/buefy  
- **Vue Material** – Material Design для Vue.js  
  https://vuematerial.io/ https://github.com/vuematerial/vue-material  
- **Vant** – Lightweight mobile UI library  
  https://youzan.github.io/vant/ https://github.com/youzan/vant  
- **VuiKit** – Vue components на базе UIKit framework  
  https://vuikit.js.org/ https://github.com/vuikit/vuikit  
- **Vuestic UI** – Vue 3 UI framework с кастомизацией  
  https://ui.vuestic.dev/ https://github.com/epicmaxco/vuestic-ui  
- **Nuxt UI** – Fully styled и customizable components для Nuxt  
  https://ui.nuxt.com/ https://github.com/nuxt/ui  
- **Headless UI** – Unstyled, fully accessible UI components (Tailwind)  
  https://headlessui.com/ https://github.com/tailwindlabs/headlessui  

### Полезные ссылки

- Список UI библиотек https://ui-libs.vercel.app/

### Библиотеки

- Таблицы
    - vxe-table https://gitee.com/xuliangzhan_admin/vxe-table https://github.com/x-extends/vxe-table/tree/master
- Формы
    - Vueform — open-source form framework для Vue.js: рендеринг, валидация и обработка форм, 25+ элементов, вложенные и повторяющиеся элементы, Tailwind-темизация, 50+ валидаторов, условная логика, form steps, i18n и drag-and-drop form builder. https://vueform.com https://github.com/vueform/vueform
- Сплиттеры
    - https://antoniandre.github.io/splitpanes/
- Чаты
    - MChat - библиотека компонентов чата на Vue.js, которая предоставляет базовые компоненты для быстрой разработки веб-чатов с возможностью расширения функциональности. https://gitee.com/july-meteor/vue-mchat
- Админки
    - https://github.com/vbenjs/vue-vben-admin

### Слайдеры

- https://github.surmon.me/vue-awesome-swiper

### Термины

- composables - это логика повторного использования, которая позволяет группировать и использовать повторяющиеся функциональные части вашего кода во всём приложении Vue.

### Учебники

- учебник по Vue https://ru.vuejs.org/tutorial/

### Блоги

- https://webdevblog.ru/
- https://skibardin.ru/category/vue3/

### Статьи

- Основное
    - Vue 3.4 Новая механика v-model компонента https://webdevblog.ru/vue-3-4-novaya-mehanika-v-model-komponenta/
    - Как принудительно пере-отобразить (re-render) компонент Vue https://webdevblog.ru/kak-prinuditelno-pere-otobrazit-re-render-komponent-vue/
    - Анонс Vue 3.4 https://webdevblog.ru/anons-vue-3-4/
    - Vue 3 под капотом и тонкости Composition API: Reactivity, Provide/Inject, Suspense — разбор внутренних механизмов Vue 3: реактивность на `Proxy`, `ref`, `reactive`, `computed`, `watch`, `customRef`, паттерны `provide/inject`, работа `Suspense` с асинхронными компонентами и практические нюансы Composition API. https://habr.com/ru/articles/870986/
- Реактивность
    - Vue 3: Почему `ref()` — это новая ссылка, а `reactive()` — обёртка? — разбор различий `ref()` и `reactive()` в Composition API: `.value`, `Proxy`, ссылочная семантика объектов, отсутствие копирования в `reactive()`, ошибки со сбросом форм и эталонными объектами. https://habr.com/ru/articles/920186/
    - Реактивность в Vue 3: `watch`, `watchEffect` и продвинутые техники — обзор системы реактивности Vue 3 через `Proxy`, сравнение `watch` и `watchEffect`, deep/immediate watchers, наблюдение за несколькими источниками, cleanup асинхронных эффектов, отладка и оптимизация производительности. https://skibardin.ru/reaktivnost-vue3-watch-watcheffect-prodvinutye-tehniki/
    - ReactiveEffect во Vue 3: что на самом деле исполняет вашу реактивность — разбор внутреннего исполнения реактивности Vue 3: `dep`, `track()`/`trigger()`, структура `target -> key -> dep`, жизненный цикл `ReactiveEffect`, `scheduler`, `stop()`, связь с `watchEffect`, `watch`, `computed`, render effect и `trackOpBits`. https://habr.com/ru/articles/996880/
- SFC
    - `<script setup>` | Vue.js — официальная русскоязычная документация по синтаксису `<script setup>` в однофайловых компонентах Vue: top-level bindings в шаблоне, `defineProps`, `defineEmits`, `defineModel`, `defineExpose`, `defineOptions`, `defineSlots`, TypeScript и ограничения макросов компилятора. https://ru.vuejs.org/api/sfc-script-setup
- Teleport
    - Understanding Vue Teleport — короткое введение в Vue 3 Teleport: зачем выносить содержимое компонента в другое место DOM-дерева, типичный сценарий с модальным окном, условный Teleport через `v-if`, несколько target-узлов и польза для переиспользования, доступности и модульности. https://kaperskyguru.medium.com/understanding-vue-teleport-cfbc77a93b79
    - Teleport | Vue.js — официальная документация Vue 3 по встроенному компоненту `<Teleport>`: рендеринг части шаблона в другом DOM-узле через `to`, отключение переноса через `disabled`, работа нескольких Teleport в одну цель и отложенный Teleport. https://vuejs.org/guide/built-ins/teleport.html
    - Vue Teleport: как работает — разбор встроенного компонента Vue 3 `<Teleport>`: связь с Virtual DOM и `vnode`, атрибуты `to`, `disabled` и `defer`, пример модального окна с фокусом, доступностью, блокировкой прокрутки, SSR-гидрацией и тестами через `@vue/test-utils`. https://habr.com/ru/companies/otus/articles/922610/
- Suspense
    - Suspense | Vue.js — официальная русскоязычная документация Vue 3 по экспериментальному встроенному компоненту `<Suspense>`: ожидание асинхронных зависимостей в дереве компонентов, слоты `#default` и `#fallback`, события `pending`, `resolve`, `fallback`, вложенные Suspense и совместная работа с `RouterView`, `Transition` и `KeepAlive`. https://ru.vuejs.org/guide/built-ins/suspense
- Nuxt
    - Контекст в Vue/Nuxt: осознать, не терять и беречь https://habr.com/ru/articles/812145/
- JWT
    - Vue.js + Vuex — JWT аутентификация (руководство и примеры) https://emackovenko.ru/vue-js-vuex-jwt-autentifikaciya-instrukciya-prime/
- Redux
    - How We Use Redux & Redux-Observable with Vue (v3.0 Journal) https://snipcart.com/blog/redux-vue
    - Redux vs Vuex for state management in Vue.js https://agilno.com/blog/redux-vs-vuex-for-state-management-in-vue-js/
- Примеры приложений
    - Building an LLM chat interface using Ollama and Vue https://medium.com/@mpalmerlee/building-an-llm-chat-interface-using-ollama-and-vue-5bf4e2fc65fd
    - Создание анонимного чата в Telegram: Бот с MiniApp интерфейсом. Часть 2 — VueJS3 + Centrifugo с монетизацией приложения https://habr.com/ru/companies/amvera/articles/893250/

### Видео

- Примеры приложений
    - Vue 3 для начинающих / Разработка интернет-магазина Vue Sneakers https://www.youtube.com/watch?v=U_-Ht_v-oAs
- Vite
    - Visual Guide to the Modern Frontend Toolchain (Vite) https://www.youtube.com/watch?v=M_edImKoEt8
- Курсы, Обучающие видео
    - The Ultimate Vue 3 Tutorial (100% Composition API) https://www.youtube.com/watch?v=I_xLMmNeLDY
    - Master Vue.js Composition API: Build 10 Stunning Projects for Real-world Expertise! https://www.youtube.com/watch?v=pgWZLS75Nmo
    - Vue 101 Crash Course: Learn Vue JS (6 HOURS!) + Build Your First Project | Zero To Mastery https://www.youtube.com/watch?v=IgBOT0QyByQ
    - Vue 3 Tutorial - Full Course 10 Hours 10 apps https://www.youtube.com/watch?v=e-E0UB-YDRk
    - Архитектура больших Vue-приложений и лучшие практики // Демо-занятие курса «Vue.js разработчик» https://www.youtube.com/watch?v=4svekvtxYJs
- https://www.youtube.com/c/LachlanMiller

### Книги

- https://lachlan-miller.me/design-patterns-for-vuejs
- https://rethinking-reusability-in-vue.alexvipond.dev/

### Курсы

- https://www.vuemastery.com/courses/
- https://vueschool.io/courses
- https://michaelnthiessen.com/
- https://frontendmasters.com/learn/vue/
- https://www.udemy.com/topic/vue-js/
- https://adamwathan.me/advanced-vue-component-design/
- https://www.youtube.com/watch?v=I_xLMmNeLDY
