return {
  {
    'echasnovski/mini.files',
    version = '*',
    opts = {},
    config = function()
      local MiniFiles = require('mini.files')

      local function toggle_minifiles()
        if not MiniFiles.close() then
          MiniFiles.open()
        end
      end

      local function toggle_minifiles_current()
        local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        vim.schedule(function()
          MiniFiles.reveal_cwd()
        end)
      end

      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { desc = desc })
      end

      map('-', toggle_minifiles_current, '[-] Explore')
      map('<leader>-', toggle_minifiles_current, '[-] Explore')
      map('<leader>E', toggle_minifiles, '[E]xplore')

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(ev)
          vim.schedule(function()
            vim.api.nvim_set_option_value('buftype', 'acwrite', { buf = 0 })
            vim.api.nvim_buf_set_name(0, tostring(vim.api.nvim_get_current_win()))
            vim.api.nvim_create_autocmd('BufWriteCmd', {
              buffer = ev.data.buf_id,
              callback = function()
                require('mini.files').synchronize()
              end,
            })
          end)
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionRename',
        callback = function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })
    end,
  },
}
