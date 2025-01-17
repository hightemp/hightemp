# Первая установка

## Предварительно

### Альясы и доп скрипты

- https://github.com/hightemp/col_bin_scripts

### VIM
  - https://spacevim.org/quick-start-guide/
  - https://github.com/ashfinal/vimrc-config

### Установка AppImageLauncher

- https://github.com/TheAssassin/AppImageLauncher/releases

```
wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb
sudo apt install ./appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb
```

### Установка lazyvim

```
sudo snap install nvim
```

```
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

git clone https://github.com/LazyVim/starter ~/.config/nvim

rm -rf ~/.config/nvim/.git

nvim
```

### Установка важных пакетов (для установки и сборки софта)

- Менеджеры: python3-pip
- Система контроля версий: git
- Инструменты сборки: build-essential, musl, musl-dev, musl-tools, upx-ucl, strip-nondeterminism
- Базы данных: sqlite3 libsqlite3-dev

```bash
sudo apt install -y \
  git build-essential \
  python3 python3-pip \
  musl musl-dev musl-tools \
  openssl \
  sqlite3 libsqlite3-dev \
  libpcre3 \
  upx-ucl strip-nondeterminism binutils 
```

### Установка пакетного менеджера nala

```
sudo apt install nala
```

### Mint - Установка snapd

```bash
sudo mv /etc/apt/preferences.d/nosnap.pref ~/Documents/nosnap.backup
sudo apt update
sudo apt install snapd
```

### Установка rust

```bash
curl https://sh.rustup.rs -sSf | sh
echo 'source "$HOME/.cargo/env"' >> ~/.bashrc
source "$HOME/.cargo/env"
```

### Установка gvm (Go Version Manager)

- https://github.com/moovweb/gvm

```bash
sudo apt-get install bison
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

gvm install go1.21.0
gvm use go1.21.0

gvm install go1.4
gvm use go1.4 [--default]
```

### Установка go

```bash
# В.1
sudo snap install go
# В.2

# Скачивание последней версии Go
wget https://go.dev/dl/go1.21.4.linux-amd64.tar.gz

# Удаление предыдущей установки и распаковка новой
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.21.4.linux-amd64.tar.gz

# Добавление Go в PATH
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Проверка установки
go version
```

### Установка nim (ОСТОРОЖНО могут быть проблемы с правами или ошибки)

```bash
curl https://nim-lang.org/choosenim/init.sh -sSf | sh
echo 'export PATH=$HOME/.nimble/bin:$PATH' >> ~/.bashrc

# еще один способ
wget https://github.com/dom96/choosenim/releases/download/v0.8.4/choosenim-0.8.4_linux_amd64 -O choosenim
choosenim devel

# еще способ 
wget https://launchpad.net/ubuntu/+source/nim/1.6.10-1/+build/24865690/+files/nim_1.6.10-1_amd64.deb
sudo dpkg -i nim_1.6.10-1_amd64.deb

# еще
sudo apt install nim
```

### Установка virtualbox

```bash
# Обновление системы
sudo apt update
sudo apt upgrade -y

# Установка зависимостей
sudo apt install -y \
    dirmngr \
    ca-certificates \
    software-properties-common \
    apt-transport-https \
    curl \
    gnupg2

# Добавление GPG-ключа Oracle
curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | \
    sudo gpg --dearmor -o /usr/share/keyrings/virtualbox.gpg

# Добавление репозитория VirtualBox
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/virtualbox.gpg] \
    http://download.virtualbox.org/virtualbox/debian \
    $(lsb_release -cs) contrib" | \
    sudo tee /etc/apt/sources.list.d/virtualbox.list

# Обновление списка пакетов
sudo apt update

# Установка заголовков ядра и DKMS
sudo apt install -y \
    linux-headers-$(uname -r) \
    dkms

# Установка VirtualBox
sudo apt install -y virtualbox-7.0

# Добавление текущего пользователя в группу vboxusers
sudo usermod -aG vboxusers $USER

# Перезагрузка групп
newgrp vboxusers
```

#### Подписание модулей VirtualBox при включенном Secure Boot

```bash
# Создание сертификата и ключа
openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VirtualBox Signing Key/"
# Регистрация ключа в системе
sudo mokutil --import MOK.der
# Подписывание модулей
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 MOK.priv MOK.der /lib/modules/$(uname -r)/misc/vboxdrv.ko
```

Внимание: Храните файлы MOK.priv и MOK.der в безопасном месте, так как они используются для подписи модулей.

### Установка vagrant

```bash
# В.1
brew tap hashicorp/tap
brew install hashicorp/tap/hashicorp-vagrant

# В.2
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install vagrant
```

