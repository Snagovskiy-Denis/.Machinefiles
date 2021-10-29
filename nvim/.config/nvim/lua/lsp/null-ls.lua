local M = {}

function M.setup ()
    local null_ls = require 'null-ls'

    local sources = {
        null_ls.builtins.formatting.yapf,      -- python
        null_ls.builtins.formatting.prettier,  -- js, html+css, md
        null_ls.builtins.formatting.shfmt,     -- shell
    }
    null_ls.config({ sources = sources })

    require('lspconfig')['null-ls'].setup { }
end

return M
