### Интеграции для редакторов

#### DevDocs

- devdocs.el - это Emacs-просмотрщик для DevDocs, аналогичный встроенному Info-браузеру, доступный в GNU ELPA и MELPA через `M-x package-install RET devdocs`. https://github.com/astoff/devdocs.el
- emacs-devdocs-browser - это Emacs-пакет для просмотра DevDocs через EWW с подсветкой синтаксиса, офлайн-режимом и управлением docset'ами. https://github.com/blahgeek/emacs-devdocs-browser
- DevDocs.el - это устаревший Emacs-пакет для поиска в DevDocs с открытием результатов в браузере через `M-x devdocs-search`. https://github.com/xuchunyang/DevDocs.el
- devdocs-lookup - это минималистичный Emacs-пакет для быстрого перехода к записям devdocs.io в браузере. https://github.com/skeeto/devdocs-lookup
- nvim-devdocs - это Neovim-плагин для офлайн-просмотра DevDocs с интеграцией Telescope и рендерингом Markdown (заархивирован). https://github.com/luckasRanarison/nvim-devdocs
- devdocs.nvim - это Neovim-клиент для devdocs.io на базе `curl`, `jq`, `pandoc` и snacks.nvim picker. https://github.com/maskudo/devdocs.nvim
- madstone-devdocs.nvim - это Neovim-плагин с fuzzy-поиском через Telescope и офлайн-режимом, требующий Rust-инструмент `dedoc` (`cargo install dedoc`). https://github.com/madstone-tech/madstone-devdocs
- devdocs JetBrains Plugin - это плагин для IntelliJ/PhpStorm, позволяющий искать документацию на devdocs.io через `Ctrl+K`. https://plugins.jetbrains.com/plugin/15367-devdocs

#### Dash / Zeal Docsets

- helm-dash - это Emacs-пакет для поиска по Dash/Zeal docsets через Helm/Ivy/Consult без необходимости запускать Dash. https://github.com/dash-docs-el/helm-dash
- counsel-dash - это Emacs-пакет для поиска по Dash docsets через интерфейс Ivy. https://github.com/dash-docs-el/counsel-dash
- zeal-at-point - это Emacs-пакет для открытия Zeal с символом под курсором, аналог `dash-at-point` для macOS. https://github.com/jinzhu/zeal-at-point
- vscode-dash - это расширение VS Code для поиска документации в Dash/Zeal по символу под курсором через `Ctrl+H`. https://marketplace.visualstudio.com/items?itemName=deerawan.vscode-dash
- IntelliJDashPlugin - это плагин для IntelliJ/PhpStorm/GoLand, обеспечивающий интеграцию с Dash на macOS и Velocity на Windows через `Ctrl+Shift+D`. https://github.com/gdelmas/IntelliJDashPlugin
- Alfred-Dash-Workflow - это официальный Alfred Workflow для быстрого поиска по Dash docsets на macOS. https://github.com/Kapeli/Dash-Alfred-Workflow
- dasht - это набор shell-скриптов для поиска по Dash docsets в терминале через `w3m` или локальный HTTP-сервер с поддержкой интеграции в Vim/Neovim. https://github.com/sunaku/dasht
- Visual Studio Code Dash: Расширение для редактора VS Code, обеспечивающее быструю интеграцию с браузерами документации Dash, Zeal и Velocity для мгновенного поиска API-справок по выделенному фрагменту кода или языку программирования. https://github.com/deerawan/vscode-dash

### Утилиты для скачивания и хранения документации

- Zeal: Оффлайн-браузер документации для разработчиков программного обеспечения, вдохновленный Dash и позволяющий быстро осуществлять поиск по наборам API-документации без доступа к интернету. https://github.com/zealdocs/zeal https://zealdocs.org/
- Velocity — аналог Dash для Windows https://velocity.findmysoft.com/
- dasht is a collection of shell scripts for searching, browsing, and managing API documentation (in the form of 200+ offline documentation sets, courtesy of Dash for macOS) all from the comfort of your own terminal! https://www.x-cmd.com/install/dasht https://github.com/x-cmd/x-cmd
- A documentation browser with support for DevDocs, Dash and Hoogle, written in Haskell and QML https://github.com/qwfy/doc-browser

### Сервисы предоставляющие документацию для разработчиков

- DevDocs — это бесплатный веб‑браузер документации для разработчиков, который объединяет более 100 справочников в одном интерфейсе и поддерживает быстрый поиск, в том числе офлайн‑доступ. https://devdocs.io/ https://github.com/freeCodeCamp/devdocs
    - Можно запустить self-hosted через Docker: `docker run -d -p 9292:9292 ghcr.io/freecodecamp/devdocs:latest`
- smartstack.dev — это AI-powered хаб документации для разработчиков, который позволяет искать и общаться в чате сразу по 200+ официальным источникам документации в одном месте, давая точные ответы без галлюцинаций. https://smartstack.dev/