return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  opts = function()
    local icons = require('ayrock/icons')

    vim.o.laststatus = vim.g.lualine_laststatus

    local theme = {
      normal = {
        a = { fg = vim.g.terminal_color_0, bg = vim.g.terminal_color_6, gui = 'bold' },
        b = { fg = vim.g.terminal_color_0, bg = vim.g.terminal_color_5, gui = 'bold' },
        c = { fg = vim.g.termina_color_7, bg = vim.g.terminal_color_0 },
      },
      insert = { a = { fg = vim.g.terminal_color_0, bg = vim.g.terminal_color_3, gui = 'bold' } },
      visual = { a = { fg = vim.g.terminal_color_0, bg = vim.g.terminal_color_3, gui = 'bold' } },
      replace = { a = { fg = vim.g.terminal_color_7, bg = vim.g.terminal_color_1, gui = 'bold' } },
    }

    local opts = {
      options = {
        globalstatus = true,
        disabled_filetypes = { statusline = { 'snacks_dashboard' } },
        theme = theme,
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
              return api.is_running() and 'Supermaven running.' or 'Supermaven stopped.'
            end,
          },
        },
        lualine_y = {
          'encoding',
          'filetype',
        },
        lualine_z = {
          { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
          { 'location', padding = { left = 0, right = 1 } },
        },
      },
    }

    local trouble = require('trouble')
    local symbols = trouble.statusline
      and trouble.statusline({
        mode = 'symbols',
        groups = {},
        title = false,
        filter = { range = true },
        format = '{kind_icon}{symbol.name:Normal}',
        hl_group = 'lualine_c_normal',
      })
    table.insert(opts.sections.lualine_c, {
      symbols and symbols.get,
      cond = symbols and symbols.has,
    })

    return opts
  end,
}
