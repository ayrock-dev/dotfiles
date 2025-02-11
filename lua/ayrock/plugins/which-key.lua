return {
  -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  config = function()
    -- document existing keymaps
    require('which-key').register({
      ['<leader>c'] = { name = '[c]ode', _ = 'which_key_ignore' },
      ['<leader>d'] = { name = '[d]ocument', _ = 'which_key_ignore' },
      ['<leader>g'] = { name = '[g]it', _ = 'which_key_ignore' },
      ['<leader>h'] = { name = 'git [h]unk', _ = 'which_key_ignore' },
      ['<leader>r'] = { name = '[r]ename', _ = 'which_key_ignore' },
      ['<leader>s'] = { name = '[s]earch', _ = 'which_key_ignore' },
      ['<leader>t'] = { name = '[t]oggle', _ = 'which_key_ignore' },
      ['<leader>w'] = { name = '[w]orkspace', _ = 'which_key_ignore' },
    })
    -- register which-key VISUAL mode
    -- required for visual <leader>hs (hunk stage) to work
    require('which-key').register({
      ['<leader>'] = { name = 'VISUAL <leader>' },
      ['<leader>h'] = { 'git [H]unk' },
    }, { mode = 'v' })
  end,
}
