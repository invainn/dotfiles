-- local status, fugitive = pcall(require, 'fugitive')
-- if (not status) then return end
--
-- print('hello')
vim.keymap.set('n', '<Leader>gf', vim.cmd.Git)
