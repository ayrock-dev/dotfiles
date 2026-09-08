-- Single source of truth for "which JS/TS toolchain owns this file".
--
-- Consumed by `after/lsp/{biome,eslint,oxlint}.lua` and `plugins/format.lua` so
-- detection lives in one place and linting LSPs can't double-attach.
--
-- Linter arbitration:
--   biome is all-in-one and exclusive -- it wins outright.
--   eslint and oxlint may coexist (common while migrating: oxlint for the fast
--   rules, eslint for the rest).

---@alias ayrock.js.LinterKind 'biome'|'eslint'|'oxlint'
---@alias ayrock.js.FormatterKind 'biome'|'oxfmt'|'prettier'

---@class ayrock.js.Linter
---@field kind ayrock.js.LinterKind
---@field root string

---@class ayrock.js.Formatter
---@field kind ayrock.js.FormatterKind
---@field root string?

---@class ayrock.js.Toolchain
---@field linters ayrock.js.Linter[]
---@field formatter ayrock.js.Formatter

local biome_configs = { 'biome.json', 'biome.jsonc' }

local oxlint_configs = { '.oxlintrc.json', '.oxlintrc.jsonc', 'oxlint.config.ts' }

local oxfmt_configs = { '.oxfmtrc.json', '.oxfmtrc.jsonc', 'oxfmt.config.ts' }

local eslint_configs = {
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

local project_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', '.git' }

local deno_markers = { 'deno.json', 'deno.jsonc', 'deno.lock' }

---@param path string
---@return table?
local function read_json(path)
  local stat = vim.uv.fs_stat(path)
  if not stat then
    return nil
  end
  local fd = vim.uv.fs_open(path, 'r', 438)
  if not fd then
    return nil
  end
  local ok, data = pcall(vim.uv.fs_read, fd, stat.size, 0)
  vim.uv.fs_close(fd)
  if not ok or type(data) ~= 'string' then
    return nil
  end
  local decoded, parsed = pcall(vim.json.decode, data)
  if not decoded or type(parsed) ~= 'table' then
    return nil
  end
  return parsed
end

---Nearest-first list of config paths found walking up from `fname`.
---@param fname string
---@param names string[]
---@return string[]
local function find_upward(fname, names)
  return vim.fs.find(names, { path = fname, type = 'file', upward = true, limit = math.huge })
end

---Nearest ancestor directory whose `package.json` satisfies `predicate`.
---@param fname string
---@param predicate fun(pkg: table): boolean
---@return string?
local function package_json_dir(fname, predicate)
  for dir in vim.fs.parents(fname) do
    local pkg = read_json(vim.fs.joinpath(dir, 'package.json'))
    if pkg and predicate(pkg) then
      return dir
    end
  end
  return nil
end

---@param pkg table
---@param name string
---@return boolean
local function declares_dep(pkg, name)
  for _, field in ipairs({ 'dependencies', 'devDependencies' }) do
    local deps = pkg[field]
    if type(deps) == 'table' and deps[name] ~= nil then
      return true
    end
  end
  return false
end

---@param fname string
---@return string?
local function project_root(fname)
  return vim.fs.root(fname, project_markers)
end

---Outer boundary of the checkout. Nested lockfiles are common in monorepos, so
---this -- not `project_root` -- bounds searches that walk to the outermost config.
---@param fname string
---@return string?
local function repo_root(fname)
  return vim.fs.root(fname, '.git')
end

---@param fname string
---@return string?
local function biome_root(fname)
  local config = find_upward(fname, biome_configs)[1]
  return config and vim.fs.dirname(config)
end

---oxlint supports nested per-directory configs, so the server must own the
---outermost config within the project rather than the nearest one.
---@param fname string
---@return string?
local function oxlint_root(fname)
  local repo = repo_root(fname)
  local outermost
  for _, config in ipairs(find_upward(fname, oxlint_configs)) do
    local dir = vim.fs.dirname(config)
    if repo and not vim.fs.relpath(repo, dir) then
      break
    end
    outermost = dir
  end
  if outermost then
    return outermost
  end
  local dir = package_json_dir(fname, function(pkg)
    return declares_dep(pkg, 'oxlint')
  end)
  return dir and (project_root(fname) or dir)
end

---@param fname string
---@return string?
local function eslint_root(fname)
  if vim.fs.find(deno_markers, { path = fname, type = 'file', upward = true, limit = 1 })[1] then
    return nil
  end
  local config = find_upward(fname, eslint_configs)[1]
  local dir = config and vim.fs.dirname(config) or package_json_dir(fname, function(pkg)
    return pkg.eslintConfig ~= nil
  end)
  return dir and (project_root(fname) or dir)
end

local M = {}

---@param bufnr integer
---@return ayrock.js.Toolchain
function M.resolve(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)

  local biome = biome_root(fname)
  if biome then
    return {
      linters = { { kind = 'biome', root = biome } },
      formatter = { kind = 'biome', root = biome },
    }
  end

  local oxfmt = find_upward(fname, oxfmt_configs)[1]
  local formatter = oxfmt and { kind = 'oxfmt', root = vim.fs.dirname(oxfmt) } or { kind = 'prettier' }

  local linters = {}
  local oxlint = oxlint_root(fname)
  if oxlint then
    table.insert(linters, { kind = 'oxlint', root = oxlint })
  end
  local eslint = eslint_root(fname)
  if eslint then
    table.insert(linters, { kind = 'eslint', root = eslint })
  end

  return { linters = linters, formatter = formatter }
end

---Root the given linter should attach at, or nil if another toolchain owns the file.
---@param bufnr integer
---@param kind ayrock.js.LinterKind
---@return string?
function M.linter_root(bufnr, kind)
  for _, linter in ipairs(M.resolve(bufnr).linters) do
    if linter.kind == kind then
      return linter.root
    end
  end
  return nil
end

---@param bufnr integer
---@return ayrock.js.Formatter
function M.formatter(bufnr)
  return M.resolve(bufnr).formatter
end

return M
