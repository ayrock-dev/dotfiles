return {
  {
    'echasnovski/mini.files',
    version = '*',
    opts = {},
    config = function()
      local function toggle_minifiles()
        local MiniFiles = require('mini.files')
        if not MiniFiles.close() then
          MiniFiles.open()
        end
      end

      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { desc = desc })
      end

      map('-', toggle_minifiles, '[-] Explore')
      map('<leader>-', toggle_minifiles, '[-] Explore')
      map('<leader>E', toggle_minifiles, '[E]xplore')
    end,
  },
}
