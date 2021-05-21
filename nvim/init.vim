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
" Информация
"
" Глобальная метка `E ведёт к разделу после импорта плагинов
"
" Строка разделитель:
" len("\" + "=" * 78) == 79 == PEP 8 recommendation
"
" Порядок оформления стандартных разделов: 
"   0) строка-разделитель
"   1) строка идентификатор
"   2) пустая строка
"   3) опциональное описание с отступом в 4 пробела
"   4) пустая строка
"   5) тело раздела
"   6) пустая строка
"   7) строка-разделитель
" Строка идентификатор состоит из имени раздела / функции. Для плагинов после имени через слэш-символ добавляется сокрашённая ссылка на репозиторий плагина
"
"=============================================================================
" Общие настройки
"
set encoding=UTF-8
set fileencodings=utf-8,cp1251

set number relativenumber
syntax enable

set scrolloff=7 " Экран начинает двигаться, когда остаётся 7 строк до курсора"

set clipboard=unnamedplus  " Интеграция с системным буфером обмена
set mouse=nv  " Поддержка мыши

set cpoptions+=$  " Добавить знак '$' в то место, где происходит замена

"=============================================================================
" Настройка табов согласно python-рекомендации
"
set tabstop=4
set softtabstop=4
set smarttab
set shiftwidth=4
set expandtab
set autoindent  " Автоотступ

"=============================================================================
" Поддержка русского языка
"
set keymap=russian-jcukenwin  " включить встроенную поддержку
set iminsert=0 " На старте ввод на английском, а не русском
set imsearch=0 " На старте поиск на английском, а не русском

"=============================================================================
"
" Использовать глобальный интерпретатор python для Neovim, вместо venv
" Это позволит не устанавливать pynvim пакет в каждую venv
" Пока не буду добавлять (т.к. установил пакет через pacman), но в теории:
" let g:python3_host_prog = ''

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
        echo "Minpac package does not exist. Plugin-less environment is used"
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
"
set termguicolors
colorscheme base16-spacemacs
"colorscheme base16-gruvbox-dark-hard

"=============================================================================
" NERDCommenter / 'preservim/nerdcommenter'
"
nmap <C-_> <Plug>NERDCommenterToggle
vmap <C-_> <Plug>NERDCommenterToggle<CR>gv

"=============================================================================
" NERDTree / 'preservim/nerdtree'
"
let NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI = 1
nmap <C-N> :NERDTreeToggle<CR>

"=============================================================================
" vim-airline / 'vim-airline/vim-airline' & vim-ariline-themes
"
" Better status line
"
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
"     <C-[HJKL]> вместо <C-W-[HJKL]>
"     При отсутствии окна:
"         - <С-[HL]> = <C-W-V> <C-W-[HL]>
"         - <C-[JK]> = <C-W-S> <C-W-[JK]>
"
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

"=============================================================================
" Переключение раскладок и индикация выбранной в данный момент раскладки
" 
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

"=============================================================================
"            _____                                           _     
"           /  __ \                                         | |    
"           | /  \/ ___  _ __ ___  _ __ ___   __ _ _ __   __| |___ 
"           | |    / _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` / __|
"           | \__/\ (_) | | | | | | | | | | | (_| | | | | (_| \__ \
"            \____/\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|___/
"=============================================================================
" Управление плагинами
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
