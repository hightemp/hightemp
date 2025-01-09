### Полезные ссылки

- Документация https://nginx.org/en/docs/
- Форум https://forum.nginx.org/
- Песочница https://github.com/sportebois/nginx-rate-limit-sandbox

### Книги

- NGINX. Книга рецептов, Дерек Де Йонге
- Администрирование сервера NGINX, Димитрий Айвалиотис
- NGINX Essentials, Valery Kholodkov
- NGINX HTTP Server, Martin Fjordvald, Clement Nedelcu
- NGNIX High Performance, Rahul Sharma
- ModSecurity 3.0 and NGINX: Quick Start Guide, Faisal Memon, Owen Garrett, Michael Pleshakov
- Cisco ACE to NGINX: Migration Guide, Faisal Memon

### Блоги

- https://medium.com/tag/nginx

### Статьи

- Основное
    - Установка и настройка nginx: пошаговая инструкция https://firstvds.ru/technology/ustanovka-i-nastroyka-nginx
    - Введение в nginx (nginx web) https://www.opennet.ru/base/net/nginx_intro.txt.html
    - Understanding NGINX Architecture, Configuration & Alternatives https://www.solo.io/topics/nginx
    - NGINX Architecture https://blog.nginx.org/nginx-architecture
    - Understanding NGINX Worker Architecture - Powering Modern Web Servers https://chessman7.substack.com/p/understanding-nginx-worker-architecture 
    - An In-Depth Guide to Nginx for Developers https://thelinuxcode.com/an-in-depth-guide-to-nginx-for-developers/
    - NGINX — Zero To Hero: Your Ultimate Guide from Beginner to Advanced Mastery https://medium.com/h7w/nginx-zero-to-hero-your-ultimate-guide-from-beginner-to-advanced-mastery-ac7e4c6b9795
- Ограничение скорости; limit_rate
    - Ограничение скорости в Nginx для сложных конфигураций: HTTP/2, API и видеостриминг https://habr.com/ru/companies/otus/articles/843424/
- Оптимизация
    - Optimizing Nginx for Performance: Strategies for Maximum Efficiency https://medium.com/@navneetskahlon/optimizing-nginx-for-performance-strategies-for-maximum-efficiency-15e664626760
    - NGINX Performance Tuning Tips https://www.plesk.com/blog/various/nginx-performance-tuning-tips/
- Кэширование
    - High‑Performance Caching with NGINX and NGINX Plus https://www.f5.com/company/blog/nginx/nginx-high-performance-caching
- Мониторинг
    - Mastering NGINX Monitoring: Comprehensive Guide to Essential Tools https://www.atatus.com/blog/mastering-nginx-monitoring-a-comprehensive-guide-to-essential-tools/
- Безопасность
    - Настройка SSL/TLS сертификатов
        - How to Configure SSL/TLS Encryption on NGINX https://scohostings.com/how-to-configure-ssl-tls-encryption-on-nginx/
        - Nginx: Create CSR & Install SSL Certificate (OpenSSL) https://www.digicert.com/kb/csr-ssl-installation/nginx-openssl.htm
- Балансировка нагрузки
    - Различные методы балансировки
        - Round Robin (Круговой метод)
        - Least Connections (Наименьшее количество соединений)
        - IP Hash
        - Weighted Round Robin
        - Остальное
            - Using nginx as HTTP load balancer https://nginx.org/en/docs/http/load_balancing.html
            - Setting Up Load Balancing by Using NGINX https://docs.oracle.com/en/operating-systems/oracle-linux/8/balancing/balancing-SettingUpLoadBalancingbyUsingNGINX.html#nginx-round-robin
            - How to Use Nginx as a Load Balancer for Your Application https://medium.com/@elaurichetoho/how-to-use-nginx-as-a-load-balancer-for-your-application-d80ca40f28d8
            - How to Set Up Nginx Load Balancing: Step-by-Step Guide https://toxigon.com/how-to-set-up-nginx-load-balancing
            - How to Configure Nginx as a Load Balancer https://webhostinggeeks.com/howto/how-to-configure-nginx-as-a-load-balancer/
            - How to implement load balancing with NGINX https://www.slingacademy.com/article/implement-load-balancing-with-nginx/
    - Health checks
        - Health Checks in NGINX: The Complete Guide https://www.slingacademy.com/article/health-checks-in-nginx-the-complete-guide/
        - Active or Passive Health Checks: Which Is Right for You? https://www.f5.com/company/blog/nginx/active-or-passive-health-checks-which-is-right-for-you
        - What is Health Checks? https://www.javatpoint.com/nginx-http-health-checks
        - NGINX HTTP Health Checks https://www.naukri.com/code360/library/nginx-http-health-checks
        - NGINX TCP Health Checks https://www.javatpoint.com/nginx-tcp-health-checks
        - UDP Health Checks https://docs.nginx.com/nginx/admin-guide/load-balancer/udp-health-check/
        - HTTP Health Checks, gRPC Health Checks https://docs.nginx.com/nginx-management-suite/acm/how-to/policies/health-check/
    - Sticky Sessions
        - IP Hash метод
        - Sticky Learn метод (NGINX Plus)
            - HTTP Load Balancing https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/
        - Остальное
            - What Are Sticky Sessions — How They Work and When to Use Them https://traefik.io/glossary/what-are-sticky-sessions/
            - Mastering NGINX Learn how to configure sticky sessions in NGINX to distribute incoming traffic efficiently and maintain session persistence across multiple servers https://www.pdxdev.com/nginx-reverse-proxy/configuring-sticky-sessions/
            - How Sticky Sessions Can Tilt Load Balancers https://medium.com/@iSooraj/how-sticky-sessions-can-tilt-load-balancers-c5dc8f50099c
            - Session affinity (sticky) with Nginx load balancing https://opensourcehacker.com/2011/03/21/session-affinity-sticky-with-nginx-load-balancing/
- Остальное
    - Is Nginx dead? Is Traefik v3 20% faster than Traefik v2? https://medium.com/beyn-technology/is-nginx-dead-is-traefik-v3-20-faster-than-traefik-v2-f28ffb7eed3e