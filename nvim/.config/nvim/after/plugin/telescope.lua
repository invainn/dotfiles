local status, telescope = pcall(require, 'telescope')
if (not status) then return end

local sorters = require('telescope.sorters')
local previewers = require('telescope.previewers')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

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
    file_sorter = sorters.get_fuzzy_file,
    file_ignore_patterns = { "node_modules" },
    generic_sorter = sorters.get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = previewers.buffer_previewer_maker,
    mappings = {
      n = { ["q"] = actions.close },
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
}

telescope.setup(options)

vim.keymap.set('n', '<Leader>ps', builtin.live_grep)
vim.keymap.set('n', '<Leader>pk', builtin.keymaps)
vim.keymap.set('n', '<Leader>pg', builtin.git_files)
vim.keymap.set('n', '<Leader>ph', builtin.help_tags)
vim.keymap.set(
  'n',
  '<Leader>pf',
  function()
    builtin.find_files { find_command = { "rg", "--files", "--hidden", "-g", "!.git" } }
  end
)

local home = os.getenv('HOME')
vim.keymap.set(
  'n',
  '<Leader>pd',
  function()
    builtin.find_files { find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
      search_dirs = { home .. "/.dotfiles" } }
  end
)

telescope.load_extension('fzf')
