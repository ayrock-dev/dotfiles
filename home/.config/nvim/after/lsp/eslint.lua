local eslint_config_files = {
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
  'eslint.config.js',
  'eslint.config.mjs',
  'eslint.config.cjs',
  'eslint.config.ts',
  'eslint.config.mts',
  'eslint.config.cts',
}

-- Returns true if `package.json` at `dir` declares an `eslintConfig` field.
local function package_json_has_eslint(dir)
  local pkg = vim.fs.joinpath(dir, 'package.json')
  local stat = vim.uv.fs_stat(pkg)
  if not stat then
    return false
  end
  local ok, contents = pcall(function()
    local fd = assert(vim.uv.fs_open(pkg, 'r', 438))
    local data = vim.uv.fs_read(fd, stat.size, 0)
    vim.uv.fs_close(fd)
    return data
  end)
  if not ok or not contents then
    return false
  end
  local ok2, parsed = pcall(vim.json.decode, contents)
  return ok2 and type(parsed) == 'table' and parsed.eslintConfig ~= nil
end

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
    -- Exclude deno projects
    if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc', 'deno.lock' }) then
      return
    end

    local filename = vim.api.nvim_buf_get_name(bufnr)
    -- Look for any eslint config file upward
    local config = vim.fs.find(eslint_config_files, {
      path = filename,
      type = 'file',
      upward = true,
      limit = 1,
    })[1]

    local config_dir
    if config then
      config_dir = vim.fs.dirname(config)
    else
      -- Fall back to package.json with eslintConfig field
      for dir in vim.fs.parents(filename) do
        if package_json_has_eslint(dir) then
          config_dir = dir
          break
        end
      end
    end

    if not config_dir then
      return
    end

    -- Anchor at the project root (lockfile or .git) if found, otherwise the config dir.
    local project_root = vim.fs.root(bufnr, { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', '.git' })
    on_dir(project_root or config_dir)
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
      if result then
        vim.ui.open(result.url)
      end
      return {}
    end,
    ['eslint/confirmESLintExecution'] = function(_, result)
      if not result then
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
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspEslintFixAll', function()
      client:request_sync('workspace/executeCommand', {
        command = 'eslint.applyAllFixes',
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
            version = vim.lsp.util.buf_versions[bufnr],
          },
        },
      }, nil, bufnr)
    end, {})

    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'LspEslintFixAll',
    })
  end,
}
