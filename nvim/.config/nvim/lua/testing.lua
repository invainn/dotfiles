require("neotest").setup({
  adapters = {
    require("neotest-go"),
    require("neotest-python"),
  },
})

vim.keymap.set('n', '<Leader>tn', ':lua require("neotest").run.run()<CR>')
vim.keymap.set('n', '<Leader>tf', ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>')
vim.keymap.set('n', '<Leader>dt', ':lua require("neotest").run.run({ strategy = "dap" })<CR>')
