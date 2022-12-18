vim.keymap.set('n', '<Leader>vsp', '<C-w>v')
vim.keymap.set('n', '<Leader>sp', '<C-w>s')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set('n', '<Leader>b', '<C-o>')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Don't yank with x
vim.keymap.set('n', 'x', '"_x')

vim.keymap.set('n', '+', '<C-a>')
vim.keymap.set('n', '-', '<C-x>')

-- to the clipboard! but not on windows
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- what is this even
vim.keymap.set("n", "Q", "<nop>")
