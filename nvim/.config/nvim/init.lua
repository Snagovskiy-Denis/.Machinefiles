-- self@machine .vimrc
--

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

vim.cmd [[set completeopt+=menuone,noselect,popup]]
vim.cmd [[set suffixesadd+=.md]]

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
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/numToStr/Comment.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter",        version = "main" },
    { src = "https://github.com/ThePrimeagen/harpoon",                   version = "harpoon2" },
    { src = "https://github.com/akinsho/toggleterm.nvim",                version = "v2.13.1" },
    { src = "https://github.com/folke/persistence.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/romgrk/barbar.nvim" },
    { src = "https://github.com/folke/which-key.nvim" },
    -- telescope
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
    -- telescope end
    -- lsp
    { src = "https://github.com/neovim/nvim-lspconfig" }, -- lsp configs data repository
    { src = "https://github.com/mason-org/mason.nvim" },  -- lsp apps manager (instead of pacman & brew)
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    -- lsp end
    -- autocomplete
    { src = "https://github.com/saghen/blink.cmp" },
    { src = "https://github.com/joelazar/blink-calc" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    -- autocomplete end
    -- git
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    -- git end
    -- debugger
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/rcarriga/nvim-dap-ui" },
    { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
    { src = "https://github.com/leoluz/nvim-dap-go" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
    -- debugger end
    -- aesthetics
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/navarasu/onedark.nvim" },
    { src = "https://github.com/bignimbus/pop-punk.vim" }, -- nostalgia
    -- aesthetics end
})

require "onedark".setup { style = "deep" }
require "onedark".load()

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

require "Comment".setup()

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

require "toggleterm".setup {
    open_mapping = "<C-T>",
    direction = "float",
}


local map = vim.keymap.set

local which_key = require "which-key"
map({ "n" }, "<leader>?", which_key.show, { desc = "Which-key help" })
map({ "n" }, "Y", "y$", { desc = "Yank to end of line" })
map({ "n" }, "<leader>Qq", ":qa<cr>", { desc = "Gentle quit" })
map({ "n" }, "<leader>Qf", ":qa!<cr>", { desc = "Force quit" })
map({ "n" }, "<leader>h", "<cmd>:set hlsearch!<cr>", { desc = "Toggle highlight" })
map({ "n" }, "<leader>S", "<cmd>:set spell!<cr>", { desc = "Toggle Spell check" })
map({ "n" }, "<leader>e", "<cmd>Oil<cr>", { desc = "Explore" })
map({ "n" }, "<leader>ch", "<cmd>cd %:h<cr><cmd>:pwd<cr>", { desc = "cd to Here" })
map({ "n" }, "<leader>bd", ":bp | bd #<cr>", { desc = "Close buffer w/o split close" })

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
        print("last test expression is empty")
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
map({ "n" }, "<C-S-P>", function() harpoon:list():prev() end)
map({ "n" }, "<C-S-N>", function() harpoon:list():next() end)
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
        print("No unused plugins.")
        return
    end

    if 1 == vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2) then
        vim.pack.del(unused_plugins)
    end
end, { desc = "Clean unused plugins" })
-- plugins manager end

