local indent = require('indent_blankline')

vim.opt.list = true
vim.opt.listchars:append "eol:↴"

local options = {
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = false,
}

indent.setup(options)
