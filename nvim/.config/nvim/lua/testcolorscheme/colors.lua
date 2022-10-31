local M = {}

function M.setup()
    -- config = config or require 'testcolorscheme.config'

    -- Color Palette
    local colors = {}

    colors = {
        none = 'NONE',

        white = '#ffffff',
        gray_1 = '#1a1a1a',
        gray_2 = '#2e373e',
        gray_3 = '#3a3a3a',
        gray_4 = '#5a5a5a',
        gray_5 = '#767c88',
        gray_6 = '#8b8a7c',
        gray_7 = '#8787af',
        black = '#000000',

        eggshell = '#ffffcd',
        mauve = '#e4dfff',
        blue = '#0088ff',
        teal = '#40e0d0',
        magenta = '#c526ff',
        burgundy = '#5f2a5f',
        red_1 = '#d70061',
        red_2 = '#ff005f',
        orange = '#ff9d00',
        sun = '#ffdd00',
        yellow = '#ffff00',
        pink = '#f9e0f5',
        green = '#5ff967',
        cobalt_1 = '#306b8f',
        cobalt_2 = '#445291',

        -- git = { change = '#6183bb', add = '#449dab', delete = '#914c54', conflict = '#bb7a61' },
        -- gitSigns = { add = '#164846', change = '#394b70', delete = '#823c41' },
    }

    return colors
end

return M