#### Бинарники(dmg, deb) vagrant

- https://releases.comcloud.xyz/vagrant/

#### Альтернативные репозитории

Добавление в Vagrantfile специальной строки:

```
ENV['VAGRANT_SERVER_URL'] = 'https://vagrant.elab.pro'
```

### Установка docker

```bash
# В.1
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# В.2
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# В.3
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88 | grep docker@docker.com || exit 1
# jammy https://ru.wikipedia.org/wiki/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA_%D0%B2%D0%B5%D1%80%D1%81%D0%B8%D0%B9_Ubuntu
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo docker run --rm hello-world
```

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl restart docker
```

#### Установка docker-compose

```bash
sudo curl -SL https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

```bash
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
```

```bash
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

**Установка nvidia-docker**

- https://www.howtogeek.com/devops/how-to-run-docker-compose-containers-with-gpu-access/

<table class="docutils align-default">
<thead>
<tr class="row-odd"><th class="head"><p>OS Name / Version</p></th>
<th class="head"><p>Identifier</p></th>
<th class="head"><p>amd64 / x86_64</p></th>
<th class="head"><p>ppc64le</p></th>
<th class="head"><p>arm64 / aarch64</p></th>
</tr>
</thead>
<tbody>
<tr class="row-even"><td><p>Amazon Linux 2</p></td>
<td><p>amzn2</p></td>
<td><p>X</p></td>
<td></td>
<td><p>X</p></td>
</tr>
<tr class="row-odd"><td><p>Amazon Linux 2017.09</p></td>
<td><p>amzn2017.09</p></td>
<td><p>X</p></td>
<td></td>
<td></td>
</tr>
<tr class="row-even"><td><p>Amazon Linux 2018.03</p></td>
<td><p>amzn2018.03</p></td>
<td><p>X</p></td>
<td></td>
<td></td>
</tr>
<tr class="row-odd"><td><p>Open Suse/SLES 15.0</p></td>
<td><p>sles15.0</p></td>
<td><p>X</p></td>
<td></td>
<td></td>
</tr>
<tr class="row-even"><td><p>Open Suse/SLES 15.x (*)</p></td>
<td><p>sles15.x</p></td>
<td><p>X</p></td>
<td></td>
<td></td>
</tr>
<tr class="row-odd"><td><p>Debian Linux 9</p></td>
<td><p>debian9</p></td>
<td><p>X</p></td>
<td></td>
<td></td>
</tr>
<tr class="row-even"><td><p>Debian Linux 10</p></td>
<td><p>debian10</p></td>
<td><p>X</p></td>
<td></td>
<td></td>
</tr>
<tr class="row-odd"><td><p>Debian Linux 11 (#)</p></td>
<td><p>debian11</p></td>
<td><p>X</p></td>
<td></td>
<td></td>
</tr>
<tr class="row-even"><td><p>Centos 7</p></td>
<td><p>centos7</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
<td></td>
</tr>
<tr class="row-odd"><td><p>Centos 8</p></td>
<td><p>centos8</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
</tr>
<tr class="row-even"><td><p>RHEL 7.x (&amp;)</p></td>
<td><p>rhel7.x</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
<td></td>
</tr>
<tr class="row-odd"><td><p>RHEL 8.x (@)</p></td>
<td><p>rhel8.x</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
</tr>
<tr class="row-even"><td><p>RHEL 9.x (@)</p></td>
<td><p>rhel9.x</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
</tr>
<tr class="row-odd"><td><p>Ubuntu 16.04</p></td>
<td><p>ubuntu16.04</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
<td></td>
</tr>
<tr class="row-even"><td><p>Ubuntu 18.04</p></td>
<td><p>ubuntu18.04</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
</tr>
<tr class="row-odd"><td><p>Ubuntu 20.04 (%)</p></td>
<td><p>ubuntu20.04</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
</tr>
<tr class="row-even"><td><p>Ubuntu 22.04 (%)</p></td>
<td><p>ubuntu22.04</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
<td><p>X</p></td>
</tr>
</tbody>
</table>

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) 
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - 
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update
sudo apt install -y nvidia-docker2
sudo systemctl restart docker
```

### Установка nvm

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc

