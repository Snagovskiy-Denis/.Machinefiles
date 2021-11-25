local catppuccino = require('catppuccin')

catppuccino.setup(
    {
		colorscheme = 'neon_latte',
		transparency = false,
		term_colors = false,
		styles = {
			comments = 'italic',
			functions = 'italic',
			keywords = 'italic',
			strings = 'NONE',
			variables = 'NONE',
		},
		integrations = {
			treesitter = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = 'italic',
					hints = 'italic',
					warnings = 'italic',
					information = 'italic',
				},
				underlines = {
					errors = 'underline',
					hints = 'underline',
					warnings = 'underline',
					information = 'underline',
				}
			},
			lsp_trouble = false,
			lsp_saga = false,
			gitgutter = false,
			gitsigns = true,
			telescope = true,
			nvimtree = {
				enabled = true,
				show_root = false,
			},
			which_key = true,
			indent_blankline = {
				enabled = false,
				colored_indent_levels = false,
			},
			dashboard = true,
			neogit = false,
			vim_sneak = false,
			fern = false,
			barbar = true,
			bufferline = false,
			markdown = true,
			lightspeed = false,
			ts_rainbow = false,
			hop = false,
		}
	}
)


-- base16-colors base16-isotope base16-atelier-seaside base16-google-dark
vim.cmd[[colorscheme catppuccin]]
