local M = require('lualine.component'):extend()

function M:init(options)
  M.super.init(self, options)
end

function M:update_status()
  local status = '󰜺'

  if package.loaded['supermaven-nvim.api'] then
    local api = require('supermaven-nvim.api')
    status = api.is_running() and '' or ''
  end

  return string.format('󰘧%s ', status)
end

return M
