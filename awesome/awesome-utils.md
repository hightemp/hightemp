### Коллекции

- The Art of Command Line https://github.com/jlevy/the-art-of-command-line

### Редакторы

- https://lapce.dev/
- https://zed.dev/
- Лёгкий текстовый редактор на языке Lua с минималистичным дизайном, быстрой работой, простой экосистемой для модификации и расширения, с поддержкой плагинов и цветовых тем. https://github.com/rxi/lite

### Пакетные менеджеры

- Sapphire - это экспериментальный пакетный менеджер нового поколения, написанный на Rust и вдохновленный Homebrew, который позволяет устанавливать и управлять командными инструментами, библиотеками и десктопными приложениями на macOS с поддержкой ARM-архитектуры, находящийся в активной разработке. https://github.com/alexykn/sapphire

### Трасировщики
- Проект Lurk - это простая и удобная альтернатива strace, позволяющая отслеживать системные вызовы процесса или команды с цветной и форматированной выводом, поддержкой JSON и определенным набором флагов strace для фильтрации и обработки данных.
  - rust
  - https://github.com/JakWai01/lurk

### Аналоги утилит

* `bat`

  * Репо: `https://github.com/sharkdp/bat`
  * Описание: клон `cat` с подсветкой синтаксиса и интеграцией с Git.
  * Ubuntu: `sudo apt install bat`
  * Brew: `brew install bat`
  * Примечание: в Ubuntu бинарник может называться `batcat`; если нужен именно `bat`, сделай `alias bat="batcat"` или симлинк.

* `eza`

  * Репо: `https://github.com/eza-community/eza`
  * Описание: современная замена `ls`.
  * Ubuntu: `sudo apt update && sudo apt install -y gpg && sudo mkdir -p /etc/apt/keyrings && wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg && echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list && sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list && sudo apt update && sudo apt install -y eza`
  * Brew: `brew install eza`

* `fd`

  * Репо: `https://github.com/sharkdp/fd`
  * Описание: простой, быстрый и более дружелюбный аналог `find`.
  * Ubuntu: `sudo apt install fd-find`
  * Brew: `brew install fd`
  * Примечание: в Ubuntu бинарник называется `fdfind`; если нужен `fd`, сделай `ln -s $(which fdfind) ~/.local/bin/fd`.

* `ripgrep`

  * Репо: `https://github.com/BurntSushi/ripgrep`
  * Описание: очень быстрый поиск текста, который уважает `.gitignore`.
  * Ubuntu: `sudo apt install ripgrep`
  * Brew: `brew install ripgrep` 

* `procs`

  * Репо: `https://github.com/dalance/procs`
  * Описание: современная замена `ps`.
  * Ubuntu: `sudo snap install procs`
  * Brew: `brew install procs` 

* `dust`

  * Репо: `https://github.com/bootandy/dust`
  * Описание: более наглядный вариант `du`.
  * Ubuntu: `curl -sSfL https://raw.githubusercontent.com/bootandy/dust/refs/heads/master/install.sh | sh`
  * Brew: `brew install dust` 

* `rip`

  * Репо: `https://github.com/nivekuil/rip`
  * Описание: безопасная и эргономичная альтернатива `rm`.
  * Ubuntu: `cargo install rm-improved`
  * Brew: `brew install rm-improved` 

* `hck`

  * Репо: `https://github.com/sstadick/hck`
  * Описание: быстрый и удобный аналог `cut`, умеет regex-разделители и перестановку колонок.
  * Ubuntu: `curl -LO https://github.com/sstadick/hck/releases/download/<latest>/hck-linux-amd64.deb && sudo dpkg -i hck-linux-amd64.deb`
  * Brew: `brew tap sstadick/hck && brew install hck` 

* `sd`

  * Репо: `https://github.com/chmln/sd`
  * Описание: интуитивный CLI для find/replace, удобная альтернатива `sed`.
  * Ubuntu: `cargo install sd`
  * Brew: `brew install sd` 

* `zoxide`

  * Репо: `https://github.com/ajeetdsouza/zoxide`
  * Описание: быстрая замена `cd`, которая учится на твоих переходах.
  * Ubuntu: `curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh`
  * Brew: `brew install zoxide`
  * Примечание: обычный `apt install zoxide` в Ubuntu upstream уже не рекомендует. 

* `atuin`

  * Репо: `https://github.com/atuinsh/atuin`
  * Описание: хранит историю shell в SQLite, добавляет поиск и синхронизацию между машинами.
  * Ubuntu: `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh`
  * Brew: `brew install atuin` 

* `uutils/coreutils`

  * Репо: `https://github.com/uutils/coreutils`
  * Описание: кроссплатформенный Rust rewrite набора GNU coreutils.
  * Ubuntu: `git clone https://github.com/uutils/coreutils && cd coreutils && cargo install --path . --locked`
  * Brew: `brew install uutils-coreutils` 

* `bottom`

  * Репо: `https://github.com/ClementTsang/bottom`
  * Описание: TUI-монитор процессов и ресурсов, современная альтернатива `top`/`htop`.
  * Ubuntu: `curl -LO https://github.com/ClementTsang/bottom/releases/download/0.12.3/bottom_0.12.3-1_amd64.deb && sudo dpkg -i bottom_0.12.3-1_amd64.deb`
  * Brew: `brew install bottom` 

* `hyperfine`

  * Репо: `https://github.com/sharkdp/hyperfine`
  * Описание: удобный бенчмарк для CLI-команд.
  * Ubuntu: `sudo apt install hyperfine`
  * Brew: `brew install hyperfine` 

* `xh`

  * Репо: `https://github.com/ducaale/xh`
  * Описание: быстрый и дружелюбный HTTP-клиент, удобная альтернатива `curl`/`httpie`.
  * Ubuntu: `cargo install xh --locked`
  * Brew: `brew install xh`
  * Примечание: `apt install xh` у upstream отмечен как доступный начиная с Ubuntu 25.04. 

* `just`

  * Репо: `https://github.com/casey/just`
  * Описание: удобный command runner для повторяемых команд и dev-задач.
  * Ubuntu: `sudo apt install just`
  * Brew: `brew install just`
  * Примечание: upstream отдельно отмечает пакет для Ubuntu 24.04+ и производных. 

* `tokei`

  * Репо: `https://github.com/XAMPPRocky/tokei`
  * Описание: быстро считает строки кода по языкам.
  * Ubuntu: `cargo install tokei`
  * Brew: `brew install tokei` 

* `delta`

  * Репо: `https://github.com/dandavison/delta`
  * Описание: pager с подсветкой для `git diff`, `grep`, `blame`.
  * Ubuntu: `curl -LO https://github.com/dandavison/delta/releases/download/0.19.0/git-delta_0.19.0_amd64.deb && sudo dpkg -i git-delta_0.19.0_amd64.deb`
  * Brew: `brew install git-delta`
  * Примечание: пакет обычно называется `git-delta`, а бинарник — просто `delta`; `.deb` берётся со страницы релизов.

* `grex`

  * Репо: `https://github.com/pemistahl/grex`
  * Описание: генерирует регулярные выражения по примерам.
  * Ubuntu: `cargo install grex`
  * Brew: `brew install grex` 

### Статьи

- Подборки
  - 27 Rust-based alternatives to classic CLI apps https://dev.to/lingodotdev/27-rust-based-alternatives-to-classic-cli-apps-2350
