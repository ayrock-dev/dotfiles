return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup({
      columns = { 'icon' },
      keymaps = {
        ['<C-h>'] = false,
        ['<M-h>'] = 'actions.select_split',
      },
      view_options = {
        show_hidden = true,
      },
    })

    -- Open parent directory in current window
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = '[-] Explore' })
    vim.keymap.set('n', '<Leader>E', '<CMD>Oil<CR>', { desc = '[E]xplore' })

    -- Open parent directory in floating window
    vim.keymap.set('n', '<Leader>-', require('oil').toggle_float, { desc = '[-] Explore' })
  end,
}
