### Коллекции

- https://moistcatawumpus.github.io/awesome-docker/
- https://github.com/veggiemonk/awesome-docker
- https://github.com/docker/awesome-compose
- https://gitpiper.com/resources/docker/awesomelists/n1trux-awesome-sysadmin

### Репозитории

- Сканеры безопасности, security scanners
    - cnitch - это инструмент командной строки и фреймворк для мониторинга Docker-контейнеров, который выявляет процессы, запущенные с правами root-пользователя, что помогает обеспечить безопасность контейнеризованных приложений. https://github.com/nicholasjackson/cnitch
    - Trivy - это универсальный сканер безопасности с открытым исходным кодом, который проверяет контейнеры, файловые системы, Git-репозитории, образы виртуальных машин и Kubernetes на наличие уязвимостей, проблем с конфигурацией, секретов и лицензий программного обеспечения. https://github.com/aquasecurity/trivy
- Линтеры, linters
    - Hadolint - это интеллектуальный линтер Dockerfile, анализирующий синтаксис через AST и использующий ShellCheck для проверки bash-команд в инструкциях RUN, помогающий создавать Docker-образы в соответствии с лучшими практиками. https://github.com/hadolint/hadolint
    - Dockle - это инструмент с открытым исходным кодом для анализа безопасности Docker-образов, который помогает создавать контейнеры в соответствии с лучшими практиками, поддерживает CI/CD интеграцию и включает проверки на соответствие CIS Benchmarks. https://github.com/goodwithtech/dockle
- Образы
    - "Distroless" - это проект контейнерных образов, содержащих только необходимые приложения и их зависимости времени выполнения, без стандартных компонентов Linux-дистрибутива, что делает их максимально легкими и безопасными. https://github.com/GoogleContainerTools/distroless

### Остальное

- Windows in a Docker container. https://github.com/dockur/windows

### Базы данных в docker

- https://github.com/treetips/docker-compose-all-mysql
- https://github.com/studiomitte/docker-compose-mariadb
- https://github.com/yiisoft/db-mysql/tree/master

### Полезные ссылки

- https://awesome-docker-compose.com/
- https://github.com/openfaas/faas
- Devilbox — это открытая и настраиваемая среда для локальной веб-разработки на основе стека LAMP/MEAN. http://devilbox.org/

### Гайды

- Docker, FROM scratch https://docker-from-scratch.ivonet.nl/

### Книги

### Статьи

- Основоное
    - A Deep Dive into Docker Compose https://dev.to/alexmercedcoder/a-deep-dive-into-docker-compose-27h5
    - How to use docker compose depends_on a beginner's guide https://geshan.com.np/blog/2024/02/docker-compose-depends-on/
    - The definitive Guide to Docker compose https://gabrieltanner.org/blog/docker-compose/
    - Docker for Beginners: A Step-by-Step Guide to Get Started…. https://medium.com/@anjanathenuwara/from-beginner-to-pro-everything-you-need-to-know-about-docker-5d8f38db2ba6
    - Docker на каждый день: Ключевые команды в одной статье-шпаргалке https://habr.com/ru/articles/913978/
- Отладка, Debugging, Troubleshooting
    - Chapter 12: Troubleshooting and Debugging with Docker https://praneethreddybilakanti.medium.com/chapter-12-troubleshooting-and-debugging-with-docker-0a37b6d47d38
    - 13 Ways to Troubleshoot Docker Faster in 2024 https://overcast.blog/13-ways-to-troubleshoot-docker-faster-in-2024-5b064c20c9e2
- Network
    - Compose Create Networks In Docker Compose https://www.warp.dev/terminus/docker-compose-networks
    - Доступ http из одного проекта docker-compose к другому https://itelmenko.ru/devops/docker-composer-2-project-network/
    - Chap-14: Docker Networking with Docker Compose: Example and Configuration https://medium.com/@maheshwar.ramkrushna/chap-13-docker-networking-with-docker-compose-example-and-configuration-cc5a8b2bdb2b
    - Docker Stacks and Attachable networks https://blog.alexellis.io/docker-stacks-attachable-networks/
    - Элемент верхнего уровня сети https://digitology.tech/docs/docker/compose/compose-file/06-networks.html
    - Setting Up Docker Overlay Network https://opstree.com/blog/2020/07/07/setting-up-docker-overlay-network/
- Swarm
    - Docker Secrets
        - How to use secrets in Docker Compose https://docs.docker.com/compose/how-tos/use-secrets/
        - Docker Secrets: An Introductory Guide with Examples https://medium.com/@laura_67852/docker-secrets-an-introductory-guide-with-examples-d25be5fc8e50
        - A Complete Guide to Docker Secrets Management https://semaphore.io/blog/docker-secrets-management
        - How to Handle Secrets in Docker https://blog.gitguardian.com/how-to-handle-secrets-in-docker/
        - Handling Docker Secrets the Right Way https://medium.com/@dariusmurawski/handling-docker-secrets-the-right-way-cc625be3395d
        - Managing Secrets in Docker Compose — A Developer's Guide https://phase.dev/blog/docker-compose-secrets/
        - Handling Environment Variables in Docker Compose for Secure and Flexible Configurations https://medium.com/@sh.hamzarauf/handling-environment-variables-in-docker-compose-for-secure-and-flexible-configurations-5ce6a5bb0412
        - Secure Your Docker Stack: A Comprehensive Guide to Docker Compose Secrets https://www.bitdoze.com/docker-compose-secrets/
