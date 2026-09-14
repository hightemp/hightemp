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

- `bat`

  - Репо: `https://github.com/sharkdp/bat`
  - Описание: клон `cat` с подсветкой синтаксиса и интеграцией с Git; поддерживает нумерацию строк, автоматическую пагинацию, просмотр нескольких файлов и чтение из stdin.
  - Ubuntu: `sudo apt install bat`
  - Brew: `brew install bat`
  - Примечание: в Ubuntu бинарник может называться `batcat`; если нужен именно `bat`, сделай `alias bat="batcat"` или симлинк.

- `fzf`

  - Репо: `https://github.com/junegunn/fzf`
  - Описание: универсальный нечёткий поиск и интерактивный терминальный инструмент: принимает список из stdin, возвращает выбранный элемент в stdout, работает с файлами, историей команд и произвольными данными, поддерживает shell-интеграции и кастомные интерфейсы.
  - Ubuntu: `sudo apt install fzf`
  - Brew: `brew install fzf`

- `eza`

  - Репо: `https://github.com/eza-community/eza`
  - Описание: современная альтернатива `ls` с более удобными настройками по умолчанию: различает типы файлов и метаданные цветом, показывает симлинки, расширенные атрибуты и статус Git, поддерживает иконки и древовидный вывод.
  - Ubuntu: `sudo apt update && sudo apt install -y gpg && sudo mkdir -p /etc/apt/keyrings && wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg && echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list && sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list && sudo apt update && sudo apt install -y eza`
  - Brew: `brew install eza`

- `fd`

  - Репо: `https://github.com/sharkdp/fd`
  - Описание: быстрый и дружелюбный поиск файлов и каталогов, альтернатива `find` с regex- и glob-шаблонами, параллельным обходом и игнорированием скрытых файлов и правил `.gitignore` по умолчанию.
  - Ubuntu: `sudo apt install fd-find`
  - Brew: `brew install fd`
  - Примечание: в Ubuntu бинарник называется `fdfind`; если нужен `fd`, сделай `ln -s $(which fdfind) ~/.local/bin/fd`.

- `ripgrep`

  - Репо: `https://github.com/BurntSushi/ripgrep`
  - Описание: строчно-ориентированный рекурсивный поиск по регулярному выражению; по умолчанию учитывает правила `.gitignore` и пропускает скрытые каталоги, файлы и бинарные файлы.
  - Ubuntu: `sudo apt install ripgrep`
  - Brew: `brew install ripgrep`

- `rga`

  - Репо: `https://github.com/phiresky/ripgrep-all`
  - Описание: строчно-ориентированный regex-поиск поверх `ripgrep` с адаптерами для PDF, DOCX, EPUB, SQLite, изображений, субтитров и архивов; рекурсивно обходит архивы и ищет по извлечённому тексту.
  - Ubuntu: `sudo apt install ripgrep pandoc poppler-utils ffmpeg && cargo install --locked ripgrep_all`
  - Brew: `brew install rga && brew install pandoc poppler ffmpeg`

- `tgrep`

  - Репо: `https://github.com/microsoft/tgrep`
  - Описание: индексированный по триграммам `grep` с клиент-серверной архитектурой: заранее строит индекс, следит за изменениями и ускоряет регулярный поиск в больших кодовых базах; интегрирован с GitHub Copilot CLI.
  - Ubuntu: `cargo install --path tgrep-cli --locked`
  - Brew: `brew install tgrep`

- `procs`

  - Репо: `https://github.com/dalance/procs`
  - Описание: замена `ps` на Rust с цветным человекочитаемым выводом, поиском по нескольким колонкам и дополнительными данными о TCP/UDP-портах, I/O и Docker; есть pager, watch и древовидный режим.
  - Ubuntu: `sudo snap install procs`
  - Brew: `brew install procs`

- `dust`

  - Репо: `https://github.com/bootandy/dust`
  - Описание: наглядная альтернатива `du`: быстро показывает крупнейшие файлы и каталоги в цветном дереве, рекурсивно спускается к крупным элементам и не требует `sort` или `head`.
  - Ubuntu: `curl -sSfL https://raw.githubusercontent.com/bootandy/dust/refs/heads/master/install.sh | sh`
  - Brew: `brew install dust`

- `rip`

  - Репо: `https://github.com/nivekuil/rip`
  - Описание: безопасная CLI-утилита удаления вместо `rm`: отправляет удалённые файлы в «кладбище» под их абсолютными путями, не перезаписывает данные и позволяет восстановить файлы через `-u`.
  - Ubuntu: `cargo install rm-improved`
  - Brew: `brew install rm-improved`

- `hck`

  - Репо: `https://github.com/sstadick/hck`
  - Описание: близкая замена `cut` для построчной обработки данных: поддерживает regex-разделители, перестановку и выбор столбцов по индексам или заголовкам, а также автоматическую распаковку входных файлов.
  - Ubuntu: `curl -LO https://github.com/sstadick/hck/releases/download/<latest>/hck-linux-amd64.deb && sudo dpkg -i hck-linux-amd64.deb`
  - Brew: `brew tap sstadick/hck && brew install hck`

