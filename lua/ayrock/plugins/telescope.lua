return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {},
  config = function()
    local telescope_builtin = require('telescope.builtin')

    vim.keymap.set('n', '<Leader>sf', function()
      telescope_builtin.find_files({ hidden = true })
    end, { desc = '[s]earch for [f]ile by name' })

    vim.keymap.set('n', '<Leader>ff', function()
      telescope_builtin.live_grep()
    end, { desc = '[f]ind in [f]iles (live grep)' })

    vim.keymap.set('n', '<Leader>fh', function()
      telescope_builtin.help_tags()
    end, { desc = '[f]ind [h]elp tags' })

    vim.keymap.set('n', '<Leader>fb', function()
      telescope_builtin.buffers()
    end, { desc = '[f]ind [b]uffers' })

    vim.keymap.set('n', '<Leader>gs', function()
      telescope_builtin.git_status()
    end, { desc = '[g]it [s]tatus' })
  end,
}
