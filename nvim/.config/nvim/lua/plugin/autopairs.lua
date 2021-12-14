local autopairs = require 'nvim-autopairs'

autopairs.setup {
    check_ts = true,
    ts_config = {
        lua = { 'string' },
        javascript = { 'template_string' },
        java = false,
    },
    fast_wrap = {},  -- Unpaired char + <M-e> + $ or q
}
autopairs.setup {
    fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
        offset = 0, -- Offset from pattern match
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        hightlight = 'Search'
    }
}


-- Additional rules
local Rule = require 'nvim-autopairs.rule'
--local cond = require 'nvim-autopairs.conds'
-- Insert multi-line quotes if press <tab> after two single/double quotes
autopairs.add_rules({
    Rule([['']], '', 'python')
        :use_regex(true, "<tab>")
        :replace_endpair(function () return [[''''<esc>2hi]] end),
    Rule([[""]], '', 'python')
        :use_regex(true, "<tab>")
        :replace_endpair(function () return [[""""<esc>2hi]] end),
    }
)



--require 'nvim-treesitter.configs'.setup { autopairs = { enable = true } }