- Права
    - Understanding File Permissions https://serversideup.net/open-source/docker-php/docs/guide/understanding-file-permissions
    - Permission Denied Nginx Docker | by Serghei Pogor | Medium https://sergheipogor.medium.com/permission-denied-nginx-docker-72caa442e351
- Масштаблирование, Scaling
    - Масштабирование сервисов https://javarush.com/quests/lectures/ru.javarush.docker.fullstack.lecture.level04.lecture07
- Логирование
    - Работа с логами (Logs) в Docker https://linux-notes.org/rabota-s-logami-logs-v-docker/
- Images, Образы
    - Основное
        - 10 Docker Security Best Practices https://snyk.io/blog/10-docker-image-security-best-practices/
        - 10 best practices to containerize Node.js web applications with Docker https://snyk.io/blog/10-best-practices-to-containerize-nodejs-web-applications-with-docker/
    - scratch
        - Building container images from scratch (with the scratch base image) https://medium.com/@m0v_3r/building-container-images-from-scratch-with-the-scratch-base-image-8ff56812124b
        - Using Docker images from scratch https://zawadidone.nl/using-docker-images-from-scratch/
        - Why Can't I Pull The Scratch Docker Image? https://mannes.tech/docker-scratch/
        - Non-privileged containers based on the scratch image https://medium.com/@lizrice/non-privileged-containers-based-on-the-scratch-image-a80105d6d341
    - Остальное
        - The Quest for Minimal Docker Images, part 1 https://jpetazzo.github.io/2020/02/01/quest-minimal-docker-images-part-1/
        - The Quest for Minimal Docker Images, part 2 http://jpetazzo.github.io/2020/03/01/quest-minimal-docker-images-part-2/
        - The Quest for Minimal Docker Images, part 3 http://jpetazzo.github.io/2020/04/01/quest-minimal-docker-images-part-3/
- AI
    - Docker Model Runner
        - https://docs.docker.com/desktop/features/model-runner/
        - Docker теперь конкурент Ollama? https://habr.com/ru/articles/897326/
- Лучшие практики
    - 50 years of accumulated technologies, 70+ best practices, and you need to figure it out all on your own https://pythonspeed.com/products/productionhandbook/
- Безопасность
    - Основное
        - 10 самых распространенных проблем при линтинге Dockerfile'ов https://habr.com/ru/companies/flant/articles/787494/
        - Худшие из так называемых «лучших практик» для Docker https://habr.com/ru/companies/vk/articles/550138/
        - Способы и примеры внедрения утилит для проверки безопасности Docker https://habr.com/ru/companies/swordfish_security/articles/524490/
        - Лучшие практики при написании безопасного Dockerfile https://habr.com/ru/companies/swordfish_security/articles/537280/
    - Trivy
        - Безопасность контейнеров на новом уровне: Погружение в Trivy https://habr.com/ru/companies/securityvison/articles/837966/
        - Trivy: вредные советы по скрытию уязвимостей https://habr.com/ru/companies/swordfish_security/articles/822705/        
- Примеры готовых решений
    - nginx
        - Running Nginx official image as non root https://forums.docker.com/t/running-nginx-official-image-as-non-root/135759
    - Devilbox
        - Devilbox aka ящик дьявола https://php.dragomano.ru/devilbox/?ysclid=m7vn8s9mtj381038846#pristupaem
        - Best practice https://devilbox.readthedocs.io/en/latest/intermediate/best-practice.html?highlight=mysql#php-project-hostname-settings
        - Лучший аналог OpenServer Для Linux (Devilbox) https://seryibaran.github.io/posts/analog-openserver-dlya-linux-devilbox/
    - Остальное
- Подборки
    - Обзор топ-5 полезных утилит для Docker https://habr.com/ru/companies/first/articles/703708/
    - 5 Awesome Docker Tools To Make Your Life Easier https://dev.to/code42cate/5-awesome-docker-tools-to-make-your-life-easier-22kl
    - Docker Tips: Essential Tips and Tricks for Developers https://dev.to/pawanimadushika/docker-tips-essential-tips-and-tricks-for-developers-1hl8
- Остальное
    - Using `socat` in Docker to power a single-use download service https://dev.to/jmarhee/using-socat-in-docker-to-power-a-single-use-download-service-3c98
    - Как связать Docker-контейнеры, не заставляя приложение читать переменные окружения https://habr.com/ru/articles/260053/
    - Socat and Docker https://lihsmi.ch/docker/2020/01/02/socat-docker.html

### Блоги

- https://blog.alexellis.io/
- https://mannes.tech/tag/docker/

### Примеры

- https://github.com/itelmenko/myblog/tree/main/examples/docker-network

### Вопросы

- https://www.turing.com/interview-questions/docker
- https://www.edureka.co/blog/interview-questions/docker-interview-questions/
- https://www.mygreatlearning.com/blog/docker-interview-question-and-answers/
- https://medium.com/@sushantkapare1717/docker-interview-questions-74b517ee8943
- https://www.geeksforgeeks.org/docker-interview-questions/