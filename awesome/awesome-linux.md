
### Коллекции

- https://github.com/inputsh/awesome-linux
- https://github.com/luong-komorebi/Awesome-Linux-Software
- KDE
    - https://github.com/francoism90/awesome-kde
- Gnome
    - https://github.com/Kazhnuz/awesome-gnome

### Утилиты

- Поиск
    - `ag` The Silver Searcher - это инструмент поиска кода, аналогичный ack, с фокусом на скорость. 
        - https://github.com/ggreer/the_silver_searcher
        - `apt-get install silversearcher-ag`
- NixOs
    - https://github.com/nix-community/nixos-anywhere

### Пакетные менеджеры

- https://nix.dev/install-nix#install-nix
- https://docs.brew.sh/Homebrew-on-Linux

### Дополнения для виртуальных машин

- virt-manager, kvm, qemu
    - https://www.spice-space.org/download.html

### Аналоги утилит на rust

- tree
    - https://github.com/solidiquis/erdtree

### Репозитории

### Гайды

- About A comprehensive guide for Linux Network (Socket) programming https://github.com/nguyenchiemminhvu/LinuxNetworkProgramming

### Книги, Wiki

- https://bottomupcs.com/index.html

### Книги

### Полезные ссылки

- Паксталл AUR для Ubuntu https://pacstall.dev/
- Образы дисков для виртуалки windows для SPICE(drag&drop, общий буфер) для virt-manager, virtio-win driver https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md
- The easiest way to run a Linux distribution or application on an Android device. With UserLAnd the power to do or create whatever you want will never be out of reach. https://userland.tech/
- Китай
    - Группа по интересам West Post Linux Бесплатный Открытый Доступ https://www.xiyoulinux.com/
- ExplainShell — это онлайн-сервис для анализа и упрощения понимания команд командной строки в Linux, в котором пользователь вводит команду, а сайт разбирает ее, предоставляя подробное объяснение каждого аргумента и опции на основании данных из руководств.https://www.explainshell.com/

### Полезные утилиты

- WindTerm https://github.com/kingToolbox/WindTerm https://kingtoolbox.github.io/
- Muon SSH Terminal/SFTP Client (Formerly Snowflake) https://github.com/devlinx9/muon-ssh
- electerm Open-sourced terminal/ssh/telnet/serialport/RDP/VNC/sftp client(linux, mac, win). https://github.com/electerm/electerm
- Ásbrú Connection Manager is a user interface that helps organizing remote terminal sessions and automating repetitive tasks https://www.asbru-cm.net/ https://github.com/asbru-cm/asbru-cm

### Курсы

- https://ravesli.com/uroki-po-linux/

### Блоги

- https://www.redhat.com/en/blog
- https://www.brendangregg.com/blog/
- https://linuxtldr.com/
- https://www.linux-magazine.com
- https://www.linuxbabe.com
- https://blog.it-kb.ru/tag/linux/
- https://www.learnlinux.tv/
- https://idea.popcount.org/
- https://darkcoding.net/tags/linux/
- https://penkovski.com/
- https://linuxexplore.com/
- https://www.linuxlinks.com/
- https://adamdjellouli.com/articles/linux_notes

### Статьи

