## Как отключить темную тему (dark mode)

### Способ 1

Есть способ отключить темный режим в ваших шаблонах электронной почты. Вам нужно добавить эти два мета-тега в ваш HTML:

```html
<meta name="color-scheme" content="light">
<meta name="supported-color-schemes" content="light">
```

Новые браузеры, которые распознают темный режим, смогут использовать это, поэтому электронное письмо будет отображаться так, как раньше. Автоматической перезаписи стиля таким образом быть не должно.

Если вы хотите добавить темный режим, чтобы перезаписать свои стили светлого режима, добавьте их следующим образом, что я и рекомендую:

```html
<meta name="color-scheme" content="light dark">
<meta name="supported-color-schemes" content="light dark">
<style>
@media (prefers-color-scheme: dark) {
  /* Dark mode styles */
}
</style>
```

Ваши встроенные стили останутся, но опять же, новые почтовые клиенты смогут распознавать разделы style и media. Старые почтовые клиенты будут игнорировать это.

## Рендринг для почтовых клиентов

К сожалению, когда дело доходит до EDMs (прямая электронная почта), Outlook - ваш злейший враг. Некоторые версии не учитывают заполнение, когда содержимое ячейки определяет размеры ячейки.

Подход, который даст вам наиболее согласованный результат во всех почтовых клиентах, заключается в использовании пустых ячеек таблицы в качестве заполнения (я знаю, ужас), но не забудьте заполнить эти таблицы пустым изображением желаемых размеров, потому что, как вы уже догадались, некоторые версии Outlook не учитывают объявления высоты / ширины пустых ячеек.

Разве EDM не забавны? (Нет. Это не так.)

- https://www.emailonacid.com/blog/article/email-development/spacing-techniques-in-html-email/
- https://maool.com/html-email-tips-and-tricks/outlook/
- https://sendpulse.com/ru/blog/html-coding-for-email

## Base64 Encode of 1x1px Transparent GIF

На всякий случай, если он вам понадобится. Вы можете растянуть его, чтобы заполнить пространство по мере необходимости.

```html
<img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7">
```

Или черного:

```html
<img src="data:image/gif;base64,R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=">
```
