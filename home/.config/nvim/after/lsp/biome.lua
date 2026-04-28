-- Biome LSP. Only attach if a biome config file is present in the file's
-- directory tree (avoids spurious diagnostics in repos that don't use biome).
---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'biome'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)
  end,
  filetypes = {
    'css',
    'graphql',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'typescript',
    'typescriptreact',
    'vue',
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local biome_config = vim.fs.find({ 'biome.json', 'biome.jsonc' }, {
      path = filename,
      type = 'file',
      upward = true,
      limit = 1,
    })[1]
    if not biome_config then
      return
    end
    on_dir(vim.fs.dirname(biome_config))
  end,
}
