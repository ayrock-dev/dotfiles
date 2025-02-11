return {
  'folke/trouble.nvim',
  branch = 'dev', -- v3
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {},
  config = function()
    vim.keymap.set('n', '<leader>tt', function()
      require('trouble').toggle('diagnostics')
    end, { desc = '[T]oggle [T]rouble' })

    vim.keymap.set('n', '[d', function()
      require('trouble').open()
      require('trouble').previous({ skip_groups = true, jump = true })
    end, { desc = 'Previous Trouble' })

    vim.keymap.set('n', ']d', function()
      require('trouble').open()
      require('trouble').next({ skip_groups = true, jump = true })
    end, { desc = 'Next Trouble' })
  end,
}
