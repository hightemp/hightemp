
### Коллекции

- https://github.com/enaqx/awesome-pentest
- Hackfa.st — гигантская бесплатная база данных по хакерству и кибербезопасности, включающая разборы атак, инструкции по защите и инструменты пентеста. https://hackfa.st
- https://github.com/huhusmang/Awesome-LLMs-for-Vulnerability-Detection
- Awesome Cybersecurity List — персональная подборка cybersecurity blog posts, write-ups и papers, разложенная по годам с 2011 по 2026 и отдельными разделами Misc/Other Lists; полезна для чтения разборов уязвимостей, exploit chains, reverse engineering, malware, kernel/browser/mobile/security research. https://github.com/0xor0ne/awesome-list
- Hacking-Tools — каталог на GitHub с большой библиотекой инструментов кибербезопасности, сгруппированных по категориям (OSINT, сканирование уязвимостей, пентест, анализ сетей и трафика, форензика, стресс‑тесты, подбор паролей, анализ веба, реверс‑инжиниринг и социальная инженерия). https://github.com/yogsec/Hacking-Tools
- Awesome AI Security Benchmarks — развивающийся каталог бенчмарков безопасности AI с разбивкой по годам, типам и задачам: CTF, пентест, поиск и исправление уязвимостей, CTI/SOC, prompt injection и безопасность агентов; для многих позиций приведены статьи, датасеты, сайты и репозитории. https://github.com/EvanThomasLuke/Awesome-AI-Security-Benchmarks

### Модели для кибербезопасности

- KillChain-8B — полностью дообученная версия Qwen3-8B на датасете Ultimate Offensive Red Team для red-team симуляций и исследований, обучения специалистов, adversarial-оценки LLM и контролируемого внутреннего тестирования; опубликована в BF16 под Apache 2.0 и поддерживает запуск через Transformers и vLLM. Использовать только в образовательных целях и для разрешённых проверок. https://huggingface.co/MrPibb/KillChain-8B
- KillChainExtra-8B — разрабатываемая специализированная версия Qwen3-8B для помощи red team в разрешённом тестировании безопасности, обучаемая на датасете Ultimate Offensive Red Team и более чем миллионе строк данных из источников вроде CVE и ExploitDB. Репозиторий пока содержит только карточку модели; автор помечает её как незавершённую и не рекомендует текущую версию к использованию. https://huggingface.co/MrPibb/KillChainExtra-8B

### Бенчмарки для AI-агентов в кибербезопасности

- Inspect Evals — официальный репозиторий готовых оценок для фреймворка Inspect AI; раздел кибербезопасности содержит запускаемые реализации Cybench, CVE-Bench, CyberGym, CyberSecEval, 3CB, InterCode-CTF и других бенчмарков. https://github.com/UKGovernmentBEIS/inspect_evals
- AgentThreatBench — бенчмарк 2026 года для проверки устойчивости LLM-агентов к угрозам OWASP Top 10 for Agentic Applications; три запускаемые задачи Inspect одновременно измеряют полезность и безопасность при отравлении памяти, перехвате автономного поведения и эксфильтрации данных. https://ukgovernmentbeis.github.io/inspect_evals/evals/safeguards/agent_threat_bench/ https://github.com/UKGovernmentBEIS/inspect_evals/tree/main/src/inspect_evals/agent_threat_bench
- CyberSecEval 4 — набор бенчмарков Meta для оценки наступательных и защитных возможностей AI: автономных киберопераций, эксплуатации уязвимостей, автоматического исправления кода, malware/CTI-анализа, prompt injection, злоупотребления интерпретатором и генерации безопасного кода. https://meta-llama.github.io/PurpleLlama/CyberSecEval/ https://github.com/meta-llama/PurpleLlama/tree/main/CybersecurityBenchmarks
- DefenderBench — открытый набор интерактивных сред Microsoft для оценки языковых агентов в сетевом вторжении, обнаружении вредоносного текста и сайтов, CTI-вопросах, поиске и исправлении уязвимостей кода. https://github.com/microsoft/DefenderBench
- ExploitGym — крупномасштабный бенчмарк из 869 реальных уязвимостей в userspace-программах, движке V8 и ядре Linux для оценки способности AI-агентов разрабатывать работающие эксплойты; включает изолированные Docker-окружения, автоматическую оценку и firewall для ограничения сети. https://github.com/sunblaze-ucb/exploitgym
- ExploitBench — бенчмарк и leaderboard для оценки полного процесса разработки эксплойтов по пяти уровням: достижение уязвимого кода, воспроизведение сбоя, построение специфичных и универсальных exploit primitives и arbitrary code execution. Первый набор `v8-bench` проверяет 16 возможностей на production V8 с включённым security sandbox, используя детерминированный verifier, Docker-окружения и MCP. https://exploitbench.ai/ https://github.com/exploitbench/exploitbench
- CVE-Bench — бенчмарк из 40 критических CVE для оценки способности AI-агентов эксплуатировать реальные уязвимости веб-приложений; поддерживает zero-day и one-day сценарии и запускает воспроизводимые проверки в изолированных Docker-окружениях через Inspect. https://github.com/uiuc-kang-lab/cve-bench
- Cybench — бенчмарк для оценки возможностей и рисков языковых моделей в кибербезопасности на 40 профессиональных CTF-задачах из четырёх соревнований; охватывает криптографию, веб-безопасность, reverse engineering, форензику и эксплуатацию, а промежуточные подзадачи позволяют оценивать частичный прогресс агента. https://cybench.github.io/ https://github.com/andyzorigin/cybench
- BountyBench — бенчмарк реальных bug bounty-задач для сквозной оценки обнаружения, эксплуатации и исправления уязвимостей AI-агентами с учётом денежной ценности результата; содержит воспроизводимые окружения и отдельные detect, exploit и patch workflows. https://bountybench.com/ https://github.com/bountybench/bountybench
- TermiBench — реалистичный agent-oriented бенчмарк пентестинга на 510 хостах, 25 сервисах и 30 CVE, где целью является получение полного контроля над системой, а не поиск CTF-флага; код и контейнеризованные уязвимые сервисы опубликованы на Zenodo. https://arxiv.org/abs/2509.09207 https://zenodo.org/records/17479793
- CyberGym-E2E — end-to-end бенчмарк из 920 реальных уязвимостей в 139 open-source проектах: агент должен самостоятельно обнаружить уязвимость, создать PoC и написать исправление; также есть patch-only режим и четыре стадии проверки результата. https://www.cybergym.io/cybergym-e2e/ https://github.com/sunblaze-ucb/cybergym-e2e
- CyberGym — фреймворк оценки AI-агентов на 1507 исторических уязвимостях из 188 проектов OSS-Fuzz: проверяет воспроизведение уязвимостей работающими PoC, поддерживает несколько уровней входных данных, open-ended vulnerability discovery и локальное Docker-развёртывание. https://www.cybergym.io/cybergym/ https://github.com/sunblaze-ucb/cybergym
- SEC-bench — воспроизводимый Docker-бенчмарк реальных software-security задач для LLM-агентов: автоматически строит экземпляры из OSV/CVE и оценивает генерацию PoC и исправление уязвимостей с поддержкой SWE-agent, OpenHands, Aider и smolagents. https://sec-bench.github.io/ https://github.com/SEC-bench/SEC-bench
- A.S.E — repository-level бенчмарк Tencent для оценки безопасности кода, создаваемого моделями и coding-агентами, на сценариях из реальных проектов и CVE-патчей; охватывает 29 типов CWE и сочетает функциональные тесты, статический анализ и динамическую проверку PoC. https://github.com/Tencent/AICGSecEval
- SecCodeBench — бенчмарк для современных agentic coding tools с 98 проверенными экспертами задачами на Java, C/C++, Python, Go и Node.js по 22 типам CWE; оценивает генерацию и исправление кода, сначала проверяя функциональность, а затем безопасность динамическими PoC и специализированным judge. https://github.com/alibaba/sec-code-bench

