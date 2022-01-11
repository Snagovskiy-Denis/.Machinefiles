null_ls = require 'null-ls'

null_ls.setup{
    sources = {
        null_ls.builtins.formatting.yapf,      -- python
        null_ls.builtins.formatting.prettier,  -- js, html+css, md
        null_ls.builtins.formatting.shfmt,     -- shell
    }
}
