-- Picks the JS/TS/JSON/etc. formatter based on which config the project uses.
-- See `ayrock.js_toolchain`; formatter kinds map 1:1 to conform formatter names.
local function js_formatter(bufnr)
  return { require('ayrock.js_toolchain').formatter(bufnr).kind }
end

return {
  'stevearc/conform.nvim',
  -- Format-on-save is driven by `ayrock.on_save` (which requires this module,
  -- triggering the lazy load) so lint fixes are guaranteed to run first.
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
        command = function(_, ctx)
          local root = require('ayrock.js_toolchain').formatter(ctx.buf).root
          local local_cmd = root and vim.fs.joinpath(root, 'node_modules/.bin/biome')
          return local_cmd and vim.fn.executable(local_cmd) == 1 and local_cmd or 'biome'
        end,
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
