local status, catppuccin = pcall(require, "catppuccin")
if (not status) then return end

catppuccin.setup({
  flavour = "frappe",
  term_colors = false,
  integrations = {
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
    },
    dashboard = true,
    harpoon = true,
    neotest = true,
    cmp = true,
    telescope = true,
    dap = {
      enabled = true,
      enable_ui = true,
    },
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
    treesitter = true,
    nvimtree = true,
    markdown = true,
  },
})

vim.opt.termguicolors = true
-- Load the colorscheme
vim.cmd.colorscheme "catppuccin"
