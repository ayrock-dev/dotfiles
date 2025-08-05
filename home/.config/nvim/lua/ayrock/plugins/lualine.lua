return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  opts = function()
    local icons = require('ayrock/icons')

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
            file_status = true, -- Displays file status (readonly status, modified status)
            newfile_status = false,
            -- 0: Just the filename
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory
            path = 1, -- 1: Relative path
            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            symbols = {
              modified = '[+]', -- Text to show when the file is modified.
              readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
              unnamed = '[No Name]', -- Text to show for unnamed buffers.
              newfile = '[New]', -- Text to show for newly created file before first write
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
              return api.is_running() and '󰘧 ' or '󰘧 '
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

    return opts
  end,
}
