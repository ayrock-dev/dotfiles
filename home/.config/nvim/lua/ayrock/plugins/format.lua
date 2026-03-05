return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true })
      end,
      desc = '[f]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    formatters = {
      biome = {
        -- override default biome config https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/biome.lua
        -- in order to support assist (which only runs on biome check)
        args = { 'check', '--write', '--stdin-file-path', '$FILENAME' },
      },
    },
    -- These options will be passed to conform.format()
    default_format_opts = {
      -- conform formatters first -> LSP formatters as fallback
      lsp_format = 'fallback',
    },
    -- These options will be passed to conform.format()
    format_on_save = { timeout_ms = 1500 },
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      graphql = { 'prettier' },
    },
  },
}
