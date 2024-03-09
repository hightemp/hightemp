# Как установить LDAP сервер и его клиентов.

Оригинал на английском: [ссылка 1](http://www.debuntu.org/ldap-server-and-linux-ldap-clients), [ссылка 2](http://www.debuntu.org/ldap-server-and-linux-ldap-clients-p2)

Сервер LDAP (Lightweight Directory Access Protocol) позволяет централизовать управление пользователями, группами, доменами, аутентификацией, хранением информации.

Используя LDAP в локальной сети, вы можете позволить своим пользователям подключаться и проходить аутентификацию на любом компьютере, входящем в вашу локальную сеть.

Это руководство разделено на 2 части. В первой части я опишу, как установить, сконфигурировать LDAP сервер, добавить нескольких пользователей и групп. Во второй части мы настроим Linux-клиента для аутентификации через LDAP, если пользователь не существует на локальном компьютере.

В этом туториале я рассчитываю на то, что наш LDAP сервер расположен по адресу 192.168.1.4. Все машины в сети могут распознавать сетевое имя "ldap" как IP-адрес 192.168.1.4. LDAP сервер предназначен для управления доменом debuntu.local. Сервер работает под Debian 4 (тестируемый, но почти стабильный), а клиентская машина - под Ubuntu Fiesty 7.04

## 1. LDAP сервер

### 1.1 Установка

Чтобы наш LDAP сервер заработал, мы должны установить несколько пакетов:

```bash
# apt-get install slapd ldap-utils migrationtools
```

Ответьте на все заданные при их установке вопросы, а затем переконфигурируйте slapd, чтобы заставить dpkg задать нам немного больше вопросов:

```bash
# dpkg-reconfigure slapd
```

При запросе настроек сервера LDAP:

- Пропустить настройку сервера LDAP? ... Нет
- Отключить конфигурацию OpenLDAP server? ... Нет
- Доменное имя DNS: ... debuntu.local
- Название организации: ... Всечтоугодно & Со
- Пароль для admin: XXXXXX
- Подтвердите пароль: XXXXXX
- Настраивается пакет slapd (информация о формате базы ldap): OK
- Выбор формата базы ldap: BDB
- Удалять базу данных при вычистке slapd? ... Нет
- Переместить старую базу данных? ... Да
- Включить протокол LDAPv2? ... Нет

Теперь мы установили домен, а заодно и административную учетную запись "admin".

Теперь вы можете проверить, имеете ли вы доступ к вашему LDAP-серверу, выполнив следующую команду в консоли:

```bash
$ ldapsearch -x -b dc=debuntu,dc=local
```

Если вы получили сообщение об ошибке, похожее на "ldap_bind: Can't contact LDAP server (-1)", это означает, что ваш сервер не запущен. Вы можете запустить его с помощью команды:

```bash
# /etc/init.d/slapd start
```

Теперь наш сервер готов для идентификации наших пользователей. Давайте перейдем к заполнению базы.

### 1.2. Заполнение базы

Используя migrationtools, мы получаем возможность быстро импортировать всех существующих пользователей и групп с локальной системы в LDAP.

```bash
# cd /usr/share/migrationtools/
```

Нам необходимо отредактировать дефолтовый конфигурационный файл migrationtools, имеющий имя migrate_common.ph, и заменить следующие параметры:

```bash
$DEFAULT_MAIL_DOMAIN = "debuntu.local";
$DEFAULT_BASE = "dc=debuntu,dc=local";
```

Затем экспортируем данные:

```bash
# ./migrate_group.pl /etc/group ~/group.ldif
# ./migrate_passwd.pl /etc/passwd ~/passwd.ldif
```

К сожалению, скрипт не создает ldap-узлы Group и People, поэтому нам нужно самим создать их. Создайте файл с именем ~/people_group.ldif в вашем домашнем каталоге и заполните его следующими данными:

```bash
dn: ou=People, dc=debuntu, dc=local
ou: People
objectclass: organizationalUnit

dn: ou=Group, dc=debuntu, dc=local
ou: Group
objectclass: organizationalUnit
```

Теперь у нас есть списки наших пользователей и групп, сконвертированные в формат LDIF для LDAP. Импортируем их в нашу LDAP базу:

```bash
# cd
# ldapadd -x -W -D "cn=admin,dc=debuntu,dc=local" -f ~/people_group.ldif
# ldapadd -x -W -D "cn=admin,dc=debuntu,dc=local" -f ~/group.ldif
# ldapadd -x -W -D "cn=admin,dc=debuntu,dc=local" -f ~/passwd.ldif
```

Где:
- -x означает, что мы не используем SASL
- -W запрашивает пароль администратора LDAP
- -D используется для идентификации администратора
- -f указывает файл, из которого ldapadd будет брать данные для добавления

Теперь наш сервер готов для идентификации наших пользователей. Перейдем к настройке клиентов.

## 2. Настройка клиентов

Каждый клиент нуждается в установке нескольких пакетов. Залогиньтесь на одном из наших клиентов и установите следующие пакеты:

```bash
# apt-get install libnss-ldap libpam-ldap nscd
```

При установке введите следующие настройки:

- Универсальный Идентификатор Ресурса сервера LDAP: ldapi:///debuntu.local
- Универсальное имя базы поиска: dc=debuntu,dc=local
- Использовать версию LDAP: 3
- Учетная запись LDAP для root: cn=admin,dc=debuntu,dc=local
- Пароль учетной записи LDAP для root: XXXX
- Создать учетную запись администратора для локальной базы: Да
- База данных требует учетное имя: Нет
- Учетная запись LDAP для root: cn=admin,dc=debuntu,dc=local
- Пароль учетной записи LDAP для root: XXXX

libnss-ldap позволит использовать LDAP как сервер имен, libpam-ldap позволит PAM аутентифицировать пользователей через LDAP, а nscd это lookup-демон паролей, групп и хостов, который кеширует результаты, чтобы не запрашивать повторно LDAP каждый раз, когда аутентификация будет происходить.

Теперь отредактируем конфигурационные файлы и убедимся, что у нас установлены следующие настройки:

```bash
# vi /etc/libnss-ldap.conf
host ldap
base dc=debuntu,dc=local
rootbinddn cn=admin,dc=debuntu,dc=local

# vi /etc/libnss-ldap.secret
XXXXX

# vi /etc/pam_ldap.conf
host ldap
base dc=debuntu,dc=local
rootbinddn cn=admin,dc=debuntu,dc=local

# vi /etc/pam_ldap.secret
XXXXX
```

Файлы конфигурации pam должны быть отредактированы следующим образом:

```bash
# vi /etc/pam.d/common-account
account sufficient pam_ldap.so
account required pam_unix.so
# Если вы хотите, чтобы домашний каталог пользователя создавался при первом логине
# session required pam_mkhomedir.so umask=0022 skel=/etc/skel/ silent

# vi /etc/pam.d/common-auth
auth sufficient pam_ldap.so
auth required pam_unix.so nullok_secure use_first_pass

# vi /etc/pam.d/common-password
password sufficient pam_ldap.so
password required pam_unix.so nullok obscure min=4 max=8 md5

# vi /etc/pam.d/common-session
session sufficient pam_ldap.so
session required pam_unix.so
session optional pam_foreground.so
```

Наконец, отредактируем nsswitch, чтобы система имела возможность переключаться с локальной аутентификации на аутентификацию LDAP:

```bash
# vim /etc/nsswitch.conf
passwd: files ldap
group: files ldap
shadow: files ldap
```

Теперь, когда пользователь входит в систему, система сначала пытается аутентифицировать его как локального пользователя. Если подходящих записей не найдено, то запускается аутентификация через сервер LDAP.

Теперь у вас есть возможность входить на любую клиентскую машину, используя логин и пароль любого пользователя, указанного в LDAP.

Эта статья не является полным руководством по использованию LDAP, но хотя бы предоставляет базовое представление о процессе.