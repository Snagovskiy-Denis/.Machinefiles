-- Setup luasnip
-- local luasnip = require 'luasnip'

-- Setup nvim-cmp
local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function (args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
    completion = {
        keyword_length = 1,
    },
    experimental = {
        ghost_text = true,
        native_menu = false,
    },
    formatting = {
      format = function(entry, vim_item)
        local icons = require 'lsp.kinds'
        vim_item.kind = icons[vim_item.kind]
        vim_item.menu = ({
          nvim_lsp = '(LSP)',
          emoji = '(Emoji)',
          path = '(Path)',
          calc = '(Calc)',
          cmp_tabnine = '(Tabnine)',
          vsnip = '(Snippet)',
          luasnip = '(Snippet)',
          buffer = '(Buffer)',
        })[entry.source.name]
        vim_item.dup = ({
          buffer = 1,
          path = 1,
          nvim_lsp = 0,
        })[entry.source.name] or 0
        return vim_item
      end,
    },
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = function(fallback)
          if cmp.visible() then
              cmp.select_next_item()
          else
            fallback()
          end
        end,
        ['<S-Tab>'] = function(fallback)
          if cmp.visible() then
              cmp.select_next_item()
          else
            fallback()
          end
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'calc' },
    },
}
