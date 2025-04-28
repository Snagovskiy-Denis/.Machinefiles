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
    -- old mappings
    -- ['/'] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle linewise (visual)" },

    { "<leader>/", "<Plug>(comment_toggle_linewise_visual)", desc = "Comment toggle linewise (visual)", mode = "v", nowait = true, remap = false },
}

local mappings = {
    -- old mappings
    -- ['/'] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle current line" },
    -- ['a'] = { ':lua require("harpoon"):list():append()<cr>', 'Harpoon this' },
    -- ['f'] = { '<cmd>Telescope find_files<CR>', 'Find File' },
    -- ['h'] = { '<cmd>:set hlsearch!<CR>', 'Toggle highlight' },
    -- ['A'] = { '<cmd>:AnsiEsc<CR>', 'Toggle ANSI ecapie sequences look' },
    -- ['S'] = { '<cmd>:set spell!<CR>', 'Toggle Spell checking' },
    -- ['t'] = { '<cmd>new term://bash<CR>', 'Open Terminal' },
    -- ['e'] = { '<cmd>NvimTreeToggle<CR>', 'Explore' },
    -- ['x'] = { '<cmd>TZAtaraxis<CR>', 'Dzen mode' },
    -- ['D'] = { '<cmd>ToggleDiag<CR>', 'Toggle Diagnostics' },
    -- ['M'] = { '<cmd>MarkdownPreviewToggle<cr>', 'Render markdown' },
    -- l = {
    --     name = 'LSP',

    --     I = { '<cmd>LspInstallInfo<CR>', 'Info' },
    --     K = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Help pop-up' },
    --     d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Definitoin' },
    --     D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Declaration' },
    --     i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Implementation' },
    --     a = { "<cmd>lua require('lvim.core.telescope').code_actions()<cr>", 'Code Action' },
    --     r = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename' },
    --     f = { '<cmd>lua vim.lsp.buf.format { async = true }<CR>', 'Format' },

    --     s = { '<cmd>Telescope lsp_document_symbols<CR>', 'Document Symbols' },
    --     S = { '<cmd>Telescope lsp_workspace_symbols<CR>', 'Workspace Symbols' },

    --     -- Diagnostics
    --     j = { '<cmd>lua vim.diagnostic.goto_next()<CR>', 'Next Diagnostics' },
    --     k = { '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'Previous Diagnostics' },
    --     l = { '<cmd>Telescope diagnostics<CR>', 'Document Diagnostics' },

    --     R = { '<cmd>LspRestart<CR>', 'Refreshes the LSP' },
    -- },
    -- s = {
    --     name = 'Search',
    --     f = { '<cmd>Telescope find_files<CR>', 'Find File' },
    --     -- e = { '<cmd>Telescope file_browser<CR>', 'Browse files' },
    --     t = { '<cmd>Telescope live_grep<CR>', 'Text' },
    --     b = { '<cmd>Telescope buffers<CR>', 'Buffers' },
    --     h = { '<cmd>Telescope help_tags<CR>', 'Find Help' },
    --     R = { '<cmd>Telescope registers<CR>', 'Registers' },
    --     c = { '<cmd>Telescope colorscheme<CR>', 'Colorscheme' },
    --     M = { '<cmd>Telescope man_pages<CR>', 'Man Pages' },
    --     k = { '<cmd>Telescope keymaps<CR>', 'Keymaps' },
    --     r = { '<cmd>Telescope oldfiles<CR>', 'Open Recent File' },
    --     C = { '<cmd>Telescope commands<CR>', 'Commands' },
    --     q = { '<cmd>Telescope command_history<CR>', 'Commands history' },
    -- },
    -- z = {
    --     name = 'Zettelkasten',
    --     o = { '<cmd>Telekasten panel<cr>', 'Command palette' },
    --     f = { '<cmd>Telekasten find_notes<cr><cmd>cd "${ZETTELKASTEN}Z/"<cr>', 'Find notes by title' },
    --     l = { '<cmd>Telekasten insert_link<cr>', 'Paste [[link]]' },
    --     n = { '<cmd>Telekasten new_note<cr>', 'New note, prompts for title' },
    --     z = { '<cmd>Telekasten follow_link<cr>', 'Follow link under cursor' },
    --     g = { '<cmd>Telekasten search_notes<cr>', 'grep in all notes' },
    --     B = { '<cmd>Telekasten show_backlinks<cr>', 'Show all notes linking to the link under the cursor' },
    --     F = { '<cmd>Telekasten find_friends<cr>', 'Show all notes linking to the link under the cursor' },
    --     T = { '<cmd>Telekasten goto_today<cr>', "Open today's daily note" },
    --     t = { '<cmd>Telekasten toggle_todo<cr>', "Toggle todo" },
    --     r = { '<cmd>Telekasten rename_note<cr>', "Rename" },
    -- },
    -- g = {
    --     name = 'Git',
    --     o = { '<cmd>Telescope git_status<cr>", "Open changed file' },
    --     b = { '<cmd>Telescope git_branches<cr>", "Checkout branch' },
    --     c = { '<cmd>Telescope git_commits<cr>", "Checkout commit' },
    --     C = {
    --       '<cmd>Telescope git_bcommits<cr>',
    --       'Checkout commit(for current file)',
    --     },
    -- },
    -- P = {
    --     name = 'Plugin',
    --     -- TODO: function instead of buffer maccros
    --     o = { [["byi':!xdg-open https://github.com/<C-r>b &<CR>]], 'Open link' },
    --     p = { [[o{ '<Esc>"+pa' },<Esc>2T/dT']], 'Paste new from "+' },
    -- },
    -- c = {
    --     name = 'Change',
    --     -- TODO: function instead of buffer maccros
    --     f = { '/<++><CR>c4l', '<++> forward' },
    --     b = { '?<++><CR>c4l', '<++> backward' },
    --     t = { '/<++><CR>R', '<++> table (f)' },

    --     C = { ':OpenInScim<CR>', 'Edit in sc-im' },
    --     c = { '<cmd>terminal sc-im "%"', 'Open current in sc-im' },
    --     x = { '<cmd>UndotreeToggle<cr>', 'Undo tree' },
    -- },

    { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment toggle current line", nowait = true, remap = false },
    { "<leader>A", "<cmd>:AnsiEsc<CR>", desc = "Toggle ANSI ecapie sequences look", nowait = true, remap = false },
    { "<leader>D", "<cmd>ToggleDiag<CR>", desc = "Toggle Diagnostics", nowait = true, remap = false },
    { "<leader>M", "<cmd>MarkdownPreviewToggle<cr>", desc = "Render markdown", nowait = true, remap = false },

    { "<leader>l", group = "LSP", nowait = true, remap = false },
    { "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Declaration", nowait = true, remap = false },
    { "<leader>lI", "<cmd>LspInstallInfo<CR>", desc = "Info", nowait = true, remap = false },
    { "<leader>lK", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Help pop-up", nowait = true, remap = false },
    { "<leader>lR", "<cmd>LspRestart<CR>", desc = "Refreshes the LSP", nowait = true, remap = false },
    { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace Symbols", nowait = true, remap = false },
    { "<leader>la", "<cmd>lua require('lvim.core.telescope').code_actions()<cr>", desc = "Code Action", nowait = true, remap = false },
    { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Definitoin", nowait = true, remap = false },
    { "<leader>lf", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", desc = "Format", nowait = true, remap = false },
    { "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Implementation", nowait = true, remap = false },
    { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Next Diagnostics", nowait = true, remap = false },
    { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Previous Diagnostics", nowait = true, remap = false },
    { "<leader>ll", "<cmd>Telescope diagnostics<CR>", desc = "Document Diagnostics", nowait = true, remap = false },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename", nowait = true, remap = false },
    { "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document Symbols", nowait = true, remap = false },

    { "<leader>s", group = "Search", nowait = true, remap = false },
    { "<leader>sC", "<cmd>Telescope commands<CR>", desc = "Commands", nowait = true, remap = false },
    { "<leader>sM", "<cmd>Telescope man_pages<CR>", desc = "Man Pages", nowait = true, remap = false },
    { "<leader>sR", "<cmd>Telescope registers<CR>", desc = "Registers", nowait = true, remap = false },
    { "<leader>sb", "<cmd>Telescope buffers<CR>", desc = "Buffers", nowait = true, remap = false },
    { "<leader>sc", "<cmd>Telescope colorscheme<CR>", desc = "Colorscheme", nowait = true, remap = false },
    { "<leader>sf", "<cmd>Telescope find_files<CR>", desc = "Find File", nowait = true, remap = false },
    { "<leader>sh", "<cmd>Telescope help_tags<CR>", desc = "Find Help", nowait = true, remap = false },
    { "<leader>sk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps", nowait = true, remap = false },
    { "<leader>sq", "<cmd>Telescope command_history<CR>", desc = "Commands history", nowait = true, remap = false },
    { "<leader>sr", "<cmd>Telescope oldfiles<CR>", desc = "Open Recent File", nowait = true, remap = false },
    { "<leader>st", "<cmd>Telescope live_grep<CR>", desc = "Text", nowait = true, remap = false },
    { "<leader>t", "<cmd>new term://bash<CR>", desc = "Open Terminal", nowait = true, remap = false },
    { "<leader>x", "<cmd>TZAtaraxis<CR>", desc = "Dzen mode", nowait = true, remap = false },

    { "<leader>g", group = "Git", nowait = true, remap = false },
    { "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "Checkout commit(for current file)", nowait = true, remap = false },
    { "<leader>gb", desc = '<cmd>Telescope git_branches<cr>", "Checkout branch', nowait = true, remap = false },
    { "<leader>gc", desc = '<cmd>Telescope git_commits<cr>", "Checkout commit', nowait = true, remap = false },
    { "<leader>go", desc = '<cmd>Telescope git_status<cr>", "Open changed file', nowait = true, remap = false },
    { "<leader>h", "<cmd>:set hlsearch!<CR>", desc = "Toggle highlight", nowait = true, remap = false },

    { "<leader>z", group = "Zettelkasten", nowait = true, remap = false },
    { "<leader>zB", "<cmd>Telekasten show_backlinks<cr>", desc = "Show all notes linking to the link under the cursor", nowait = true, remap = false },
    { "<leader>zF", "<cmd>Telekasten find_friends<cr>", desc = "Show all notes linking to the link under the cursor", nowait = true, remap = false },
    { "<leader>zT", "<cmd>Telekasten goto_today<cr>", desc = "Open today's daily note", nowait = true, remap = false },
    { "<leader>zf", '<cmd>Telekasten find_notes<cr><cmd>cd "${ZETTELKASTEN}Z/"<cr>', desc = "Find notes by title", nowait = true, remap = false },
    { "<leader>zg", "<cmd>Telekasten search_notes<cr>", desc = "grep in all notes", nowait = true, remap = false },
    { "<leader>zl", "<cmd>Telekasten insert_link<cr>", desc = "Paste [[link]]", nowait = true, remap = false },
    { "<leader>zn", "<cmd>Telekasten new_note<cr>", desc = "New note, prompts for title", nowait = true, remap = false },
    { "<leader>zo", "<cmd>Telekasten panel<cr>", desc = "Command palette", nowait = true, remap = false },
    { "<leader>zr", "<cmd>Telekasten rename_note<cr>", desc = "Rename", nowait = true, remap = false },
    { "<leader>zt", "<cmd>Telekasten toggle_todo<cr>", desc = "Toggle todo", nowait = true, remap = false },
    { "<leader>zz", "<cmd>Telekasten follow_link<cr>", desc = "Follow link under cursor", nowait = true, remap = false },

    { "<leader>P", group = "Plugin", nowait = true, remap = false },
    { "<leader>Po", "\"byi':!xdg-open https://github.com/<C-r>b &<CR>", desc = "Open link", nowait = true, remap = false },
    { "<leader>Pp", "o{ '<Esc>\"+pa' },<Esc>2T/dT'", desc = 'Paste new from "+', nowait = true, remap = false },
    { "<leader>S", "<cmd>:set spell!<CR>", desc = "Toggle Spell checking", nowait = true, remap = false },
    { "<leader>a", ':lua require("harpoon"):list():add()<cr>', desc = "Harpoon this", nowait = true, remap = false },

    { "<leader>c", group = "Change", nowait = true, remap = false },
    { "<leader>cC", ":OpenInScim<CR>", desc = "Edit in sc-im", nowait = true, remap = false },
    { "<leader>cb", "?<++><CR>c4l", desc = "<++> backward", nowait = true, remap = false },
    { "<leader>cc", '<cmd>terminal sc-im "%"', desc = "Open current in sc-im", nowait = true, remap = false },
    { "<leader>cf", "/<++><CR>c4l", desc = "<++> forward", nowait = true, remap = false },
    { "<leader>ct", "/<++><CR>R", desc = "<++> table (f)", nowait = true, remap = false },
    { "<leader>cx", "<cmd>UndotreeToggle<cr>", desc = "Undo tree", nowait = true, remap = false },
    { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explore", nowait = true, remap = false },
    { "<leader>f", "<cmd>Telescope find_files<CR>", desc = "Find File", nowait = true, remap = false },

}

require 'keymappings'  -- for vim.g.mapleader

local which_key = require 'which-key'
which_key.setup(setup)

which_key.add(mappings, opts)
which_key.add(vmappings, vopts)
