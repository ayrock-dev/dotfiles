---@type vim.lsp.Config
return {
  cmd = { 'elixir-ls' }, -- 'elixir-ls' must be in PATH (e.g., installed via Brew)
  filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)

    -- Elixir workspaces may have multiple `mix.exs` files (umbrella layout).
    -- Pick the top-level `mix.exs` if present.
    local matches = vim.fs.find({ 'mix.exs' }, { upward = true, limit = 2, path = fname })
    local child_or_root_path, maybe_umbrella_path = unpack(matches)
    on_dir(vim.fs.dirname(maybe_umbrella_path or child_or_root_path))
  end,
}
