-- self@machine .vimrc
--

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.showtabline = 0
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.sidescrolloff = 8
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.laststatus = 3
vim.opt.winborder = "rounded"
vim.opt.cmdheight = 2
vim.opt.conceallevel = 0 -- markdown don"t hide marks now
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.keymap = "russian-jcukenwin"
vim.opt.iminsert = 0 -- start insert using eng lang, not russian-jcukenwin
vim.opt.imsearch = 0 -- same as above, but for search mode
vim.opt.mouse = "a"  -- oh no
vim.opt.hidden = true
vim.opt.spelllang = "ru,en,la"

vim.cmd [[set completeopt+=menuone,noselect,popup]]
vim.cmd [[set suffixesadd+=.md]]
--vim.cmd [[set shortmess+=c]] -- disable default completion messages

--vim.g.mapleader = " "
vim.g.mapleader = ","

vim.pack.add({
    { src = "https://github.com/renerocksai/telekasten.nvim" },
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/numToStr/Comment.nvim" },
    { src = "https://github.com/andymass/vim-matchup" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/ThePrimeagen/harpoon",                   version = "harpoon2" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter",        version = "main" },
    { src = "https://github.com/akinsho/toggleterm.nvim",                version = "v2.13.1" },
    -- telescope
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
    -- telescope end
    -- lsp
    { src = "https://github.com/neovim/nvim-lspconfig" }, -- lsp configs data repository
    { src = "https://github.com/mason-org/mason.nvim" },  -- lsp apps manager (instead of pacman)
    -- lsp end
    -- autocomplete
    { src = "https://github.com/saghen/blink.cmp" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    -- autocomplete end
    -- status line and bufferline
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/romgrk/barbar.nvim" },
    -- status line and bufferline end
    -- debugger
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/rcarriga/nvim-dap-ui" },
    { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
    { src = "https://github.com/leoluz/nvim-dap-go" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
    -- debugger end
    -- git
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    -- git end
    -- aesthetics
    { src = "https://github.com/folke/tokyonight.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/EdenEast/nightfox.nvim" },
    { src = "https://github.com/bignimbus/pop-punk.vim" },
    -- aesthetics end
    -- syntax
    { src = "https://github.com/ledger/vim-ledger" },
    { src = "https://github.com/mracos/mermaid.vim" },
    -- syntax end
})

vim.cmd [[colorscheme tokyonight-moon]]
-- vim.cmd [[colorscheme carbonfox]]

vim.lsp.enable({
    "lua_ls", "gopls", "bashls", "clangd", "cssls",
    "denols", "docker_compose_language_server", "dockerls",
    "html", "jsonls", "lemminx", "markdown_oxide", "pyright",
    "rust+analyzer", "sqlls", "stylelint_lsp", "templ", "texlab",
})

vim.lsp.config("lua_ls", { settings = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) } } } }) -- add vim config api autocomplition

require("nvim-dap-virtual-text").setup {}
require("dap-go").setup()
local dap, dapui = require("dap"), require("dapui")
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end


require "luasnip".setup { enable_autosnippets = true }

require "blink.cmp".setup({
    signature = { enabled = true },
    fuzzy = { implementation = "lua" },
})

require "Comment".setup()

require "lualine".setup { sections = { lualine_a = { "mode",
    function()
        if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
            return "⌨ " .. string.upper(vim.b.keymap_name)
        end
        return ""
    end,
}, }, }

require "nvim-autopairs".setup()

require "oil".setup {
    lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = true,
    },
    columns = { "icon", }
}

require "mason".setup {}

local telescope = require "telescope"
telescope.setup {
    defaults = {
        preview = { treesitter = true },
        color_devicons = true,
        path_displays = { "smart" },
        layout_config = {
            width = 0.75,
            prompt_position = "bottom",
            preview_cutoff = 120,
        },
        file_ignore_patterns = { "venv" },
        mappings = {
            i = {
                ["<C-f>"] = { "<C-^>", type = "command" }, -- switch layout
            },
        },
    },
}
telescope.load_extension("ui-select")

