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