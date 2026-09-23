# Pi Agents

### Репозитории

- Oh My Pi (omp) — форк Pi: мощный coding agent с IDE-интеграцией; 60+ провайдеров, 31 встроенный инструмент, 14 LSP-операций, 28 DAP-операций, ядро на ~80k строк Rust. Память изолируется по проекту (backend: local / Hindsight / Mnemopi); работает из терминала и из редактора (Zed). Установка: curl -fsSL https://omp.sh/install | sh. https://github.com/can1357/oh-my-pi https://omp.sh

### MCP

- Pi MCP Adapter — token-efficient MCP-адаптер для Pi coding agent: подключает MCP-серверы через один proxy tool вместо загрузки всех tool definitions в контекст, лениво запускает серверы по требованию, кеширует метаданные инструментов, поддерживает `.mcp.json`, host-specific импорты для Cursor/Claude Code/Codex и direct tools для выбранных MCP-инструментов. https://github.com/nicobailon/pi-mcp-adapter

### Skills

- Pi Skills — коллекция skills для pi-coding-agent, совместимая также с Claude Code, Codex CLI, Amp и Droid; включает brave-search, browser-tools, Google Calendar/Drive/Gmail CLI skills, transcribe, VS Code integration и youtube-transcript. https://github.com/badlogic/pi-skills
