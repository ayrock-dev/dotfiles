return {
  -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  opts = {
    spec = {
      { '<leader>c', group = '[c]ode' },
      { '<leader>d', group = '[d]ocument' },
      { '<leader>g', group = '[g]it' },
      { '<leader>h', group = 'git [h]unk' },
      { '<leader>r', group = '[r]ename' },
      { '<leader>s', group = '[s]earch' },
      { '<leader>t', group = '[t]oggle' },
      { '<leader>w', group = '[w]orkspace' },
    },
  },
}
