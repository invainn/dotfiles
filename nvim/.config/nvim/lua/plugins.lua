vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- packer
    use 'wbthomason/packer.nvim'

    -- huh
    use 'nvim-lua/plenary.nvim'

    -- colorschemes
    -- use 'folke/tokyonight.nvim'
    use { 'catppuccin/nvim', as = 'catppuccin' }

    -- formatter
    use 'sbdchd/neoformat'
    use 'tpope/vim-commentary'

    -- telescope
    use { 'nvim-telescope/telescope.nvim', tag = '0.1.0' }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- treesitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    -- debugger
    use 'mfussenegger/nvim-dap'
    use { 'rcarriga/nvim-dap-ui', requires = {'mfussenegger/nvim-dap'} }
    use 'theHamsta/nvim-dap-virtual-text'
    use 'leoluz/nvim-dap-go'
    use 'mfussenegger/nvim-dap-python'

    -- testing
    use {
        "nvim-neotest/neotest",
        requires = {
          "nvim-lua/plenary.nvim",
          "nvim-treesitter/nvim-treesitter",
          "antoinemadec/FixCursorHold.nvim",
          "nvim-neotest/neotest-go",
          "nvim-neotest/neotest-python",
        }
    }

    -- lsp-zero
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
             -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }
end)