-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
require('ayrock.globals')

require('ayrock.keymaps')
require('ayrock.opts')
require('ayrock.highlight-on-yank')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim' 
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('tokyonight')
    end,
  },

  require 'kickstart.plugins.autoformat',
  require 'kickstart.plugins.debug',

  { import = 'ayrock.plugins' },
}, {})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
