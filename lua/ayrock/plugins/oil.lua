return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    default_file_explorer = true,
    columns = { 'icon' },
    view_options = {
      show_hidden = true,
    },
  },
  keys = {
    {
      '-',
      function()
        require('oil').open()
      end,
      desc = '[-] Explore',
    },
    {
      '<leader>E',
      function()
        require('oil').open()
      end,
      desc = '[E]xplore',
    },
    {
      '<leader>-',
      function()
        require('oil').toggle_float()
      end,
      desc = '[-] Explore (Popup)',
    },
  },
}
