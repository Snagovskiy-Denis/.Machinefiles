-- self@machine .vimrc
--
-- MEMO: KISS

-- tip: use ':help number' to check option effect
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
--vim.opt.cmdheight = 2 -- TODO: nvim v0.12 and lualine glitches with this setting
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.keymap = "russian-jcukenwin"
vim.opt.iminsert = 0 -- start insert using eng lang, not russian-jcukenwin
vim.opt.imsearch = 0 -- same as above, but for search mode
vim.opt.mouse = "a"  -- heresy
vim.opt.hidden = true
vim.opt.spelllang = "ru,en,la"
vim.opt.background = "light"

vim.cmd [[set completeopt+=menuone,noselect,popup]]

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "markdown", "text" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
    group = vim.api.nvim_create_augroup("text", {}),
})

vim.g.mapleader = " "

-- tip: use 'checkhealth' to ensure plugins are valid,
-- also check their external requirements (e.g. nvim-treesitter requires gcc)
vim.pack.add({
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter",            version = "main" },
    { src = "https://github.com/ThePrimeagen/harpoon",                       version = "harpoon2" },
    { src = "https://github.com/akinsho/toggleterm.nvim",                    version = "v2.13.1" },
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/romgrk/barbar.nvim" },
    { src = "https://github.com/folke/persistence.nvim" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/folke/flash.nvim" },
    -- telescope
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
    -- lsp
    { src = "https://github.com/neovim/nvim-lspconfig" }, -- lsp configs data repository
    { src = "https://github.com/mason-org/mason.nvim" },  -- lsp apps manager (instead of pacman & brew)
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    -- autocomplete
    { src = "https://github.com/saghen/blink.cmp" },
    { src = "https://github.com/joelazar/blink-calc" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    -- git
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    -- debugger
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/rcarriga/nvim-dap-ui" },
    { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
    { src = "https://github.com/leoluz/nvim-dap-go" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
    -- aesthetics
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/navarasu/onedark.nvim" },
    { src = "https://github.com/bignimbus/pop-punk.vim" },
    { src = "https://github.com/dchinmay2/alabaster.nvim" },
})

-- require "onedark".setup { style = "deep" }
-- require "onedark".load()
vim.cmd("colorscheme alabaster")

local fg_hilghlight_theme = true
if vim.o.background == "light" and fg_hilghlight_theme then
    local black = "#000000"
    local white = "#ffffff"
    local dark_green = "#95cb82"
    local light_green = "#DBECB6"
    local dark_blue = "#71bfe7"
    local light_blue = "#DBF1FF"
    local light_purple = "#cc8bc9"
    local light_yellow = "#FFFABC"
    local brown = "#aa3536"

    local theme = {
        ["@string"] = { bg = light_green },
        String = { bg = light_green },
        ["@AlabasterString"] = { bg = light_green },

        ["@string.regex"] = { bg = light_purple, fg = black },
        Special = { fg = brown },
        ["@string.escape"] = { bg = light_purple, fg = black },
        Title = { bg = light_purple, fg = black },

        -- ["@constant.builtin"] = { bg = "#cc8bc9", fg = "#000000" },
        -- ["@AlabasterConstant"] = { bg = "#cc8bc9", fg = "#000000" },
        -- Number = { bg = "#cc8bc9" },
        -- Boolean = { bg = "#cc8bc9" },
        -- Float = { bg = "#cc8bc9" },
        -- Character = { bg = "#cc8bc9" },
        -- Constant = { bg = "#cc8bc9" },
        -- TSConstBuiltin = { bg = "#cc8bc9" },
        -- TSNone = { bg = "#cc8bc9" },
        -- ["@none"] = { bg = "#cc8bc9" },

        Comment = { bg = light_yellow, fg = "" },
        Todo = { bg = brown, fg = "" },

        Search = { bg = brown, fg = white },

        ["@AlabasterDefinition"] = { bg = light_blue },

        FlashBackdrop = { fg = black, italic = true },
        BufferCurrentMod = { fg = brown },
    }
    for group, hl in pairs(theme) do
        vim.api.nvim_set_hl(0, group, hl)
    end
end

-- tip: 'help lspconfig-all' for correct names
local lsp_langs = {
    "lua_ls", "gopls", "bashls", "clangd", "cssls",
    "denols", "docker_compose_language_service", "dockerls",
    "html", "jsonls", "lemminx", "markdown_oxide", "pyright",
    "rust_analyzer", "sqlls", "stylelint_lsp", "texlab",
}
require "mason".setup {}
require "mason-lspconfig".setup {
    automatically_enable = false,
    ensure_installed = lsp_langs,
}
vim.lsp.enable(lsp_langs)

vim.lsp.config("lua_ls", { settings = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) } } } }) -- add vim config api autocomplition

