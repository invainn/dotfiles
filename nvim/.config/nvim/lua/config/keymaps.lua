-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")
local map = Util.safe_keymap_set

map("n", "<leader>wb", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>wr", "<C-W>v", { desc = "Split window right", remap = true })
