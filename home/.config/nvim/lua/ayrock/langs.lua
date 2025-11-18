-- Language support configuration.

-- This file is a space to manage language support.
-- This includes config for both treesitter and mason_lspconfig.

-- To add support for a language, look up the treesitter module AND the language server.

return {
  -- treesitter syntax highlighting
  -- See: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
  treesitter_langs = {
    'bash',
    'diff',
    'elixir',
    'html',
    'lua',
    'luadoc',
    'markdown',
    'rust',
    'tsx',
    'javascript',
    'typescript',
    'graphql',
    'dockerfile',
    'json',
    'sql',
    'toml',
    'prisma',
    'proto',
    'python',
    'vim',
    'vimdoc',
    'yaml',
  },
  -- language servers
  -- See: https://github.com/mason-org/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
  servers = {
    --example == {
    -- cmd = { ... },
    -- filetypes = { ... },
    -- capabilities = {},
    --}
    lua_ls = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
    rust_analyzer = {},
    elixirls = {
      cmd = { 'elixir-ls' }, -- 'elixir-ls' must be in path and on-system, for example via Brew
    },
    graphql = {},
    html = {},
    prismals = {},
    pyright = {}, -- python lsp by microsoft
    eslint = {
      capabilities = {
        documentFormattingProvider = true,
        codeActionOnSave = {
          enable = true,
          mode = 'all',
        },
        format = true,
      },
    },
    sqlls = {},
    tailwindcss = {},
    dockerls = {},
    jsonls = {
      capabilities = {
        documentFormattingProvider = false,
      },
    },
    yamlls = {},
    taplo = {},
    biome = {
      server_capabilities = {
        documentFormattingProvider = false,
      },
    },
  },
}
