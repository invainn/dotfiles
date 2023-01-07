local status, treesitter_config = pcall(require, 'nvim-treesitter.configs')
if (not status) then return end

treesitter_config.setup {
  autotag = {
    enable = true,
  },

  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },

  sync_install = false,
  auto_install = true,

  ensure_installed = {
    "tsx",
    "toml",
    "json",
    "yaml",
    "css",
    "html",
    "lua"
  },

  indent = {
    enable = true,
    disable = {}
  },

  highlight = {
    enable = true,
    disable = {},
  },
}
