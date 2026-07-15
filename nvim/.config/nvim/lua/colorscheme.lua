-- require "onedark".setup { style = "deep" }
-- require "onedark".load()
vim.cmd("colorscheme alabaster")

-- tip: use :Inspect to see highlight groups under cursor
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

    -- give more priority for highlights groups from ^ above ^
    vim.highlight.priorities.semantic_tokens = 95
end
