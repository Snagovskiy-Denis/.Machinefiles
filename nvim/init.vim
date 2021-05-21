"=============================================================================
"          
"           /\/|____      _  __             _                    
"          |/\/  ___|    | |/ _|           (_)                   
"             \ `--.  ___| | |_      __   ___ _ __ ___  _ __ ___ 
"              `--. \/ _ \ |  _|     \ \ / / | '_ ` _ \| '__/ __|
"             /\__/ /  __/ | |        \ V /| | | | | | | | | (__ 
"             \____/ \___|_|_|       (_)_/ |_|_| |_| |_|_|  \___|
"          
"=============================================================================
" Общие базовые настройки (без категории)
syntax enable
set number relativenumber
set splitbelow splitright
set clipboard=unnamedplus  " Интеграция с системным буфером обмена
set mouse=nv  " Поддержка мыши

set scrolloff=7 " Между курсором и концом экрана 7 строк, иначе двигай экран

" Настройка табов согласно python-рекомендации
set tabstop=4
set softtabstop=4
set smarttab
set shiftwidth=4
set expandtab
set autoindent  " Автоотступ


" Поддержка русского языка
set keymap=russian-jcukenwin  " включить встроенную поддержку; см. remapping
set iminsert=0 " На старте ввод на английском, а не русском
set imsearch=0 " На старте поиск на английском, а не русском


"=============================================================================
"       _     _     _            __         _             _           
"      | |   (_)   | |          / _|       | |           (_)          
"      | |    _ ___| |_    ___ | |_   _ __ | |_   _  __ _ _ _ __  ___ 
"      | |   | / __| __|  / _ \|  _| | '_ \| | | | |/ _` | | '_ \/ __|
"      | |___| \__ \ |_  | (_) | |   | |_) | | |_| | (_| | | | | \__ \
"      \_____/_|___/\__|  \___/|_|   | .__/|_|\__,_|\__, |_|_| |_|___/
"                                    | |             __/ |            
"                                    |_|            |___/             
"=============================================================================
function! PlugInit() abort
    packadd minpac

    if !exists('g:loaded_minpac')
        echo "Minpac package is not installed. \
              Plugin-less environment is used"
    else
        call minpac#init()
        call minpac#add('k-takata/minpac', {'type': 'opt'})

        call minpac#add('jiangmiao/auto-pairs')
        call minpac#add('preservim/nerdtree')
        call minpac#add('preservim/nerdcommenter')
        call minpac#add('vim-airline/vim-airline-themes')

        call minpac#add('vim-airline/vim-airline')
        call minpac#add('ryanoasis/vim-devicons')

        call minpac#add('fnune/base16-vim')
    endif
endfunction
"=============================================================================
"     ______ _             _                  _   _   _                 
"     | ___ \ |           (_)                | | | | (_)                
"     | |_/ / |_   _  __ _ _ _ __    ___  ___| |_| |_ _ _ __   __ _ ___ 
"     |  __/| | | | |/ _` | | '_ \  / __|/ _ \ __| __| | '_ \ / _` / __|
"     | |   | | |_| | (_| | | | | | \__ \  __/ |_| |_| | | | | (_| \__ \
"     \_|   |_|\__,_|\__, |_|_| |_| |___/\___|\__|\__|_|_| |_|\__, |___/
"                     __/ |                                    __/ |    
"                    |___/                                    |___/     
"=============================================================================
" General apperance
set termguicolors
colorscheme base16-spacemacs

"----------------------------------------------------------------------------"
" NERDCommenter / 'preservim/nerdcommenter'
nmap <C-_> <Plug>NERDCommenterToggle
vmap <C-_> <Plug>NERDCommenterToggle<CR>gv

"----------------------------------------------------------------------------"
" NERDTree / 'preservim/nerdtree'
let NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI = 1
nmap <C-N> :NERDTreeToggle<CR>

"----------------------------------------------------------------------------"
" vim-airline / 'vim-airline/vim-airline' & vim-ariline-themes
" Better status line
let g:airline_theme = 'base16_spacemacs'

let g:airline_powerline_fonts = 1
let g:airline_section_z = "\ue0a1:%l/%L : %c"
let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'

let g:airline#extensions#keymap#label = ""
let g:airline#extensions#keymap#short_codes = {'russian-jcukenwin': 'RU'}
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#term#enabled = 0

"=============================================================================
"                 ______                _   _                 
"                 |  ___|              | | (_)                
"                 | |_ _   _ _ __   ___| |_ _  ___  _ __  ___ 
"                 |  _| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
"                 | | | |_| | | | | (__| |_| | (_) | | | \__ \
"                 \_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
"
"=============================================================================
" Управление окнами
"
"     <C-[hjkl]> вместо <C-w> <C-[hjkl]>
"     При отсутствии окна в которое можно переместиться:
"         - <С-[hl]> = <C-w><C-v> <C-w><C-[hl]>
"         - <C-[jk]> = <C-w><C-s> <C-w><C-[jk]>
"
function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

"=============================================================================
"            _____                                           _     
"           /  __ \                                         | |    
"           | /  \/ ___  _ __ ___  _ __ ___   __ _ _ __   __| |___ 
"           | |    / _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` / __|
"           | \__/\ (_) | | | | | | | | | | | (_| | | | | (_| \__ \
"            \____/\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|___/
"=============================================================================
" Управление плагинами:
"
"   Установить или обновить
"   Удалить неиспользуемые
"   Просмотреть статус
"
command! PlugUpdate source $MYVIMRC | call PlugInit() | call minpac#update()
command! PlugClean  source $MYVIMRC | call PlugInit() | call minpac#clean()
command! PlugStatus packadd minpac | call minpac#status()

"=============================================================================
"           ______                                 _             
"           | ___ \                               (_)            
"           | |_/ /___ _ __ ___   __ _ _ __  _ __  _ _ __   __ _ 
"           |    // _ \ '_ ` _ \ / _` | '_ \| '_ \| | '_ \ / _` |
"           | |\ \  __/ | | | | | (_| | |_) | |_) | | | | | (_| |
"           \_| \_\___|_| |_| |_|\__,_| .__/| .__/|_|_| |_|\__, |
"                                     | |   | |             __/ |
"                                     |_|   |_|            |___/ 
"=============================================================================
" Установить сочетание клавиш для выхода из терминала
tnoremap <C-\> <C-\><C-n>
map <Leader>tt :new term://bash<CR>
"              :vnew для вертикального split

" Управление splits при помощи функции WinMove
map <silent> <C-h> :call WinMove('h')<CR>
map <silent> <C-j> :call WinMove('j')<CR>
map <silent> <C-k> :call WinMove('k')<CR>
map <silent> <C-l> :call WinMove('l')<CR>

" Управление размером split
map <silent> <C-Left> :vertical resize +3 <CR>
map <silent> <C-Right> :vertical resize -3 <CR>
map <silent> <C-Up> :resize +3 <CR>
map <silent> <C-Down> :resize -3 <CR>

" Переключение раскладки
cmap <silent> <C-F> <C-^>
imap <silent> <C-F> <C-^>
nmap <silent> <C-F> a<C-^><Esc>
vmap <silent> <C-F> <Esc>a<C-^><Esc>gv