### AI Инструменты для пентестинга

- Cybersecurity AI (CAI) - легковесная, эргономичная open-source платформа для создания искусственных интеллектов, ориентированных на поиск уязвимостей в области кибербезопасности, с интегрированными инструментами, логированием и поддержкой нескольких языковых моделей различных поставщиков. https://github.com/aliasrobotics/cai
- HexStrike AI — фреймворк для автоматизированного пентестинга и защиты приложений, использующий команду из 12 ИИ-агентов через единый MCP‑сервер для быстрого сканирования кода, поиска уязвимостей и исправления багов с заявленной точностью 98,7%. https://github.com/0x4m4/hexstrike-ai
- GHOSTCREW — автономный ИИ-агент для пентеста и задач информационной безопасности, который автоматически анализирует код, бизнес-логику, сетевой трафик и протоколы, находит уязвимости, предлагает меры по их устранению и формирует детальные отчёты в Markdown с возможностью выбора и настройки модели. https://github.com/0xSojalSec/PentestAgent
- Rogue — интеллектуальный агент-сканер веб-уязвимостей на базе LLM, который анализирует поведение приложения, генерирует контекстные payload’ы и автономно подтверждает найденные уязвимости с формированием отчётов. https://github.com/faizann24/rogue
- VulnAgent — LLM-native CLI‑сканер веб‑безопасности, который с помощью больших языковых моделей автономно исследует веб‑приложения и выявляет уязвимости без сигнатур и правил, адаптируя стратегию тестирования и формируя отчёты в нескольких форматах. https://github.com/coji/vuln-agent
- Vulnhuntr — инструмент на базе LLM и статического анализа для автоматического построения и анализа цепочек вызовов в Python‑коде (от удалённого ввода пользователя до ответа сервера) с целью выявления удалённо эксплуатируемых уязвимостей, включая сложные многошаговые баги и 0-day. https://github.com/protectai/vulnhuntr https://protectai.com/threat-research/vulnhuntr-first-0-day-vulnerabilities
- LLM-Based Code Security Scanner — инструмент для статического анализа безопасности кода, использующий LLM (например, GPT‑4 или Claude) для выявления уязвимостей и генерации отчётов, с возможностью запуска как CLI или интеграции в CI/CD через GitHub Actions (включая создание issue). https://github.com/iknowjason/llm-security-scanner 
- DorkAgent — LLM-агент для автоматизации Google Dorking в багбаунти, bug hunting и пентестинге с использованием Serper.dev и ключей популярных LLM-провайдеров. https://github.com/yee-yore/DorkAgent
- BugTrace-AI — веб‑набор инструментов для анализа уязвимостей (SAST/DAST) и генерации payload’ов с помощью генеративного ИИ, включающий ассистента по веб‑безопасности, анализ URL/кода/заголовков, специализированные сканеры (DOM XSS, JWT, PrivEsc, upload) и средства разведки, с упором на многошаговую схему Recursion→Consolidation→Refinement для повышения надёжности результатов. https://github.com/yz9yt/BugTrace-AI https://deepwiki.com/yz9yt/BugTrace-AI
- PentestGPT — автономный агент для автоматизированного пентестинга и решения CTF-задач на базе LLM в изолированном Docker-окружении (опубликован на USENIX Security 2024). https://github.com/GreyDGL/PentestGPT https://pentestgpt.com
- PentAGI — опенсорсная мультиагентная система для автономного пентестинга, в которой шесть специализированных AI-агентов координируют разведку, эксплуатацию, написание эксплойтов, развертывание инструментов, накопление знаний и взаимодействие с пользователем, автоматически выбирая и запуская профессиональные утилиты в Docker и формируя отчёты. https://github.com/vxcontrol/pentagi
- Shannon Lite — автономный white-box AI-пентестер от Keygraph для веб‑приложений и API на базе Anthropic Claude Agent SDK: анализирует исходный код и живое приложение, строит attack surface, параллельно проверяет OWASP-категории, подтверждает находки через browser/CLI-эксплуатацию и включает в отчёт только уязвимости с воспроизводимым PoC («No Exploit, No Report»); авторы заявляют 96.15% (100/104 exploits) на hint-free source-aware варианте XBOW benchmark и 20+ находок на OWASP Juice Shop. Использовать только для разрешённого white-box-тестирования, не на production. https://github.com/KeygraphHQ/shannon https://github.com/KeygraphHQ/shannon/discussions/249 https://keygraph.io/
- Shannon Pro — коммерческая платформа AppSec «всё‑в‑одном» от Keygraph, объединяющая агентный SAST/SCA/поиск секретов и тестирование бизнес‑логики с автономным динамическим пентестом и корреляцией статических находок с подтверждёнными PoC‑эксплойтами. https://github.com/KeygraphHQ/shannon/blob/main/SHANNON-PRO.md https://keygraph.io/
- METATRON — локальный AI-агент для пентестинга на Linux без API-ключей: принимает целевой IP или домен, запускает инструменты разведки вроде nmap, whois, whatweb, curl, dig и nikto, помогает находить уязвимости, эксплойты и рекомендации по исправлению. https://github.com/sooryathejas/METATRON

