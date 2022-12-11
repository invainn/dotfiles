vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- packer
  use 'wbthomason/packer.nvim'

  -- dashboard
  use 'goolord/alpha-nvim'

  -- huh
  use 'nvim-lua/plenary.nvim'

  -- indent blankline
  use 'lukas-reineke/indent-blankline.nvim'

  -- colorschemes
  -- use 'folke/tokyonight.nvim'
  use { 'invainn/catppuccin-nvim', as = 'catppuccin' }

  -- harpoon
  use 'ThePrimeagen/harpoon'

  -- tmux
  use {
    'numToStr/Navigator.nvim',
    config = function()
      -- This stuff is here because LSP zero will take C-k if it isn't binded
      -- Configuration
      require('Navigator').setup()

      -- Keybindings
      vim.keymap.set('n', "<C-h>", '<CMD>NavigatorLeft<CR>')
      vim.keymap.set('n', "<C-l>", '<CMD>NavigatorRight<CR>')
      vim.keymap.set('n', "<C-k>", '<CMD>NavigatorUp<CR>')
      vim.keymap.set('n', "<C-j>", '<CMD>NavigatorDown<CR>')
    end
  }

  -- surround
  use 'tpope/vim-surround'

  -- formatter
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'windwp/nvim-autopairs'
  use 'numToStr/Comment.nvim'
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  -- tree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
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
    requires = {
      'cljoly/telescope-repo.nvim',
      'airblade/vim-rooter',
    },
    config = function()
      vim.g.rooter_cd_cmd = 'lcd'
    end
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
end)
