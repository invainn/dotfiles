-- Keymaps are automatically loaded on the VeryLazy event
-- Add any additional keymaps here

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Don't yank with x
vim.keymap.set("n", "x", '"_x')

vim.keymap.set("n", "+", "<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement number" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })

vim.keymap.set("n", "Q", "<nop>")
