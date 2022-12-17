local status, dap = pcall(require, 'dap')
if (not status) then return end

local dapgo, dappython = require('dap-go'), require('dap-python')
local dapui = require('dapui')

dapgo.setup()
dappython.setup('~/.virtualenvs/debugpy/bin/python')
dappython.test_runner = 'pytest'

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

vim.keymap.set('n', '<Leader>dc', dap.continue)
vim.keymap.set('n', '<Leader>sr', dap.step_over)
vim.keymap.set('n', '<Leader>si', dap.step_into)
vim.keymap.set('n', '<Leader>so', dap.step_out)
vim.keymap.set('n', '<Leader>tb', dap.toggle_breakpoint)
