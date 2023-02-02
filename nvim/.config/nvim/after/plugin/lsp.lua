local lsp_status, lsp = pcall(require, 'lsp-zero')
if (not lsp_status) then return end

lsp.preset('recommended')
lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<Tab>'] = vim.NIL,
  ['<S-Tab>'] = vim.NIL,
  ['<CR>'] = vim.NIL,
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  completion = {
    get_trigger_characters = function(trigger_characters)
      local new_trigger_characters = {}
      for _, char in ipairs(trigger_characters) do
        if char ~= '>' then
          table.insert(new_trigger_characters, char)
        end
      end
      return new_trigger_characters
    end
  },
})

lsp.configure('tsserver', {
  single_file_support = false,
  root_dir = require('lspconfig.util').root_pattern('package.json'),
})

lsp.configure('denols', {
  single_file_support = false,
  root_dir = require('lspconfig.util').root_pattern('deno.json', 'deno.jsonc'),
})

lsp.setup()

local comment = require('Comment')
comment.setup {
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}

vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename)
