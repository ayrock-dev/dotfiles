vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- disable arrow keys
vim.keymap.set({ 'n', 'i' }, '<up>', '<Nop>')
vim.keymap.set({ 'n', 'i' }, '<down>', '<Nop>')
vim.keymap.set({ 'n', 'i' }, '<left>', '<Nop>')
vim.keymap.set({ 'n', 'i' }, '<right>', '<Nop>')

-- dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- buffers
vim.keymap.set('n', '<leader>bn', '<Cmd>bn<CR>', { desc = 'buffer next' })
vim.keymap.set('n', '<leader>bp', '<Cmd>bp<CR>', { desc = 'buffer previous' })

-- [[ Remaps from bautistaaa ]]
vim.keymap.set('n', '<leader>x', '<Cmd>bd<CR>', { desc = 'close current buffer' })
vim.keymap.set('n', '<leader>xx', '<Cmd>%bd<CR>', { desc = 'close all buffers' })

-- [[ Remaps from ThePrimeagen ]]
-- See: https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/remap.lua

-- greatest remap ever
vim.keymap.set('x', '<leader>p', [['_dP]])
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ 'n', 'v' }, '<leader>y', [['+y]], { desc = 'yank line' })
vim.keymap.set('n', '<leader>Y', [['+Y]], { desc = 'yank line' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', [['_d]], { desc = 'delete line' })
vim.keymap.set('i', '<C-c>', '<Esc>', { desc = 'escape' })

vim.keymap.set('v', 'L', '$<left>', { desc = 'Move to end of line in visual mode' })
vim.keymap.set('v', 'H', '^', { desc = 'Move to beginning of line in visual mode' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selected block down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selected block up' })

vim.keymap.set('x', '<<', function()
  vim.cmd('normal! <<')
  vim.cmd('normal! gv')
end, { desc = 'Indent left and reselect visual block' })

vim.keymap.set('x', '>>', function()
  vim.cmd('normal! >>')
  vim.cmd('normal! gv')
end, { desc = 'Indent right and reselect visual block' })
