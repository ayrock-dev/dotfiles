-- Deterministic BufWritePre pipeline: LSP lint fixes first, then formatting.
--
-- Both concerns previously registered their own BufWritePre autocmds (eslint on
-- LspAttach, conform on plugin load), so ordering fell out of autocmd creation
-- order. Lint fixes can emit unformatted code, so a single owner runs them in a
-- fixed order instead.

---@class ayrock.on_save.FixAll
---@field command string
---@field arguments fun(bufnr: integer): table[]

---Linting LSPs exposing a "fix all" command, in the order they should run.
---`fix_on_save` is the default, overridable per project (exrc) via
---`vim.g.<name>_fix_on_save`. `:Lsp<Name>FixAll` always works regardless.
---@type { name: string, fix_on_save: boolean, fix_all: ayrock.on_save.FixAll }[]
local linters = {
  {
    name = 'oxlint',
    -- Off by default: oxlint fixes rewrite code, and projects adopting oxlint
    -- tend to run it report-only alongside an existing linter.
    fix_on_save = false,
    fix_all = {
      command = 'oxc.fixAll',
      arguments = function(bufnr)
        return { { uri = vim.uri_from_bufnr(bufnr) } }
      end,
    },
  },
  {
    name = 'eslint',
    fix_on_save = true,
    fix_all = {
      command = 'eslint.applyAllFixes',
      arguments = function(bufnr)
        return { { uri = vim.uri_from_bufnr(bufnr), version = vim.lsp.util.buf_versions[bufnr] } }
      end,
    },
  },
}

local timeout_ms = 1500

---@param linter { name: string, fix_on_save: boolean }
---@return boolean
local function fixes_on_save(linter)
  local override = vim.g[linter.name .. '_fix_on_save']
  if override ~= nil then
    return override == true
  end
  return linter.fix_on_save
end

---@param bufnr integer
---@param selected fun(linter: { name: string, fix_on_save: boolean }): boolean
local function apply_fixes(bufnr, selected)
  for _, linter in ipairs(linters) do
    if selected(linter) then
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = linter.name })) do
        local _, err = client:request_sync('workspace/executeCommand', {
          command = linter.fix_all.command,
          arguments = linter.fix_all.arguments(bufnr),
        }, timeout_ms, bufnr)
        if err then
          vim.notify(string.format('[%s] fix all failed: %s', linter.name, err), vim.log.levels.WARN)
        end
      end
    end
  end
end

local M = {}

---Synchronously apply lint fixes on request, ignoring the fix-on-save gate.
---@param bufnr integer
---@param only string? restrict to a single client name
function M.fix(bufnr, only)
  apply_fixes(bufnr, function(linter)
    return not only or only == linter.name
  end)
end

---@param bufnr integer
function M.run(bufnr)
  apply_fixes(bufnr, fixes_on_save)
  require('conform').format({ bufnr = bufnr, timeout_ms = timeout_ms })
end

function M.setup()
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('ayrock.on_save', { clear = true }),
    callback = function(args)
      M.run(args.buf)
    end,
  })
end

return M
