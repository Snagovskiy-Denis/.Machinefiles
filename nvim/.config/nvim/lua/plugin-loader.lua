local plugin_loader = {}

function plugin_loader:init()
    -- Plugin loader bootstrapping and configring

    local package_root = vim.fn.stdpath 'data' .. '/site/pack'
    local install_path = package_root .. '/packer/start/packer.nvim'

    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system {
            'git', 'clone', '--depth', '1',
            'https://github.com/wbthomason/packer.nvim',
            install_path
        }
        vim.cmd 'packadd packer.nvim'
    end

    -- error handling: if can not import plugin manager then do nothing
    local packer_ok, packer = pcall(require, 'packer')
    if not packer_ok then return end

    -- configure packer
    packer.init {
        package_root = package_root,
        git = { clone_timeout = 300 },
        display = {
            open_fn = function()
                return require 'packer.util'.float { border = 'rounded' }
            end,
        }
    }

    self.packer = packer
    return self
end

function plugin_loader:load(plugins)
    return self.packer.startup(function(use)
        for _, plugin in ipairs(plugins) do use(plugin) end
    end)
end

-- function plugin_loader:init()
--     local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
--     if not (vim.uv or vim.loop).fs_stat(lazypath) then
--         local lazyrepo = "https://github.com/folke/lazy.nvim.git"
--         local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
--         if vim.v.shell_error ~= 0 then
--             vim.api.nvim_echo({
--                 { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
--                 { out,                            "WarningMsg" },
--                 { "\nPress any key to exit..." },
--             }, true, {})
--             vim.fn.getchar()
--             os.exit(1)
--         end
--     end
--     vim.opt.rtp:prepend(lazypath)
--     return self
-- end

-- function plugin_loader:load(plugins)
--     require("lazy").setup("plugins")
-- end

return plugin_loader
