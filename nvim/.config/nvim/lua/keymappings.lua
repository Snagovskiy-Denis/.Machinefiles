local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
    insert_mode = generic_opts_any,
    normal_mode = generic_opts_any,
    visual_mode = generic_opts_any,
    visual_block_mode = generic_opts_any,
    command_mode = generic_opts_any,
    term_mode = { silent = true },
}

local mode_adapters = {
    insert_mode = 'i',
    normal_mode = 'n',
    visual_mode = 'v',
    visual_block_mode = 'x',
    term_mode = 't',
    command_mode = 'c',
}


vim.g.mapleader = ','
local keymaps = {
    insert_mode = {
        -- Move text
        -- ['<A-j>'] = '<Esc>:m .+1<CR>==a',
        -- ['<A-k>'] = '<Esc>:m .-2<CR>==a',

        -- Switch layout
        ['<C-f>'] = '<C-^>',
    },
    normal_mode = {
        -- Split move
        ['<C-h>'] = ':lua WinMove("h")<CR>',
        ['<C-j>'] = ':lua WinMove("j")<CR>',
        ['<C-k>'] = ':lua WinMove("k")<CR>',
        ['<C-l>'] = ':lua WinMove("l")<CR>',

        -- Window resizing
        ['<M-Left>'] = ':vertical resize -2<CR>',
        ['<M-Right>'] = ':vertical resize +2<CR>',
        ['<M-Down>'] = ':resize -2<CR>',
        ['<M-Up>'] = ':resize +2<CR>',

        -- Behave Vim
        ['Y'] = 'y$',

        -- Switch buffer
        ['<S-l>'] = ':BufferNext<CR>',
        ['<S-h>'] = ':BufferPrevious<CR>',
        ['<C-p>'] = ':BufferPick<CR>',  -- buffer easy motion

        -- Switch layout
        ['<C-f>'] = 'a<C-^><Esc>',

        -- Harpoon
        ['<C-e>'] = ':lua require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())<CR>',
        -- ['<C-e>'] = ':lua require("plugin.harpoon"):toggle_telescope(require("harpoon"):list())<CR>',

        ['<C-n>'] = ':lua require("harpoon"):list():select(1)<CR>',
        ['<C-m>'] = ':lua require("harpoon"):list():select(2)<CR>',
        ['<C-s>'] = ':lua require("harpoon"):list():select(3)<CR>',
        -- ['<C-i>'] = ':lua require("harpoon"):list():select(4)<CR>',

        ['<C-S-P'] = ':lua require("harpoon"):list():prev()<CR>',
        ['<C-S-N'] = ':lua require("harpoon"):list():next()<CR>',
    },
    visual_mode = {
        -- Move text
        -- ['<A-j>'] = [[:m '>+1<CR>gv=gv]],
        -- ['<A-k>'] = [[:m '<-2<CR>gv=gv]],

        -- Switch layout
        ['<C-f>'] = '<Esc>a<C-^><Esc>gv',
    },
    visual_block_mode = {
        -- Switch layout
        ['<C-f>'] = '<Esc>a<C-^><Esc>gv',
    },
    term_mode = {
        -- Exit terminal mode
        ['<C-\\>'] = '<C-\\><C-n>',
    },
    command_mode = {
        -- Switch layout
        ['<C-f>'] = '<C-^>',
        ['<C-k>'] = '<C-p>',
        ['<C-j>'] = '<C-n>',
    },
}


function M.set_keymaps (mode, key, value)
    local opt = generic_opts[mode] and generic_opts[mode] or generic_opts_any

    if type(value) == 'table' then
        opt = value[2]
        value = value[1]
    end

    vim.api.nvim_set_keymap(mode, key, value, opt)
end

-- Non-leader maps are located here.
-- Leader maps >> plugin/which-key
function M.setup ()
    for mode, keymap in pairs(keymaps) do
        mode = mode_adapters[mode] and mode_adapters[mode] or mode
        for key, value in pairs(keymap) do
            M.set_keymaps(mode, key, value)
        end
    end
end

return M
