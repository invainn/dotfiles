local telescope = require('telescope')
local options = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      n = { ["q"] = require("telescope.actions").close },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    }
  },
  pickers = {
    find_files = {
      find_command = { 'rg', '--files', '--hidden', '-g', '!.git' }
    },
  },
}

telescope.setup(options)
telescope.load_extension "repo"

vim.keymap.set('n', '<Leader>ps', '<cmd>lua require("telescope.builtin").live_grep()<CR>')
vim.keymap.set('n', '<Leader>pk', '<cmd>lua require("telescope.builtin").keymaps()<CR>')
vim.keymap.set('n', '<Leader>pg', '<cmd>lua require("telescope.builtin").git_files()<CR>')
vim.keymap.set('n', '<Leader>pb', '<cmd>lua require("telescope.builtin").git_branches()<CR>')
vim.keymap.set('n', '<Leader>pt', '<cmd>lua require("telescope.builtin").git_stashes()<CR>')
vim.keymap.set('n', '<Leader>pf', '<cmd>lua require("telescope.builtin").find_files()<CR>')

local home = os.getenv('HOME')
vim.keymap.set('n', '<Leader>pr',
  '<cmd>lua require("telescope").extensions.repo.list()<CR>')

vim.keymap.set(
  'n',
  '<Leader>pd',
  ':lua require("telescope.builtin").find_files({find_command={"rg","--files","--hidden","-g","!.git"},search_dirs={"' ..
  home .. '/.dotfiles"}})<CR>'
)


require('telescope').load_extension('fzf')
