local utils = require('lualine.utils.utils')
local M = require('lualine.component'):extend()

local TTL_MS = 5000
local cache = {}

local function ansi_color(index, hl, fallback)
  return { fg = vim.g['terminal_color_' .. index] or utils.extract_color_from_hllist('fg', { hl }, fallback) }
end

local function refresh(root)
  local entry = cache[root]
  if not entry then
    entry = { pending = false, at = nil, ahead = 0, behind = 0 }
    cache[root] = entry
  end
  if entry.pending or (entry.at and vim.uv.now() - entry.at < TTL_MS) then
    return entry
  end
  entry.pending = true
  vim.system({ 'git', 'rev-list', '--left-right', '--count', 'HEAD...@{upstream}' }, { cwd = root, text = true }, function(result)
    local ahead, behind = (result.stdout or ''):match('(%d+)%s+(%d+)')
    vim.schedule(function()
      entry.ahead = tonumber(ahead) or 0
      entry.behind = tonumber(behind) or 0
      entry.at = vim.uv.now()
      entry.pending = false
    end)
  end)
  return entry
end

function M:init(options)
  M.super.init(self, options)
  self.highlights = {
    ahead = self:create_hl(ansi_color(2, 'DiagnosticOk', '#9ece6a'), 'ahead'),
    behind = self:create_hl(ansi_color(1, 'DiagnosticError', '#f7768e'), 'behind'),
  }
end

function M:update_status()
  local root = vim.fs.root(0, '.git')
  if not root then
    return ''
  end
  local entry = refresh(root)
  local parts = {}
  if entry.ahead > 0 then
    table.insert(parts, self:format_hl(self.highlights.ahead) .. '↑' .. entry.ahead)
  end
  if entry.behind > 0 then
    table.insert(parts, self:format_hl(self.highlights.behind) .. '↓' .. entry.behind)
  end
  return table.concat(parts, ' ')
end

return M
