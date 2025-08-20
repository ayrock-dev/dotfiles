local biome_or_prettier = { 'biome', 'prettier', stop_after_first = true }

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_format = 'first' })
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
    format_on_save = { -- These options will be passed to conform.format()
      timeout_ms = 1500,
      -- Use LSP formatting first -> cli formatters last
      lsp_format = 'first',
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = biome_or_prettier,
      typescript = biome_or_prettier,
      javascriptreact = biome_or_prettier,
      typescriptreact = biome_or_prettier,
      html = biome_or_prettier,
      json = biome_or_prettier,
      jsonc = biome_or_prettier,
      graphql = biome_or_prettier,
    },
  },
}
