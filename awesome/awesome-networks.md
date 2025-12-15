
### Коллекции

- https://github.com/anderspitman/awesome-tunneling

### Виртуальные роутеры

- Cisco ASAv https://software.cisco.com/download/home/286119613/type/280775065/release/9.18.4%20Interim
- Cisco CSR1000v https://software.cisco.com/download/home/284364978/type/282046477/release/3.15.0S

### Сервисы проверки доступности

- https://check-host.net/

### Полезные утилиты

- Self-hosted ngrok alternative https://docs.ssi.sh/
- tcp/http self-hosted tunnel https://telebit.cloud/

### Репозитории

- Этот проект представляет собой инструмент на Python 3.8.10, который позволяет извлекать домены из диапазона IP-адресов, используя исторические данные из VirusTotal (с помощью API-ключа), поддерживает входной файл и выходной CSV-файл, и может быть полезен для извлечения субдоменов в программах по поиску ошибок. https://github.com/jevalenciap/iptodomain
- WireGuard Easy — веб-приложение "всё-в-одном" для простой установки и управления VPN-сервером WireGuard на любом Linux-хосте с графическим интерфейсом для создания, редактирования и мониторинга клиентов, включая генерацию QR-кодов и статистику подключений. https://github.com/wg-easy/wg-easy

### DNS; SmartDNS

- Сервисы DNS
    - https://info.dns.malw.link/setup
- Списки
    - Список публичных DNS серверов https://atmark.ru/spisok-publichny-h-dns-serverov/

### Список публичных DNS серверов

```
Google Public DNS
8.8.8.8
8.8.4.4
The Google Public DNS IPv6 addresses:
2001:4860:4860::8888
2001:4860:4860::8844

Cloudflare DNS
Основной:
1.1.1.1
Дополнительный:
1.0.0.1
IPv6:
2606:4700:4700::1111

SmartViper Public DNS
208.76.50.50
208.76.51.51

Level 3 Communications (Broomfield, CO, US)
4.2.2.1
4.2.2.2
4.2.2.3
4.2.2.4
4.2.2.5
4.2.2.6

Verizon (Reston, VA, US)
151.197.0.38
151.197.0.39
151.202.0.84
151.202.0.85
151.202.0.85
151.203.0.84
151.203.0.85
199.45.32.37
199.45.32.38
199.45.32.40
199.45.32.43

GTE (Irving, TX, US)
192.76.85.133
206.124.64.1

One Connect IP (Albuquerque, NM, US)
67.138.54.100

OpenDNS (San Francisco, CA, US)
208.67.222.222
208.67.220.220

Exetel (Sydney, AU)
220.233.167.31

VRx Network Services (New York, NY, US)
199.166.31.3

SpeakEasy (Seattle, WA, US)
66.93.87.2
216.231.41.2
216.254.95.2
64.81.45.2
64.81.111.2
64.81.127.2
64.81.79.2
64.81.159.2
66.92.64.2
66.92.224.2
66.92.159.2
64.81.79.2
64.81.159.2
64.81.127.2
64.81.45.2
216.27.175.2
66.92.159.2
66.93.87.2

Sprintlink (Overland Park, KS, US)
199.2.252.10
204.97.212.10
204.117.214.10

Cisco (San Jose, CA, US)
64.102.255.44
128.107.241.185

OpenNIC
202.83.95.227 (au)
119.31.230.42(au)
178.63.26.173 (de)
217.79.186.148 (de)
27.110.120.30(nz)
89.16.173.11 (uk)
69.164.208.50 (us)
216.87.84.211(us)
2001:470:8388:10:0:100:53:20 (us)
2001:470:1f10:c6::2 (us)

ClearCloud
74.118.212.1
74.118.212.2

Dnsadvantage
156.154.70.1
156.154.71.1

Norton
198.153.192.1
198.153.194.1
```

### VPN

- vless
    - GUI клиенты
        - v2rayA https://github.com/v2rayA/v2rayA
        - nekoray https://github.com/MatsuriDayo/nekoray
    - Android клиенты
        - Nekobox https://github.com/MatsuriDayo/NekoBoxForAndroid
    - Остальное
        - Бесплатные ключи протокола VLESS | V2RAY https://vpnkeys.org/vless
- Остальное
    - https://www.vpnbook.com/

### Как получить список Российских адресов

- `curl https://stat.ripe.net/data/country-resource-list/data.json?resource=RU | jq -r '.data.resources.ipv4 | .[]' > ru.txt`

### Полезные ссылки