- Linux
    - Основное
        - Introduction to Linux A Hands on Guide https://tldp.org/LDP/intro-linux/html/index.html
        - The Linux Kernel Module Programming Guide https://tldp.org/LDP/lkmpg/2.6/html/index.html
        - The Linux System Administrator's Guide https://tldp.org/LDP/sag/html/index.html
        - Linux's Bedtime Routine (В статье рассматриваются процессы, связанные с переходом системы Linux из активного состояния в спящий режим. В ней подробно описываются механизмы синхронизации файловых систем, управление питанием и базовые функции ядра, которые облегчают этот переход) https://tookmund.com/2024/09/hibernation-preparation 
        - How raw sockets behave differently in macOS and Linux https://swagnik.netlify.app/posts/how-raw-sockets-behave-in-different-systems/
        - Linux fundamentals: user space, kernel space, and the syscalls API surface https://www.form3.tech/blog/engineering/linux-fundamentals-user-kernel-space
    - dup
        - dup, dup2, dup3 - duplicate a file descriptor https://man7.org/linux/man-pages/man2/dup.2.html
    - select
        - Select is fundamentally broken https://idea.popcount.org/2017-01-06-select-is-fundamentally-broken/
    - epoll
        - epoll(7) — Linux manual page https://man7.org/linux/man-pages/man7/epoll.7.html
        - What is epoll? https://medium.com/@avocadi/what-is-epoll-9bbc74272f7c
        - Async IO on Linux: select, poll, and epoll https://jvns.ca/blog/2017/06/03/async-io-on-linux--select--poll--and-epoll/
        - Epoll is fundamentally broken 1/2 https://idea.popcount.org/2017-02-20-epoll-is-fundamentally-broken-12/
        - Epoll is fundamentally broken 2/2 https://idea.popcount.org/2017-03-20-epoll-is-fundamentally-broken-22/
        - I/O Multiplexing (select vs. poll vs. epoll/kqueue) https://nima101.github.io/io_multiplexing
        - Scalable Event Multiplexing: epoll vs. kqueue https://long-zhou.github.io/2012/12/21/epoll-vs-kqueue.html
        - epoll: The API that powers the modern internet https://darkcoding.net/software/epoll-the-api-that-powers-the-modern-internet/
        - Epoll Kernel Performance Improvements https://events19.linuxfoundation.org/wp-content/uploads/2018/07/dbueso-oss-japan19.pdf
    - SO_REUSEPORT
        - Linux TCP SO_REUSEPORT — Usage and implementation https://blog.flipkart.tech/linux-tcp-so-reuseport-usage-and-implementation-6bfbf642885a
        - Performance Optimisation using SO_REUSEPORT https://medium.com/high-performance-network-programming/performance-optimisation-using-so-reuseport-c0fe4f2d3f88
        - Perfect locality and three epic SystemTap scripts https://blog.cloudflare.com/perfect-locality-and-three-epic-systemtap-scripts/
        - True Zero Downtime HAProxy Reloads (В статье описывается, как Yelp реализовала решение для перезагрузки HAProxy без простоя, используя дисциплины очередей (qdiscs) в Linux для задержки SYN-пакетов во время перезагрузки, тем самым избегая обрывов соединений и минимизируя задержку по сравнению с другими подходами, такими как отбрасывание SYN-пакетов.) https://web.archive.org/web/20220520183147/https://engineeringblog.yelp.com/2015/04/true-zero-downtime-haproxy-reloads.html
    - /dev
        - Understanding the /dev Directory in Linux https://www.baeldung.com/linux/dev-directory
    - Утилиты
        - logger
    - Файловая система
        - Files and Filesystems https://adamdjellouli.com/articles/linux_notes/file_system
    - Логирование
        - Основное
            - Linux Logging Basics https://www.loggly.com/ultimate-guide/linux-logging-basics/
            - Log Files, Journals, and Logging Systems https://adamdjellouli.com/articles/linux_notes/log_files_and_journals
        - syslog
            - How to Set Up Centralized Logging on Linux with Rsyslog https://betterstack.com/community/guides/logging/how-to-configure-centralised-rsyslog-server/
            - syslog-ng https://wiki.archlinux.org/title/Syslog-ng
    - Остальное
- ZRAM
    - Memory Compression https://www.linux-magazine.com/Issues/2018/215/Memory-Compression
    - Benad's Web Site; RAM Compression on Linux https://benad.me/blog/2021/02/23/ram-compression-on-linux/
    - How To Configure ZRAM On Ubuntu Linux https://thedroidguy.com/how-to-configure-zram-on-ubuntu-linux-1263231
    - Enabling RAM Compression on Lubuntu https://discourse.lubuntu.me/t/enabling-ram-compression-on-lubuntu/3323
    - How to Use ZRAM on Ubuntu 24.04 https://kienngd.github.io/how-to-use-zram-on-ubuntu-2404/
    - Enable Zram On Linux For Better System Performance https://fosspost.org/enable-zram-on-linux-better-system-performance
    - zram: Compressed RAM-based block devices https://docs.kernel.org/admin-guide/blockdev/zram.html
- File Descriptors, Файловые дескрипторы
    - File Descriptors https://bottomupcs.com/ch01s03.html
    - Как проверить все открытые файлы пользователем или процессом в Linux https://wiki.it-kb.ru/unix-linux/linux-cli-tools/how-to-check-all-open-files-by-process-or-user-in-linux
    - Количество открытых файлов, сокетов  https://blog.dtulyakov.ru/2015/02/files-max.html
    - Куда делись файловые дескрипторы? https://firstvds.ru/blog/kuda_delis_faylovye_deskriptory
- SSH
    - ssh_config
        - How to Use The SSH Config File https://phoenixnap.com/kb/ssh-config
    - tunnels
        - A Visual Guide to SSH Tunnels: Local and Remote Port Forwarding https://iximiuz.com/en/posts/ssh-tunnels/
        - SSH Local Port Forwarding https://penkovski.com/post/ssh-local-port-forwarding/
        - SSH port forwarding for Beginners https://nirali0.medium.com/ssh-port-forwarding-for-beginners-228d9a1d5622
    - Остальное
        - OpenSSH/Cookbook/Multiplexing https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Multiplexing
- sockets
    - What is a socket? https://beej.us/guide/bgnet/html/split/what-is-a-socket.html#what-is-a-socket
