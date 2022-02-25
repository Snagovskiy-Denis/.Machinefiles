-- self@machine .vimrc
--

require 'bootstrap':init ()
require 'plugin-loader':load { require 'plugins' }

require 'lsp'.setup ()

require 'config':init ()

require 'functions'

require 'keymappings'.setup ()

require 'colorscheme'

--
