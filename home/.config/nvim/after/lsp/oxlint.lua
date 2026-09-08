-- Oxlint LSP. Attaches only when `ayrock.js_toolchain` says oxlint owns the file
-- (avoids spurious diagnostics in repos that don't use oxlint).
local function has_tsgolint(root_dir)
  if vim.fn.executable('tsgolint') == 1 then
    return true
  end
  return vim.fn.executable(vim.fs.joinpath(root_dir, 'node_modules/.bin/tsgolint')) == 1
end

---@param root_dir string
---@return boolean
local function config_mentions_typescript(root_dir)
  for _, name in ipairs({ '.oxlintrc.json', '.oxlintrc.jsonc' }) do
    local path = vim.fs.joinpath(root_dir, name)
    if vim.uv.fs_stat(path) then
      for line in io.lines(path) do
        if line:find('typescript', 1, true) then
          return true
        end
      end
    end
  end
  return false
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'oxlint'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, '--lsp' }, dispatchers)
  end,
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
    'astro',
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local root = require('ayrock.js_toolchain').linter_root(bufnr, 'oxlint')
    if root then
      on_dir(root)
    end
  end,
  settings = {
    run = 'onType',
    fixKind = 'safe_fix',
  },
  -- Fix-on-save is owned by `ayrock.on_save`, which sequences fixes before formatting.
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspOxlintFixAll', function()
      require('ayrock.on_save').fix(bufnr, 'oxlint')
    end, { desc = 'Apply Oxlint automatic fixes' })
  end,
  before_init = function(init_params, config)
    local settings = vim.deepcopy(config.settings or {})
    local root_dir = config.root_dir
    if settings.typeAware == nil and root_dir and has_tsgolint(root_dir) and config_mentions_typescript(root_dir) then
      settings.typeAware = true
    end
    local init_options = config.init_options or {}
    init_options.settings = vim.tbl_extend('force', init_options.settings or {}, settings)
    init_params.initializationOptions = init_options
  end,
}