require "toggleterm".setup {
    open_mapping = "<C-T>",
    direction = "float",
}

local harpoon = require "harpoon"
harpoon:setup()

local homeDir = vim.loop.fs_realpath(vim.fn.expand("$ZETTELKASTEN"))
require("telekasten").setup {
    home = homeDir,

    -- dailies = home .. "../Journal",
    -- weeklies = home .. "../Journal",
    -- templates = home .. "../Templates",
    dailies = homeDir .. "/Journal",
    weeklies = homeDir .. "/Journal",
    templates = homeDir .. "/Templates",
    image_subdir = homeDir .. "/Files",

    weeklies_create_nonexisting = false,

    -- template_new_note = home .. "../Templates/Mine Моё.md",
    -- template_new_daily = home .. "../Templates/Daily.md",
    template_new_note = homeDir .. "/Templates/Mine Моё.md",
    template_new_daily = homeDir .. "/Templates/Daily.md",

    -- subdirs_in_links = false,  -- проблемы с переименованием заметок при включении
    plug_into_calendar = false,
}

local map = vim.keymap.set

map({ "n" }, "Y", "y$")
map({ "n" }, "<leader>h", "<cmd>:set hlsearch!<cr>", { desc = "Toggle highlight" })
map({ "n" }, "<leader>S", "<cmd>:set spell!<cr>", { desc = "Toggle Spell check" })
map({ "n" }, "<leader>e", "<cmd>Oil<cr>", { desc = "Explore" })
map({ "n" }, "<leader>ch", "<cmd>cd %:h<cr><cmd>:pwd<cr>", { desc = "cd to Here" })

-- switch layout
map({ "i", "c" }, "<C-F>", "<C-^>")
map({ "v", "x" }, "<C-F>", "<Esc>a<C-^><Esc>gv")
map({ "n" }, "<C-F>", "a<C-^><Esc>")
-- switch layout end

map({ "n" }, "<M-Left>", ":vertical resize -2<CR>")
map({ "n" }, "<M-Right>", ":vertical resize +2<CR>")
map({ "n" }, "<M-Down>", ":resize -2<CR>")
map({ "n" }, "<M-Up>", ":resize +2<CR>")

map({ "n" }, "<S-L>", ":BufferNext<CR>")
map({ "n" }, "<S-H>", ":BufferPrevious<CR>")

-- debugger
map({ "n" }, "<leader>d", ":DapNew<cr>", { desc = "Debug mode" })
map({ "n", "i" }, "<C-B>", ":DapToggleBreakpoint<cr>", { desc = "Toggle breakpoint" })
-- debugger end

