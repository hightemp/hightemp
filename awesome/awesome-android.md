### Репозитории

- Этот проект представляет собой инструмент для настройки прокси на Android, использующий функцию VPNService, который позволяет перехватывать HTTP-трафик только от указанных приложений и имеет японскоязычный интерфейс. https://github.com/raise-isayan/TunProxy
- ProxyMe - это инструмент для настройки прокси на Android, использующий функцию VPNService для перенаправления HTTP-трафика только от выбранных приложений через указанный прокси-сервер, с возможностью настройки списка разрешенных или запрещенных приложений. https://github.com/jayluxferro/ProxyMe
- SocksDroid - это SOCKS5-клиент для Android 5.0+, который использует API VpnService и tun2socks для работы без root-прав, поддерживает UDP-пересылку, DNS-запросы через TCP и маршрутизацию для обхода Великого китайского файрвола. https://github.com/l2dy/SocksDroid
- Breezy Weather - это приложение с погодой для Android 21+, написанное на Kotlin с использованием Jetpack Compose и Material You, которое отличается стильным дизайном, плавными анимациями, простым пользовательским интерфейсом и широкими возможностями настройки. https://github.com/breezy-weather/breezy-weather

### Root, Xposed, Zygisk

- LSPosed - фреймворк для Xposed-модулей на Android, позволяющий менять поведение системы и приложений в памяти без изменения APK; официальный сайт ведёт на релизы, репозиторий модулей и Shamiko, а GitHub-репозиторий LSPosed сейчас архивирован. https://lsposed.org/ https://github.com/LSPosed/LSPosed https://modules.lsposed.org/
- Vector - современный Xposed-совместимый ART hooking framework в виде Zygisk-модуля: сохраняет совместимость API с оригинальным Xposed, построен поверх LSPlant и поддерживает Android 8.1 - Android 17 Beta. https://github.com/JingMatrix/Vector
- Hide My Applist - Xposed-модуль для скрытия установленных приложений и отклонения запросов к списку приложений, чтобы уменьшать root/app-list fingerprinting на собственном устройстве. https://github.com/Dr-TSNG/Hide-My-Applist
- NoVPNDetect Enhanced - модуль из LSPosed Module Repository для скрытия локальных способов определения VPN на Android: перехватывает публичные сетевые API вроде `NetworkCapabilities`, `NetworkInterface`, `LinkProperties`, `ConnectivityManager`, `NetworkInfo` и native `getifaddrs()`. https://modules.lsposed.org/module/ru.bluecat.novpndetectenhanced/
- VPN Hide - инструмент для скрытия активного VPN от выбранных Android-приложений через многослойную схему `kmod`/LSPosed/Zygisk: фильтрует Java API на уровне `system_server`, нативные пути обнаружения через kernel module или Zygisk, может блокировать localhost-порты и скрывать выбранные приложения от package visibility checks. https://github.com/okhsunrog/vpnhide

### Курсы

- Современная Android-разработка: базовый курс (2025) https://stepik.org/course/232639/promo
- Kotlin: полный курс (2025) — подготовка к собеседованию https://stepik.org/course/207758/promo
- Шкодим под Android https://developer.alexanderklimov.ru/android/

### Учебники

- Уроки по Android (2011-2017) https://startandroid.ru/ru/uroki/vse-uroki-spiskom.html
- Программирование под Андроид на Java https://metanit.com/java/android/
- Android Development Tutorials - Android, Activity, Intent, ADT, Services, BroadcastReceiver https://www.vogella.com/tutorials/android.html

### Книги

### Магазины

- Neo Store - это современный F-Droid клиент с открытым исходным кодом, который предлагает быструю синхронизацию репозиториев, встроенные хранилища приложений, удобный поиск, поддержку светлой и темной тем, а также активное комьюнити для пользователей. https://github.com/NeoApplications/Neo-Store

### Статьи

- Профили
    - Shelter
        - Установка Max отдельно от всего в рабочем профиле на Android https://habr.com/ru/articles/985950/
- Сеть
    - SSH
        - Tutorial: SSH-Tunneled VPN on Stock Android https://airvpn.org/forums/topic/13486-ssh-tunneled-vpn-on-stock-android/
        - How to connect with SSH tunnel on Android using SagerNet https://torguard.net/indexori.php?rp=/knowledgebase/313/How-to-connect-with-SSH-tunnel-on-Android-using-SagerNet.html
    - VPN    
        - Develop a VPN App in Java using Android Studio https://gayanvoice.medium.com/develop-a-vpn-app-in-java-using-android-studio-6f1f2d66031e
        - Make your own Android VPN client with OpenVPN servers https://medium.com/@tanujsinghkushwah/make-your-own-android-vpn-client-with-openvpn-servers-2dfe251f40b6
        - How to make vpn app in android studio https://medium.com/@dnarayana18/how-to-make-vpn-app-in-android-studio-65523c75ae1e
- Безопасность
    - Localhost-атака: как Meta* и Яндекс следят за пользователями Android через localhost https://habr.com/ru/articles/915732/
- Остальное
    - ByteWeaver в Open Source: инструментирование байт-кода Java во имя великого блага https://habr.com/ru/companies/vk/articles/845872/
    - Installing Android Studio On Ubuntu 22.04: Complete Guide https://dev.to/janetmutua/installing-android-studio-on-ubuntu-2204-complete-guide-1kh8

### Приложения

- ProxyAuth for Android https://play.google.com/store/apps/details?id=in.silverstonelabs.proxyauth&hl=en_US
- SocksHttp. SocksHttp можно использовать для обхода локальных ограничений и сетевой цензуры через SSH-туннель. На данный момент поддерживаются следующие методы подключения: SSH DIRECT, SSH + PROXY и SSH + SSL. https://play.google.com/store/apps/details?id=com.slipkprojects.sockshttp
- SocksHttp Plus. SocksHttp Plus можно использовать для создания SSH-туннеля, через который будет маршрутизироваться весь ваш сетевой трафик. Поддержка прокси-серверов HTTP и SSL с настраиваемыми текстами подключений для обхода локальных ограничений и сетевой цензуры. https://play.google.com/store/apps/details?id=com.slipkprojects.sksplus
- Super Proxy туннелирует приложения через HTTP прокси-сервер (рут-доступ не требуется). Это позволяет вам получить доступ к Интернету в любом приложении, будь то в вашей компании или сети учебного заведения. В качестве альтернативы вы можете использовать общедоступный прокси-сервер, например, чтобы обойти ограничения вашего интернет-провайдера. https://play.google.com/store/apps/details?id=com.scheler.superproxy

### Видео

- Реализуем kotlinx.coroutines своими силами, чтобы разобраться как они устроены https://www.youtube.com/watch?v=2SpeJj7BUs4

### Блоги

- https://www.androidhive.info/
- http://technotalkative.com/
