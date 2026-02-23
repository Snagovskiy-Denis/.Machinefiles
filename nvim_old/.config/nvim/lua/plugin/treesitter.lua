require 'nvim-treesitter.configs'.setup {
    ensure_installed = {},
    ignore_install = {},
    highlights = {
        enable = true,
        disable = { 'latex' },
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true, disable = { 'python' } },
}
