-- Shared language settings; copied to both `typescript` and `javascript`
-- (vtsls keys these separately, like VS Code).
local language_settings = {
  updateImportsOnFileMove = { enabled = 'always' },
  tsserver = {
    maxTsServerMemory = 12288, -- in MiB
  },
  suggest = {
    completeFunctionCalls = true,
  },
  inlayHints = {
    enumMemberValues = { enabled = true },
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = 'literals' },
    parameterTypes = { enabled = true },
    propertyDeclarationTypes = { enabled = true },
    variableTypes = { enabled = false },
  },
}

-- Snacks: wire up vtsls' "Move to file" refactoring UI once. The guard keeps
-- registration idempotent even though `on_attach` runs per buffer.
local function register_snacks_move()
  if vim.g._vtsls_snacks_move_registered or not package.loaded['snacks'] then
    return
  end
  vim.g._vtsls_snacks_move_registered = true
  Snacks.util.lsp.on({ name = 'vtsls' }, function(_, client)
    client.commands['_typescript.moveToFileRefactoring'] = function(command, _)
      ---@type string, string, lsp.Range
      local action, uri, range = unpack(command.arguments)

      local function move(newf)
        client:request('workspace/executeCommand', {
          command = command.command,
          arguments = { action, uri, range, newf },
        })
      end

      local fname = vim.uri_to_fname(uri)
      client:request('workspace/executeCommand', {
        command = 'typescript.tsserverRequest',
        arguments = {
          'getMoveToRefactoringFileSuggestions',
          {
            file = fname,
            startLine = range.start.line + 1,
            startOffset = range.start.character + 1,
            endLine = range['end'].line + 1,
            endOffset = range['end'].character + 1,
          },
        },
      }, function(_, result)
        ---@type string[]
        local files = result.body.files
        table.insert(files, 1, 'Enter new path...')
        vim.ui.select(files, {
          prompt = 'Select move destination:',
          format_item = function(f)
            return vim.fn.fnamemodify(f, ':~:.')
          end,
        }, function(f)
          if f and f:find('^Enter new path') then
            vim.ui.input({
              prompt = 'Enter move destination:',
              default = vim.fn.fnamemodify(fname, ':h') .. '/',
              completion = 'file',
            }, function(newf)
              return newf and move(newf)
            end)
          elseif f then
            move(f)
          end
        end)
      end)
    end
  end)
end

---@type vim.lsp.Config
return {
  cmd = { 'vtsls', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  -- Prefer the nearest ts/jsconfig (scopes tsserver to that project in the
  -- monorepo), falling back to package.json, then the git root.
  root_markers = {
    { 'tsconfig.json', 'jsconfig.json' },
    { 'package.json' },
    { '.git' },
  },
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = language_settings,
    javascript = language_settings,
  },
  on_attach = function(client, bufnr)
    register_snacks_move()

    -- Preserve typescript-tools' twoslash inline type queries.
    local ok, twoslash = pcall(require, 'twoslash-queries')
    if ok then
      twoslash.attach(client, bufnr)
    end
  end,
}
