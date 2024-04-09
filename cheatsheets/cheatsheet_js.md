### ES что было введено

- [](https://miro.medium.com/v2/resize:fit:720/format:webp/1*4zyZPa1uSiD-SU7qzaGPAQ.png)

## Nodejs

1. Чтение содержимого файла:

```javascript
const fs = require('fs');

try {
  const data = fs.readFileSync('путь_к_файлу', 'utf8');
  console.log(data);
} catch (err) {
  console.error(err);
}
```

2. Запись в файл:

```javascript
const fs = require('fs');

const content = 'Текст, который нужно записать в файл';

try {
  fs.writeFileSync('путь_к_файлу', content, 'utf8');
  console.log('Файл успешно записан.');
} catch (err) {
  console.error(err);
}
```

3. Создание новой директории:

```javascript
const fs = require('fs');

try {
  fs.mkdirSync('путь_к_директории');
  console.log('Директория успешно создана.');
} catch (err) {
  console.error(err);
}
```

4. Проверка наличия файла или директории:

```javascript
const fs = require('fs');

const exists = fs.existsSync('путь_к_файлу_или_директории');

if (exists) {
  console.log('Файл или директория существуют.');
} else {
  console.log('Файл или директория не существуют.');
}
```

5. Удаление файла:

```javascript
const fs = require('fs');

try {
  fs.unlinkSync('путь_к_файлу');
  console.log('Файл успешно удален.');
} catch (err) {
  console.error(err);
}
```

6. Переименование файла:

```javascript
const fs = require('fs');

try {
  fs.renameSync('старое_имя_файла', 'новое_имя_файла');
  console.log('Файл успешно переименован.');
} catch (err) {
  console.error(err);
}
```

Синхронное копирование файла:

```javascript
const fs = require('fs');

const sourceFile = 'путь_к_исходному_файлу';
const destinationFile = 'путь_к_файлу_назначения';

try {
  fs.copyFileSync(sourceFile, destinationFile);
  console.log('Файл успешно скопирован.');
} catch (err) {
  console.error(err);
}
```
