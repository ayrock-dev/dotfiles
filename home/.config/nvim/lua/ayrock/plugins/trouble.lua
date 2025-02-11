return {
  'folke/trouble.nvim', -- v3
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {},
  cmd = 'Trouble',
  keys = {
    {
      '<leader>tt',
      function()
        require('trouble').toggle('diagnostics')
      end,
      desc = '[T]oggle [T]rouble',
    },
    {
      '[d',
      function()
        require('trouble').open()
        require('trouble').prev({ skip_groups = true, jump = true })
      end,
      desc = 'Previous Trouble ([d]iagnostic)',
    },
    {
      ']d',
      function()
        require('trouble').open()
        require('trouble').next({ skip_groups = true, jump = true })
      end,
      desc = 'Next Trouble ([d]iagnostic)',
    },
  },
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