- Содержит диапазоны ip по странам. Так же много разных инструментов. https://suip.biz/
- Форум про сетевые технологии https://ntc.party/
- GoodbyeDPI — это утилита для обхода систем глубокой проверки пакетов (DPI), которая позволяет пользователям Windows получить доступ к заблокированным веб-сайтам, обходя блокировки, установленные интернет-провайдерами. https://github.com/ValdikSS/GoodbyeDPI
- Global Ping Statistics https://wondernetwork.com/pings
- IPFS (InterPlanetary File System) - это децентрализованная пиринговая сеть для хранения и обмена данными, которая работает без центральных серверов, используя уникальные "отпечатки" контента вместо традиционных URL-адресов для более эффективного и устойчивого распространения информации в интернете https://ipfs.tech/
- https://badssl.com
- https://warp-generator.vercel.app/

### Статьи

- Основное
    - Сети для самых маленьких. Часть нулевая. Планирование https://linkmeup.ru/blog/1188/
    - Layer 2 Network Operations: How Ethernet Frames and Smart Switches Power Gigabit Networks https://chessman7.substack.com/p/layer-2-network-operations-how-ethernet
- Ethernet
    - Layer 2 Network Operations: How Ethernet Frames and Smart Switches Power Gigabit Networks https://chessman7.substack.com/p/layer-2-network-operations-how-ethernet
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
    - IPIP
    - GRE
        - Настройка туннелей GRE и IPIP в Debian и Ubuntu https://interface31.ru/tech_it/2021/09/nastroyka-tunneley-gre-i-ipip-v-debian-i-ubuntu.html
    - IPSec
        - IKEv2/IPsec
        - L2TP/IPSec
        - IPSec VTI
        - Остальное
            - Развёртывание IPsec VPN в Yandex Cloud с помощью шлюза безопасности https://github.com/yandex-cloud-examples/yc-site-to-site-vpn-with-ipsec-strongswan
    - VLESS
        - Основное
            - Протокол VLESS https://xtls.github.io/ru/development/protocols/vless.html
            - Настройка VLESS + TCP + REALITY + VISION + uTLS https://github.com/XTLS/Xray-core/discussions/3518
            - Что такое VLESS https://dtf.ru/id2385838/3404450-chto-takoe-vless
            - VLESS-TCP-TLS-WS (Recommended) https://deepwiki.com/v2fly/v2ray-examples/3.1.1-vless-tcp-tls-ws-(recommended)
        - XHTTP
            - Кратко про XHTTP для VLESS: что, зачем и как https://habr.com/ru/articles/913324/
    - DMVPN
    - SSTP
    - PPTP
    - Lightway
    - Остальное
        - Как открыть портал наружу: самый полный гайд по VPN https://habr.com/ru/articles/757920/
        - Cloudflare представила собственный VPN-сервис на базе приложения 1.1.1.1 для мобильных устройств https://habr.com/ru/companies/itsumma/articles/446418/
- XRay
    - Малоизвестные фичи XRay, о которых невозможно молчать https://habr.com/ru/articles/834290/
    - XRay (с VLESS/XTLS): проброс портов, реверс-прокси, и псевдо-VPN https://habr.com/ru/articles/774838/
    - Режимы работы Xray https://xtls.github.io/ru/document/level-1/work.html
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
    - Остальное
        - Bringing insights into TCP resets and timeouts to Cloudflare Radar https://blog.cloudflare.com/tcp-resets-timeouts/
- HTTP
    - HTTP/1
        - Key differences between HTTP=1.0 and HTTP=1.1 https://www.ra.ethz.ch/cdstore/www8/data/2136/pdf/pd1.pdf
    - HTTP/2
        - Знакомство с HTTP/2 https://timeweb.com/ru/community/articles/znakomstvo-s-http-2-1
        - Путь к HTTP/2 https://habr.com/ru/articles/308846/
    - Chunked Encoding
        - What is HTTP Chunked Encoding? https://www.ioriver.io/terms/http-chunked-encoding
- ТСПУ
    - Установка ТСПУ https://pavel.su/internet/setting-up-tspu/
- Анализ траффика
    - Wireshark & tcpdump: A Debugging Power Couple https://medium.com/javarevisited/wireshark-tcpdump-a-debugging-power-couple-c4242cc7c052
    - Packet Sniffing Essentials: Exploring Packet Capture and Analysis using TCPDump and Wireshark https://medium.com/@samuel_ad/packet-sniffing-essentials-exploring-packet-capture-and-analysis-using-tcpdump-and-wireshark-d473196a5ace
    - Remote capturing packet with tcpdump and wireshark. https://gist.github.com/quyenlv/c37352884782b5d2da984f928487a44b
    - D.3. tcpdump: Capturing with “tcpdump” for viewing with Wireshark https://www.wireshark.org/docs/wsug_html_chunked/AppToolstcpdump.html
    - Master remote packet capturing: Combining Wireshark with tcpdump https://www.comparitech.com/net-admin/tcpdump-capture-wireshark/
- Про блокировки
    - «Кривые руки» или новый уровень DPI? Разбор выходных блокировок XRay и VLESS https://habr.com/ru/articles/969618/
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