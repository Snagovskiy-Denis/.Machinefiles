vim.g.nvim_tree_respect_buf_cwd = 1

require 'nvim-tree'.setup {
    update_cwd = true,
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
}



-- TODO: assign funcs
local function open ()
    require 'bufferline.state'.set_offset(31, 'FileTree')
    require 'nvim-tree'.find_file(true)
end

local function close ()
    require 'bufferline.state'.set_offset(0)
    require 'nvim-tree'.close()
end
