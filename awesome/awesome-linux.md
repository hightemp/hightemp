
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

### Дополнения для виртуальных машин

- virt-manager, kvm, qemu
    - https://www.spice-space.org/download.html

### Аналоги утилит на rust

- tree
    - https://github.com/solidiquis/erdtree

### Книги, Wiki

- https://bottomupcs.com/index.html

### Книги

### Блоги

- https://www.redhat.com/en/blog
- https://www.brendangregg.com/blog/
- https://linuxtldr.com/
- https://www.linux-magazine.com
- https://www.linuxbabe.com

### Полезные ссылки

- Образы дисков для виртуалки windows для SPICE(drag&drop, общий буфер) для virt-manager, virtio-win driver https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md

### Пакетные менеджеры

- https://nix.dev/install-nix#install-nix
- https://docs.brew.sh/Homebrew-on-Linux

### StackOverflow

- Test if remote TCP port is open from a shell script https://stackoverflow.com/questions/4922943/test-if-remote-tcp-port-is-open-from-a-shell-script

### Статьи

- Linux
    - Introduction to Linux A Hands on Guide https://tldp.org/LDP/intro-linux/html/index.html
    - The Linux Kernel Module Programming Guide https://tldp.org/LDP/lkmpg/2.6/html/index.html
    - The Linux System Administrator's Guide https://tldp.org/LDP/sag/html/index.html
    - Linux's Bedtime Routine (В статье рассматриваются процессы, связанные с переходом системы Linux из активного состояния в спящий режим. В ней подробно описываются механизмы синхронизации файловых систем, управление питанием и базовые функции ядра, которые облегчают этот переход) https://tookmund.com/2024/09/hibernation-preparation 
    - How raw sockets behave differently in macOS and Linux https://swagnik.netlify.app/posts/how-raw-sockets-behave-in-different-systems/
    - Linux fundamentals: user space, kernel space, and the syscalls API surface https://www.form3.tech/blog/engineering/linux-fundamentals-user-kernel-space
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
    - Остальное
        - OpenSSH/Cookbook/Multiplexing https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Multiplexing
- sockets
    - What is a socket? https://beej.us/guide/bgnet/html/split/what-is-a-socket.html#what-is-a-socket
- cgroup
    - Practicing cgroup v2 https://medium.com/@charles.vissol/practicing-cgroup-v2-cad6743bba0c
- systemd
    - Основное
        - How to view status of a service on Linux using systemctl https://www.cyberciti.biz/faq/systemd-systemctl-view-status-of-a-service-on-linux/
        - Chapter 10. Managing Services with systemd https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/system_administrators_guide/chap-managing_services_with_systemd#sect-Managing_Services_with_systemd-Introduction
        - Systemd and cgroup https://medium.com/@charles.vissol/systemd-and-cgroup-7eb80a08234d
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
- Git
    - On the Matter of Beautiful git Diffs https://nathanleclaire.com/blog/2016/06/28/on-the-matter-of-beautiful-git-diffs/
- Остальное
    - How to supercharge string search through a directory hierarchy on a Linux/Unix [статья](https://www.cyberciti.biz/open-source/command-line-hacks/ag-supercharge-string-search-through-directory-hierarchy/)
    - You can list a directory containing 8 million files! But not with ls. [статья](http://be-n.com/spw/you-can-list-a-million-files-in-a-directory-but-not-with-ls.html)

### Видео

- This homelab setup is my favorite one yet. https://www.youtube.com/watch?v=2yplBzPCghA