local function biome_or_prettier(bufnr)
  local has_biome = vim.lsp.get_clients({
    bufnr = bufnr,
    name = 'biome',
  })[1]

  if has_biome then
    return {}
  end

  local has_prettier = vim.fs.find({
    -- https://prettier.io/docs/en/configuration.html
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.yml',
    '.prettierrc.yaml',
    '.prettierrc.json5',
    '.prettierrc.js',
    '.prettierrc.cjs',
    '.prettierrc.toml',
    'prettier.config.js',
    'prettier.config.cjs',
  }, { upward = true })[1]

  if has_prettier then
    return { 'prettier', 'prettierd' }
  end

  return { 'biome' }
end

return {
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_fallback = true })
      end,
      mode = '',
      desc = '[f]ormat buffer',
    },
  },
  opts = {
    stop_after_first = true,
    notify_on_error = false,
    format_on_save = function(bufnr)
      return {
        timeout_ms = 500,
        lsp_fallback = true,
      }
    end,
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