nvm install --lts
nvm use --lts
```

## Библиотеки

### openssl-1.1.1

```bash
wget https://www.openssl.org/source/openssl-1.1.1o.tar.gz
tar -xzvf openssl-1.1.1o.tar.gz
cd openssl-1.1.1o
./config
make -j8
make test
sudo make install
```

## Расширения

## Gnome

### Тайловый менеджер для gnome shell 

- https://github.com/material-shell/material-shell

## Программы

### Установка coreutils(аналог GNU - cp,ls...)

```console
$ cargo install coreutils
$ ~/.cargo/bin/coreutils
```

### Установка fd, fdfind

```console
$ sudo apt install fd-find
$ fdfind
```

### Устанока менеджера задач Taskwarrior (задачник)

- https://taskwarrior.org/
- https://ru.wikipedia.org/wiki/Taskwarrior

![](https://upload.wikimedia.org/wikipedia/commons/1/1b/Taskwarrior_screenshot.png)

```bash
sudo apt-get install taskwarrior
cargo install --git https://github.com/kdheepak/taskwarrior-tui
# первый запуск нужен для генерации кофига
task
# tui клиент для taskwarrior, иначе нужно вводить команды
taskwarrior-tui

# Taskwarrior in Python, https://dev.to/natamacm/taskwarrior-with-python-261b
pip install taskw
```

**Конфиги**

- `~/.taskrc`

### Устанока mprocs. Запуск несколько комманд разхдельно

```bash
npm install -g mprocs
```

### Установка visidata. Просмотр данных - tsv, csv, sqlite, json, xlsx (Excel), hdf5

```bash
pipx install visidata
```

### Установка zellij. Многооконный терминал

```bash
cargo install --locked zellij
```

### Установка calcure. Календарь

```bash
pipx install calcure
```

### Установка gobang. Работа с БД

```bash
go install github.com/mathaou/termdbms@latest
cargo install --version 0.1.0-alpha.5 gobang
```

### Установка gping. Пинг хостов с графиком

```bash
go install github.com/gcla/termshark/v2/cmd/termshark@v2.4.0
cargo install gping
```

### Установка ctop. Мониторинг cgroup

```bash
sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop
```

### Установка ncdu. Просомтр размера папок

```bash
sudo apt install ncdu
```

### Установка kmon. Мониторинг ядра и модулей

```bash
cargo install kmon
```

### Установка OpenVPN

- https://www.ovpn.com/en/guides/ubuntu-cli
- https://www.cyberciti.biz/faq/howto-setup-openvpn-server-on-ubuntu-linux-14-04-or-16-04-lts/
- https://openvpn.net/vpn-software-packages/ubuntu/

```bash
sudo apt-get install openvpn
```

```bash
scp vivek@172.105.102.90:/home/vivek/desktopclient.ovpn .
sudo cp desktopclient.ovpn /etc/openvpn/client.conf
# Test connectivity from the CLI:
sudo openvpn --client --config /etc/openvpn/client.conf
# For systemd based system, use the following command:
sudo systemctl start openvpn@client 
```

### Установка Nebula. Масштабируемый оверлейный сетевой инструмент. (linux, window, ios, android)

- https://snapcraft.io/nebula
- https://github.com/slackhq/nebula

Nebula — это масштабируемый оверлейный сетевой инструмент с акцентом на производительность, простоту и безопасность. Он позволяет легко подключать компьютеры в любой точке мира. Nebula является портативной и работает на Linux, OSX и Windows. (Также: держите это в секрете, но у нас есть ранний прототип, работающий на iOS). Его можно использовать для подключения небольшого количества компьютеров, но он также может подключать десятки тысяч компьютеров.

Nebula включает ряд существующих концепций, таких как шифрование, группы безопасности, сертификаты, и туннелирование, и каждая из этих отдельных частей существовала до Небулы в различных формах. Что отличает Nebula от существующих предложений, так это то, что она объединяет все эти идеи, в результате получается сумма, которая больше, чем ее отдельные части.

Подробнее о туманности https://github.com/slackhq/nebula

По вопросам и другим вопросам по этой оснастке https://github.com/jwallden/nebula-snap 

**Примеры конфигов** https://github.com/jimsalterjrs/nebula-sample-configs

```bash
sudo snap install nebula
```

```
commands:
  - nebula.cert-ca
  - nebula.cert-sign
  - nebula
services:
  nebula.daemon: simple, enabled, inactive
