# Configuration for the Pi Coding Agent

Pi coding agent is installed on system by Brew under the `pi-coding-agent` name.

Pi documentation is available at https://pi.dev/docs

## Environment

Pi is configured to run my personal preferred models.

## Work Environment

At my day job, Claude agents are accessed via Cloudflare AI Gateway. See https://pi.dev/docs/latest/providers#cloudflare-ai-gateway

Cloudflare AI Gateway secrets must be specified on system (via `~/.secrets` in this dotfiles repo).

| Environment Variable | Description |
|---|---|
| `CLOUDFLARE_API_KEY` | Cloudflare API key. |
| `CLOUDFLARE_ACCOUNT_ID` | Cloudflare Account ID. Can be found via `wrangler whoami` |
| `CLOUDFLARE_GATEWAY_ID` | Cloudflare AI Gateway ID. Create at dash.cloudflare.com → AI → AI Gateway |

## Personal Environment

For daily personal use, I use subscription-based providers. To reconnect with an ai provider use the `/login` command in Pi.

## Quickstart

Run `pi` on system to start Pi.

Packages listed under `packages` in `agent/settings.json` are installed
automatically by Pi on first launch (into `~/.pi/agent/npm/`, which is not
tracked).

## MCP Servers

Pi has built-in MCP support. See [Pi MCP documentation](https://pi.dev/docs/latest/mcp) for configuration
and tool options.

## Configuration Management

Configuration is checked into git in this directory.

Pi runtime files are ignored, such as:

- `agent/auth.json`
- `agent/sessions/`
- `agent/npm/` (installed packages)
