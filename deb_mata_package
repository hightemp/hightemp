# Мета пакеты

Подобный метапакет можно создать с помощью инструмента под названием equivs который создаст пакет только с информацией о зависимости.

Сначала создайте каталог:

```
mkdir my-metapackage
cd my-metapackage/
```

Теперь запустите программу:

```
equivs-control ns-control
```

Он создаст файл с именем ns-control, откройте этот файл в текстовом редакторе. Генерируемый вами управляющий файл должен иметь Dependsили же Recommendsстроки изменены в зависимости от пакетов, которые вы хотите установить:

```
Section: misc
Priority: optional
Standards-Version: 3.9.1

Package: my-metapackage
Version: 1.0   
Depends: openssh-server, gedit
Description: This package installes an ssh server and a text editor
 The Long description of this package ends with a newline!
```

(Просто пример, вы должны включить больше информации)

И, наконец, соберите пакет, запустив

```
equivs-build ns-control
```

Ваша посылка находится по адресу my-metapackage/my-metapackage_1.0_all.deb.

Если вы хотите также создать исходный пакет, --fullопция может быть передана equivs-build, например equivs-build --full ns-control. Это будет использовать debuild, а также создавать файлы .dsc и .tar.gz.

Чтобы создать исходный файл .changes, который можно загрузить в PPA, извлеките и соберите исходный пакет с помощью

```
dpkg-source -x my-metapackage_1.0.dsc
cd my-metapackage-1.0
debuild -S
```

Если мейнтейнер, который вы установили в ns-control, соответствует вашему ключу GPG, он должен создать и подписать файл my-metapackage_1.0_source.changes, чтобы вы могли отправить его в свой PPA.
