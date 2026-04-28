---@type vim.lsp.Config
return {
  cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
  filetypes = { 'graphql', 'typescriptreact', 'javascriptreact' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local config = vim.fs.find(
      { '.graphqlrc', '.graphqlrc.json', '.graphqlrc.yaml', '.graphqlrc.yml', '.graphqlrc.toml', '.graphqlrc.js', '.graphqlrc.ts', '.graphql.config.js', '.graphql.config.ts', '.graphql.config.json', 'graphql.config.js', 'graphql.config.ts', 'graphql.config.json' },
      { path = fname, upward = true, limit = 1, type = 'file' }
    )[1]
    if not config then
      return
    end
    on_dir(vim.fs.dirname(config))
  end,
}
