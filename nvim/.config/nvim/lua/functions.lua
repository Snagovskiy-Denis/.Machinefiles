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


function M:open_file_in_zettelkasten_directory (filename, create_new)
    local zettelkasten = os.getenv 'ZETTELKASTEN'
    if zettelkasten == nil then error 'ZETTELKASTEN env var is unset' end

    -- auto-add .md extension before :edit command
    if not filename:find('.md$') then filename = filename .. '.md' end

    local cmd = create_new and 'edit ' or 'find '
    cmd = cmd .. vim.fn.fnameescape(zettelkasten .. filename)

    local ok = pcall(vim.api.nvim_command, cmd)
    if not ok then print ' - no such file'; return end

    vim.api.nvim_command('cd ' .. zettelkasten)
end


-- Insert wiki-link to it in current buffer under cursor
-- and edit new file in zettelkasten directory if is true
function NewZettelkastenLink (edit_file)
    local function insert_link_under_cursor (filename)
        filename = filename:gsub('.md$', '')
        local link = string.format(' [[%s]]', filename)  -- note leading space

        local pos = vim.api.nvim_win_get_cursor(0)[2]
        local line = vim.api.nvim_get_current_line()
        local new_line = line:sub(0, pos) .. link .. line:sub(pos + 1)
        vim.api.nvim_set_current_line(new_line)
    end
    local function insert_template_in_current_buffer (string_template)
        -- splits registers string into array of strings
        -- and pastes it to current buffer
        local template_lines = {}
        local sep = '\n'
        local line_pattern = string.format('([^%s]*)%s', sep, sep)  -- '([^%s]+)%s' to exclude blank lines
        for line in (string_template .. sep):gmatch(line_pattern) do
            table.insert(template_lines, line)
        end
        vim.api.nvim_buf_set_lines(0, 0, vim.api.nvim_buf_line_count(0), false, template_lines)
    end

    local filename = vim.fn.input('File: ', '', 'file')
    if filename == '' then return end

    insert_link_under_cursor(filename)

    if not edit_file then return end

    M:open_file_in_zettelkasten_directory(filename, true)

    local new_file_template = vim.fn.getreg('h')
    insert_template_in_current_buffer(new_file_template)
    vim.api.nvim_win_set_cursor(0, { #template_lines, 0 })  -- goto last line
end


-- Follow by wiki-link that was extracted by alacritty regex hint
function FollowZettelkastenLinkAlacritty ()
    local function format_filename (name)
        -- supposed input format (yaml regex): "\\[\\[[^\\]]+\\]\\]"
        if not name:find('^%[%[.*%]%]$') then
            error "Clipboard link isn't contain square brackets"
        end
        return (name:sub(3, -3)):gsub('|.*$', '') .. '.md'
    end

    local unformatted_filename = vim.fn.getreg('+')
    if unformatted_filename == nil then print 'clipboard is empty'; return end

    local ok, filename = pcall(format_filename, unformatted_filename)
    if not ok then print(filename); return end

    M:open_file_in_zettelkasten_directory(filename, false)
end


-- List all wiki-links in the current buffer,
-- accept user input to which link to open,
-- and open the requested link
function FollowZettelkastenLink (input)
    local buf_content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)

    local links = {}
    for _, line in pairs(buf_content) do
        for link in line:gmatch('%[%[.-%]%]') do
            -- remove link markup
            link = link:sub(3, -3)
            link = link:gsub('|.*$', '')  -- wiki-link alias syntax
            table.insert(links, link)
        end
    end
    if next(links) == nil then print 'No [[links]] in buffer'; return end

    if type(input) ~= 'number' then
        print 'Open link with number'
        for index, link in ipairs(links) do
            print(string.format('%s: %s', index, link))
        end

        repeat
            input = vim.fn.input('Number: ', '')
            if input == '' then return end
            input = tonumber(input) or 0
            if input < 0 then input = #links + 1 + input end
        until links[input] ~= nil
    end

    local filename = links[input]
    M:open_file_in_zettelkasten_directory(filename, false)
end
