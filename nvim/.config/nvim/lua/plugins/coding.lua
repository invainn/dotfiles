return {
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      {
        "<leader>rn",
        ":IncRename ",
        desc = "Rename Symbol",
      },
    },
    config = true,
  },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "none",
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-Space>"] = { "show" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
      completion = {
        list = {
          selection = { preselect = false, auto_insert = false },
        },
      },
    },
  },
}
