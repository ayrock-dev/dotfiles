return {
  'goolord/alpha-nvim',
  config = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')
    dashboard.section.buttons.val = {
      dashboard.button('-', '󰙅 Explore', ':lua MiniFiles.open()<CR>'),
      dashboard.button('<leader>sf', ' Find File', ':Telescope find_files<CR>'),
      dashboard.button('<leader>sg', ' Grep / Text Search', ':Telescope live_grep<CR>'),
      dashboard.button('<leader>ene', ' New File', ':ene | startinsert<CR>'),
      dashboard.button('<leader>so', ' Recent Files', ':Telescope oldfiles<CR>'),
      dashboard.button('q', ' Quit', ':qa<CR>'),
    }
    alpha.setup(dashboard.config)
  end,
}
