local function biome_or_prettier(_bufnr)
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
        require('conform').format({ async = true, lsp_format = 'first' })
      end,
      desc = '[f]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
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
  init = function(_)
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*',
      callback = function()
        local conform = require('conform')
        local formatters = conform.list_formatters()

        for _, formatter in ipairs(formatters) do
          if formatter.name == 'biome' then
            vim.lsp.buf.code_action({
              filter = function(action)
                return action.kind == 'source.fixAll.biome' or action.kind == 'source.organizeImports.biome'
              end,
              apply = true,
            })
            break
          end
        end
      end,
    })
  end,
}
