local map = vim.keymap.set
vim.g.mapleader = ' '

map({ 'i', 'c' }, '<C-d>', '<BS>', { desc = 'Delete in insert mode', remap = true })
map('n', '<leader>qq', ':qa<CR>', { desc = 'Quit', remap = true })
map({ 'n', 'i' }, '<C-s>', ':w<CR>', { desc = 'Save', remap = true })
map({ 'n', 'i' }, '<A-s>', ':wa<CR>', { desc = 'Save all', remap = true })
map('n', '<leader>wq', ':wq<CR>', { desc = 'Save and Quit', noremap = true, silent = true })
map({ 'n', 'i' }, '<leader>tt', ':Run<CR>', { desc = 'Execute current file', noremap = true, silent = true })
map('n', '<C-x>', ':Run<CR>', { desc = 'Run the file', noremap = true, silent = true })
