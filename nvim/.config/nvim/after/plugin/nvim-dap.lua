local status, dap = pcall(require, 'dap')
if (not status) then return end

local dapgo, dappython = require('dap-go'), require('dap-python')
local dapui = require('dapui')

dapgo.setup()
dappython.setup('~/.virtualenvs/debugpy/bin/python')
dappython.test_runner = 'pytest'

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.keymap.set('n', '<Leader>dc', ':lua require("dap").continue()<CR>')
vim.keymap.set('n', '<Leader>sr', ':lua require("dap").step_over()<CR>')
vim.keymap.set('n', '<Leader>si', ':lua require("dap").step_into()<CR>')
vim.keymap.set('n', '<Leader>so', ':lua require("dap").step_out()<CR>')
vim.keymap.set('n', '<Leader>tb', ':lua require("dap").toggle_breakpoint()<CR>')
