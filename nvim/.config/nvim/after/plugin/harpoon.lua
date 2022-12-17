local status, harpoon = pcall(require, 'harpoon')
if (not status) then return end

local options = {
  --sets the marks upon calling `toggle` on the ui, instead of require `:w`.
  save_on_toggle = false,

  -- saves the harpoon file upon every change. disabling is unrecommended.
  save_on_change = true,

  -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
  enter_on_sendcmd = false,

  -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
  tmux_autoclose_windows = false,

  -- filetypes that you want to prevent from adding to the harpoon list menu.
  excluded_filetypes = { "harpoon" },

  -- set marks specific to each git branch inside git repository
  mark_branch = false,
}

harpoon.setup(options)

local ui = require('harpoon.ui')
local mark = require('harpoon.mark')

vim.keymap.set('n', '<Leader>hp', ui.toggle_quick_menu)
vim.keymap.set('n', '<Leader>hg', mark.add_file)

vim.keymap.set('n', '<Leader>hf', function()
  ui.nav_file(1)
end)
vim.keymap.set('n', '<Leader>hd', function()
  ui.nav_file(2)
end)
vim.keymap.set('n', '<Leader>hs', function()
  ui.nav_file(3)
end)
vim.keymap.set('n', '<Leader>ha', function()
  ui.nav_file(4)
end)