map({ "n", }, "<leader>/", "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle comment" })
map({ "v", "x" }, "<leader>/", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle comment" })
map({ "n" }, "<leader>o", ":source " .. vim.fn.expand("$MYVIMRC") .. "<CR>")
map({ "n" }, "<leader>O", ":restart<cr>")

local builtin = require "telescope.builtin"
map({ "n" }, "<leader>f", builtin.find_files, { desc = "Find files (ignore)" })
map({ "n" }, "<leader>sff", builtin.find_files, { desc = "Find files (ignore)" })
map({ "n" }, "<leader>sfa", function()
    builtin.find_files { no_ignore = true, hidden = true }
end, { desc = "Find files (all)" })
map({ "n" }, "<leader>stt", builtin.live_grep, { desc = "Live grep (ignore)" })
map({ "n" }, "<leader>sta", function()
    builtin.live_grep { no_ignore = true, hidden = true }
end, { desc = "Live grep (all)" })
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

-- zettelkasten
local Path = require "plenary.path"

function Path:mustExist()
    if not self:exists() then
        error(string.format("path doesn't exist: %s", tostring(self)))
    end
end

function Path:Zettelkasten()
    local vault = Path:new(vim.fn.expand("$ZETTELKASTEN"))
    vault:mustExist()
    return vault
end

map({ "n", }, "<leader>zf", function()
    local vault = tostring(Path:Zettelkasten())
    builtin.find_files { cwd = vault }
    vim.api.nvim_set_current_dir(vault)
end, { desc = "Find notes" })
map({ "n" }, "<leader>zt", function()
    local vault = tostring(Path:Zettelkasten())
    builtin.live_grep { cwd = vault }
    vim.api.nvim_set_current_dir(vault)
end, { desc = "Grep notes" })
map({ "n" }, "<leader>zh", '<cmd>cd $ZETTELKASTEN<cr><cmd>:pwd<cr>', { desc = "cd to Vault" })

local function edit_note(name)
    local vault = Path:Zettelkasten()
    local template = vault / "Templates" / "Mine Моё.md"
    template:mustExist()
    local targetDir = vault / "Z"
    targetDir:mustExist()

    local target = targetDir / (name .. ".md")
    vim.cmd("edit " .. tostring(target))
    vim.api.nvim_set_current_dir(tostring(targetDir))

    if target:exists() then
        return
    end

    -- place template and replace {{title}} tag if presented
    vim.cmd("read " .. tostring(template))
    vim.cmd [[normal gg"xdd]]
    vim.cmd("%s/{{title}}/" .. name .. "/g")
    vim.cmd [[normal G]]
end
map({ "n" }, "<leader>zz", function()
    local line = vim.api.nvim_get_current_line()
    local link_start, link_end = line:find("%[%[.-%]%]")
    if not link_start then return end

    local col = vim.api.nvim_win_get_cursor(0)[2] + 1
    if col < link_start or col > link_end then return end

    local link_text = line:sub(link_start + #"[[", link_end - #"]]")

    local note_name = link_text

    local alias_start, alias_end = link_text:find("|.-$")
    if alias_start and alias_end then
        note_name = link_text:sub(0, alias_start - 1)
    end

    edit_note(note_name)
end, { desc = "Edit note under cursor" })
map({ "n" }, "<leader>zn", function()
    vim.ui.input({ prompt = "Title: " }, function(input)
        if input then
            edit_note(input)
        end
    end)
end, { desc = "New note" })
map({ "v" }, "<leader>zn", function()
    local vstart, vend = vim.fn.getpos("v"), vim.fn.getpos(".")
    local visual_selection = vim.fn.getregion(vstart, vend, vim.empty_dict())
    local visual_selection_text = table.concat(visual_selection, "")

    vim.ui.input({ prompt = "Title: ", default = visual_selection_text }, function(input)
        if input then
            edit_note(input)
        end
    end)
end, { desc = "New note" })
map({ "n" }, "<leader>zd", function()
    local filepath = vim.fn.expand("%")
    if 1 ~= vim.fn.confirm("Remove file " .. filepath, "&Yes\n&No", 2) then
        return
    end
    local success, err = os.remove(filepath)
    if success then
        print "file deleted"
    else
        error(err)
    end
end, { desc = "Delete current file" })
-- zettelkasten end

local persistence = require "persistence"
persistence.setup()
map({ "n" }, "<leader>qs", persistence.load, { desc = "Load $PWD session" })
map({ "n" }, "<leader>qS", persistence.select, { desc = "Select session" })
map({ "n" }, "<leader>qd", persistence.stop, { desc = "Disable session save on quit" })
map({ "n" }, "<leader>qe", persistence.start, { desc = "Enable session save on quit" })

-- nvimdiff
if vim.opt.diff:get() then
    -- fix nvimdiff: https://github.com/neovim/neovim/issues/22696
    vim.o.diffopt = "internal,filler,closeoff"

    -- disable session autosave to prevent $PWD session pollution by nvimdiff
    persistence.stop()
end
map({ "n" }, "<leader>Qc", ":cq<cr>", { desc = "Abort git mergetool" })
map({ "n" }, "<leader>bo", ":diffget 1<cr>", { desc = "Accept ours" })
map({ "n" }, "<leader>bb", ":diffget 2<cr>", { desc = "Accept base" })
map({ "n" }, "<leader>bt", ":diffget 3<cr>", { desc = "Accept theirs" })
-- nvimdiff end

map({ "n" }, "<leader>sm", function()
    -- ~/.local/bin/dmconf replacement for MacOS
    local bmfiles_path = Path:new(vim.fn.expand("$HOME/.config/shell/bm-files"))
    bmfiles_path:mustExist()

    local filepaths = {}
    for line in bmfiles_path:read():gmatch("([^\n]+)") do
        local fields = {}
        for field in string.gmatch(line, "%S+") do
            table.insert(fields, field)
        end
        if #fields < 2 then
            error("line " .. #filepaths .. " is invalid: " .. line)
        end
        -- TODO: join enquoted paths with spaces from fields[2:] to single path
        table.insert(filepaths, vim.fn.expand(fields[2]))
    end

    builtin.find_files {
        find_command = { "echo", "-e", table.concat(filepaths, "\n") },
    }
end, { desc = "Fzf configs" })
