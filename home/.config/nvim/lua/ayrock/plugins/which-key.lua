return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    spec = {
      -- leader groups
      { '<leader>c', group = '[c]ode' },
      { '<leader>d', group = '[d]ocument' },
      { '<leader>g', group = '[g]it' },
      { '<leader>h', group = 'git [h]unk' },
      { '<leader>r', group = '[r]ename' },
      { '<leader>s', group = '[s]earch' },
      { '<leader>t', group = '[t]oggle' },
      { '<leader>w', group = '[w]orkspace' },

      -- Built-in 0.11+ LSP defaults (annotated so they show up in which-key).
      -- These mappings are provided by Neovim core when an LSP is attached.
      { 'grn', desc = 'LSP: rename symbol' },
      { 'gra', desc = 'LSP: code action', mode = { 'n', 'x' } },
      { 'grr', desc = 'LSP: references' },
      { 'gri', desc = 'LSP: implementation' },
      { 'grt', desc = 'LSP: type definition' }, -- 0.12+
      { 'gO', desc = 'LSP: document symbols' },
      { 'K', desc = 'LSP: hover' },

      -- Built-in 0.11+ unimpaired-style navigation
      { ']d', desc = 'next diagnostic' },
      { '[d', desc = 'prev diagnostic' },
      { ']D', desc = 'last diagnostic in buffer' },
      { '[D', desc = 'first diagnostic in buffer' },
      { ']q', desc = 'next quickfix' },
      { '[q', desc = 'prev quickfix' },
      { ']l', desc = 'next location' },
      { '[l', desc = 'prev location' },
      { ']b', desc = 'next buffer' },
      { '[b', desc = 'prev buffer' },
    },
  },
}