### Пентестинг

- Sn1per — автоматизированный инструментарий для пентеста и управления поверхностью атаки (ASM), который выполняет OSINT/рекон и оркестрирует сторонние сканеры уязвимостей для непрерывного обнаружения активов и рисков. https://github.com/1N3/Sn1per https://sn1persecurity.com/wordpress/ https://sn1persecurity.com/wordpress/documentation/
- Hetty — open-source HTTP toolkit для security research и bug bounty, альтернатива Burp Suite Pro: MITM HTTP-прокси, логи и поиск, ручное создание/редактирование/replay запросов, перехват запросов и ответов, scope и web-based admin interface. https://github.com/dstotijn/hetty
- HackingTool — all-in-one Python-набор для security researchers и pentesters с меню установки/запуска 185+ инструментов по категориям: information gathering, wordlists, wireless, web testing, forensics, reverse engineering, Active Directory, cloud и mobile security; поддерживает поиск по инструментам, теги, рекомендации по задаче, batch install и локальную Docker-сборку. Использовать только для обучения, лабораторий и разрешённых проверок. https://github.com/Z4nzu/hackingtool

### Сетевая безопасность

- Контроль доступа к портам
    - PortGuard - open-source решение для Single Packet Authorization / port knocking: держит сервисные порты закрытыми по умолчанию и временно открывает доступ только после валидного AES/GPG-подписанного SPA-пакета; сайт указывает клиенты для Windows, iOS/macOS и Android, а также Linux server packages. https://portguard.net

### AI-анализаторы кода

- Ship Safe — AI‑платформа и CLI для предрелизного аудита безопасности кода: запускает 22 специализированных агента по 80+ классам атак, ищет утечки секретов/API‑ключей, prompt injection, RAG poisoning, MCP server misuse, CI/CD pipeline poisoning, supply chain‑риски, auth bypass, SSRF, misconfig Docker/Terraform/Kubernetes и vibe‑coding antipatterns; поддерживает deep LLM‑анализ эксплуатируемости, SARIF/JSON/HTML/Markdown‑отчёты и CI/CD‑режим. https://github.com/asamassekou10/ship-safe https://www.npmjs.com/package/ship-safe

### Поиск эксплойтов

- WatchStack — платформа для мониторинга CVE и exploit intelligence, а страница PoC Search предназначена для поиска публичных PoC/эксплойтов по уязвимостям. https://watchstack.io/intel/poc-search

### Интсрументы проверки кода

