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
### Удаление
### Изменение
### Циклы
### Фильтрация

## Sets (множества)

### Добавление, Создание

```python
GEEK = {'g', 'e', 'k'}
```

### Удаление

```python
s.remove(value)

set1 = {0,1,2,3}
set2 = {2,3,4,5}

set1 - set2  # {0, 1}
set2 - set1  # {4, 5}
```

### Изменение

```python
GEEK.add('s')

s.update(set2)
s.update(list)
```

### Циклы

```python

```

### Фильтрация

```python

```
