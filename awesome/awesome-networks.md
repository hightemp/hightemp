
### Коллекции

- https://github.com/anderspitman/awesome-tunneling

### Виртуальные роутеры

- Cisco ASAv https://software.cisco.com/download/home/286119613/type/280775065/release/9.18.4%20Interim
- Cisco CSR1000v https://software.cisco.com/download/home/284364978/type/282046477/release/3.15.0S

### Полезные утилиты

- Self-hosted ngrok alternative https://docs.ssi.sh/
- tcp/http self-hosted tunnel https://telebit.cloud/

### Репозитории

- Этот проект представляет собой инструмент на Python 3.8.10, который позволяет извлекать домены из диапазона IP-адресов, используя исторические данные из VirusTotal (с помощью API-ключа), поддерживает входной файл и выходной CSV-файл, и может быть полезен для извлечения субдоменов в программах по поиску ошибок. https://github.com/jevalenciap/iptodomain

### VPN

- https://www.vpnbook.com/

### Как получить список Российских адресов

- `curl https://stat.ripe.net/data/country-resource-list/data.json?resource=RU | jq -r '.data.resources.ipv4 | .[]' > ru.txt`

### Полезные ссылки

- Содержит диапазоны ip по странам. Так же много разных инструментов. https://suip.biz/
- Форум про сетевые технологии https://ntc.party/
- GoodbyeDPI — это утилита для обхода систем глубокой проверки пакетов (DPI), которая позволяет пользователям Windows получить доступ к заблокированным веб-сайтам, обходя блокировки, установленные интернет-провайдерами. https://github.com/ValdikSS/GoodbyeDPI
- Global Ping Statistics https://wondernetwork.com/pings
- IPFS (InterPlanetary File System) - это децентрализованная пиринговая сеть для хранения и обмена данными, которая работает без центральных серверов, используя уникальные "отпечатки" контента вместо традиционных URL-адресов для более эффективного и устойчивого распространения информации в интернете https://ipfs.tech/

### Статьи

- TCP/IP
    - Блог Джерри - Протокол TCP/IP в действии http://blog.gerryyang.com/tcp/ip/2020/09/08/tcpip-in-action.html
- UNenLab
    - Эмулятор UNetLab — революционный прыжок https://habr.com/ru/articles/262027/
- QUIC
    - Протокол QUIC в деле: как его внедрял Uber, чтобы оптимизировать производительность https://habr.com/ru/companies/Voximplant/articles/463073/
- SSH
    - SOCKS Proxy Over SSH https://hjr265.me/blog/socks-proxy-over-ssh/
- VPN
    - OpenVPN
    - WireGuard
    - OpenConnect
        - Поднимаем OpenConnect SSL VPN сервер (ocserv) в docker для внутренних проектов https://dzen.ru/a/ZjP3xxLRw0ucW3dh
        - OpenConnect: недетектируемый VPN, который вам понравится https://habr.com/ru/articles/776256/
    - GRE
    - IPSec
        - IKEv2/IPsec
        - L2TP/IPSec
        - IPSec VTI
        - Остальное
            - Развёртывание IPsec VPN в Yandex Cloud с помощью шлюза безопасности https://github.com/yandex-cloud-examples/yc-site-to-site-vpn-with-ipsec-strongswan
    - DMVPN
    - SSTP
    - PPTP
    - Lightway
    - Остальное
        - Как открыть портал наружу: самый полный гайд по VPN https://habr.com/ru/articles/757920/
        - Cloudflare представила собственный VPN-сервис на базе приложения 1.1.1.1 для мобильных устройств https://habr.com/ru/companies/itsumma/articles/446418/
- Wireguard
    - WireGuard inside WireGuard: Accessing my homelab through my VPN provider https://sidhion.com/blog/posts/wireguard-inside-wireguard-homelab/
    - Check If a WireGuard Connection Is Up https://hjr265.me/blog/check-if-a-wireguard-connection-is-up/
- DNS
    - Основное
    - Ad blocking
        - DNS Resolvers https://www.privacyguides.org/en/dns/
    - Остальное
- ECH
    - Протокол ECH в браузере https://habr.com/ru/articles/851882/
- IPIP
    - An introduction to Linux virtual interfaces: Tunnels https://developers.redhat.com/blog/2019/05/17/an-introduction-to-linux-virtual-interfaces-tunnels
- L2TP IPIP
- L2TPv3
- GRE (Generic Routing Encapsulation) IPIP
    - An introduction to Linux virtual interfaces: Tunnels https://developers.redhat.com/blog/2019/05/17/an-introduction-to-linux-virtual-interfaces-tunnels
    - ipip_gre_tunneling.md https://gist.github.com/kalyco/22f528066285497141a40c20292e9d3a
    - What is GRE and how does it differ from IP-in-IP? https://www.x4b.net/kb/Technology/GREvsIPIP
- SIT
- VXLAN
- Вирутальные коммутаторы
    - О настройке Open vSwitch непростым языком https://habr.com/ru/articles/325560/ 
- Multicast
    - Multicast IP Address to MAC address mapping https://networklessons.com/multicast/multicast-ip-address-to-mac-address-mapping
- IPFS
    - IPFS Tutorial: Building a Private IPFS Network with IPFS-Cluster for Data Replication https://eleks.com/research/ipfs-network-data-replication/
- P2P
    - Hole punching in libp2p - Overcoming Firewalls https://blog.ipfs.tech/2022-01-20-libp2p-hole-punching/
- TCP
    - TCP Handshake
    - TCP Congestion Control
    - TCP Segmentation Offload (TSO)
- HTTP/1
    - Key differences between HTTP=1.0 and HTTP=1.1 https://www.ra.ethz.ch/cdstore/www8/data/2136/pdf/pd1.pdf
- HTTP/2
    - Знакомство с HTTP/2 https://timeweb.com/ru/community/articles/znakomstvo-s-http-2-1
    - Путь к HTTP/2 https://habr.com/ru/articles/308846/
- ТСПУ
    - Установка ТСПУ https://pavel.su/internet/setting-up-tspu/
- Анализ траффика
    - Remote capturing packet with tcpdump and wireshark. https://gist.github.com/quyenlv/c37352884782b5d2da984f928487a44b
    - D.3. tcpdump: Capturing with “tcpdump” for viewing with Wireshark https://www.wireshark.org/docs/wsug_html_chunked/AppToolstcpdump.html
    - Master remote packet capturing: Combining Wireshark with tcpdump https://www.comparitech.com/net-admin/tcpdump-capture-wireshark/
- Остальное
    - Литература по сетям передачи данных https://pavel.su/noc/networking-books/
    - Как найти все российские IP-адреса? https://pavel.su/internet/list-of-russian-ip-addresses/
    - Ищем альтернативу Ngrok в России https://habr.com/ru/articles/833884/
    - Сложно о простом. Самые популярные протоколы и принципы их работы. ARP, ICMP, IGMP, TCP, UDP, SCTP, DNS и DHCP. Часть 1 https://habr.com/ru/companies/timeweb/articles/848604/
    - Сложно о простом. Самые популярные протоколы туннелирования, динамической маршрутизации и принципы их работы. Часть 2 https://habr.com/ru/companies/timeweb/articles/851946/
    - Функционирование сетей на транспортном уровне https://habr.com/ru/companies/nauka/articles/865002/

### Блоги

- https://www.vanwerkhoven.org/blog/
- https://pavel.su/

### Видео