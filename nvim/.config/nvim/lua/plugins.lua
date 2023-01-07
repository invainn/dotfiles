local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer = require('packer')
local packer_bootstrap = ensure_packer()

return packer.startup(function(use)
  -- packer
  use 'wbthomason/packer.nvim'

  -- dashboard
  use 'goolord/alpha-nvim'

  -- huh
  use 'nvim-lua/plenary.nvim'

  -- undotree
  use 'mbbill/undotree'

  -- indent blankline
  use 'lukas-reineke/indent-blankline.nvim'

  -- colorschemes
  -- use 'folke/tokyonight.nvim'
  use { 'invainn/catppuccin-nvim', as = 'catppuccin' }

  -- harpoon
  use 'ThePrimeagen/harpoon'

  -- git stuff
  use 'tpope/vim-fugitive'
  use 'lewis6991/gitsigns.nvim'

  -- tmux
  use {
    'numToStr/Navigator.nvim',
    config = function()
      -- This stuff is here because LSP zero will take C-k if it isn't binded
      -- Configuration
      require('Navigator').setup()

      -- Keybindings
      vim.keymap.set('n', "<C-h>", vim.cmd.NavigatorLeft)
      vim.keymap.set('n', "<C-l>", vim.cmd.NavigatorRight)
      vim.keymap.set('n', "<C-k>", vim.cmd.NavigatorUp)
      vim.keymap.set('n', "<C-j>", vim.cmd.NavigatorDown)
    end
  }

  -- surround
  use 'tpope/vim-surround'

  -- formatter
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'windwp/nvim-autopairs'
  use 'invainn/nvim-ts-autotag'
  use 'numToStr/Comment.nvim'
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  -- tree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
  }

  -- lualine
  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      'nvim-tree/nvim-web-devicons',
      opt = true,
    },
  }

  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
  }

  -- treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- debugger
  use 'mfussenegger/nvim-dap'
  use { 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap' } }
  use 'theHamsta/nvim-dap-virtual-text'
  use 'leoluz/nvim-dap-go'
  use 'mfussenegger/nvim-dap-python'

  -- testing
  use {
    'nvim-neotest/neotest',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-neotest/neotest-go',
      'nvim-neotest/neotest-python',
      'haydenmeade/neotest-jest',
    }
  }

  -- lsp-zero
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  }

  if packer_bootstrap then
    packer.sync()
  end
end)