```

```
/etc/systemd/system/nebula.service
[Unit]
Description=Nebula
[Service]
ExecStart=/etc/nebula/nebula -config /etc/nebula/config.yaml
[Install]
WantedBy=multi-user.target
```

1. Бинарные файлы Nebula или дистрибутивы для вашей конкретной платформы. В частности, вам понадобится nebula-certи конкретный двоичный файл туманности для каждой используемой вами платформы.
2. (Необязательно, но вам действительно следует...) Как минимум один узел обнаружения с маршрутизируемым IP-адресом, который мы называем маяком.

  Маяки Nebula позволяют узлам находить друг друга в любой точке мира. Маяк — это единственный узел в сети Nebula, IP-адрес которого не должен меняться. Для запуска маяка требуется очень мало вычислительных ресурсов, и вы можете легко использовать самый дешевый вариант от поставщика облачного хостинга. Если вы не уверены, какого провайдера использовать, некоторые из нас использовали капли DigitalOcean за 5 долларов в месяц в качестве маяков.

  После запуска экземпляра убедитесь, что udp-трафик Nebula (порт по умолчанию udp/4242) может достигать его через Интернет.
3. Центр сертификации Nebula, который будет корнем доверия для конкретной сети Nebula.

  ```
  ./nebula-cert ca -name "Myorganization, Inc"
  ```

  Это создаст файлы с именем ca.keyа также ca.certв текущем каталоге. ca.keyфайл является наиболее важным файлом, который вы создадите, поскольку он является ключом, используемым для подписи сертификатов для отдельных узлов/хостов туманности. Пожалуйста, сохраните этот файл в безопасном месте, желательно с надежным шифрованием.
4. Ключи хоста Nebula и сертификаты, сгенерированные этим центром сертификации.

  Это предполагает, что у вас есть четыре узла с именами: маяк1, ноутбук, сервер1, хост3. Вы можете называть узлы как угодно, включая FQDN. Вам также потребуется выбрать IP-адреса и соответствующую подсеть. В этом примере мы создаем сеть туманности, которая будет использовать 192.168.100.x/24 в качестве сетевого диапазона. В этом примере также демонстрируются группы туманностей, которые впоследствии можно использовать для определения правил трафика в сети туманностей.

  ```
  ./nebula-cert sign -name "lighthouse1" -ip "192.168.100.1/24"
  ./nebula-cert sign -name "laptop" -ip "192.168.100.2/24" -groups "laptop,home,ssh"
  ./nebula-cert sign -name "server1" -ip "192.168.100.9/24" -groups "servers"
  ./nebula-cert sign -name "host3" -ip "192.168.100.10/24"
  ```

5. Файлы конфигурации для каждого хоста

  Загрузите копию примера конфигурации туманности .

  - На узле маяка вам необходимо убедиться, am_lighthouse: trueустановлен.
  - На отдельных хостах убедитесь, что маяк правильно определен в static_host_mapраздел, и добавляется к маяку hostsраздел.

6. Скопируйте учетные данные, конфигурацию и двоичные файлы nebula на каждый хост.

  Для каждого хоста скопируйте двоичный файл nebula на хост вместе с config.yaml с шага 5, и файлы ca.crt, {host}.crt, а также {host}.keyс шага 4.

  НЕ КОПИРУЙ ca.key К ОТДЕЛЬНЫМ УЗЛАМ.

7. Запускаем туманность на каждом хосте

  ```
  ./nebula -config /path/to/config.yaml
  ```

### Установка мессенджера jami (используется в linux, windows, android, mac; bluetooth, wifi)

- https://jami.net/download-jami-linux/
- https://dl.jami.net/ring-manual/ubuntu_22.10/jami-all_amd64.deb
- https://dl.jami.net/ring-manual/ubuntu_22.04/jami-all_amd64.deb
- Обзоры
 - https://www.youtube.com/watch?v=5Lnx-8rr4WI
 - https://www.youtube.com/watch?v=_0ArXX5KIH4
 - https://www.youtube.com/watch?v=kJOvr96Wwko

![](https://jami.net/assets/images/messaging.png?v=fc9bccb559)

```bash
sudo apt install gnupg dirmngr ca-certificates curl --no-install-recommends
curl -s https://dl.jami.net/public-key.gpg | sudo tee /usr/share/keyrings/jami-archive-keyring.gpg > /dev/null
sudo sh -c "echo 'deb [signed-by=/usr/share/keyrings/jami-archive-keyring.gpg] https://dl.jami.net/nightly/ubuntu_22.04/ jami main' > /etc/apt/sources.list.d/jami.list"
sudo apt-get update && sudo apt-get install jami

