-- show current keymap if it is not english
local function keymap ()
    if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
        return '⌨ ' .. string.upper(vim.b.keymap_name)
    end
    return ''
end


require 'lualine'.setup {
    sections = {
        lualine_a = { 'mode', keymap },
    },
}