-- harpoon
map({ "n" }, "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon this" })
map({ "n" }, "<C-E>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
map({ "n" }, "<C-j>", function() harpoon:list():select(1) end)
map({ "n" }, "<C-k>", function() harpoon:list():select(2) end)
map({ "n" }, "<C-n>", function() harpoon:list():select(3) end)
map({ "n" }, "<C-m>", function() harpoon:list():select(4) end)
map({ "n" }, "<C-S-P>", function() harpoon:list():prev() end)
map({ "n" }, "<C-S-N>", function() harpoon:list():next() end)
-- harpoon end

map("n", "<leader>pc",
    function()
        local active_plugins = {}
        local unused_plugins = {}

        for _, plugin in ipairs(vim.pack.get()) do
            active_plugins[plugin.spec.name] = plugin.active
        end

        for _, plugin in ipairs(vim.pack.get()) do
            if not active_plugins[plugin.spec.name] then
                table.insert(unused_plugins, plugin.spec.name)
            end
        end

        if #unused_plugins == 0 then
            print("No unused plugins.")
            return
        end

        local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
        if choice == 1 then
            vim.pack.del(unused_plugins)
        end
    end
)

map({ "n", "v", "x" }, "<leader>/", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comment toggle linewise" })
map({ "n" }, "<leader>o", ":update<CR> :source " .. vim.fn.expand("$MYVIMRC") .. "<CR>")
map({ "n" }, "<leader>O", ":restart<cr>")

map({ "n" }, "<leader>lf", vim.lsp.buf.format, { desc = "LSP format" })
map({ "n" }, "<leader>lD", vim.lsp.buf.declaration, { desc = "Declaration" })
map({ "n" }, "<leader>ld", vim.lsp.buf.definition, { desc = "Definition" })
map({ "n" }, "<leader>li", vim.lsp.buf.implementation, { desc = "implementation" })
map({ "n" }, "<leader>lj", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostics" })
map({ "n" }, "<leader>lk", function() vim.diagnostic.jump({ count = -1, float = true }) end,
    { desc = "Prev diagnostics" })
map({ "n" }, "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Action" })

local builtin = require("telescope.builtin")
map({ "n" }, "<leader>f", builtin.find_files, { desc = "Find files (ignore)" })
map({ "n" }, "<leader>sfi", builtin.find_files, { desc = "Find files (ignore)" })
map({ "n" }, "<leader>sfa", function() builtin.find_files({ no_ignore = true }) end, { desc = "Find files (all)" })
map({ "n" }, "<leader>sti", builtin.live_grep, { desc = "Live grep (ignore)" })
map({ "n" }, "<leader>sta", function() builtin.live_grep({ no_ignore = true }) end, { desc = "Live grep (all)" })
map({ "n" }, "<leader>sM", builtin.man_pages, { desc = "Man pages" })
map({ "n" }, "<leader>sb", builtin.buffers, { desc = "Buffers" })
map({ "n" }, "<leader>sh", builtin.help_tags, { desc = "Help tags" })
map({ "n" }, "<leader>sq", builtin.command_history, { desc = "Command history" })
map({ "n" }, "<leader>sr", builtin.lsp_references, { desc = "LSP references" })
map({ "n" }, "<leader>si", builtin.lsp_implementations, { desc = "Implementations" })
map({ "n" }, "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
map({ "n" }, "<leader>sj", builtin.jumplist, { desc = "Jumplist" })

map({ "n" }, "<leader>zB", ":Telekasten show_backlinks<cr>", { desc = "Show backlinks" })
map({ "n" }, "<leader>zF", ":Telekasten find_friends<cr>", { desc = "Find friends" })
map({ "n" }, "<leader>zT", ":Telekasten goto_today<cr>", { desc = "Goto today" })
map({ "n" }, "<leader>zf", ':Telekasten find_notes<cr><cmd>cd "$ZETTELKASTENZ/"<cr>', { desc = "Find notes" })
map({ "n" }, "<leader>zg", ":Telekasten search_notes<cr>", { desc = "Search notes" })
map({ "n" }, "<leader>zl", ":Telekasten insert_link<cr>", { desc = "Paste [[link]]" })
map({ "n" }, "<leader>zn", ":Telekasten new_note<cr>", { desc = "New note" })
map({ "n" }, "<leader>zo", ":Telekasten panel<cr>", { desc = "Telekasten command palette" })
map({ "n" }, "<leader>zr", ":Telekasten rename_note<cr>", { desc = "Rename note" })
map({ "n" }, "<leader>zz", ":Telekasten follow_link<cr>", { desc = "Follow link under cursor" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "markdown", "text" },
    callback = function()
        vim.cmd [[setlocal wrap]]
        vim.cmd [[setlocal spell]]
    end,
    group = vim.api.nvim_create_augroup("text", {}),
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "html" },
    callback = function() vim.cmd [[setlocal ts=2 sts=2 sw=2]] end,
    group = vim.api.nvim_create_augroup("javascript", {}),
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "ledger" },
    callback = function() vim.cmd [[setlocal foldmethod=syntax]] end,
    group = vim.api.nvim_create_augroup("ledger", {}),
})
