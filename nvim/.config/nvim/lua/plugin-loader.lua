local plugin_loader = {}

function plugin_loader:init ()
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

function plugin_loader:load (plugins)
    return self.packer.startup(function(use)
        for _, plugin in ipairs(plugins) do use(plugin) end
    end)
end

return plugin_loader