local treesitter_langs = {
    "go", "mermaid", "ledger", "markdown", "lua", "python",
    "bash", "c", "cpp", "cmake", "comment", "csv", "diff",
    "dockerfile", "printf", "gitignore", "gomod", "gosum",
    "gowork", "graphql", "html", "css", "javascript", "jq",
    "make", "nix", "proto", "regex", "sql", "yaml", "xml",
    "awk", "git_config", "json", "passwd", "http", "readline",
    "vimdoc",
}
require "nvim-treesitter".install(treesitter_langs)
vim.api.nvim_create_autocmd("FileType", {
    pattern = treesitter_langs,
    callback = function() vim.treesitter.start() end,
})

require("dap-go").setup {}
require "nvim-dap-virtual-text".setup {}
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
    completion = { documentation = { auto_show = true } },
    sources = {
        default = { "lsp", "path", "snippets", "buffer", "calc" },
        providers = {
            path = {
                opts = {
                    show_hidden_files_by_default = true,
                },
            },
            calc = {
                name = "Calc",
                module = "blink-calc",
            },
        },
    },
    fuzzy = { implementation = "lua" },
})

require "lualine".setup {
    sections = {
        lualine_a = {
            "mode",
            function()
                if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
                    return "⌨ " .. string.upper(vim.b.keymap_name)
                end
                return ""
            end,
        },
    },
}

require "nvim-autopairs".setup()

require "oil".setup {
    lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = true,
    },
    columns = { "icon" },
}

local telescope = require "telescope"
telescope.setup {
    defaults = {
        preview = { treesitter = true },
        color_devicons = true,
        path_displays = { "smart" },
        sorting_strategy = "ascending",
        layout_config = {
            width = 0.75,
            prompt_position = "top",
            preview_cutoff = 120,
        },
        mappings = {
            i = {
                ["<C-f>"] = { "<C-^>", type = "command" }, -- switch layout
            },
        },
    },
}
telescope.load_extension("ui-select")

require "toggleterm".setup { -- TODO: replace with tmux after tmux+alacritty bugfix
    open_mapping = "<C-T>",
    direction = "float",
}

require "zettelkasten" -- locale package


local map = vim.keymap.set

local which_key = require "which-key"
map({ "n" }, "<leader>?", which_key.show, { desc = "Which-key help" })
map({ "n" }, "Y", "y$", { desc = "Yank to end of line" })
map({ "n" }, "<leader>Qq", ":qa<cr>", { desc = "Gentle quit" })
map({ "n" }, "<leader>Qf", ":qa!<cr>", { desc = "Force quit" })
map({ "n" }, "<leader>h", "<cmd>:set hlsearch!<cr>", { desc = "Toggle highlight" })
map({ "v" }, "<leader>h", function()
    local vstart, vend = vim.fn.getpos("v"), vim.fn.getpos(".")
    local visual_selection = vim.fn.getregion(vstart, vend, vim.empty_dict())
    local visual_selection_text = table.concat(visual_selection, "")
    vim.fn.setreg("/", visual_selection_text)
    vim.opt.hlsearch = true
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end, { desc = "Highlight selection" })
map({ "n" }, "<leader>e", "<cmd>Oil<cr>", { desc = "Explore" })
map({ "n" }, "<leader>ch", "<cmd>cd %:h<cr><cmd>:pwd<cr>", { desc = "cd to Here" })
map({ "n" }, "<leader>bd", ":bp | bd #<cr>", { desc = "Close buffer w/o split close" })
map({ "n" }, "<leader>o", ":source " .. vim.fn.expand("$MYVIMRC") .. "<CR>")
map({ "n" }, "<leader>O", ":restart<cr>")

map({ "i", "c" }, "<C-F>", "<C-^>", { desc = "Toggle layout" })
map({ "v", "x" }, "<C-F>", "<Esc>a<C-^><Esc>gv", { desc = "Toggle layout" })
map({ "n" }, "<C-F>", "a<C-^><Esc>", { desc = "Toggle layout" })

