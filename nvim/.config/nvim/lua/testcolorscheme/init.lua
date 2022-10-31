local theme = require 'testcolorscheme.theme'


if vim.g.colors_name then
  vim.cmd('hi clear')
end

vim.o.termguicolors = true
vim.g.colors_name = 'testcolorscheme'

for _, colors in pairs(theme) do
    for group, color in pairs(colors) do
      -- local style = color.style and 'gui=' .. color.style or 'gui=NONE'
      local fg = color.fg and 'guifg=' .. color.fg or 'guifg=NONE'
      local bg = color.bg and 'guibg=' .. color.bg or 'guibg=NONE'
      -- local sp = color.sp and 'guisp=' .. util.getColor(color.sp) or ''

      -- local hl = 'highlight ' .. group .. ' ' .. style .. ' ' .. fg .. ' ' .. bg .. ' ' .. sp
      local hl = 'highlight ' .. group .. ' ' .. fg .. ' ' .. bg
      vim.cmd(hl)
    end
end

theme:setup()
