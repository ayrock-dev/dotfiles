# Configuration for the Pi Coding Agent

Pi coding agent is installed on system by Brew under the `pi-coding-agent` name.

Pi documentation is available at https://pi.dev/docs

## Environment

Pi is configured to run against Claude models via Cloudflare AI Gateway. See https://pi.dev/docs/latest/providers#cloudflare-ai-gateway

Cloudflare AI Gateway secrets must be specified on system (via `~/.secrets` in this dotfiles repo).

| Environment Variable | Description |
|---|---|
| `CLOUDFLARE_API_KEY` | Cloudflare API key. |
| `CLOUDFLARE_ACCOUNT_ID` | Cloudflare Account ID. Can be found via `wrangler whoami` |
| `CLOUDFLARE_GATEWAY_ID` | Cloudflare AI Gateway ID. Create at dash.cloudflare.com → AI → AI Gateway |

## Quickstart

Run `pi` on system to start Pi.

Packages listed under `packages` in `agent/settings.json` are installed
automatically by Pi on first launch (into `~/.pi/agent/npm/`, which is not
tracked).

## MCP Servers

Pi has no built-in MCP support. It is provided by the
[`pi-mcp-adapter`](https://pi.dev/packages/pi-mcp-adapter) package, declared in
`agent/settings.json` under `packages`. The adapter exposes MCP servers through a
single proxy tool and starts servers lazily to keep context usage low.

Servers are configured in `agent/mcp.json` using the standard `mcpServers`
format. Remote servers use `url` (StreamableHTTP with SSE fallback) with
`auth`/`oauth`; local servers use `command` + `args`. Values support `${VAR}`
interpolation from the environment (secrets come from `~/.secrets`).

```json
{
  "mcpServers": {
    "notion": {
      "url": "https://mcp.notion.com/mcp",
      "auth": "oauth"
    }
  }
}
```

Project-local overrides can be placed in `<project>/.pi/mcp.json`. See the
[adapter README](https://pi.dev/packages/pi-mcp-adapter) for the full option
set (`headers`, `bearerToken`, `lifecycle`, `directTools`, etc.).

## Configuration Management

Configuration is checked into git in this directory.

Pi runtime files are ignored, such as:

- `agent/auth.json`
- `agent/sessions/`
- `agent/npm/` (installed packages)
