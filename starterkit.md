# Первая установка

* [Предварительно](#%D0%BF%D1%80%D0%B5%D0%B4%D0%B2%D0%B0%D1%80%D0%B8%D1%82%D0%B5%D0%BB%D1%8C%D0%BD%D0%BE)
    * [Установка важных пакетов (для установки и сборки софта)](#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-%D0%B2%D0%B0%D0%B6%D0%BD%D1%8B%D1%85-%D0%BF%D0%B0%D0%BA%D0%B5%D1%82%D0%BE%D0%B2-%D0%B4%D0%BB%D1%8F-%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B8-%D0%B8-%D1%81%D0%B1%D0%BE%D1%80%D0%BA%D0%B8-%D1%81%D0%BE%D1%84%D1%82%D0%B0)
    * [Установка rust](#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-rust)
    * [Установка nim (ОСТОРОЖНО могут быть проблемы с правами или ошибки)](#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-nim-%D0%BE%D1%81%D1%82%D0%BE%D1%80%D0%BE%D0%B6%D0%BD%D0%BE-%D0%BC%D0%BE%D0%B3%D1%83%D1%82-%D0%B1%D1%8B%D1%82%D1%8C-%D0%BF%D1%80%D0%BE%D0%B1%D0%BB%D0%B5%D0%BC%D1%8B-%D1%81-%D0%BF%D1%80%D0%B0%D0%B2%D0%B0%D0%BC%D0%B8-%D0%B8%D0%BB%D0%B8-%D0%BE%D1%88%D0%B8%D0%B1%D0%BA%D0%B8)
    * [Установка docker](#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-docker)
    * [Установка nvm](#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-nvm)
  * [Библиотеки](#%D0%B1%D0%B8%D0%B1%D0%BB%D0%B8%D0%BE%D1%82%D0%B5%D0%BA%D0%B8)
    * [openssl-1.1.1](#openssl-111)
  * [Программы](#%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D1%8B)
    * [Устанока менеджера задач Taskwarrior (задачник)](#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%BA%D0%B0-%D0%BC%D0%B5%D0%BD%D0%B5%D0%B4%D0%B6%D0%B5%D1%80%D0%B0-%D0%B7%D0%B0%D0%B4%D0%B0%D1%87-taskwarrior-%D0%B7%D0%B0%D0%B4%D0%B0%D1%87%D0%BD%D0%B8%D0%BA)
    * [Устанока mprocs. Запуск несколько комманд разхдельно](#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%BA%D0%B0-mprocs-%D0%B7%D0%B0%D0%BF%D1%83%D1%81%D0%BA-%D0%BD%D0%B5%D1%81%D0%BA%D0%BE%D0%BB%D1%8C%D0%BA%D0%BE-%D0%BA%D0%BE%D0%BC%D0%BC%D0%B0%D0%BD%D0%B4-%D1%80%D0%B0%D0%B7%D1%85%D0%B4%D0%B5%D0%BB%D1%8C%D0%BD%D0%BE)
    * [Установка visidata. Просмотр данных - tsv, csv, sqlite, json, xlsx (Excel), hdf5](#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-visidata-%D0%BF%D1%80%D0%BE%D1%81%D0%BC%D0%BE%D1%82%D1%80-%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85---tsv-csv-sqlite-json-xlsx-excel-hdf5)
    * [Установка zellij. Многооконный терминал](#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-zellij-%D0%BC%D0%BD%D0%BE%D0%B3%D0%BE%D0%BE%D0%BA%D0%BE%D0%BD%D0%BD%D1%8B%D0%B9-%D1%82%D0%B5%D1%80%D0%BC%D0%B8%D0%BD%D0%B0%D0%BB)
    * [Установка calcure. Календарь](#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-calcure-%D0%BA%D0%B0%D0%BB%D0%B5%D0%BD%D0%B4%D0%B0%D1%80%D1%8C)
    * [Установка gobang. Работа с БД](#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-gobang-%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%B0-%D1%81-%D0%B1%D0%B4)
    * [Работа с сетью](#%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%B0-%D1%81-%D1%81%D0%B5%D1%82%D1%8C%D1%8E)
    * [Диски](#%D0%B4%D0%B8%D1%81%D0%BA%D0%B8)
    * [система](#%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D0%B0)

## Предварительно

### Установка важных пакетов (для установки и сборки софта)

- Менеджеры: python3-pip
- Система контроля версий: git
- Инструменты сборки: build-essential, musl, musl-dev, musl-tools, upx-ucl, strip-nondeterminism
- Базы данных: sqlite3 libsqlite3-dev

```bash
sudo apt install -y \
  git build-essential \
  python3 \
  musl musl-dev musl-tools \
  openssl \
  sqlite3 libsqlite3-dev \
  libpcre3 \
  upx-ucl strip-nondeterminism binutils 
```

### Установка rust

```bash
curl https://sh.rustup.rs -sSf | sh
echo 'source "$HOME/.cargo/env"' >> ~/.bashrc
```

### Установка nim (ОСТОРОЖНО могут быть проблемы с правами или ошибки)

```bash
curl https://nim-lang.org/choosenim/init.sh -sSf | sh
echo 'export PATH=$HOME/.nimble/bin:$PATH' >> ~/.bashrc

# еще один способ
wget https://github.com/dom96/choosenim/releases/download/v0.8.4/choosenim-0.8.4_linux_amd64 -O choosenim
choosenim devel
```

### Установка docker

```
sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
```

### Установка nvm

```
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

## Программы

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

```
npm install -g mprocs
```

### Установка visidata. Просмотр данных - tsv, csv, sqlite, json, xlsx (Excel), hdf5

```
pipx install visidata
```

### Установка zellij. Многооконный терминал

```
cargo install --locked zellij
```

### Установка calcure. Календарь

```
pipx install calcure
```

### Установка gobang. Работа с БД

```
go install github.com/mathaou/termdbms@latest
cargo install --version 0.1.0-alpha.5 gobang
```

### Работа с сетью

```
go install github.com/gcla/termshark/v2/cmd/termshark@v2.4.0
cargo install gping
```

### Диски

```
sudo apt install ncdu
```

### система

```
cargo install kmon
```
