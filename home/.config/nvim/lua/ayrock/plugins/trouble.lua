return {
  'folke/trouble.nvim', -- v3
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    {
      '<leader>tt',
      function()
        require('trouble').toggle('diagnostics')
      end,
      desc = '[t]oggle [t]rouble',
    },
    {
      '[d',
      function()
        require('trouble').open()
        require('trouble').prev({ skip_groups = true, jump = true })
      end,
      desc = 'previous [d]iagnostic',
    },
    {
      ']d',
      function()
        require('trouble').open()
        require('trouble').next({ skip_groups = true, jump = true })
      end,
      desc = 'next [d]iagnostic',
    },
  },
  config = function(_, opts)
    vim.diagnostic.config({ virtual_text = true })
    require('trouble').setup(opts)
  end,
  specs = {
    'folke/snacks.nvim',
    opts = function(_, opts)
      return vim.tbl_deep_extend('force', opts or {}, {
        picker = {
          actions = require('trouble.sources.snacks').actions,
          win = {
            input = {
              keys = {
                ['<c-t>'] = {
                  'trouble_open',
                  mode = { 'n', 'i' },
                },
              },
            },
          },
        },
      })
    end,
  },
}