- cgroup
    - Practicing cgroup v2 https://medium.com/@charles.vissol/practicing-cgroup-v2-cad6743bba0c
- systemd
    - Основное
        - Systemd для начинающих: разбор юнитов и их функций https://habr.com/ru/companies/factory5/articles/842518/
        - How to view status of a service on Linux using systemctl https://www.cyberciti.biz/faq/systemd-systemctl-view-status-of-a-service-on-linux/
        - Chapter 10. Managing Services with systemd https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/system_administrators_guide/chap-managing_services_with_systemd#sect-Managing_Services_with_systemd-Introduction
        - Systemd and cgroup https://medium.com/@charles.vissol/systemd-and-cgroup-7eb80a08234d
        - systemd десять лет спустя. Историческая и техническая ретроспектива https://habr.com/ru/articles/503816/
    - healthcheck
        - Set up self-healing services with systemd https://www.redhat.com/en/blog/systemd-automate-recovery
    - systemd-nspawn
        - Основное
            - Systemd и контейнеры: знакомство с systemd-nspawn https://habr.com/ru/companies/selectel/articles/271957/
        - machinectl
            - Setting up containers with systemd-nspawn https://medium.com/@huljar/setting-up-containers-with-systemd-nspawn-b719cff0fb8d
            - Developer Diary Excerpts: machinectl auto-login https://philip-trauner.me/blog/post/machinectl-autologin
        - Остальное
            - Running systemd-nspawn containers with a VPN interface https://blog.lieter.nl/posts/systemd-nspawn-multi-interfaces-container-wireguard/
            - Systemd Nspawn https://jimmyg.org/blog/2022/nspawn/index.html
    - Остальное
        - Systemd Watchdog for Any Service https://www.medo64.com/2019/01/systemd-watchdog-for-any-service/      
        - systemd: The Good Parts https://www.hashicorp.com/resources/systemd-the-good-parts
        - systemd For Administrators, Part XXI https://0pointer.net/blog/systemd-for-administrators-part-xxi.html
- Привилегии, Capabilities
    - Остальное
        - What's The Big Deal With Linux Capabilities? https://hackernoon.com/whats-the-big-deal-with-linux-capabilities
        - What's the Big Deal with Linux Capabilities? (Part 2) https://hackernoon.com/whats-the-big-deal-with-linux-capabilities-part-2
        - В двух словах о привилегиях Linux (capabilities) https://habr.com/ru/companies/otus/articles/471802/
    - setcap, getcap
        - setcap https://www.protokols.ru/WP/setcap/
        - Замена setuid-бита на capabilities для системных программ в Linux https://www.opennet.ru/tips/2469_capabilities_suid_security_limit.shtml
        - Лишение пользователя root привилегий https://rus-linux.net/MyLDP/admin/making_root_unprivileged.html
        - Capabilities (Русский) https://wiki.archlinux.org/title/Capabilities_(Русский)
    - capsh
        - capsh command https://linux-audit.com/system-administration/commands/capsh/
- getfattr, setfattr
- setfacl, getfacl
- setpriv
- podman
    - Podman at the edge: Keeping services alive with custom healthcheck actions https://www.redhat.com/en/blog/podman-edge-healthcheck
- RabbitMQ
    - How to Install RabbitMQ Server on Linux (Quick Guide) https://linuxtldr.com/install-rabbitmq-server-on-linux/
- SSH
    - Fail2Ban
        - Fail2Ban-SSH и Brute-force attack https://hackmd.io/@AndrewMsk/rJhRSfwti
- find
    - Find large files Linux/macOS https://www.vanwerkhoven.org/blog/2024/find-large-files-linux-macos/
- Сеть, network
    - Основное
    - Количество соединений
        - What limits the maximum number of connections on a Linux server? https://betterstack.com/community/questions/what-limits-the-maximum-number-of-connections-on-linux-server/
        - Maximize your concurrent web server connections https://wakatime.com/blog/47-maximize-your-concurrent-web-server-connections
    - Остальное
- Системы мониторинга
    - Zabbix
        - Развертывание Zabbix 4.4 с nginx, php-fpm и MySQL Percona в Docker https://it-lux.ru/развертывание-zabbix-4-с-nginx-php-fpm-и-mysql-в-docker/
