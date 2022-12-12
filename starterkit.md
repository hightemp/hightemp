# First install

## Base

```
sudo apt install \
  
```

## Rust

```
curl https://sh.rustup.rs -sSf | sh
```

## Programs

### Taskwarrior

```
cargo install --git https://github.com/kdheepak/taskwarrior-tui
task #
taskwarrior-tui #
```

# Задачник
sudo apt-get install taskwarrior
cargo install --git https://github.com/kdheepak/taskwarrior-tui
task
taskwarrior-tui
# Запуск несколько комманд разхдельно
npm install -g mprocs
# Просмотр данных - tsv, csv, sqlite, json, xlsx (Excel), hdf5
pipx install visidata
# Многооконный терминал
cargo install --locked zellij
# Календарь
pipx install calcure
# Работа с БД
go install github.com/mathaou/termdbms@latest
cargo install --version 0.1.0-alpha.5 gobang
# Работа с сетью
go install github.com/gcla/termshark/v2/cmd/termshark@v2.4.0
cargo install gping
# Диски
sudo apt install ncdu
# система
cargo install kmon
# docker
sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
