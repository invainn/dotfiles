require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    }
  }
}

vim.keymap.set('n', '<Leader>ps',
  ':lua require("telescope.builtin").grep_string({ search = vim.fn.input("Grep For >> ")})<CR>')
vim.keymap.set('n', '<Leader>pg', ':lua require("telescope.builtin").git_files()<CR>')
vim.keymap.set('n', '<Leader>pb', ':lua require("telescope.builtin").git_branches()<CR>')
vim.keymap.set('n', '<Leader>pt', ':lua require("telescope.builtin").git_stashes()<CR>')
vim.keymap.set('n', '<Leader>pf', ':lua require("telescope.builtin").find_files()<CR>')

require('telescope').load_extension('fzf')
