### Коллекции

- https://github.com/dictcp/awesome-git
- A collection of .gitignore templates https://github.com/github/gitignore

### Курсы

- GitByBit — это интерактивный курс, который обучает работе с Git прямо в редакторе кода (VS Code), позволяя практиковаться с командами и получать мгновенную обратную связь для быстрого освоения системы контроля версий. https://gitbybit.com/

### Conventional Commits - Тип коммита:

* `feat` – добавление новой функциональности.
* `fix` – исправление ошибки (бага).
* `chore` – прочие изменения, не затрагивающие исходный код или тесты (например, обновление зависимостей).
* `refactor` – рефакторинг кода, который не исправляет ошибки и не добавляет новую функциональность.
* `docs` – обновление документации (например, `README` или других файлов markdown).
* `style` – изменения, не влияющие на логику кода (пробелы, форматирование, недостающие точки с запятой и т.п.).
* `test` – добавление новых или исправление существующих тестов.
* `perf` – изменения, улучшающие производительность.
* `ci` – изменения, затрагивающие систему непрерывной интеграции (CI).
* `build` – изменения, которые влияют на систему сборки или внешние зависимости.
* `revert` – откат предыдущего коммита.

### Тренажеры

- https://learngitbranching.js.org/

### Шпаргалки

- https://dangitgit.com/ru
- https://firstaidgit.ru/
- Шпаргалка по Git, в которой представлены основные команды https://proglib.io/p/git-cheatsheet
- https://github.com/nanisimova/texts/blob/main/tools/git_intro.md

### Книги

- Building Git https://shop.jcoglan.com/building-git/

### Статьи

- Основное
    - Современные команды и возможности Git https://www.dev-notes.ru/articles/git/modern-git-commands-and-features/
    - Инструкция как писать стандартизированные комментарии к коммитам (git commit) https://habr.com/ru/articles/673344/
    - Мегагайд: культура работы с Git https://habr.com/ru/companies/yandex_praktikum/articles/812139/
    - Введение в Git Merge и Git Rebase: зачем и когда их использовать https://habr.com/ru/articles/432420/
    - Modern Git Commands and Features You Should Be Using https://martinheinz.dev/blog/109
- Как устроен git
    - 10.2 Git Internals - Git Objects https://git-scm.com/book/en/v2/Git-Internals-Git-Objects
    - Git Internals: Architecture and Index Files https://learn.microsoft.com/en-us/archive/msdn-magazine/2017/august/devops-git-internals-architecture-and-index-files
    - Git Internals https://www.geeksforgeeks.org/git/git-internals/
    - DAG (Directed Acyclic Graph) https://www.graphapp.ai/engineering-glossary/git/dag-directed-acyclic-graph
    - Git object types (blob, tree, commit, tag) https://www.graphapp.ai/engineering-glossary/git/git-object-types-blob-tree-commit-tag
    - Explain BLOB object and tree object in Git. https://www.tutorialspoint.com/explain-blob-object-and-tree-object-in-git
    - Git Internals part 1: The git object model https://dev.to/calebsander/git-internals-part-1-the-git-object-model-474m
    - Git Internals part 2: packfiles https://dev.to/calebsander/git-internals-part-2-packfiles-1jg8
    - Git Internals part 3: the SSH transport https://dev.to/calebsander/git-internals-part-3-the-ssh-transport-2m5c
    - Как реализовать простой контроль версий с помощью JavaScript, чтобы лучше разобраться в Git https://nuancesprog.ru/p/19491/
    - Inside .git https://jvns.ca/blog/2024/01/26/inside-git/
    - Git from the inside out https://maryrosecook.com/blog/post/git-from-the-inside-out
- .gitignore
    - gitignore - Specifies intentionally untracked files to ignore https://git-scm.com/docs/gitignore/2.42.0
    - Настройка глобального файла .gitignore https://sergeymukhin.com/blog/nastroyka-globalnogo-fayla-gitignore
    - Игнорирование в Git https://www.atlassian.com/ru/git/tutorials/saving-changes/gitignore
    - Файл .gitignore – как игнорировать файлы и папки в Git https://wiki.merionet.ru/articles/fajl-gitignore-kak-ignorirovat-fajly-i-papki-v-git
    - Правила синтаксиса файла .gitignore https://korobchinskiy.com/gitignore-rules/
    - .gitignore Command Guide: Practical Examples and Terraform Tips https://www.env0.com/blog/gitignore-command-guide-practical-examples-and-terraform-tips
