-- Contains leader key mappings

-- TODO: move these somethere (config.lua ?)
local wikilink_regex = [[\[\[\([^|]*\)|\?\(.*\)\]\]o\?]]

local url_g0 = [[[Hh][Tt][Tt][Pp][Ss]\?:\/\/\([Ww]\{3,3}\.\)\?]]
local url_g1 = [[[-a-zA-Z0-9@:%._+~#=]\+]]
local url_g2 = [[\.[a-zA-Z0-9()]\+]]
local url_g3 = [[\/\?[-a-zA-Z0-9()@:%._+~#=?&/]*[a-zA-Z0-9]o\?]]

local url_regexp = url_g0 .. url_g1 .. url_g2 .. url_g3
local url_short_regexp =     url_g1 .. url_g2 .. url_g3


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
    ['z'] = { '<cmd>TZAtaraxis<CR>', 'Dzen mode' },
    ['x'] = { '<cmd>TZAtaraxis<CR>', 'Toggle fading' },
    l = {
        name = 'LSP',

        I = { '<cmd>LspInfo<CR>', 'Info' },
        K = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Help pop-up' },
        d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Definitoin' },
        D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Declaration' },
        r = { '<cmd>lua vim.lsp.buf.references()<CR>', 'References' },
        i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Implementation' },
        a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code Action' },
        R = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename' },
        f = { '<cmd>lua vim.lsp.buf.formatting()<CR>', 'Format' },

        s = { '<cmd>Telescope lsp_document_symbols<CR>', 'Document Symbols' },
        S = { '<cmd>Telescope lsp_workspace_symbols<CR>', 'Workspace Symbols' },

        -- Diagnostics
        j = { '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', 'Next Diagnostics' },
        k = { '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', 'Previous Diagnostics' },
        w = { '<cmd>Telescope lsp_workspace_diagnostics<CR>', 'Workspace Diagnostics' },
        l = { '<cmd>Telescope lsp_document_diagnostics<CR>', 'Document Diagnostics' },
    },
    s = {
        name = 'Search',
        f = { '<cmd>Telescope find_files<CR>', 'Find File' },
        e = { '<cmd>Telescope file_browser<CR>', 'Browse files' },
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
    y = {
        name = 'Yank',
        u = { string.format('mb/%s<CR>ygn`b:echo "\"<C-r>+\" was copied<CR>"', url_regexp), 'url' },
        s = {
            name = 'short',
            u = { string.format('mb/%s<CR>ygn`b:echo "\"<C-r>+\" was copied<CR>"', url_short_regexp), 'url' },
        },
    },
    g = {
        name = 'Goto File',
        w = { string.format('mb/%s<CR>:nohl<CR>lvi[gf', wikilink_regex), 'closest [[wikilink]]' },
        v = { '<cmd>:edit $MYVIMRC | cd %:p:h<CR>', '.vimrc' },
    },
    n = {
        name = 'New file',
        w = { '"byi[:e <C-r>b.md<CR>"hPG', '[[Wikilink]] file (b buffer)' },
    },
    P = {
        name = 'Plugin',
        o = { [["byi':!xdg-open https://github.com/<C-r>b &<CR>]], 'Open link' },
        p = { [[o{ '<Esc>"+pa' },<Esc>2T/dT']], 'Paste new from "+' },
    },
    c = {
        name = 'Change',
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
