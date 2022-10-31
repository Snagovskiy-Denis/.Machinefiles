local colors = require 'testcolorscheme.colors'


local M = {}


function M.setup()
    -- config = config or require 'testcolorscheme.config'

    local theme = {}
    theme.config = config
    theme.colors = colors.setup()
    local c = theme.colors

    theme.base = {
        Normal = { fg = c.white, bg = c.black },  -- normal text

        StatusLine = { fg = c.magenta, bg = c.gray_2 }, -- status line of current window
        StatusLineNC = { fg = c.gray_7, bg = c.gray_2 }, -- status lines of not-current windows
        WildMenu = { fg = c.none, bg = c.gray_7 }, -- current match in 'wildmenu' completion

        Cursor = { fg = c.black, bg = c.mauve }, -- character under the cursor
        lCursor = { fg = c.black, bg = c.mauve }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
        CursorIM = { fg = c.black, bg = c.mauve }, -- like Cursor, but used when in IME mode |CursorIM|
        CursorColumn = { fg = c.none, bg = c.gray_1 }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
        CursorLine = { fg = c.none, bg = c.gray_1 }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
        CursorLineNr = { fg = c.yellow, bg = c.none }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.

        Debug = { fg = c.gray_6, bg = c.none }, -- debugging statement

        DiffAdd = { fg = c.none, bg = c.gray_3 }, -- diff mode: Added line |diff.txt|
        DiffChange = { fg = c.eggshell, bg = c.cobalt_1 }, -- diff mode: Changed line |diff.txt|
        DiffDelete = { fg = c.red_2, bg = c.none }, -- diff mode: Deleted line |diff.txt|
        DiffRemoved = { fg = c.red_2, bd = c.none }, -- diff mode
        DiffText = { fg = c.eggshell, bg = c.burgundy }, -- diff mode: Changed text within a changed line |diff.txt|

        Directory = { fg = c.magenta, bg = c.none }, -- directory names (and other special names in listings)
        FoldColumn = { fg = c.gray_1, bg = c.gray_7, style = 'italic' }, -- 'foldcolumn'
        Folded = { fg = c.gray_1, bg = c.gray_7, style = 'italic' }, -- line used for closed folds

        IncSearch = { fg = c.white, bg = c.blue }, -- 'incsearch' highlighting; also used for the text replaced with ':s///c'

        LineNr = { fg = c.gray_7, bg = c.black }, -- Line number for ':number' and ':#' commands, and when 'number' or 'relativenumber' option is set.

        ErrorMsg = { fg = c.red_2, bg = c.none }, -- error messages on the command line
        MoreMsg = { fg = c.pink, bg = c.gray_2 }, -- |more-prompt|
        WarningMsg = { fg = c.yellow, bg = c.black }, -- warning messages
        NonText = { fg = c.gray_5, bg = c.none }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.


        Pmenu = { fg = c.white, bg = c.gray_2 }, -- Popup menu: normal item.
        PmenuSel = { fg = c.white, bg = c.red_1 }, -- Popup menu: selected item.
        PmenuSbar = { fg = c.none, bg = c.gray_2 }, -- Popup menu: scrollbar.
        PmenuThumb = { fg = c.none, bg = c.cobalt_1 }, -- Popup menu: Thumb of the scrollbar.
        Question = { fg = c.pink, bg = c.gray_2 }, -- |hit-enter| prompt and yes/no questions
        Search = { fg = c.white, bg = c.blue }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.

        SignColumn = { fg = c.gray_1, bg = c.black }, -- column where |signs| are displayed
        -- SignColumnSB = {}, -- column where |signs| are displayed

        TabLine = { fg = c.magenta, bg = c.gray_2 }, -- tab pages line, not active tab page label
        TabLineFill = { fg = c.white, bg = c.gray_2 }, -- tab pages line, where there are no labels
        TabLineSel = { fg = c.white, bg = c.magenta, style = 'bold' }, -- tab pages line, active tab page label
        Title = { fg = c.white, bg = c.none }, -- titles for output from ':set all', ':autocmd' etc.
        Visual = { fg = c.gray_1, bg = c.mauve }, -- Visual mode selection

        VisualNOS = { fg = c.magenta, bg = c.black }, -- Visual mode selection when vim is 'Not Owning the Selection'.
        VertSplit = { fg = c.magenta, bg = c.black }, -- the column separating vertically split windows
    }

    return theme
end


return M
