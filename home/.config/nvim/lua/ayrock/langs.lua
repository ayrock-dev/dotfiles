-- Treesitter parsers to install + enable highlighting for.
-- LSP servers are NOT listed here; they self-register by virtue of having
-- a config file at `after/lsp/<name>.lua`. See `lua/ayrock/plugins/lsp.lua`.
return {
  -- See: https://github.com/nvim-treesitter/nvim-treesitter (main branch) for supported langs
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
}
