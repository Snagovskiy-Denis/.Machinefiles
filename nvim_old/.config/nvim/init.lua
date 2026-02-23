-- self@machine .vimrc
--

local plugin_loader = require 'plugin-loader':init ()
plugin_loader:load { require 'plugins' }

require 'lsp'.setup ()

require 'config':init ()

require 'functions'

require 'keymappings'.setup ()

require 'colorscheme'

--