- FuzzForge — open-source платформа и CLI для автоматизации AppSec/оффенсив‑секьюрити процессов с AI‑агентами и интеграцией фреймворков для фаззинга, позволяющая описывать и масштабировать security‑воркфлоу как код. https://github.com/FuzzingLabs/fuzzforge_ai

### Инструменты для проверки LLM

- garak — бесплатный набор инструментов для red-teaming и оценки уязвимостей LLM/диалоговых систем, выявляющий галлюцинации, утечки данных, prompt injection, дезинформацию, токсичность и jailbreak-поведение с помощью статических, динамических и адаптивных проверок.

### Инструменты для проверки файлов

- Qu1cksc0pe — консольный all‑in‑one инструмент на Python для статического и частично динамического анализа подозрительных файлов и артефактов (Windows/Linux/macOS/Android исполняемые файлы, документы, архивы, PCAP и E‑Mail), извлекающий IOC и технические признаки вроде импортов/API, секций, разрешений, URL/IP/Email и встроенных payload’ов. https://github.com/CYB3RMX/Qu1cksc0pe

### Стеганография

- ST3GG — open-source тулкит для стеганографии и стеганализа: по данным README, включает 112 техник сокрытия данных для изображений, аудио, текста/Unicode, документов, сетевых пакетов, архивов и кода; поддерживает 120 LSB-комбинаций, F5/DCT для JPEG, SPECTER channel hopping, Matryoshka-вложение до 11 слоёв, Ghost Mode с AES-256-GCM, 50 analysis/decode tools, 109 примеров и 568 тестов. Работает как 100% client-side браузерный сайт без серверной части, а также как Python CLI/TUI/WebUI; подходит для CTF, DFIR, DLP-тестов и разрешённых red/blue team сценариев. https://github.com/elder-plinius/st3gg https://ste.gg/

### MCP

- HexStrike AI — продвинутый MCP‑фреймворк, позволяющий автономным AI‑агентам (Claude, GPT) управлять арсеналом из 150+ инструментов для пентестинга и автоматизировать задачи от разведки до поиска уязвимостей, что делает его мощным решением для специалистов по кибербезопасности, баг‑баунти и операций Red Team. https://github.com/0x4m4/hexstrike-ai
- CVE-Search MCP Server — MCP‑сервер на Python для запросов к API CVE‑Search, позволяющий получать списки вендоров и продуктов, уязвимости по продукту или CVE‑ID, последние обновлённые CVE и сведения о состоянии/обновлении базы. https://github.com/roadwy/cve-search_mcp https://www.cve-search.org/api/

### Системы автоматизированного тестирования

- Reaper — современная легковесная система для тестирования безопасности приложений, предназначенная для использования людьми и ИИ, интегрирующая разведку, проксирование запросов и валидацию уязвимостей, поддерживающая работу с ИИ-агентами и автоматизирующая рутинные задачи для разгрузки инженеров по безопасности. https://github.com/ghostsecurity/reaper/

### Сервисы проверки на вирусы

- https://virustest.gov.ru

### Упражнения

