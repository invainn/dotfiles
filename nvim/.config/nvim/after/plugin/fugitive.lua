vim.keymap.set('n', '<Leader>gs', vim.cmd.Git)

local fugitive = vim.api.nvim_create_augroup('fg-group', {})

local autocmd = vim.api.nvim_create_autocmd
autocmd('BufWinEnter', {
  group = fugitive,
  pattern = "*",
  callback = function()
    if vim.bo.ft ~= 'fugitive' then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set('n', '<Leader>P', function()
      vim.cmd.Git('push')
    end, opts)

    vim.keymap.set('n', '<Leader>F', function()
      vim.cmd.Git('push --force')
    end, opts)

    vim.keymap.set('n', '<Leader>p', function()
      vim.cmd.Git('pull')
    end, opts)
  end
})