map({ "t" }, "<C-\\>", "<C-\\><C-N>", { desc = "Exit terminal mode" })

map({ "n" }, "<M-Left>", ":vertical resize -2<CR>")
map({ "n" }, "<M-Right>", ":vertical resize +2<CR>")
map({ "n" }, "<M-Down>", ":resize -2<CR>")
map({ "n" }, "<M-Up>", ":resize +2<CR>")

map({ "n" }, "<S-L>", ":BufferNext<CR>")
map({ "n" }, "<S-H>", ":BufferPrevious<CR>")

-- debugger
local last_test_expression = ""
local function start_dap_for_test(name)
    last_test_expression = name
    local config = {
        type = "go",
        name = "test",
        request = "launch",
        mode = "test",
        program = "neovim",
        args = { "-test.run", name }
    }
    dap.run(config)
end

-- map({ "n" }, "<leader>d", ":DapNew<cr>", { desc = "Debug mode" })
map({ "n", "i" }, "<C-B>", ":DapToggleBreakpoint<cr>", { desc = "Toggle breakpoint" })
map({ "n" }, "<leader>dd", function()
    vim.ui.input({ prompt = "Test expression: ", default = last_test_expression }, function(input)
        if not input then
            return
        end
        start_dap_for_test(input)
    end)
end, { desc = "Debug test" })
map({ "n" }, "<leader>dr", function()
    if last_test_expression == "" then
        vim.notify("last test expression is empty", vim.log.levels.ERROR)
        return
    end
    start_dap_for_test(last_test_expression)
end, { desc = "Rerun last test" })
map({ "n" }, "<leader>dc", dap.continue, { desc = "Continue" })
map({ "n" }, "<Right>", dap.step_over, { desc = "Step over" })
map({ "n" }, "<Down>", dap.step_into, { desc = "Step into" })
map({ "n" }, "<Up>", dap.step_out, { desc = "Step out" })
-- debugger end

-- harpoon
local harpoon = require "harpoon"
harpoon:setup()
map({ "n" }, "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon this" })
map({ "n" }, "<C-E>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
map({ "n" }, "<C-j>", function() harpoon:list():select(1) end)
map({ "n" }, "<C-k>", function() harpoon:list():select(2) end)
map({ "n" }, "<C-n>", function() harpoon:list():select(3) end)
map({ "n" }, "<C-m>", function() harpoon:list():select(4) end)
-- harpoon end

-- plugins manager
map({ "n" }, "<leader>pu", vim.pack.update, { desc = "Update plugins" })
map({ "n" }, "<leader>pc", function()
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
        vim.notify("No unused plugins.", vim.log.levels.WARN)
        return
    end

    if 1 == vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2) then
        vim.pack.del(unused_plugins)
    end
end, { desc = "Clean unused plugins" })
-- plugins manager end

