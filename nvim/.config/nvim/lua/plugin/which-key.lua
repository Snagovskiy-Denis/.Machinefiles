-- Contains leader key mappings

local setup = {
    plugins = {
        spelling = { enabled = true },
        presets = {
            operators = true,
            motions = true,
            text_objects = true,
        },
    },
    window = { border = 'single' },
}

local opts = {
    mode = 'n',
    prefix = '<leader>',
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
}

local vopts = {
    mode = 'v',
    prefix = '<leader>',
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
}

local vmappings = {
    ['/'] = { '<esc><cmd>lua require ("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', 'Comment' },
}

local mappings = {
    ['/'] = { '<cmd>lua require("Comment.api").toggle_current_linewise()<CR>', 'Comment' },
    ['f'] = { '<cmd>Telescope find_files<CR>', 'Find File' },
    ['h'] = { '<cmd>:set hlsearch!<CR>', 'Toggle highlight' },
    ['S'] = { '<cmd>:set spell!<CR>', 'Toggle Spell checking' },
    ['t'] = { '<cmd>new term://bash<CR>', 'Open Terminal' },
    ['e'] = { '<cmd>NvimTreeToggle<CR>', 'Explore' },
    ['x'] = { '<cmd>TZAtaraxis<CR>', 'Dzen mode' },
    -- ['x'] = { '<cmd>TZAtaraxis<CR>', 'Toggle fading' },
    l = {
        name = 'LSP',

        I = { '<cmd>LspInstallInfo<CR>', 'Info' },
        K = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Help pop-up' },
        d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Definitoin' },
        D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Declaration' },
        i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Implementation' },
        a = { "<cmd>lua require('lvim.core.telescope').code_actions()<cr>", 'Code Action' },
        r = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename' },
        f = { '<cmd>lua vim.lsp.buf.formatting()<CR>', 'Format' },

        s = { '<cmd>Telescope lsp_document_symbols<CR>', 'Document Symbols' },
        S = { '<cmd>Telescope lsp_workspace_symbols<CR>', 'Workspace Symbols' },

        -- Diagnostics
        j = { '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', 'Next Diagnostics' },
        k = { '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', 'Previous Diagnostics' },
        w = { '<cmd>Telescope lsp_workspace_diagnostics<CR>', 'Workspace Diagnostics' },
        l = { '<cmd>Telescope diagnostics<CR>', 'Document Diagnostics' },
    },
    s = {
        name = 'Search',
        f = { '<cmd>Telescope find_files<CR>', 'Find File' },
        -- e = { '<cmd>Telescope file_browser<CR>', 'Browse files' },
        t = { '<cmd>Telescope live_grep<CR>', 'Text' },
        b = { '<cmd>Telescope buffers<CR>', 'Buffers' },
        h = { '<cmd>Telescope help_tags<CR>', 'Find Help' },
        R = { '<cmd>Telescope registers<CR>', 'Registers' },
        c = { '<cmd>Telescope colorscheme<CR>', 'Colorscheme' },
        M = { '<cmd>Telescope man_pages<CR>', 'Man Pages' },
        k = { '<cmd>Telescope keymaps<CR>', 'Keymaps' },
        r = { '<cmd>Telescope oldfiles<CR>', 'Open Recent File' },
        C = { '<cmd>Telescope commands<CR>', 'Commands' },
        q = { '<cmd>Telescope command_history<CR>', 'Commands history' },
    },
    d = {
        name = "Debug",
        t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
        b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
        c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
        C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
        d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
        g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
        i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
        o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
        u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
        p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
        r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
        s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
        q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
    },
    z = {
        name = 'Zettelkasten',
        l = { '<cmd>lua NewZettelkastenLink()<CR>', 'paste [[link]]' },
        f = { '<cmd>lua NewZettelkastenLink(true)<CR>', 'paste [[link]] and :edit File.md' },
        o = { '<cmd>lua FollowZettelkastenLink()<CR>', 'Wiki-links in buffer' },
        j = { '<cmd>lua FollowZettelkastenLink(1)<CR>', 'First wiki-links in buffer' },
        k = { '<cmd>lua FollowZettelkastenLink(-1)<CR>', 'Last wiki-links in buffer' },
        a = { '<cmd>lua FollowZettelkastenLinkAlacritty()<CR>', 'Edit alacritty hinted link' },
    },
    g = {
        name = 'Git',
        o = { '<cmd>Telescope git_status<cr>", "Open changed file' },
        b = { '<cmd>Telescope git_branches<cr>", "Checkout branch' },
        c = { '<cmd>Telescope git_commits<cr>", "Checkout commit' },
        C = {
          '<cmd>Telescope git_bcommits<cr>',
          'Checkout commit(for current file)',
        },
    },
    P = {
        name = 'Plugin',
        -- TODO: function instead of buffer maccros
        o = { [["byi':!xdg-open https://github.com/<C-r>b &<CR>]], 'Open link' },
        p = { [[o{ '<Esc>"+pa' },<Esc>2T/dT']], 'Paste new from "+' },
    },
    c = {
        name = 'Change',
        -- TODO: function instead of buffer maccros
        f = { '/<++><CR>c4l', '<++> forward' },
        b = { '?<++><CR>c4l', '<++> backward' },
        t = { '/<++><CR>R', '<++> table (f)' },
    },
}


require 'keymappings'  -- for vim.g.mapleader

local which_key = require 'which-key'
which_key.setup(setup)

which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