- Telehack (https://telehack.com/) - платформа воссоздаёт атмосферу компьютерных сетей 1980-х годов, позволяя прикоснуться к истокам современного интернета, на ней развернуты 26 600 виртуальных хостов, имитирующих системы времён Usenet и первых BBS, платформа эмулирует работу через Telnet, воспроизводя принципы ранних сетей ARPANET и MILNET.
- OverTheWire (https://overthewire.org/wargames/) - платформа объединяет серию обучающих игр (wargames), ставших настоящей находкой для начинающих, с каждым уровнем сложность возрастает, а задачи становятся более комплексными.
- PicoCTF (https://picoctf.com/) - обучение проходит в формате Capture The Flag, пользователям придётся искать уязвимости в веб-приложениях, проводить криминалистический анализ цифровых данных, разбирать бинарные файлы и др., отдельное внимание уделяется сетевой безопасности и методам разведки по открытым источникам.
- Виртуальные лаборатории TryHackMe (https://tryhackme.com/) и HackTheBox (https://www.hackthebox.com/) - здесь можно развернуть целые сети из виртуальных машин с разными операционными системами, а затем искать в них уязвимости, чаще всего для тренировки используют специальные версии Windows XP и Linux-систему Metasploitable – в них намеренно оставлены бреши в защите, чтобы пользователи могли оттачивать свои навыки.

### Коллекции и каталоги уязвимых лабораторных окружений

- Vulhub — коллекция готовых уязвимых окружений на основе Docker Compose для воспроизведения уязвимостей, обучения и исследований безопасности; для каждого окружения приведены инструкции по запуску и воспроизведению. https://github.com/vulhub/vulhub
- DockerLabs — каталог уязвимых машин для практики пентестинга с разделением по сложности и направлениям: веб-безопасность, bug bounty, CMS, инфраструктура и pivoting. https://dockerlabs.es/
- Offensive Pentesting Lab — коллекция намеренно уязвимых Docker-контейнеров и готовых образов виртуальных машин для практики разведки, анализа и эксплуатации уязвимостей различных сетевых служб в изолированном окружении. https://github.com/InfoSecWarrior/Offensive-Pentesting-Lab

### Docker-образы инструментов и рабочих окружений для тестирования безопасности

- Kali Linux — официальный минимальный образ Kali Rolling; инструменты устанавливаются отдельно. Образ: `kalilinux/kali-rolling`; получение: `docker pull kalilinux/kali-rolling`. https://hub.docker.com/r/kalilinux/kali-rolling
- OWASP ZAP — стабильный образ прокси и сканера безопасности веб-приложений. Образ: `zaproxy/zap-stable`; получение: `docker pull zaproxy/zap-stable`. https://hub.docker.com/r/zaproxy/zap-stable
- WPScan — сканер безопасности WordPress. Образ: `wpscanteam/wpscan`; получение: `docker pull wpscanteam/wpscan`. https://hub.docker.com/r/wpscanteam/wpscan
- Metasploit Framework — образ фреймворка для разработки и проверки эксплойтов. Образ: `metasploitframework/metasploit-framework`; получение: `docker pull metasploitframework/metasploit-framework`. https://hub.docker.com/r/metasploitframework/metasploit-framework
- Docker Bench for Security — проверка конфигурации Docker по рекомендациям CIS Docker Benchmark. Опубликованный образ устарел, поэтому проект нужно собирать из репозитория: `git clone https://github.com/docker/docker-bench-security.git && cd docker-bench-security && docker compose run --rm docker-bench-security`. https://github.com/docker/docker-bench-security

### Уязвимые Docker-образы и стенды для практики

- Pentest-In-Docker — стенд для отработки эксплуатации Shellshock, повышения привилегий и выхода из контейнера, а также проверки Trivy и Falco. Образ: `dvyakimov/vuln-wheezy`; получение: `docker pull dvyakimov/vuln-wheezy`. https://github.com/Swordfish-Security/Pentest-In-Docker
- DVWA — намеренно уязвимое приложение на PHP и MySQL для практики веб-безопасности. Образ: `vulnerables/web-dvwa`; получение: `docker pull vulnerables/web-dvwa`. https://hub.docker.com/r/vulnerables/web-dvwa
- Vulnerable WordPress — намеренно уязвимая сборка WordPress для проверки WPScan и изучения уязвимостей экосистемы. Сборка: `git clone https://github.com/wpscanteam/VulnerableWordPress.git && cd VulnerableWordPress && docker build --rm -t wpscan/vulnerablewordpress .`. https://github.com/wpscanteam/VulnerableWordPress
- Shellshock (CVE-2014-6271) — изолированный стенд для воспроизведения Shellshock. Образ: `hmlio/vaas-cve-2014-6271`; получение: `docker pull hmlio/vaas-cve-2014-6271`. https://hub.docker.com/r/hmlio/vaas-cve-2014-6271
- Heartbleed (CVE-2014-0160) — изолированный стенд для воспроизведения Heartbleed. Образ: `hmlio/vaas-cve-2014-0160`; получение: `docker pull hmlio/vaas-cve-2014-0160`. https://hub.docker.com/r/hmlio/vaas-cve-2014-0160
- Security Ninjas — учебное приложение по безопасности веб-приложений. Образ: `opendns/security-ninjas`; получение: `docker pull opendns/security-ninjas`. https://hub.docker.com/r/opendns/security-ninjas
- OWASP Security Shepherd — платформа с заданиями по безопасности веб- и мобильных приложений. Образ: `owasp/security-shepherd`; получение: `docker pull owasp/security-shepherd`. https://hub.docker.com/r/owasp/security-shepherd
- OWASP WebGoat — намеренно небезопасное Java-приложение для изучения типовых веб-уязвимостей. Образ: `webgoat/webgoat`; получение: `docker pull webgoat/webgoat`. https://hub.docker.com/r/webgoat/webgoat
- OWASP NodeGoat — учебное Node.js-приложение по рискам OWASP Top 10. Запуск из репозитория: `git clone https://github.com/OWASP/NodeGoat.git && cd NodeGoat && docker compose up --build`. https://github.com/OWASP/NodeGoat
- OWASP Mutillidae II — намеренно уязвимое веб-приложение для практики пентестинга. Образ: `webpwnized/mutillidae:www`; получение: `docker pull webpwnized/mutillidae:www`. https://hub.docker.com/r/webpwnized/mutillidae

### Смартфоны

- FLX1s — Linux-смартфон от компании Furi Labs, работающий на FuriOS, обеспечивающий высокий уровень конфиденциальности и поддерживающий Android-приложения, с предзаказом по цене $550 и первой партией, запланированной на 25 октября. https://furilabs.com/flx1s-is-launched/ https://github.com/FuriLabs/

### Отчеты

- Выявление слежки в 30 популярных российских приложениях https://files.rks.global/russian_apps_search_for_vpn_ru.pdf

### Репозитории

- ModSecurity is an open source, cross platform web application firewall (WAF) engine for Apache, IIS and Nginx. It has a robust event-based programming language which provides protection from a range of attacks against web applications and allows for HTTP traffic monitoring, logging and real-time analysis. https://github.com/owasp-modsecurity/ModSecurity

### Обучающие материалы

- PwnPad — открытая аппаратная учебная платформа для изучения hardware hacking и безопасности встроенных систем через набор практических челленджей (UART/I2C/SPI, дамп прошивок, fault injection, side-channel) с переключением заданий джамперами и документацией по сборке и прохождению. https://github.com/twelvesec/PwnPad https://github.com/twelvesec/PwnPadWiki/wiki https://www.youtube.com/watch?v=uaiB-Esttt4

### Курсы

- Мастерство разработки эксплойтов и переполнение буфера — курс уровня OSCP по разработке реальных эксплойтов с нуля: переполнение буфера, контроль EIP, выполнение shellcode, egghunter, плохие символы, обход ASLR/DEP, ROP-цепочки, запуск Meterpreter и пошаговые практики на SLMail, Crossfire и Vulnserver с Immunity Debugger, GDB-PEDA и Kali Linux. https://drive.google.com/drive/folders/1szf2vgueGvSWCUcd0-LHQp2sAuvE9nLd

### Книги

- Computer Security https://textbook.cs161.org/

### Полезные ссылки

### Форумы

- 0x00sec – https://0x00sec.org
- Alligator – https://alligator.cash
- Altenen Forums – https://altenens.is
- Antichat – https://forum.antichat.com
- ASCarding – https://ascarding.com
- Black Hat Pro Tools – https://www.blackhatprotools.info
- BreachForums – https://breached.to
- Carder Forum Online – https://carder-forum.online
- Carding Forum – https://cardingforum.cx
- Carding Leaks – https://cardingleaks.ws
- CardVilla – https://cardvilla.cc
- Chitachok – https://chitachok.fun
- Combolist – https://combolist.top
- Cracked – https://cracked.io
- Crackia – https://crackia.com
- Cracking – https://cracking.org
- Crackingall – https://crackingall.com
- Cracking Hits – https://crackinghits.to
- Cracking Italy – https://crackingitaly.to
- Cracking X – https://crackingx.com
- Cracking Pro – https://www.crackingpro.com
- Crackingshare – https://crackingshare.com
- Crackx – https://crackx.to
- Crimenetwork – https://crime.to
- CrdCrew – https://crdcrew.cc
- CrdPro – https://crdpro.cc
- CWEB Carding Forum – https://www.cweb.ws
- CyberForum RU – https://www.cyberforum.ru
- Cyber Leaks – https://cyberleaks.to
- Cyber Nulled – https://cybernulled.com
- DarkPro – https://darkpro.net
- DarkStash – https://darkstash.com
- Dark-Time – https://srv2.dark-time.life
- Darkweb Mafias – https://darkwebmafias.ws
- Demon Forums – https://www.demonforums.net
- DirectLeaks – https://directleaks.to
- DrDark – https://drdark.ru
- ELeaks – https://eleaks.to
- Enclave – https://www.enclave.cc
- Eternia – https://eternia.to
- Exetools – https://forum.exetools.com
- Exploit.in – https://exploit.in
- EzCarder – https://ezcarder.cc
- ForumTeamSite – https://forumteam.site
- FSSquad – https://fssquad.com
- Ghostlyhaks – https://ghostlyhaks.com/forum
- Go4Expert – https://www.go4expert.com/forums
- Greekhacking – https://greekhacking.gr
- Hack Forums – https://hackforums.net
- Hacking Father – https://hackingfather.com
- Hackonology – https://hackonology.com/forum
- Hack Seller – https://hackseller.com
- HacksTurkey – https://hacksturkey.com
- Happy Hack – http://happy-hack.net/board
- Hide01 Forums – https://forums.hide01.ir
- High-Minded – https://high-minded.net
- Indetectables – https://indetectables.net/index.php
- Iran-Cyber – https://iran-cyber.net/forums
- Kuketz Forum – https://forum.kuketz-blog.de
- Leak Forum – https://leakforum.org
- Leak Zone – https://leakzone.net
- Leaked BB – https://leakedbb.com
- Leech – https://leech.is
- Legit Carder – https://legitcarder.ru
- LegitCarders – https://legitcarders.ws
- Lolz Guru – https://lolz.guru
- MaulTalk – https://www.maultalk.com
- Memory Hackers – https://memoryhackers.org
- Niflheim – https://niflheim.top
- Noirth – https://noirth.com
- Nsane Forums – https://nsaneforums.com
- Null Cracker – https://nullcrack.store
- Nulled – https://www.nulled.to
- Nulled.Id – https://nulled.id
- Pegasus Hack Team – https://pegasushackteam.com
- Psylab – https://psylab.cc
- Openssource – https://www.openssource.info
- P0wersurge – https://p0wersurge.com/forums
- ProLogic – https://prologic.su
- R10 – https://www.r10.net
- Reteam – http://reteam.org/board
- ROM Hacking – https://www.romhacking.net/forum
- RST Forums – https://rstforums.com/forum
- Russian Carder – https://russiancarder.net
- Seopirat – https://www.seopirat.club
- Shield Forum – https://shieldforum.in
- Sinful Site – https://sinfulsite.com
- Sinisterly – https://sinister.ly
- SoldierX – https://www.soldierx.com/bbs
- SzeneBox – https://www.szenebox.org
- TrainingCircle – https://trainingcircle.in
- Trusted Sellers – https://trustedsellers.ws
- TurkHacks – https://www.turkhacks.com
- Underc0de – https://underc0de.org/foro
- UnderWorldMafias – https://underworldmafias.net
- Valid Market – https://www.validmarket.io
- Verified Carder – https://www.verifiedcarder.net
- VLMI – https://vlmi.ws
- Webmasters – http://webmasters.ru/forum
- Wilders Security – https://www.wilderssecurity.com
- Xaker.Name Team – https://xak.guru
- XSS.is – https://xss.is
- YouHack – https://www.youhack.ru

### Телеграм

- Авторские:
    - Пакет Безопасности (https://t.me/package_security) 
    - Пост Лукацкого (https://t.me/alukatsky) 
    - Сицебрекс! (https://t.me/sycebrex) и Sachok (https://t.me/CyberSachok)
    - Ever Secure (https://t.me/ever_secure) и Технологический болт Генона (https://t.me/tech_b0lt_Genona) 
    - Солдатов в телеграм, (https://t.me/soldatov_in_telegram) BESSEС, (https://t.me/bessec) Евгений Касперский (https://t.me/e_kaspersky)
    - ZLONOV, (https://t.me/zlonov) Управление уязвимостями и прочее (https://t.me/avleonovrus) и Топ кибербезопасности Батранкова (https://t.me/safebdv)
- Offensive: 
    - Похек (https://t.me/poxek) 
    - Red team brazzers (https://t.me/RedTeambro) 
    - Багхантер (https://t.me/bughunter_circuit) 
    - Кавычка (https://t.me/webpwn) 
    - Егор Богомолов (https://t.me/YAH_Channel) 
    - Заметки Слонсера (https://t.me/slonser_notes) и PRO:PENTEST  (https://t.me/pro_pentest)
    - s0i37_chanel (https://t.me/s0i37_channel) 
    - Поросенок Петр (https://t.me/pigPeter)
    - GigaHackers (https://t.me/GigaHack)
- Defensive: 
    - ESCalator (https://t.me/ptescalator)
    - README.hta (https://t.me/s3Ch1n7)
    - Blue (h/c)at Café (https://t.me/bh_cat) и Security wine (https://t.me/sec_devops) (бывший - DevSecOps Wine) (https://t.me/bh_cat) и Makrushin (https://t.me/makrushin) 
    - Disasm.me channel (https://t.me/disasm_me_ch)
    - Четыре луча, (https://t.me/four_rays) AppSec Journey (https://t.me/AppSecJourney) и PurpleBear (https://t.me/purple_medved)
- Mixed:
    - k8s (in)security (https://t.me/k8security) 
    - Кибервойна (https://t.me/cyberguerre) и Mobile AppSec World  (https://t.me/mobile_appsec_world)
    - Репорты простым языком (https://t.me/critical_bug) 
    - Сертификат безопасности (https://t.me/qcakz) 
    - Кибербез образование, (https://t.me/cyber_edu) Райтапы по CTF {2025}, (https://t.me/writeup_ctf) ГОСТ VPN | aveselov.ru, (https://t.me/aveselov_ru) PWN AI, (https://t.me/pwnai) Monkey see, monkey do (https://t.me/moseedo)
- Микроблоги: 
    - Ильдар Пишет (https://t.me/nxblog) 
    - Омский Багхантер (https://t.me/bughunter_omsk) 
    - Банка пывна (https://t.me/banka_pwn) и Про ИБ с высоты каблуков (https://t.me/verestnikova) и Кибербез Андрея Дугина (https://t.me/cybersecdugin) 
    - Двое из Кибермаркетинга  (https://t.me/CyberMarketingDuO)
    - CyberBox (https://t.me/cyberboxch) и NA_SOC (https://t.me/na_soc) 
    - Защита персональных данных и не только (https://t.me/shudrova_pdn) и SbX | Security by Xyurity (https://t.me/xyuriti)
- Новостные/агрегаторы:
    - SecАtor (https://t.me/true_secator) 
    - НеЛукацкий (https://t.me/notlukatsky)
    - НеКасперский (https://t.me/NeKaspersky) 
    - Утечки информации (https://t.me/dataleak) и Порвали два трояна (https://t.me/kasperskyb2b) и Offensive Twitter (https://t.me/OffensiveTwitter) 
    - Об ЭП и УЦ (https://t.me/ep_uc) 
    - Максим Горшенин | imaxai (https://t.me/imaxairu) и RUSCADASEC news: Кибербезопасность АСУ ТП (https://t.me/ruscadasecnews)
- Корпоративные: 
    - Kaspersky (https://t.me/kasperskylab_ru) 
    - Red Security (https://t.me/+yAyfd817hidhNzFi) 
    - Positive Technologies (https://t.me/Positive_Technologies) 
    - Борьба с киберпреступностью | F6 (https://t.me/f6_cybersecurity) и BI.ZONE  (https://t.me/bizone_channel)
    - Innostage  (https://t.me/innostage_group)
    - РТ-ИБ, (https://t.me/rtinfobez) ИнфоТеКС, (https://t.me/infotecs_official) Инфосистемы Джет, (https://t.me/jetinfosystems) 3side кибербезопасности (https://t.me/By3side) и Echelon Eyes (https://t.me/EchelonEyes)
    - CURATOR, (https://t.me/curatorpro) Angara Security, (https://t.me/angarasecurity) InfoWatchOut (https://t.me/infowatchout)
- Каналы IT-журналистов: 
    - Грустный киберпанк (https://t.me/korolevsnotes) 
    - КиберBEZправил (https://t.me/kiberbezpravil) 
    - Radio Tishina (https://t.me/radio_tishina) 
    - Игнатий Цукергрохер (https://t.me/divannyi_it) 
    - Doomtech (https://t.me/doomtech) 
    - Убедился корр. ТАСС, (https://t.me/zabelinTASS) Половников (https://t.me/semsotslov) и Девочки/Перцева (https://t.me/girls_pertseva) 
    - Точксичная цифра, (https://t.me/toxic_digital) Первый канал, (https://t.me/bezumnomojnobytpervym) Электро⚡️шок, (https://t.me/electroshockNEWS) это Жабин (https://t.me/zhabinpishet)

### Блоги

- https://alexmacra.com/author/alex/

### Статьи

- Оценка AI-агентов в кибербезопасности
    - Measuring AI Agents’ Progress on Multi-Step Cyber Attack Scenarios — исследование автономных кибератак на двух специализированных cyber range: 32-шаговой корпоративной сети и 7-шаговой промышленной системе управления; сравнивает семь frontier-моделей, влияние бюджета до 100 млн токенов и способность агентов связывать разнородные техники в длинные цепочки атак. https://arxiv.org/html/2603.11214v2
- Уязвимости; CVE; write-up
    - Copy Fail (CVE-2026-31431) — disclosure и технический разбор Linux kernel LPE в `algif_aead`/`authencesn`: цепочка `AF_ALG` + `splice()` даёт unprivileged local user контролируемую 4-byte запись в page cache читаемого файла, что превращается в root через setuid-бинарник и затрагивает multi-tenant Linux, CI runners и контейнерные/Kubernetes-среды; есть mitigations через патч kernel commit `a664bf3d603d`, блокировку `AF_ALG`/`algif_aead` и PoC-репозиторий для авторизованной проверки патчей. https://copy.fail/ https://xint.io/blog/copy-fail-linux-distributions https://github.com/theori-io/copy-fail-CVE-2026-31431
- DevSecOps
    - The Six Dumbest Ideas in Computer Security https://www.ranum.com/security/computer_security/editorials/dumb/
    - Setting Up a Cloud Security Roadmap for Your Startup https://awssecuritydigest.com/articles/cloud-security-roadmap-for-startups
- Threat Intelligence
    - Malware
        - Cloned, Loaded, and Stolen: How 109 Fake GitHub Repositories Delivered SmartLoader and StealC — разбор malware-кампании с фейковыми GitHub-репозиториями, LuaJIT SmartLoader, StealC, C2 через Polygon smart contract, IoC и правилами детекции. https://hexastrike.com/resources/blog/threat-intelligence/cloned-loaded-and-stolen-how-109-fake-github-repositories-delivered-smartloader-and-stealc/
- Penetration testing
    - Stockholm Syndrome: Accurate network testing https://blog.exploit.org/caster-stockholm-syndrome/
- Сетевая безопасность
    - Мобильные сети
        - Что такое SS7 и почему это опасно — обзор рисков сигнальной сети SS7 в мобильной связи: роль HLR/MSC/VLR/STP, перехват SMS и звонков, угрозы для SMS-2FA и причины, по которым устаревшая инфраструктура 2G/3G остаётся важной для безопасности современных сетей. https://codeby.net/threads/chto-takoye-ss7-i-pochemu-eto-opasno.80491/
        - SS7 TOOL: FULL GUIDE FOR LINUX USERS — старый практический материал по лабораторной работе с SS7-стеком в Linux: требования к окружению, SCTP/Wireshark, SafeSeven, симуляция HLR/MSC/VLR и примеры MAP/SMS-сценариев; рассматривать как учебный материал для изолированных стендов и авторизованных исследований. https://kali09.blogspot.com/2018/01/ss7-tool-full-guide-for-linux-users.html
- WAF
    - ModSecurity
        - ModSecurity SQL Injection Challenge: Lessons Learned https://www.trustwave.com/en-us/resources/blogs/spiderlabs-blog/modsecurity-sql-injection-challenge-lessons-learned/
        - How to Set Up ModSecurity with Nginx on Debian/Ubuntu https://www.linuxbabe.com/security/modsecurity-nginx-debian-ubuntu
- Сканирование уязвимостей
    - Как защищать данные, когда денег на ИБ мало: топ-5 Open Source сканеров для поиска уязвимостей https://habr.com/ru/companies/garda/articles/978582/
- Остальное
    - Баги, которые от нас скрывают. Выбираем лучший сайт для поиска уязвимостей https://xakep.ru/2021/06/11/cve-search-services/
- Подборки
    - Обучение кибербезопасности. Бесплатное ПО для практики https://habr.com/ru/articles/888690/
    - Free for Open Source Application Security Tools https://owasp.org/www-community/Free_for_Open_Source_Application_Security_Tools
    - Лучшие сайты для поиска уязвимостей https://spy-soft.net/exploit-databases-for-finding-vulnerabilities/
    - От контейнеров до кода: инструменты для поиска уязвимостей на все случаи https://habr.com/ru/articles/910840/

### Видео

- Плейлисты
    - Digital OWASP  AppSec Israel 2020 https://www.youtube.com/playlist?list=PLA4gj-PiNukcgk6vpXtfRXj4oq4uMAwEG
