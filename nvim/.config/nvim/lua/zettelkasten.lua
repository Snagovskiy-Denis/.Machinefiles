-- markdown and configs management stuff
local Path = require "plenary.path"

local builtin = require "telescope.builtin"

function Path:must_exist()
    if not self:exists() then
        error(string.format("path doesn't exist: %s", tostring(self)))
    end
end

function Path:Zettelkasten()
    local vault = Path:new(vim.fn.expand("$ZETTELKASTEN"))
    vault:must_exist()
    return vault
end

local function edit_note(name)
    local vault = Path:Zettelkasten()
    local template = vault / "Templates" / "Mine Моё.md"
    template:must_exist()
    local targetDir = vault / "Z" -- TODO: do not hardcode Z dir exactly, use find to find dir
    targetDir:must_exist()

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

vim.keymap.set({ "n" }, "<leader>cz", '<cmd>cd $ZETTELKASTEN<cr><cmd>:pwd<cr>', { desc = "cd to Vault" })
vim.keymap.set({ "n", }, "<leader>zf", function()
    local vault = tostring(Path:Zettelkasten())
    builtin.find_files {
        cwd = vault,
        sorter = require("telescope.sorters").get_generic_fuzzy_sorter(), -- support utf chars case insensitivity
    }
    vim.api.nvim_set_current_dir(vault)
end, { desc = "Find notes" })
vim.keymap.set({ "n" }, "<leader>zt", function()
    local vault = tostring(Path:Zettelkasten())
    builtin.live_grep { cwd = vault }
    vim.api.nvim_set_current_dir(vault)
end, { desc = "Grep notes" })

vim.keymap.set({ "n" }, "<leader>zz", function()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1
    local search_start = 1

    ::search::
    local link_start, link_end = line:find("%[%[.-%]%]", search_start)

    -- no matches
    if not link_start or not link_end then return end

    -- search for a next match
    if col < link_start or col > link_end then
        search_start = link_end
        goto search
    end

    local link_text = line:sub(link_start + #"[[", link_end - #"]]")

    local note_name = link_text

    if link_text:find("|.-|.-$") then
        vim.notify("invalid wiki-link: contains more than 1 alias", vim.log.levels.ERROR)
        return
    end

    local alias_start, alias_end = link_text:find("|.-$")
    if alias_start and alias_end then
        note_name = link_text:sub(0, alias_start - 1)
    end

    edit_note(note_name)
end, { desc = "Edit note under cursor" })
vim.keymap.set({ "n" }, "<leader>zn", function()
    vim.ui.input({ prompt = "Title: " }, function(input)
        if input then
            edit_note(input)
        end
    end)
end, { desc = "New note" })
vim.keymap.set({ "n" }, "<leader>zd", function()
    local filepath = vim.fn.expand("%")
    if 1 ~= vim.fn.confirm("Remove file " .. filepath, "&Yes\n&No", 2) then
        return
    end
    local success, err = os.remove(filepath)
    if success then
        vim.notify("file deleted", vim.log.levels.INFO)
    else
        error(err)
    end
end, { desc = "Delete current file" })


vim.keymap.set({ "n" }, "<leader>sm", function()
    -- ~/.local/bin/dmconf replacement for MacOS
    local bookmarks_sources = {}
    for _, str_path in pairs({ "$HOME/.config/shell/bm-files", "$HOME/.config/shell/bm-dirs" }) do
        local path = Path:new(vim.fn.expand(str_path))
        path:must_exist()
        table.insert(bookmarks_sources, path)
    end

    local bookmarks = {}
    for _, bookmark_source in pairs(bookmarks_sources) do
        local filepaths = {}
        for line in bookmark_source:read():gmatch("([^\n]+)") do
            if line:sub(1, 1) == "#" then
                goto continue
            end

            local fields = {}
            for field in line:gmatch("%S+") do
                if #fields < 2 then
                    table.insert(fields, field)
                else
                    fields[2] = fields[2] .. field
                end
            end

            if #fields < 2 then
                vim.notify("file " ..
                tostring(bookmark_source) .. " is invalid: line " .. #filepaths .. " has no filepath: " .. line)
                return
            end

            table.insert(filepaths, vim.fn.expand(fields[2]))
            ::continue::
        end

        for _, filepath in pairs(filepaths) do
            table.insert(bookmarks, filepath)
        end
    end

    local bookmarks_string = table.concat(bookmarks, "\n")
    builtin.find_files { find_command = { "echo", "-e", bookmarks_string } }
end, { desc = "Fzf configs" })
