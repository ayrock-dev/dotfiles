local function biome_or_prettier(bufnr)
  local has_biome = vim.fs.find({
    -- https://biomejs.dev/guides/configure-biome
    'biome.json',
    'biome.jsonc',
  }, { upward = true })[1]

  if has_biome then
    -- use biome on system
    return { 'biome' }
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
    -- use prettier on system
    return { 'prettier', 'prettierd' }
  end

  return {}
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
    format_on_save = { -- These options will be passed to conform.format()
      timeout_ms = 500,
      -- Use cli formatters (i.e. stylua, prettier) then LSP formatting last (i.e. eslint, biome, rust, go)
      lsp_format = 'last',
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
