local status, lualine = pcall(require, 'lualine')
if (not status) then return end

local options = {
  icons_enabled = true,
  theme = 'catppuccin',
  component_separators = '|',
  section_separators = { left = '', right = '' },
  disabled_filetypes = {
    statusline = {},
    winbar = {},
  },
  ignore_focus = {},
  always_divide_middle = true,
  globalstatus = false,
  refresh = {
    statusline = 1000,
    tabline = 1000,
    winbar = 1000,
  }
}

local sections = {
  lualine_a = { 'mode' },
  lualine_b = { 'branch', 'diagnostics' },
  lualine_c = { 'filename' },
  lualine_x = { 'location' },
  lualine_y = { 'encoding', 'fileformat', 'filetype' },
  lualine_z = {},
}

local inactive_sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = { 'filename' },
  lualine_x = {},
  lualine_y = {},
  lualine_z = {},
}

lualine.setup {
  options = options,
  sections = sections,
  inactive_sections = inactive_sections,
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}
