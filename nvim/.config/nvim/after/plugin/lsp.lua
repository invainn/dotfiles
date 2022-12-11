local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.setup()

local comment = require('Comment')
comment.setup()
