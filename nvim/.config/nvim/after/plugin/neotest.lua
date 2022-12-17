local status, neotest = pcall(require, 'neotest')
if (not status) then return end

neotest.setup({
  adapters = {
    require("neotest-go"),
    require("neotest-python"),
    require("neotest-jest"),
  },
})

vim.keymap.set('n', '<Leader>tn', neotest.run.run)
vim.keymap.set('n', '<Leader>tf', function()
  neotest.run.run(vim.fn.expand("%"))
end)

vim.keymap.set('n', '<Leader>dt', function()
  neotest.run.run({ strategy = "dap" })
end)
