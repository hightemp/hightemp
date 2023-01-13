# python шпора

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
### Удаление
### Изменение
### Циклы
### Фильтрация

## Sets (множества)

### Добавление, Создание
### Удаление
### Изменение
### Циклы
### Фильтрация