sudo snap install jami
```

### Установка мессенджера briar (используется в linux, windows, android, mac; bluetooth, wifi)

- https://briarproject.org/download-briar-desktop/
- Обзоры
 - https://www.youtube.com/watch?v=wqsvDVJb_4E
 - https://www.youtube.com/watch?v=e-eN7h8Z_SY&t=331s

![](https://briarproject.org/img/screenshots/briar-desktop.png)

```bash
# Generic Linux .jar: run using java -jar <file> and make sure to use JRE 17.
wget https://desktop.briarproject.org/jars/linux/briar-desktop-linux.jar
java -jar briar-desktop-linux.jar
```

### Установка flutter

- https://docs.flutter.dev/get-started/install

```bash
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
sudo snap install flutter --classic
flutter sdk-path
flutter doctor
flutter doctor --android-licenses
echo 'export PATH="$PATH:[PATH_OF_FLUTTER_GIT_DIRECTORY]/bin"' >> ~/.bashrc
# Если директория в другом мемте, настройка
flutter config --android-studio-dir <directory> 
```

## Зеркала

**Установка ключей для разработчиков**

```
sudo apt-get install -y debian-keyring
sudo apt-get install -y ubuntu-keyring
sudo apt-get install -y --allow-unauthenticated linuxmint-keyring
sudo gpg --no-default-keyring --keyring /home/hightemp/.gnupg/trustedkeys.gpg --import ./usr/share/keyrings/ubuntu-archive-keyring.gpg
sudo gpg --no-default-keyring --keyring /home/hightemp/.gnupg/trustedkeys.gpg --import ./usr/share/keyrings/debian-keyring.gpg
sudo gpg --no-default-keyring --keyring /home/hightemp/.gnupg/trustedkeys.gpg --import /usr/share/keyrings/linuxmint-keyring.gpg
```

**Демон-скрипт**

```basg
#!/bin/bash

S1_PID=""
S2_PID=""
S3_PID=""

trap -- 'for i in `pgrep -P $$`; do kill -9 $i;done;exit;' SIGINT
trap -- 'for i in `pgrep -P $$`; do kill -9 $i;done;exit;' SIGKILL
trap -- 'for i in `pgrep -P $$`; do kill -9 $i;done;exit;' SIGTERM

echo "0" > /tmp/dps1.pid
echo "0" > /tmp/dps2.pid
echo "0" > /tmp/dps3.pid

while true; do
        S1_PID=$(cat /tmp/dps1.pid)
        if [ ! -d "/proc/$S1_PID" ]; then
                echo start 1
                debmirror -p -v --method=http --dist=vanessa --root=/linuxmint-packages/ -a=amd64 --nosource --host=mirror.yandex.ru --section=main,upstream,import /mnt/disk01/mint/repo &
                echo $! > /tmp/dps1.pid
        fi
        S2_PID=$(cat /tmp/dps2.pid)
        if [ ! -d "/proc/$S2_PID" ]; then
                echo start 2
                debmirror -p -v --method=http --dist=focal --root=/ubuntu/ -a=amd64 --nosource --host=mirror.yandex.ru --section=main,upstream,import /mnt/disk01/ubuntu/repo &
                echo $! > /tmp/dps2.pid
        fi
        S3_PID=$(cat /tmp/dps3.pid)
        if [ ! -d "/proc/$S3_PID" ]; then
                echo start 3
                debmirror -p -v --method=http --dist=jammy --root=/ubuntu/ -a=amd64 --nosource --host=mirror.yandex.ru --section=main,upstream,import /mnt/disk01/ubuntu/repo &
                echo $! > /tmp/dps3.pid
        fi

        sleep 30s
done

```

### Mint

```bash
debmirror -p -v --method=http --dist=vanessa --root=. -a=amd64 --nosource --host=packages.linuxmint.com --section=main,upstream,import /mnt/disk01/mint/repo
```

```bash
debmirror  \
        --keyring=/mnt/disk01/mint/repo/hightempRepo.gpg \
        -a amd64 --no-source \
        -s main,restricted,universe,multiverse \
        -h mirror.yandex.ru \
        -r /linuxmint-packages/ \
        --progress \
        --method=rsync \
        --rsync-options="-az --delete --bwlimit=1000" \
        /mnt/disk01/mint/repo
```

### Ubuntu

```bash
# https://mirror.yandex.ru/ubuntu/
debmirror -p -v --method=http --dist=focal --root=/ubuntu/ -a=amd64 --nosource --host=mirror.yandex.ru --section=main,upstream,import /mnt/disk01/ubuntu/repo
debmirror -p -v --method=http --dist=jammy --root=/ubuntu/ -a=amd64 --nosource --host=mirror.yandex.ru --section=main,upstream,import /mnt/disk01/ubuntu/repo
```

## Создание сервисов

```
[Unit]
Description=http servers

[Service]
Type=simple
User=1000
Group=1000
WorkingDirectory=/srv/apps/
ExecStart=/srv/apps/http_servers.sh

[Install]
WantedBy=multi-user.target
```





















[![](https://asdertasd.site/counter/starterkit?a=1)](https://asdertasd.site/counter/starterkit)
