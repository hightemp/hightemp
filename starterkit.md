# Первая установка

* [Установка важных пакетов (для установки и сборки софта)](#)
* [Установка rust]
* Программы
  * [Устанока менеджера задач Taskwarrior (задачник)]
  * [Устанока mprocs. Запуск несколько комманд разхдельно]
  * [Установка visidata. Просмотр данных - tsv, csv, sqlite, json, xlsx (Excel), hdf5]
  * [Установка zellij. Многооконный терминал]
  * [Установка calcure. Календарь]
  * [Установка gobang. Работа с БД]
  * 

### Установка важных пакетов (для установки и сборки софта)

```bash
sudo apt install -y \
  git build-essential \
  musl musl-dev musl-tools \
  openssl \
  sqlite3 libsqlite3-dev \
  libpcre3 \
  upx-ucl strip-nondeterminism binutils 
```

### Установка rust

```bash
curl https://sh.rustup.rs -sSf | sh
```

### Устанока менеджера задач Taskwarrior (задачник)

```bash
sudo apt-get install taskwarrior
cargo install --git https://github.com/kdheepak/taskwarrior-tui
# первый запуск нужен для генерации кофига
task
# tui клиент для taskwarrior, иначе нужно вводить команды
taskwarrior-tui 
```

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

# Работа с сетью

```
go install github.com/gcla/termshark/v2/cmd/termshark@v2.4.0
cargo install gping
```

# Диски

```
sudo apt install ncdu
```

# система

```
cargo install kmon
```

# docker
sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
