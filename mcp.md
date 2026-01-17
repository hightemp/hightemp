### codex

```toml
[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp"]

[mcp_servers.puppeteer]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-puppeteer"]

[mcp_servers.mdurl]
command = "npx"
args = ["-y", "go-mdurl-mcp-server", "-t", "stdio"]

[mcp_servers.serper]
command = "npx"
args = ["-y", "go-serper-mcp-server", "-t", "stdio"]

[mcp_servers.serper.env]
SERPER_API_KEY = ""

[mcp_servers.computer_use]
command = "/home/hightemp/Projects/go_computer_use_mcp_server/go_computer_use_mcp_server"
args = ["-t", "stdio"]
env_vars = ["DISPLAY", "XAUTHORITY"]
```