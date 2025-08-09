-- Highlight when yanking (copying) text
-- See `:help vim.hl.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = highlight_group,
  callback = function()
    vim.hl.on_yank()
  end,
})
