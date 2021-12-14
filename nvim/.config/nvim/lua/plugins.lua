-- NB - :luafile $MYVIMRC doesn't work for some reason.
-- Needs to reopen nvim so that changes will take an effect.
return {
    -- Packer can manage itself as an optional plugin
    { 'wbthomason/packer.nvim' },

    -- LSP actions & formatter
    { 'jose-elias-alvarez/null-ls.nvim' },

    -- LSP autocompletion
    {
      'hrsh7th/nvim-cmp',
      config = [[require 'plugin.cmp']],
      requires = {
        -- snippets sourses
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'rafamadriz/friendly-snippets',

        -- other sources
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-calc',
        'hrsh7th/cmp-nvim-lua',
      },
    },

    -- Navigation
    {
      'nvim-telescope/telescope.nvim',
      config = [[require 'plugin.telescope']],
    },
    {
      'kyazdani42/nvim-tree.lua',
      config = [[require 'plugin.nvim-tree']],
    },

    -- Whichkey
    {
      'folke/which-key.nvim',
      config = [[require 'plugin.which-key']],
      event = 'BufWinEnter',
    },

    -- Autopairs
    {
      'windwp/nvim-autopairs',
      -- event = 'InsertEnter',
      -- after = 'nvim-cmp',
      config = [[require 'plugin.autopairs']],
    },

    -- Treesitter / NB: remove after neovim 0.6 release
    {
      'nvim-treesitter/nvim-treesitter',
      branch = '0.5-compat',
      config = [[require 'plugin.treesitter']],
    },


    -- Version Control
    {
      'lewis6991/gitsigns.nvim',
      config = [[require 'plugin.gitsigns']],
      event = 'BufRead',
    },

    -- Comments
    {
      'numToStr/Comment.nvim',
      event = 'BufRead',
      config = [[require 'plugin.comment']],
    },

    -- project.nvim
    {
      'ahmedkhalf/project.nvim',
      config = [[require 'plugin.project']],
    },

    -- Status Line and Bufferline
    {
      'nvim-lualine/lualine.nvim',
      config = [[require 'plugin.lualine']],
    },
    {
      'romgrk/barbar.nvim',
      -- config = [[require 'plugin.bufferline']],
      event = 'BufWinEnter',
    },

    -- TODO Debugging
    {
      'mfussenegger/nvim-dap',
      -- event = 'BufWinEnter',
      config = [[require 'plugin.dap']],
    },
    { 'theHamsta/nvim-dap-virtual-text' },
    { 'Pocco81/DAPInstall.nvim' },

    -- Dashboard
    {
        'ChristianChiarulli/dashboard-nvim',
        event = 'BufWinEnter',
        config = [[require 'plugin.dashboard']],
    },

    -- Terminal
    {
        'akinsho/toggleterm.nvim',
        event = 'BufWinEnter',
        config = [[require 'plugin.terminal']],
    },

    -- Make % match flow control keywords (if-else etc.)
    { 'andymass/vim-matchup' },

    -- Highlight colors hex codes with corresponding ones
    { 'norcalli/nvim-colorizer.lua' },

    -- TODO Test runner helper
    {
        'rcarriga/vim-ultest',
        requires = { 'vim-test/vim-test' },
        run = ':UpdateRemotePlugins',
    },

    -- Disctraction free
    {
        'Pocco81/TrueZen.nvim',
        config = [[require 'plugin.zen']],
    },
    { 'folke/twilight.nvim' },

    -- Dependencies for more than one plugin
    { 'neovim/nvim-lspconfig' },  -- Autoconfigure LSP client \ dependency
    { 'nvim-lua/plenary.nvim' },  -- utils like tests and dependecy for other plugins
    { 'nvim-lua/popup.nvim' },  -- dependecy for null-ls?
    { 'kyazdani42/nvim-web-devicons' },  -- Icons for other plugins

    -- Themes and aesthetics
    { 'Pocco81/Catppuccino.nvim' },
    { 'dracula/vim' },
    { 'marko-cerovac/material.nvim' },
    { 'bignimbus/pop-punk.vim', disable = true },


    -- Maybe later
    -- { 'romgrk/nvim-treesitter-context' },
    -- { 'TimUntersberger/neogit' },

    -- Smooth scroll
    { 'karb94/neoscroll.nvim', config = [[require 'neoscroll'.setup()]], disable = true },
}
