return {
  'goolord/alpha-nvim',
  config = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')
    dashboard.section.buttons.val = {
      dashboard.button('e', '󰙅 Explore', '-'),
      dashboard.button('f', ' Find File', ':Telescope find_files<CR>'),
      dashboard.button('g', ' Grep / Text Search', ':Telescope live_grep<CR>'),
      dashboard.button('n', ' New File', ':ene | startinsert<CR>'),
      dashboard.button('r', ' Recent Files', ':Telescope oldfiles<CR>'),
      dashboard.button('q', ' Quit', ':qa<CR>'),
    }
    alpha.setup(dashboard.config)
  end,
}
