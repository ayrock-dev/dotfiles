return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    defaults = {
      initial_mode = 'normal',
      hidden = true,
    },
  },
  config = function(opts)
    local telescope_builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[s]earch [h]elp' })
    vim.keymap.set('n', '<leader>sk', telescope_builtin.keymaps, { desc = '[s]earch [k]eymaps' })
    vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, { desc = '[s]earch [f]iles' })
    vim.keymap.set('n', '<leader>ss', telescope_builtin.builtin, { desc = '[s]earch [s]elect telescope' })
    vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[s]earch current [w]ord' })
    vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = '[s]earch by [g]rep' })
    vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[s]earch [d]iagnostics' })
    vim.keymap.set('n', '<leader>sr', telescope_builtin.resume, { desc = '[s]earch [r]esume' })
    vim.keymap.set('n', '<leader>s.', telescope_builtin.oldfiles, { desc = '[s]earch previous [.]' })
    vim.keymap.set('n', '<leader>sb', telescope_builtin.buffers, { desc = '[s]earch open [b]uffers' })
    vim.keymap.set('n', '<leader><leader>', telescope_builtin.buffers, { desc = 'search open buffers [<leader>]' })

    return opts
  end,
}
