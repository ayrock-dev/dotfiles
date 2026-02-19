---@type vim.lsp.Config
return {
  on_init = function(client)
    if client.server_capabilities then
      client.server_capabilities.documentFormattingProvider = false
    end
  end,
}
