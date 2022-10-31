local M = {}

function M:init()
    self.load_vanilla_options()
    self.load_commands()
end

-- vim.opt commands
function M:load_vanilla_options()
    local options = {
        -- Please, do not duplicate defaults (:help nvim-defaults)
        clipboard = 'unnamedplus', -- allows neovim to acces system clipboard
        cmdheight = 2, -- more space in the neovim command line
        conceallevel = 0, -- markdown do not hide marks now
        completeopt = 'menuone,noselect', -- options for Insert mode completions
        cursorline = true, -- highlight the current line
        expandtab = true, -- <Tab> insert spaces instead of <Tab>
        iminsert = 0, -- on start insert is in english by default
        imsearch = 0, -- on start search is in english by default
        keymap = 'russian-jcukenwin', -- add russian layout
        mouse = 'a', -- allow mouse to be used in all neovim modes
        hidden = true, -- allow hide unsaved but changed buffers
        number = true, -- set numbered lines
        relativenumber = true, -- set relative numbered lines
        scrolloff = 8, -- minimal number of screen lines to keep above and below the cursor
        showtabline = 0, -- -always- never show tabs
        shiftwidth = 4, -- number of spaces which >> injects
        sidescrolloff = 8, -- scrolloff for left and right movement
        smartindent = true, -- dynamic autoidentation
        softtabstop = 4, -- <Tab> counts as 4 spaces in special cases
        splitbelow = true, -- horizontal splits spawn below current window
        splitright = true, -- vertical splits spawn righter current window
        tabstop = 4, -- <Tab> counts as 4 spaces
        termguicolors = true, -- enable terminal gui colors
        wrap = false, -- display lines as one long line
        spelllang = 'ru,en,la', -- check spelling of given languages
        laststatus = 3, -- global statusline (one for every window splits)
    }

    local append_options = {
        isfname = '{,}', -- ${HOME}/.config now is valid path for gf
        shortmess = 'c', -- disable default completion messages
        suffixesadd = '.md', -- gf opens [[link to file]] as link\ to\ file.md now
    }

    for k, v in pairs(append_options) do
        vim.opt[k]:append(v)
    end

    for k, v in pairs(options) do
        vim.opt[k] = v
    end

    vim.opt['iminsert'] = options['iminsert'] -- fix this option separately
end

-- vim.cmd commands
function M:load_commands()
    local cmd = vim.cmd
    local autocommands = {
        --
        --     Pattern:
        --
        -- _augroup_name = {
        --     { 'trigger', 'pattern', 'text'},
        --     { 'trigger2', 'pattern2', 'text2'},
        -- },

        _general_settings = {
            { 'TermOpen', '*', 'startinsert' }, -- Open insert mode on :terminal
        },

        _autoformat = {
            -- { 'BufWritePre', '*', 'lua vim.lsp.buf.formatting_sync()' },
        },

        _git = {
            { 'FileType', 'gitcommit', ' setlocal wrap' },
            { 'FileType', 'gitcommit', 'setlocal spell' },
        },

        _markdown = {
            { 'FileType', 'markdown', ' setlocal wrap' },
            { 'FileType', 'markdown', 'setlocal spell' },
        },

        _text = {
            { 'FileType', 'text', ' setlocal wrap' },
            { 'FileType', 'text', 'setlocal spell' },
        },

        _javascript = {
            { 'FileType', 'javascript', 'setlocal ts=2 sts=2 sw=2' },
            { 'FileType', 'html', 'setlocal ts=2 sts=2 sw=2' },
        },

        _autocompile = {
            --{ 'BufWritePost', 'plugins.lua', ':luafile $MYVIMRC | PackerCompile' },
        },

        _dashboard = {
            { 'FileType', 'dashboard', 'setlocal nocursorline noswapfile nonumber norelativenumber nocursorcolumn nolist' },
        },

        _ledger = {
            { 'FileType', 'ledger', 'setlocal foldmethod=syntax' },
        },
    }

    for group_name, definition in pairs(autocommands) do
        cmd('augroup ' .. group_name)
        cmd 'autocmd!'

        for _, def in pairs(definition) do
            local command = table.concat(vim.tbl_flatten { 'autocmd', def }, ' ')
            cmd(command)
        end

        cmd 'augroup END'
    end
end

return M
