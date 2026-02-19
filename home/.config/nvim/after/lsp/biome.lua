---@type vim.lsp.Config
return {
  root_dir = function(bufnr, on_dir)
    if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc', 'deno.lock' }) then
      return
    end

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
  on_init = function(client)
    if client.server_capabilities then
      client.server_capabilities.documentFormattingProvider = false
    end
  end,
}
