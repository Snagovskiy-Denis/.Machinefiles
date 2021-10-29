local M = {}

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
    --require 'plugin.cmp-config'  -- autocompletion is included in plugin.init

    M.rise_ui ()

    require 'lsp.null-ls'.setup ()

    local lsp_settings_status_ok, lsp_settings = pcall(require, 'nlspsettings')
    if lsp_settings_status_ok then
        lsp_settings.setup {}
    end


    -- activate servers
    -- TODO activate through autocommands if needed
    local language_servers_files = {
        'lsp.ls.bash-ls',
        'lsp.ls.javascript-ls',
        'lsp.ls.json-ls',
        'lsp.ls.lua-ls',
        'lsp.ls.python-ls',
    }
    for _, path in ipairs(language_servers_files) do require(path) end
end


return M