- plumbing commands
    - the plumbing commands https://gist.github.com/schacon/1153310
- Conventional Commits
    - How to Write Better Git Commit Messages – A Step-By-Step Guide https://www.freecodecamp.org/news/how-to-write-better-git-commit-messages/
    - Conventional Commits A specification for adding human and machine readable meaning to commit messages https://www.conventionalcommits.org/en/v1.0.0/#summary
    - Руководство по отправке сообщений https://developers.google.com/blockly/guides/contribute/get-started/commits?hl=ru
- Тэги, tags
    - How to push tags in Git https://graphite.dev/guides/git-push-tag
    - Git Push Tags https://www.warp.dev/terminus/git-push-tags
- worktree
    - git-worktree - Manage multiple working trees https://git-scm.com/docs/git-worktree
    - Как работать с Git worktree: краткая инструкция https://inoy.dev/blog/85
    - Experiment on your code freely with Git worktree https://opensource.com/article/21/4/git-worktree
- sparse-checkout
    - Bring your monorepo down to size with sparse-checkout https://github.blog/open-source/git/bring-your-monorepo-down-to-size-with-sparse-checkout/
- bisect
    - git-bisect - Use binary search to find the commit that introduced a bug https://git-scm.com/docs/git-bisect
- rebase
    - A Guide to Git Interactive Rebase, with Practical Examples https://www.sitepoint.com/git-interactive-rebase-guide/
    - Git Rebase vs. Merge: Which to Use? https://builtin.com/software-engineering-perspectives/git-rebase-vs-merge
    - How to Git rebase onto another branch https://graphite.dev/guides/git-rebase-onto-another-branch
- cherry pick
    - Git cherry pick https://www.atlassian.com/git/tutorials/cherry-pick
- Bisect: Отладка с помощью бинарного поиска
    - Using git bisect, the detective tool for debugging https://joeattardi.dev/using-git-bisect-the-detective-tool-for-debugging
    - git bisect: путешествие по времени и багам https://habr.com/ru/articles/591447/
- Reflog
    - Git reflog: Восстановление истории коммитов https://icoder.uz/testirovanie-i-devops/ys0zwa9wafu-git-reflog-history/
    - Using Refs And Reflogs In Git https://www.geeksforgeeks.org/git/using-refs-and-reflogs-in-git/
- git flow
    - GitFlow, GithubFlow, Trunk based development. Выбираем оптимальную модель ветвления https://timeweb.cloud/tutorials/microservices/kak-vybrat-optimalnuyu-model-vetvleniya
- Code review
    - Review checklist https://gist.github.com/bigsergey/aef64f68c22b3107ccbc439025ebba12
    - A complete guide to code reviews https://www.swarmia.com/blog/a-complete-guide-to-code-reviews/
    - What to look for in a code review https://google.github.io/eng-practices/review/reviewer/looking-for.html
- Остальное
    - How to Copy Commits From One Branch to Another? https://betterstack.com/community/questions/how-to-copy-commits-from-one-branch-to-another/
    - Ship / Show / Ask A modern branching strategy https://martinfowler.com/articles/ship-show-ask.html
    - Advanced Git: разбор сложных сценариев работы с репозиторием https://tproger.ru/articles/advanced-git--razbor-slozhnyh-scenariev-raboty-s-repozitoriem
    - Полезные команды Git: безопасная отмена коммитов, добавление файла из другой ветки и другие https://tproger.ru/translations/git-tips-and-tricks

### Видео

- Git — инструмент для совместной работы, с нуля и до регламента в команде — доклад Школы разработки интерфейсов Яндекса. Отличное объяснение того, что такое blob, commit, head, index, working tree, а также чем git merge отличается от git rebase. https://youtu.be/yDSs80lu3ak?si=-sHHqd7rPBk3Eywj