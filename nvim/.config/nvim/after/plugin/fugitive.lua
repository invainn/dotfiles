vim.keymap.set('n', '<Leader>gs', vim.cmd.Git)
vim.keymap.set('n', '<Leader>gP', function()
  vim.cmd.Git('push')
end)
