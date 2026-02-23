-- General helping functions
local M = {}


-- Auto-open new split if move to non-existing one
function WinMove (key)
    -- Aliases
    local get_window_number = vim.api.nvim_win_get_number
    local exec = vim.api.nvim_command

    local current_window = get_window_number(0)  -- 0 means current win
    exec('wincmd ' .. key)
    if current_window == get_window_number(0) then
        if key == 'j' or key == 'k' then
            exec 'wincmd s'
        else
            exec 'wincmd v'
        end
        exec('wincmd ' .. key)
    end
end
