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
vim.keymap.set('n', '<leader>bn', '<Cmd>bn<CR>', { desc = 'buffer [n]ext' })
vim.keymap.set('n', '<leader>bp', '<Cmd>bp<CR>', { desc = 'buffer [p]revious' })

-- [[ Remaps from bautistaaa ]]
vim.keymap.set('n', '<leader>x', '<Cmd>bd<CR>', { desc = '[x] close current buffer' })
vim.keymap.set('n', '<leader>xx', '<Cmd>%bd<CR>', { desc = '[xx] close all buffers' })

-- [[ Remaps from ThePrimeagen ]]
-- See: https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/remap.lua

-- greatest remap ever
vim.keymap.set('x', '<leader>p', [['_dP]])
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ 'n', 'v' }, '<leader>y', [['+y]], { desc = '[y]ank line' })
vim.keymap.set('n', '<leader>Y', [['+Y]], { desc = '[Y]ank line' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', [['_d]], { desc = '[d]elete line' })
vim.keymap.set('i', '<C-c>', '<Esc>', { desc = '[C-c] escape' })
