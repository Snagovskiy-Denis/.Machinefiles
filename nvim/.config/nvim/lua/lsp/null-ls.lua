local null_ls = require 'null-ls'

local formatting = null_ls.builtins.formatting
local diagnostic = null_ls.builtins.diagnostics
local code_action = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion
local hover = null_ls.builtins.hover

null_ls.setup {
    sources = {
        code_action.shellcheck,
        -- code_action.refactoring,

        diagnostic.shellcheck,

        -- formatting.autopep8,  -- python
        formatting.prettier,  -- js, html+css, md
        formatting.shfmt,     -- shell
    }
}
