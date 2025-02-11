-- Language support configuration.

-- This file is a space to manage language support.
-- This includes config for both treesitter and mason_lspconfig.

-- To add support for a language, look up the treesitter module AND the language server.

return {
  -- treesitter syntax highlighting
  -- See: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
  treesitter_langs = {
    'bash',
    'c',
    'diff',
    'html',
    'lua',
    'luadoc',
    'markdown',
    'rust',
    'tsx',
    'javascript',
    'typescript',
    'dockerfile',
    'json',
    'toml',
    'prisma',
    'proto',
    'vim',
    'vimdoc',
  },
  -- language servers
  -- See: https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
  servers = {
    lua_ls = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
    rust_analyzer = {},
    tsserver = {},
    html = {},
    prismals = {},
    tailwindcss = {},
    -- htmx = {},
    dockerls = {},
    jsonls = {},
    yamlls = {},
    taplo = {},
  },
}
