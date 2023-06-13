-- NB - :luafile $MYVIMRC doesn't work for some reason.
-- Needs to reopen nvim so that changes will take an effect.
return {
    -- Packer can manage itself as an optional plugin
    { 'wbthomason/packer.nvim' },


    -- {
    --     'codota/tabnine-nvim',
    --     run = "./dl_binaries.sh",
    --     config = [[
    --         require('tabnine').setup({
    --           disable_auto_comment=true,
    --           accept_keymap="<Tab>",
    --           dismiss_keymap = "<C-]>",
    --           debounce_ms = 800,
    --           suggestion_color = {gui = "#808080", cterm = 244},
    --           exclude_filetypes = {"TelescopePrompt"},
    --           log_file_path = nil, -- absolute path to Tabnine log file
    --         })
    --     ]],
    -- },

    -- LSP actions & formatter
    { 'jose-elias-alvarez/null-ls.nvim', requires = { 'nvim-lua/popup.nvim' } },

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

    -- lsp-server installer
    {
        'williamboman/mason.nvim' ,
        config = [[require 'plugin.mason']],
    },
    {
        'williamboman/mason-lspconfig.nvim',
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

    -- Treesitter
    {
      'nvim-treesitter/nvim-treesitter',
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
        disable = true,
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

    -- Disctraction free
    {
        'Pocco81/true-zen.nvim',
        config = [[require 'plugin.zen']],
    },
    { 'folke/twilight.nvim' },

    -- Dependencies for more than one plugin
    { 'neovim/nvim-lspconfig' },  -- Autoconfigure LSP client \ dependency
    { 'nvim-lua/plenary.nvim' },  -- utils like tests and dependecy for other plugins

    -- Icons for other plugins
    { 'kyazdani42/nvim-web-devicons' },
    { 'ChristianChiarulli/neovim-codicons' },

    -- Themes and aesthetics
    { 'Pocco81/Catppuccino.nvim', disable = true },
    { 'folke/tokyonight.nvim' },
    { 'dracula/vim' },
    { 'bignimbus/pop-punk.vim' },


    { 'romgrk/nvim-treesitter-context' },

    -- Maybe later
    -- { 'TimUntersberger/neogit' },

    -- Smooth scroll
    { 'karb94/neoscroll.nvim', config = [[require 'neoscroll'.setup()]], disable = true },

    -- JavaScript syntax highlighting
    { 'mxw/vim-jsx' },
    { 'pangloss/vim-javascript' },

    -- zettelkasten
    {
        'renerocksai/telekasten.nvim',
        config = [[require 'plugin.telekasten']],
    },

    {
        'ColinKennedy/toggle-lsp-diagnostics.nvim',
        config = [[require'toggle_lsp_diagnostics'.init({ underline = false, virtual_text = { prefix = "XXX", spacing = 5 }})]]
    },
    { 'michaeljsmith/vim-indent-object' },


    { 'ledger/vim-ledger' },
    {
        'iamcco/markdown-preview.nvim',
        run = function() vim.fn['mkdp#util#install']() end,
    },
    { 'vim-scripts/AnsiEsc.vim' },

    { 'mracos/mermaid.vim' },
}
