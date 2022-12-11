local status, lsp = pcall(require, 'lsp-zero')
if (not status) then return end

lsp.preset('recommended')
lsp.setup()

local comment = require('Comment')
comment.setup()
