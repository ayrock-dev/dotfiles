-- Picks the JS/TS/JSON/etc. formatter based on which config the project uses.
-- Repos with biome.json -> biome (with --write check, includes assist).
-- Otherwise -> prettier.
local function js_formatter(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local biome_config = vim.fs.find({ 'biome.json', 'biome.jsonc' }, {
    path = fname,
    type = 'file',
    upward = true,
    limit = 1,
  })[1]
  if biome_config then
    return { 'biome' }
  end
  return { 'prettier' }
end

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
      javascript = js_formatter,
      typescript = js_formatter,
      javascriptreact = js_formatter,
      typescriptreact = js_formatter,
      html = js_formatter,
      json = js_formatter,
      jsonc = js_formatter,
      graphql = js_formatter,
    },
  },
}
