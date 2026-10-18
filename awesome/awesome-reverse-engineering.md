
### Иснтрументы

- RevEng - ИИ-инструмент для углублённого анализа исполняемых файлов (EXE, DLL), скриптов, архивов и патчей на предмет вредоносного кода, обхода защиты и нестандартных методов обфускации, при этом умеющий распознавать встроенное вредоносное ПО и другие признаки киберугрозы без необходимости запуска файла, с подробным отчётом и интеграцией с Ghidra и IDA Pro. https://github.com/LaurieWired/GhidraMCP https://www.youtube.com/watch?v=u2vQapLAW88 https://x.com/lauriewired
- ASC — сверхбыстрый Android-декомпилятор-фронтенд для AI-агентов и mobile-исследователей, замена Jadx MCP: анализ 10+ APK параллельно, декомпиляция для reverse engineering Android-приложений, используется для поиска мобильных уязвимостей. Принят в BlackHat EU Arsenal. https://github.com/MG1937/ASC
- apk-reverse — Agent Skill (набор SKILL.md) для Android APK reverse engineering, debloating, удаления рекламы и surgical-патчинга dex, пересборки и подписи APK, разбора обфускации (packers/loaders), анализа native-слоя и реверса Flutter через Dart AOT; работает с Claude Code, Codex и любым агентом, поддерживающим формат Agent Skills, инструменты не упакованы — AI сам их доустанавливает. Структурирован как процедура с вентилями (R1-R4, симптомы, гейты G1-G4, правило двух промахов) против типичных ошибок реверсера. https://github.com/newliver666/apk-reverse

### Студия reverse engineering для AI-агентов (из поста @N01ennn — «binary → REA → SPEC.md → rebuild»)

Набор открытых инструментов, из которых AI-агент собирает full-loop RE (анализ → SPEC.md → пересборка → проверка). Для анализа ПО, на которое есть права/разрешение, CTF и исследовательских задач.

- 01 · Analysis core
    - REA (Reverse Engineer Anything) — центральный инструмент, «один MCP для всего» (уже есть в awesome-cyber-security.md). https://github.com/morluto/rea
    - Ghidra — бесплатный фреймворк/декомпилятор для разбора бинарей. https://github.com/NationalSecurityAgency/ghidra
    - GhidraMCP — мост агента в Ghidra (уже есть выше и в awesome-n8n.md). https://github.com/LaurieWired/GhidraMCP
    - ida-pro-mcp — подключение IDA Pro к языковым моделям через MCP. https://github.com/mrexodia/ida-pro-mcp
- 02 · Mobile & apps
    - jadx — Android APK → Java-исходники (декомпилятор). https://github.com/skylot/jadx
    - Apktool — распаковка и пересборка APK. https://github.com/iBotPeaches/Apktool
    - Frida — хуки динамического исполнения (runtime hooks). https://github.com/frida/frida
    - ILSpy — декомпилятор .NET. https://github.com/icsharpcode/ILSpy
- 03 · Binary & low-level
    - radare2 — terminal-фреймворк для reverse engineering. https://github.com/radareorg/radare2
    - x64dbg — Windows-дебаггер для реверса. https://github.com/x64dbg/x64dbg
    - ImHex — hex-редактор + pattern language. https://github.com/WerWolv/ImHex
    - angr — символьное выполнение/платформа бинарного анализа. https://github.com/angr/angr
- 04 · Network & runtime
    - mitmproxy — интерактивный перехват трафика (MITM-прокси). https://github.com/mitmproxy/mitmproxy
    - dnSpy — .NET debug & edit (форк-ревайвл dnSpyEx). https://github.com/dnSpyEx/dnSpy
    - rizin — форк radare2. https://github.com/rizinorg/rizin
    - raddebugger — нативный дебаггер Epic Games. https://github.com/EpicGames/raddebugger
- 05 · Rebuild & verify
    - awesome-ai-reverse-engineering — курируемый список 122 репо для AI-реверса, каждое прочитано и оценено по безопасности. https://github.com/zhuyansen/awesome-ai-reverse-engineering
    - awesome-reverse-engineering — список ресурсов от автора REA. https://github.com/morluto/awesome-reverse-engineering
    - REA workflows — встроенные в REA пайплайны: SPEC.md + oracles + verification (внутри репозитория). https://github.com/morluto/rea