local builtin = require "telescope.builtin"
map({ "n" }, "<leader>f", builtin.find_files, { desc = "Find files" })
map({ "n" }, "<leader>sf", builtin.find_files, { desc = "Find files" })
map({ "n" }, "<leader>st", builtin.live_grep, { desc = "Live grep" })
map({ "n" }, "<leader>sc", function()
    local filepath = os.getenv("HOME") .. "/.config/fd/rgrc"
    --vim.cmd("edit " .. filepath)

    local file = io.open(filepath, "r")
    local content
    if file then
        content = file:read("*all")
        file:close()
    else
        vim.notify("Cound not open file", vim.log.levels.ERROR)
        return
    end

    local mode = ""
    if content:sub(1, 1) == "#" then
        content = content:sub(2, -1)
        mode = "on"
    else
        content = "#" .. content
        mode = "off"
    end

    file = io.open(filepath, "w")
    if file then
        file:write(content)
        file:close()
        vim.notify("Global ignore " .. mode, vim.log.levels.INFO)
    else
        vim.notify("Cound not open file", vim.log.levels.ERROR)
        return
    end
end, { desc = "Switch global ignore" })
map({ "n" }, "<leader>sM", builtin.man_pages, { desc = "Man pages" })
map({ "n" }, "<leader>sb", function()
    builtin.buffers({
        attach_mappings = function(prompt_bufnr, telescope_map)
            telescope_map({ "n" }, "<leader>d", function()
                local buffer_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                buffer_picker:delete_selection(function(selection)
                    vim.api.nvim_buf_delete(selection.bufnr, { force = true })
                end)
            end, { desc = "Delete selected buf" })
            return true -- don't close the buffer_picker
        end
    })
end, { desc = "Buffers" })
map({ "n" }, "<leader>sh", builtin.help_tags, { desc = "Help tags" })
map({ "n" }, "<leader>sq", builtin.command_history, { desc = "Command history" })
map({ "n" }, "<leader>sr", builtin.lsp_references, { desc = "LSP references" })
map({ "n" }, "<leader>si", builtin.lsp_implementations, { desc = "Implementations" })
map({ "n" }, "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
map({ "n" }, "<leader>sj", builtin.jumplist, { desc = "Jumplist" })

map({ "n" }, "<leader>lf", vim.lsp.buf.format, { desc = "LSP format" })
map({ "n" }, "<leader>lD", vim.lsp.buf.declaration, { desc = "Declaration" })
map({ "n" }, "<leader>ld", vim.lsp.buf.definition, { desc = "Definition" })
map({ "n" }, "<leader>li", vim.lsp.buf.implementation, { desc = "implementation" })
map({ "n" }, "<leader>lj", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostics" })
map({ "n" }, "<leader>lk", function() vim.diagnostic.jump({ count = -1, float = true }) end,
    { desc = "Prev diagnostics" })
map({ "n" }, "<leader>lR", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Action" })
map({ "n" }, "<leader>lo", function()
    for _, client in pairs(vim.lsp.get_clients { bufnr = 0 }) do
        client:stop()
    end
    vim.defer_fn(vim.cmd.edit, 1000)
end, { desc = "Restart LSP" })

local persistence = require "persistence"
persistence.setup()
map({ "n" }, "<leader>qs", persistence.load, { desc = "Load $PWD session" })
map({ "n" }, "<leader>qS", persistence.select, { desc = "Select session" })

-- nvimdiff
if vim.opt.diff:get() then
    -- fix nvimdiff: https://github.com/neovim/neovim/issues/22696
    vim.o.diffopt = "internal,filler,closeoff"

    -- disable session autosave to prevent $PWD session pollution by nvimdiff
    persistence.stop()
end
map({ "n" }, "<leader>Qc", ":cq<cr>", { desc = "Abort git mergetool" })
map({ "n" }, "<leader>bt", ":diffget 1<cr>", { desc = "Accept theirs" })
map({ "n" }, "<leader>bb", ":diffget 2<cr>", { desc = "Accept base" })
map({ "n" }, "<leader>bo", ":diffget 3<cr>", { desc = "Accept ours" })
map({ "n" }, "<leader>bn", ":xa<cr>", { desc = "Save all and edit next file" })
-- nvimdiff end

local flash = require "flash"
map({ "n", "x", "o" }, "<leader>j", flash.jump, { desc = "Jump" })
map({ "n", "x", "o" }, "<leader>zj", function()
    local cursor_before = vim.api.nvim_win_get_cursor(0)
    flash.jump { pattern = "[[" }
    local cursor_after = vim.api.nvim_win_get_cursor(0)
    if cursor_before[1] ~= cursor_after[1] or cursor_before[2] ~= cursor_after[2] then
        vim.lsp.buf.definition()
    end
end, { desc = "Jump into note" })

-- nvim-treesitter-textobjects
require "nvim-treesitter-textobjects".setup {}

local textobjects_move = require "nvim-treesitter-textobjects.move"
map({ "n", "x", "o" }, "]f", function()
    textobjects_move.goto_next_start("@function.outer", "textobjects")
end, { desc = "Next function" })
map({ "n", "x", "o" }, "[f", function()
    textobjects_move.goto_previous_start("@function.outer", "textobjects")
end, { desc = "Next function" })

local textobjects_select = require "nvim-treesitter-textobjects.select"
map({ "x", "o" }, "af", function()
    textobjects_select.select_textobject("@function.outer", "textobjects")
end, { desc = "Select a function" })
map({ "x", "o" }, "if", function()
    textobjects_select.select_textobject("@function.inner", "textobjects")
end, { desc = "Select a function" })
-- end nvim-treesitter-textobjects
