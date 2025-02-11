return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  config = function()
    vim.keymap.set('n', '<leader>tt', function()
      require('trouble').toggle()
    end, { desc = 'Toggle Trouble' })

    vim.keymap.set('n', '[d', function()
      require('trouble').previous()
    end, { desc = 'Previous Trouble' })
    
    vim.keymap.set('n', ']d', function()
      require('trouble').next()
    end, { desc = 'Next Trouble' })
  end,
}