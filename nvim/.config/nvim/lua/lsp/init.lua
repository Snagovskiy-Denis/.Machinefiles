-- Install language servers function
require 'lsp.utils'

local M = {}

local server_configs = {
    cssls = {
        capabilities = (function ()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            return capabilities
        end)(),
    },
    html = {
        capabilities = (function ()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            return capabilities
        end)(),
        filetypes = {
            'html',
            'javascript',
            'css',
        },
    },
}

function M.rise_ui ()
    local border = {
          {"🭽", "FloatBorder"},
          {"▔", "FloatBorder"},
          {"🭾", "FloatBorder"},
          {"▕", "FloatBorder"},
          {"🭿", "FloatBorder"},
          {"▁", "FloatBorder"},
          {"🭼", "FloatBorder"},
          {"▏", "FloatBorder"},
    }

    vim.lsp.protocol.CompletionItemKind = require 'lsp.kinds'

    -- function on_attach (client, bufnr)
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { border = border, })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, { border = border, })

    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
    })

    local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

    for type, icon in pairs(signs) do
        local hl = "LspDiagnosticsSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
end

function M.setup ()
    M.rise_ui ()

    -- Activate servers
    -- local lsp_installer = require('nvim-lsp-installer')
    -- lsp_installer.on_server_ready(function(server)
    --     local opts = {}
    --     if server_configs[server.name] then
    --         opts = server_configs[server.name]
    --     end
    --     server:setup(opts)
    -- end)

    -- Activate servers
    require 'plugin.mason'

    local lsp_setuper = require 'mason-lspconfig'
    lsp_setuper.setup()
    lsp_setuper.setup_handlers {
        function (server)
            require('lspconfig')[server].setup {}
        end,
    }
    require 'lsp.null-ls'
end


return M
