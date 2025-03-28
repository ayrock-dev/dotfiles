return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  opts = function()
    local icons = require('ayrock/icons')

    local trouble = require('trouble')
    local trouble_symbols = trouble.statusline
        and trouble.statusline({
          mode = 'symbols',
          groups = {},
          title = false,
          filter = { range = true },
          format = '{kind_icon}{symbol.name:Normal}',
          hl_group = 'lualine_c_normal',
        })

    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        globalstatus = true,
        disabled_filetypes = { statusline = { 'snacks_dashboard' } },
        theme = 'auto',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {
          {
            'filename',
            symbols = {
              modified = '',
              readonly = '',
              unnamed = '',
              newfile = '[New]',
            },
          },
          {
            'diagnostics',
            symbols = {
              error = icons.diagnostics.error,
              warn = icons.diagnostics.warn,
              info = icons.diagnostics.info,
              hint = icons.diagnostics.hint,
            },
          },
          {
            trouble_symbols and trouble_symbols.get,
            cond = trouble_symbols and trouble_symbols.has,
          },
        },
        lualine_x = {
          {
            'diff',
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          {
            function()
              if not package.loaded['supermaven-nvim.api'] then
                return 'Supermaven not loaded.'
              end
              local api = require('supermaven-nvim.api')
              return api.is_running() and '󰘧 ' or '󰘧 '
            end,
          },
        },
        lualine_y = {
          'encoding',
          'filetype',
        },
        lualine_z = {
          { 'progress', separator = ' ',                  padding = { left = 1, right = 0 } },
          { 'location', padding = { left = 0, right = 1 } },
        },
      },
    }

    return opts
  end,
}
