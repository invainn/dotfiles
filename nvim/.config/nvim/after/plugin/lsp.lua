local status, lsp = pcall(require, 'lsp-zero')
if (not status) then return end

lsp.preset('recommended')
lsp.nvim_workspace()
lsp.setup()

local comment = require('Comment')
comment.setup()

vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename)