- VyOS (Open-source fully functional router and firewall platform)
    - Основное
        - https://vyos.net/get/nightly-builds/
        - VyOS https://ru.wikipedia.org/wiki/VyOS
    - Wireguard
        - OSPF over Wireguard with VyOS https://www.eliseomartelli.it/blog/vyos-ospf-wireguard
    - Homelab
        - VyOS from Scratch: Routing and VPS Edition https://blog.kroy.io/2021/06/23/vyos-from-scratch-routing-and-vps-edition/
        - Homelab Proxmox + Debian + VyOS upgrade migration https://www.vanwerkhoven.org/blog/2024/homelab-upgrade-migration/
    - Остальное
        - Configuring A and AAAA records in VyOS 1.1.7 https://blog.mana.ee/2017/11/30/configuring-a-and-aaaa-records-in-vyos/
        - VPN tunnel between Cisco and VyOS routers using VTIs https://dosztal.com/blog/vpn-cisco-vyos/
        - VyOS OpenSource Router https://habr.com/ru/articles/435568/
        - Создание отказоустойчивой ИТ инфраструктуры. Часть 3. Организация маршрутизации на роутерах VyOS https://habr.com/ru/companies/lenvendo/articles/487408/
        - Программная маршрутизация с VyOS https://selectel.ru/blog/programmnaya-marshrutizaciya-s-vyos/
        - Программная маршрутизация с VyOS https://habr.com/ru/companies/selectel/articles/248907/
        - Программная маршрутизация с VyOS в условиях санкций https://lwcom.ru/blog/programmnaya-marshrutizatsiya-s-vyos-v-usloviyakh-sanktsiy/
- Nix
    - NixOs
        - Немного о NixOS. Часть 1. Общая информация и установка https://habr.com/ru/articles/826148/
        - Мои приключения с NixOS, часть 1: начало работы https://setser.github.io/2019/02/01/nixos-part-1.html
        - Сборка пакета для Nix https://uralbash.ru/articles/2017/nixpkgs-contribute/
        - Как создать песочницу и опакетить программу в NixOS? https://vk.com/@openrc-kak-opaketit-programmu-v-nixos-i-kak-sozdat-pesochnicu
        - Nix: воспроизводимая сборка https://habr.com/ru/companies/typeable/articles/556828/
        - Воспроизводимая среда разработки с Nix https://archercreat.github.io/build-environment-with-nix-shell/
        - NixOS is a good server OS, except when it isn't https://sidhion.com/blog/posts/nixos_server_issues/
        - NixOS — установка и настройка https://vk.com/@linuxsovet-nixos-ustanovka-i-nastroika
        - Nginx https://nixos.wiki/wiki/Nginx
        - Running NixOS from any Linux Distro in systemd-nspawn Containers https://nixcademy.com/posts/nixos-nspawn/
        - Run and Auto-Update Docker Containers on NixOS https://nixcademy.com/posts/auto-update-containers/
    - Остальное
        - Isolated Development Environment using Nix https://ariya.io/2016/06/isolated-development-environment-using-nix
        - A step towards the future of configuration and infrastructure management with Nix https://blog.container-solutions.com/step-towards-future-configuration-infrastructure-management-nix
        - Cheap Docker images with Nix https://lucabrunox.github.io/2016/04/cheap-docker-images-with-nix_15.html
- Диски
    - \[Пошагово\] Клонирование диска Clonezilla с большего на меньший https://www.diskpart.com/ru/articles/clonezilla-clone-larger-disk-to-smaller-disk-1503.html
- Git
    - On the Matter of Beautiful git Diffs https://nathanleclaire.com/blog/2016/06/28/on-the-matter-of-beautiful-git-diffs/
- Подборки
    - 30 Linux Terminal Emulators https://linuxblog.io/linux-terminal-emulators/
    - 23 Best Emulator Choices of 2025 https://thectoclub.com/tools/best-terminal-emulator/
    - A Guide to Linux System Monitoring: top, htop, btop, and glances https://machaddr.substack.com/p/a-guide-to-linux-system-monitoring
- Остальное
    - Мой первый контейнер без Docker https://habr.com/ru/articles/881428/
    - How to supercharge string search through a directory hierarchy on a Linux/Unix [статья](https://www.cyberciti.biz/open-source/command-line-hacks/ag-supercharge-string-search-through-directory-hierarchy/)
    - You can list a directory containing 8 million files! But not with ls. [статья](http://be-n.com/spw/you-can-list-a-million-files-in-a-directory-but-not-with-ls.html)

### Видео

- This homelab setup is my favorite one yet. https://www.youtube.com/watch?v=2yplBzPCghA
- POSIX
    - pthreads
        - АК[ОС] 28. Pthreads. Потоки в POSIX. https://www.youtube.com/watch?v=pPjDPe0duXc
- Ядро Linux
    - Системные вызовы
        - Linux Kernel. 1 - Исследуем системный вызов fork https://www.youtube.com/watch?v=KIaTpku7wEI

### StackOverflow

- Test if remote TCP port is open from a shell script https://stackoverflow.com/questions/4922943/test-if-remote-tcp-port-is-open-from-a-shell-script
- Cloning hard disk partition to smaller SSD on laptop \[duplicate\] https://askubuntu.com/questions/842029/cloning-hard-disk-partition-to-smaller-ssd-on-laptop
- Using Wireshark with remote interface https://superuser.com/questions/1585650/using-wireshark-with-remote-interface