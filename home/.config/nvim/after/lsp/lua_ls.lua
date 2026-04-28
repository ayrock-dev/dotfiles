---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    { '.luarc.json', '.luarc.jsonc', '.emmyrc.json' },
    { '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml' },
    { '.git' },
  },
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      codeLens = { enable = true },
      hint = { enable = true, semicolon = 'Disable' },
    },
  },
}
