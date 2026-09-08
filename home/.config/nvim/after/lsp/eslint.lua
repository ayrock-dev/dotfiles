-- Eslint LSP. Attaches only when `ayrock.js_toolchain` says eslint owns the file
-- (avoids spurious diagnostics in repos that don't use eslint).
---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'vscode-eslint-language-server'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
    'astro',
    'htmlangular',
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local root = require('ayrock.js_toolchain').linter_root(bufnr, 'eslint')
    if root then
      on_dir(root)
    end
  end,
  before_init = function(_, config)
    local root_dir = config.root_dir
    if root_dir then
      config.settings = config.settings or {}
      config.settings.workspaceFolder = {
        uri = root_dir,
        name = vim.fn.fnamemodify(root_dir, ':t'),
      }
      -- Yarn2 (PnP) support
      local pnp_cjs = root_dir .. '/.pnp.cjs'
      local pnp_js = root_dir .. '/.pnp.js'
      if type(config.cmd) == 'table' and (vim.uv.fs_stat(pnp_cjs) or vim.uv.fs_stat(pnp_js)) then
        config.cmd = vim.list_extend({ 'yarn', 'exec' }, config.cmd --[[@as table]])
      end
    end
  end,
  settings = {
    -- Disable eslint LSP formatting (we use prettier via conform).
    format = false,
    validate = 'on',
    useESLintClass = false,
    experimental = {},
    codeActionOnSave = {
      enable = false,
      mode = 'all',
    },
    quiet = false,
    onIgnoredFiles = 'off',
    rulesCustomizations = {},
    run = 'onType',
    problems = { shortenToSingleLine = false },
    nodePath = '',
    workingDirectory = { mode = 'auto' },
    codeAction = {
      disableRuleComment = { enable = true, location = 'separateLine' },
      showDocumentation = { enable = true },
    },
  },
  handlers = {
    ['eslint/openDoc'] = function(_, result)
      if result ~= nil and result ~= vim.NIL then
        vim.ui.open(result.url)
      end
      return {}
    end,
    ['eslint/confirmESLintExecution'] = function(_, result)
      if result == nil or result == vim.NIL then
        return
      end
      return 4 -- approved
    end,
    ['eslint/probeFailed'] = function()
      vim.notify('[eslint] probe failed.', vim.log.levels.WARN)
      return {}
    end,
    ['eslint/noLibrary'] = function()
      vim.notify('[eslint] unable to find ESLint library.', vim.log.levels.WARN)
      return {}
    end,
  },
  -- Fix-on-save is owned by `ayrock.on_save`, which sequences fixes before formatting.
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspEslintFixAll', function()
      require('ayrock.on_save').fix(bufnr, 'eslint')
    end, { desc = 'Apply ESLint automatic fixes' })
  end,
}
