# python шпора

## Виртуальная среда(venv)

env - название

```bash
python -m venv env
source env/bin/activate
# Установка зависимостей
pip install -r requirements.txt
```

## Lists (списки)

### Добавление, Создание

```python
list.append(value)
```

### Удаление

```python
list.remove(value)
a.pop(1)
del a[-1]
del a[2:4]
```

### Проврека

```python
value in list
list.index(value)
```

- https://stackoverflow.com/questions/7571635/fastest-way-to-check-if-a-value-exists-in-a-list

### Изменение

```python
list.insert(index, value)

list(map(lambda x: x.replace('Pant', 'Ishan'), list))
```

### Циклы

```python
for x in thislist:
  print(x)
 
for i in range(len(thislist)):
  print(thislist[i])
  
for i, v in enumerate(a):
  print(i, v)
  
[print(x) for x in thislist]
```

### Фильтрация

```python
list(filter(lambda age: age >= 18, ages))

[age for age in ages if age >= 18]
```

- https://www.codingem.com/python-filter-lists/

## Dictionaries (словари)

### Добавление, Создание

```python
dict[key] = value

data = {'a': 1, 'b': 2, 'c': 3}
# OR
data = dict(a=1, b=2, c=3)
# OR
data = {k: v for k, v in (('a', 1), ('b',2), ('c',3))}

data = dict(zip(list_with_keys, list_with_values))
```

- https://stackoverflow.com/questions/1024847/how-can-i-add-new-keys-to-a-dictionary

### Удаление

```python
del data[key]  # Removes specific element in a dictionary
data.pop(key)  # Removes the key & returns the value
data.clear()  # Clears entire dictionary
```

### Проверка

```python
key in data
```

### Изменение

```python
# merge - Python 3.5+:
data = {**data1, **data2, **data3}
# merge - Python 3.9+:
data = data1 | {'c':3,'d':4}

data['a'] = 1  # Updates if 'a' exists, else adds 'a'
# OR
data.update({'a': 1})
# OR
data.update(dict(a=1))
# OR
data.update(a=1)

data |= {'c':3,'d':4}
```

### Циклы

```python
for key in data: # Iterates just through the keys, ignoring the values
for key, value in d.items(): # Iterates through the pairs
for key in d.keys(): # Iterates just through key, ignoring the values
for value in d.values(): # Iterates just through value, ignoring the keys
```

### Фильтрация

## Tuples (кортежи)

### Добавление, Создание

```python
# Создание пустого кортежа
empty_tuple = ()

# Создание кортежа с элементами
my_tuple = (1, 2, 3, 'apple', 'banana')
```

### Удаление

```python
my_tuple = (1, 2, 3)
del my_tuple
# Теперь my_tuple не существует
```

```python
original_tuple = (1, 2, 3, 'apple', 'banana')

# Создаем новый кортеж без элемента 'apple'
new_tuple = tuple(item for item in original_tuple if item != 'apple')

print(new_tuple)
```

### Изменение

```python
original_tuple = (1, 2, 3)
new_tuple = original_tuple + (4, 5)
print(new_tuple)
```

```python
original_tuple = (1, 2, 3)
modified_tuple = original_tuple[:2] + (4,) + original_tuple[3:]
print(modified_tuple)
```

### Циклы

```python
my_tuple = (1, 2, 3, 'apple', 'banana')
for item in my_tuple:
    print(item)
```

### Фильтрация

```python
numbers = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
even_numbers = tuple(filter(lambda x: x % 2 == 0, numbers))
print(even_numbers)
```

## Sets (множества)

### Добавление, Создание

```python
GEEK = {'g', 'e', 'k'}

set([frozenset([1,2]), frozenset([2,3])])
```

### Удаление

```python
s.remove(value)

set1 = {0,1,2,3}
set2 = {2,3,4,5}

set1 - set2  # {0, 1}
set2 - set1  # {4, 5}
```

### Проверка

```python
'a' in a_set

set([2]) in s

>>> k
{'ip': '123.123.123.123', 'pw': 'test1234', 'port': 1234, 'debug': True}
>>> set('ip,port,pw'.split(',')).issubset(set(k.keys()))
True
>>> set('ip,port,pw'.split(',')) in set(k.keys())
False
```

### Изменение

```python
GEEK.add('s')

s.update(set2)
s.update(list)
```

### Циклы

```python
for val in test_set:
    print(val)

for counter, item in enumerate(my_set):
    print(item)

for item in iter(my_set):
    print(item)
    
i = 0
while i < len(my_list):
  print(my_list[i])
  i = i + 1
```

### Фильтрация

```python
original_set = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

# Фильтрация только четных чисел
even_numbers = {num for num in original_set if num % 2 == 0}

print(even_numbers)
```

## Flask

### Минимальное приложение

```python
from flask import Flask, render_template
app = Flask(__name__)

@app.route('/')
def index():
   return render_template('index.html')

if __name__ == '__main__':
   app.run()
```

## SQLAchimetry

### INSERT one

```python
newToner = Toner(toner_id = 1,
                    toner_color = 'blue',
                    toner_hex = '#0F85FF')

dbsession.add(newToner)   
dbsession.commit()
```

### INSERT multiple

```python
newToner1 = Toner(toner_id = 1,
                    toner_color = 'blue',
                    toner_hex = '#0F85FF')

newToner2 = Toner(toner_id = 2,
                    toner_color = 'red',
                    toner_hex = '#F01731')

dbsession.add_all([newToner1, newToner2])   
dbsession.commit()
```

### UPDATE

```python
q = dbsession.query(Toner)
q = q.filter(Toner.toner_id==1)
record = q.one()
record.toner_color = 'Azure Radiance'

dbsession.commit()
```

or using a fancy one-liner using MERGE

```python
record = dbsession.merge(Toner( **kwargs))
```

## SQLAlchemy

### Получение данных

```python
from sqlalchemy import create_engine, Column, Integer, String, select
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import Session

# Создаем объект для работы с базой данных (в данном случае, используем SQLite в памяти)
engine = create_engine('sqlite:///:memory:', echo=True)

# Создаем базовый класс для определения модели данных
Base = declarative_base()

# Определяем модель данных (в данном случае, таблицу 'users')
class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True)
    name = Column(String)
    age = Column(Integer)

# Создаем таблицу в базе данных
Base.metadata.create_all(engine)

# Создаем сессию для взаимодействия с базой данных
with Session(engine) as session:
    # Добавляем несколько записей в таблицу 'users'
    session.add_all([
        User(name='Alice', age=25),
        User(name='Bob', age=30),
        User(name='Charlie', age=22)
    ])

    # Выполняем SELECT запрос для выборки данных из таблицы 'users'
    stmt = select(User)
    result = session.execute(stmt)

    # Получаем результаты запроса
    users = result.fetchall()

    # Выводим результаты
    for user in users:
        print(f"User ID: {user.id}, Name: {user.name}, Age: {user.age}")

```

## Файловая система

### Получить отсортированнные файлы

```python
import glob
import os
dir_name = '/home/user/dir'
# Get list of all files in a given directory sorted by name
list_of_files = sorted( filter( os.path.isfile,
                        glob.glob(dir_name + '*') ) )
# Iterate over sorted list of files and print the file paths 
# one by one.
for file_path in list_of_files:
    print(file_path)
```

