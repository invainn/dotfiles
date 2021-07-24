vim.g.neoformat_enabled_python = {'black'}

vim.keymap.set('n', '<Leader>nf', ':Neoformat<CR>')

-- local fmt = vim.api.nvim_create_augroup('fmt', { clear = true })
-- vim.api.nvim_create_autocmd('BufWritePre', {
  -- command = 'try | undojoin | Neoformat | catch /E790/ | Neoformat | endtry',
  --group = fmt,
--})
