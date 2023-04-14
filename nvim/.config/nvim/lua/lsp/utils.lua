function Install_language_servers ()
    local servers = {
        'bashls',
        'cssls',
        'denols',
        'dockerls',
        'eslint',
        'hls',
        'html',
        ---- 'jedi_language_server',
        'jsonls',
        'ltex',
        -- 'pylsp',
        'quick_lint_js',
        --'remark_ls',
        'spectral',
        'sqlls',
        'sqls',
        'stylelint_lsp',
        'lua_ls',
        'tailwindcss',
        'texlab',
        'vuels',
        'zeta_note',
        'zk',
    }

    -- for _, server in pairs(servers) do
    --     vim.api.nvim_command('LspInstall ' .. server)
    -- end
end
