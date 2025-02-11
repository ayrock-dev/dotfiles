-- Language support configuration.

-- This file is a space to manage language support.
-- This includes config for both treesitter and mason_lspconfig.

-- To add support for a language, look up the treesitter module as well
-- as the language server.

return {
  -- treesitter syntax highlighting
  -- See: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
  treesitter_langs = {
    'lua',
    'rust',
    'tsx',
    'javascript',
    'typescript',
    'dockerfile',
    'bash',
    'json',
    'yaml',
    'toml',
    'prisma',
    'proto',
  },
  -- language servers
  -- See: https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
  servers = {
    lua_ls = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
    rust_analyzer = {},
    tsserver = {},
    html = {},
    -- htmx = {},
    dockerls = {}, -- Dockerfile
    jsonls = {},
    yamlls = {},
    taplo = {}, -- .toml
    prismals = {}, -- .prsima
    tailwindcss = {},
  },
}
