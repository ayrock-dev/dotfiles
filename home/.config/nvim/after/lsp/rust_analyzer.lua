---@type vim.lsp.Config
return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
  },
  settings = {
    ['rust-analyzer'] = {
      lens = {
        debug = { enable = true },
        enable = true,
        implementations = { enable = true },
        run = { enable = true },
      },
    },
  },
  before_init = function(init_params, config)
    -- rust-analyzer expects settings under initializationOptions.
    -- See https://github.com/rust-lang/rust-analyzer/blob/master/docs/dev/lsp-extensions.md
    if config.settings and config.settings['rust-analyzer'] then
      init_params.initializationOptions = config.settings['rust-analyzer']
    end
  end,
}
