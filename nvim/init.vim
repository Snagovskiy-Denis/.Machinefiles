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

set encoding=UTF-8
set fileencodings=utf-8,cp1251
set number relativenumber
syntax enable
set scrolloff=7 " Экран начинает двигаться, когда остаётся 7 строк до курсора"

" Настройка табов согласно python-рекомендации:
    set tabstop=4
    set softtabstop=4
    set smarttab
    set shiftwidth=4
    set expandtab
    set autoindent  " Автоотступ

set keymap=russian-jcukenwin  " встроенная поддержка русского языка
set iminsert=0 " Чтобы при старте ввод был на английском, а не русском
set imsearch=0 " Чтобы при старте поиск был на английском, а не русском

set clipboard=unnamedplus  " Интеграция с системным буфером обмена
set mouse=nv  " Поддержка мыши

set cpoptions+=$  " Добавить знак '$' в то место, где происходит замена

" Использовать глобальный интерпретатор python для Neovim, вместо venv
" Это позволит не устанавливать pynvim пакет в каждую venv
" Пока не буду добавлять (т.к. установил пакет через pacman), но в теории:
" let g:python3_host_prog = ''

"=============================================================================
"               ______ _              ______            _       
"               | ___ \ |             | ___ \          (_)      
"               | |_/ / |_   _  __ _  | |_/ / ___  __ _ _ _ __  
"               |  __/| | | | |/ _` | | ___ \/ _ \/ _` | | '_ \ 
"               | |   | | |_| | (_| | | |_/ /  __/ (_| | | | | |
"               \_|   |_|\__,_|\__, | \____/ \___|\__, |_|_| |_|
"                               __/ |              __/ |        
"                              |___/              |___/         
"=============================================================================
"
call plug#begin('~/.local/share/nvim/plugged')
" so %; PlugInstall

"Plug 'lyokha/vim-xkbswitch'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'jmcantrell/vim-virtualenv'

Plug 'vim-airline/vim-airline'  " Красивая панель состояния
Plug 'ryanoasis/vim-devicons'  " Иконки для панели состояний, nordtree etc.

Plug 'fnune/base16-vim'  " Цветовые схемы

call plug#end()
"
"=============================================================================
"                   ______ _               _____          _ 
"                   | ___ \ |             |  ___|        | |
"                   | |_/ / |_   _  __ _  | |__ _ __   __| |
"                   |  __/| | | | |/ _` | |  __| '_ \ / _` |
"                   | |   | | |_| | (_| | | |__| | | | (_| |
"                   \_|   |_|\__,_|\__, | \____/_| |_|\__,_|
"                                   __/ |                   
"                                  |___/                    
"=============================================================================
"
colorscheme base16-spacemacs
"colorscheme base16-gruvbox-dark-hard
set termguicolors


" NERDCommenter
nmap <C-_> <Plug>NERDCommenterToggle
vmap <C-_> <Plug>NERDCommenterToggle<CR>gv


" NERDTree
let NERDTreeQuitOnOpen=1
let g:NERDTreeMinimalUI=1
nmap <C-N> :NERDTreeToggle<CR>


" vim-airline plugin
let g:airline_powerline_fonts = 1  " Включить поддержку шрифтов powerline
let g:airline#extensions#keymap#enabled = 1  " Текущая раскладка: 0=не показывать; 1=показывать (по-умолчанию)
let g:airline_section_z = "\ue0a1:%l/%L : %c"  " Пользовательская графа положения курсора (правый нижний угол)
let g:Powerline_symbols='unicode'  " Поддержка unicode
let g:airline#extensions#tabline#enabled = 1  " Показывать buffers
" let g:airline#extensions#xkblayout#enabled=0  " Руссификация через xkb-плагин


" Вместо Ctrl+W[HJKL] можно переключатья между окнами просто на Ctrl+{HJKL}.
" При этом если окна нет, то создаётся новое окно
map <silent> <C-h> :call WinMove('h')<CR>
map <silent> <C-j> :call WinMove('j')<CR>
map <silent> <C-k> :call WinMove('k')<CR>
map <silent> <C-l> :call WinMove('l')<CR>
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


" Переключение раскладок и индикация выбранной в данный момент раскладки
 " -->
    " Переключение раскладок будет производиться по <C-F>
    "
    " При английской раскладке статусная строка текущего окна будет синего
    " цвета, а при русском — зелёного.

    function MyKeyMapHighlight()
        if &iminsert == 0
            hi StatusLine ctermfg=DarkBlue guifg=DarkBlue
        else
            hi StatusLine ctermfg=DarkGreen guifg=DarkGreen
        endif
    endfunction

    " Вызываем функцию, чтобы она установила цвета при запуске vim'а
    call MyKeyMapHighlight()

    " При изменении активного окна будет выполнятья обновление индикации
    " текущей раскладки
    au WinEnter * :call MyKeyMapHighlight()

    cmap <silent> <C-F> <C-^>
    imap <silent> <C-F> <C-^>X<Esc>:call MyKeyMapHighlight()<CR>a<C-H>
    nmap <silent> <C-F> a<C-^><Esc>:call MyKeyMapHighlight()<CR>
    vmap <silent> <C-F> <Esc>a<C-^><Esc>:call MyKeyMapHighlight()<CR>gv>
" <--


"=============================================================================
"           ______                                 _             
"           | ___ \                               (_)            
"           | |_/ /___ _ __ ___   __ _ _ __  _ __  _ _ __   __ _ 
"           |    // _ \ '_ ` _ \ / _` | '_ \| '_ \| | '_ \ / _` |
"           | |\ \  __/ | | | | | (_| | |_) | |_) | | | | | (_| |
"           \_| \_\___|_| |_| |_|\__,_| .__/| .__/|_|_| |_|\__, |
"                                     | |   | |             __/ |
"                                     |_|   |_|            |___/ 
"           
"=============================================================================
"
" Установить сочетание клавиш для выхода из терминала
tnoremap <C-\> <C-\><C-n>