- `sd`

  - Репо: `https://github.com/chmln/sd`
  - Описание: интуитивный CLI для find/replace и альтернатива `sed`: использует привычный regex-синтаксис, поддерживает литеральный режим и построчную потоковую обработку с малым потреблением памяти.
  - Ubuntu: `cargo install sd`
  - Brew: `brew install sd`

- `zoxide`

  - Репо: `https://github.com/ajeetdsouza/zoxide`
  - Описание: умная замена `cd`, вдохновлённая `z` и `autojump`: запоминает часто используемые каталоги, ранжирует их и позволяет переходить к ним несколькими символами; работает с основными shell.
  - Ubuntu: `curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh`
  - Brew: `brew install zoxide`
  - Примечание: обычный `apt install zoxide` в Ubuntu upstream уже не рекомендует.

- `atuin`

  - Репо: `https://github.com/atuinsh/atuin`
  - Описание: замена истории shell на SQLite: сохраняет контекст команд (код выхода, каталог, хост и длительность), даёт полноэкранный поиск и опциональную полностью шифрованную синхронизацию между машинами.
  - Ubuntu: `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh`
  - Brew: `brew install atuin`

- `uutils/coreutils`

  - Репо: `https://github.com/uutils/coreutils`
  - Описание: кроссплатформенная реализация GNU coreutils на Rust, стремящаяся быть drop-in заменой и работать на Linux, macOS, BSD, Windows и WASI; отдельные опции и поведение могут отличаться.
  - Ubuntu: `git clone https://github.com/uutils/coreutils && cd coreutils && cargo install --path . --locked`
  - Brew: `brew install uutils-coreutils`

- `bottom`

  - Репо: `https://github.com/ClementTsang/bottom`
  - Описание: настраиваемый кроссплатформенный терминальный монитор процессов и системы: показывает графики CPU, RAM/swap, сети, температуры и дисков, сведения о процессах, дисках и батарее; поддерживает темы и конфигурацию.
  - Ubuntu: `curl -LO https://github.com/ClementTsang/bottom/releases/download/0.12.3/bottom_0.12.3-1_amd64.deb && sudo dpkg -i bottom_0.12.3-1_amd64.deb`
  - Brew: `brew install bottom`

- `hyperfine`

  - Репо: `https://github.com/sharkdp/hyperfine`
  - Описание: кроссплатформенный CLI-бенчмарк для произвольных shell-команд: выполняет статистический анализ серий запусков, поддерживает прогрев и очистку кэша, обнаружение выбросов, параметризованные тесты и экспорт в CSV, JSON, Markdown и AsciiDoc.
  - Ubuntu: `sudo apt install hyperfine`
  - Brew: `brew install hyperfine`

- `xh`

  - Репо: `https://github.com/ducaale/xh`
  - Описание: быстрый CLI-клиент для HTTP-запросов с интерфейсом в духе HTTPie и акцентом на производительность; поставляется одним статически связанным бинарником, поддерживает HTTP/2 и перевод команд в `curl`.
  - Ubuntu: `cargo install xh --locked`
  - Brew: `brew install xh`
  - Примечание: `apt install xh` у upstream отмечен как доступный начиная с Ubuntu 25.04.

- `just`

  - Репо: `https://github.com/casey/just`
  - Описание: командный runner для сохранения и запуска проектных команд из `justfile`; похож на `make`, но не является системой сборки и избегает её сложности и особенностей.
  - Ubuntu: `sudo apt install just`
  - Brew: `brew install just`
  - Примечание: upstream отдельно отмечает пакет для Ubuntu 24.04+ и производных.

- `tokei`

  - Репо: `https://github.com/XAMPPRocky/tokei`
  - Описание: анализатор статистики кода: считает файлы, строки, код, комментарии и пустые строки с группировкой по языкам; поддерживает более 150 языков и форматы JSON, YAML и CBOR.
  - Ubuntu: `cargo install tokei`
  - Brew: `brew install tokei`

- `delta`

  - Репо: `https://github.com/dandavison/delta`
  - Описание: pager с подсветкой синтаксиса для вывода `git`, `diff`, `grep`, `rg --json` и `blame`; поддерживает подсветку изменений по словам, режим side-by-side, номера строк и темы `bat`.
  - Ubuntu: `curl -LO https://github.com/dandavison/delta/releases/download/0.19.0/git-delta_0.19.0_amd64.deb && sudo dpkg -i git-delta_0.19.0_amd64.deb`
  - Brew: `brew install git-delta`
  - Примечание: пакет обычно называется `git-delta`, а бинарник — просто `delta`; `.deb` берётся со страницы релизов.

- `grex`

  - Репо: `https://github.com/pemistahl/grex`
  - Описание: CLI-утилита и Rust-библиотека с Python bindings, которая автоматически строит регулярное выражение по заданным тестовым строкам; результат гарантированно совпадает с ними и по умолчанию старается быть максимально специфичным.
  - Ubuntu: `cargo install grex`
  - Brew: `brew install grex`

### Статьи

- Подборки
  - 27 Rust-based alternatives to classic CLI apps https://dev.to/lingodotdev/27-rust-based-alternatives-to-classic-cli-apps-2350
