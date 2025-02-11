return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {},
  config = function()
    local telescope_builtin = require('telescope.builtin')

    vim.keymap.set('n', '<Leader>s', function()
      telescope_builtin.find_files({ hidden = true })
    end, { desc = '[S]earch files' })

    vim.keymap.set('n', '<Leader>ff', function()
      telescope_builtin.live_grep()
    end, { desc = 'Grep [f]iles' })

    vim.keymap.set('n', '<Leader>fh', function()
      telescope_builtin.help_tags()
    end, { desc = 'Find [h]elp tags' })

    vim.keymap.set('n', '<Leader>fb', function()
      telescope_builtin.buffers()
    end, { desc = 'Show [b]uffers' })

    vim.keymap.set('n', '<Leader>gs', function()
      telescope_builtin.git_status()
    end, { desc = 'Git [s]tatus' })
  end,
}
