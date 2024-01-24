-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Remaps from ThePrimeagen ]]
-- See: https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/remap.lua

-- greatest remap ever
vim.keymap.set('x', '<leader>p', [['_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({'n', 'v'}, '<leader>y', [['+y]])
vim.keymap.set('n', '<leader>Y', [['+Y]])

vim.keymap.set({'n', 'v'}, '<leader>d', [['_d]])

vim.keymap.set('i', '<C-c>', '<Esc>')