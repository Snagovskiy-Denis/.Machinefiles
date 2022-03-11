local actions = require 'telescope.actions'
require 'telescope'.load_extension 'projects'

-- TODO: further configurations
require 'telescope'.setup {
    defaults = {
        prompt_prefix = ' ',
        selection_caret = ' ',
        entry_prefix = '  ',
        layout_config = {
          width = 0.75,
          prompt_position = 'bottom',
          preview_cutoff = 120,
          horizontal = { mirror = false },
          vertical = { mirror = false },
        },

        mappings = {
            i = {
                ['<C-j>'] = actions.cycle_history_next,
                ['<C-k>'] = actions.cycle_history_prev,
                ['<C-c>'] = actions.close,
            },
        },

        file_ignore_patterns = {
            'venv',
        },
    },

    pickers = {
        find_files = {
            follow = true,  -- follow symlinks
        },
    },
}


-- TODO: new dmconf picker?
