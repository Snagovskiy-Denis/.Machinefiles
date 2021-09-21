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
"
"                             ┌╌╌╌╌╌╌╌╌╌╌╌╌┐                    █
"                             ╎            ╎                    █
"                             ╎ ОГЛАВЛЕНИЕ ╎                    █
"                             ╎            ╎                  ◥███◤
"                             └╌╌╌╌╌╌╌╌╌╌╌╌┘                   ◥█◤
"                                                               ▔
"       {{en}}                    {{ru}}                    {{marks}}
"
"       Vanilla              Базовые настройки                 `v
"
"   Plugins Settings         Настройки плагинов                `p
"
"      Functions                 Функции                       `f
"
"      Commands                  Команды                       `c
"
"     Key mapping            Назначение клавиш                 `m
"
"   List of plugins           Список плагинов                  `l
"
"
"
autocmd BufEnter *.config/nvim/init.vim setlocal foldmethod=indent
"=============================================================================
" Vanilla
"                        _   _             _ _ _       
"                       | | | |           (_) | |      
"                       | | | | __ _ _ __  _| | | __ _ 
"                       | | | |/ _` | '_ \| | | |/ _` |
"                       \ \_/ / (_| | | | | | | | (_| |
"                        \___/ \__,_|_| |_|_|_|_|\__,_|
"=============================================================================

    " Общие настройки
    syntax enable
    set number relativenumber
    set splitbelow splitright
    set clipboard=unnamedplus
    set mouse=nv

    " Между курсором и концом экрана 7 строк, иначе двигай экран
    set scrolloff=7 

"

    " Поддержка русского языка
    set keymap=russian-jcukenwin 
    set iminsert=0  " На старте ввод на английском, а не русском
    set imsearch=0  " На старте поиск на английском, а не русском

"

    " Внешний вид
    set termguicolors
    "colorscheme base16-colors
    colorscheme base16-isotope  " hi blue Operator нечитаем в sh (e.g. точка)
    "colorscheme base16-atelier-seaside  
    "colorscheme base16-google-dark

    " Reset theme background-color to regain background opacity
    autocmd BufEnter * highlight normal guibg=000000

    " Установить подсвечивание текущей линии
    set cursorline
    autocmd FileType sh colorscheme pop-punk
    autocmd FileType python colorscheme base16-isotope

"

    " Настройка табов согласно python-рекомендации
    set tabstop=4
    set softtabstop=4
    set smarttab
    set shiftwidth=4
    set expandtab
    set autoindent  " Автоотступ

"

"=============================================================================
" Plugins settings
"   ______ _             _                      _   _   _                 
"   | ___ \ |           (_)                    | | | | (_)                
"   | |_/ / |_   _  __ _ _ _ __  ___   ___  ___| |_| |_ _ _ __   __ _ ___ 
"   |  __/| | | | |/ _` | | '_ \/ __| / __|/ _ \ __| __| | '_ \ / _` / __|
"   | |   | | |_| | (_| | | | | \__ \ \__ \  __/ |_| |_| | | | | (_| \__ \
"   \_|   |_|\__,_|\__, |_|_| |_|___/ |___/\___|\__|\__|_|_| |_|\__, |___/
"                   __/ |                                        __/ |    
"                  |___/                                        |___/     
"=============================================================================

    " nerdtree
    " Изменяет навигацию по файловой системе
    let NERDTreeQuitOnOpen = 1
    let g:NERDTreeMinimalUI = 1

"

    " vim-airline & vim-airline-themes
    " Изменяет statusline
    let g:airline_theme = 'google_dark'

    let g:airline_section_z = "%l:%c %P"
    let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'

    let g:airline#extensions#keymap#label = "⌨"
    let g:airline#extensions#keymap#short_codes = {'russian-jcukenwin': 'RU'}
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#buffer_min_count = 4
    let g:airline#extensions#term#enabled = 0
    
"=============================================================================
" Functions
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
        " <C-[hjkl]> вместо <C-w> <C-[hjkl]>
        " При отсутствии окна в которое можно переместиться:
        "     - <С-[hl]> = <C-w><C-v> <C-w><C-[hl]>
        "     - <C-[jk]> = <C-w><C-s> <C-w><C-[jk]>
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

"

    " Показать список установленных плагинов
    "
        " Используется командами:
        " PlugOpenDir & PlugOpenUrl
    "
    function! PlugList(...)
        call PlugInit()
        return join(sort(keys(minpac#getpluglist())), "\n")
    endfunction

"

    " Redirect ex command output into new split
    function! TabMessage(cmd)
      redir => message
      silent execute a:cmd
      redir END
      if empty(message)
        echoerr "no output"
      else
        new
        setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
        silent put=message
      endif
    endfunction
    command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

"=============================================================================
" Commands
"            _____                                           _     
"           /  __ \                                         | |    
"           | /  \/ ___  _ __ ___  _ __ ___   __ _ _ __   __| |___ 
"           | |    / _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` / __|
"           | \__/\ (_) | | | | | | | | | | | (_| | | | | (_| \__ \
"            \____/\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|___/
"=============================================================================

    " Управление плагинами:
    "
    " 1. Установить или обновить
    " 2. Удалить неиспользуемые
    " 3. Просмотреть статус
    "
    command! PlugUpdate source $MYVIMRC |call PlugInit()| call minpac#update()
    command! PlugClean  source $MYVIMRC |call PlugInit()| call minpac#clean()
    command! PlugStatus packadd minpac  | call minpac#status()

    "
    " 4. Открыть директорию плагина в split-терминале
    " 5. Открыть репозиторий плагина в браузере
    "
        " Аргумент команд: 
        "   Имя плагина без имени пользователя
        "   e.g. PlugOpenDir minpac
    "
    command! -nargs=1 -complete=custom,PlugList
          \ PlugOpenDir call PlugInit() | :new | call termopen(&shell,
          \    {'cwd': minpac#getpluginfo(<q-args>).dir,
          \     'term_finish': 'close'})

    command! -nargs=1 -complete=custom,PlugList
          \ PlugOpenUrl call PlugInit() | call openbrowser#open(
          \    minpac#getpluginfo(<q-args>).url)

"

    " gf opens [[link to file]] as link\ to\ file.md
    autocmd BufEnter *.md set suffixesadd+=.md

"=============================================================================
" Key mapping
"        _   __                                         _             
"       | | / /                                        (_)            
"       | |/ /  ___ _   _   _ __ ___   __ _ _ __  _ __  _ _ __   __ _ 
"       |    \ / _ \ | | | | '_ ` _ \ / _` | '_ \| '_ \| | '_ \ / _` |
"       | |\  \  __/ |_| | | | | | | | (_| | |_) | |_) | | | | | (_| |
"       \_| \_/\___|\__, | |_| |_| |_|\__,_| .__/| .__/|_|_| |_|\__, |
"                    __/ |                 | |   | |             __/ |
"                   |___/                  |_|   |_|            |___/ 
"=============================================================================
" Установить <Leader> на <Space> <= this is a lie
"noremap <Space> <NOP>
"let g:mapleader = "\<Space>"
let g:mapleader = ","

    " Терминал
    " Установить сочетание клавиш для выхода из терминала
    tnoremap <C-\> <C-\><C-n>
    map <Leader>tt :new term://bash<CR>
    "              :vnew для вертикального split

"

    " Splits \ Окна
    " Управление splits при помощи функции WinMove
    map <silent> <C-h> :call WinMove('h')<CR>
    map <silent> <C-j> :call WinMove('j')<CR>
    map <silent> <C-k> :call WinMove('k')<CR>
    map <silent> <C-l> :call WinMove('l')<CR>

    " Управление размером split
    map <silent> <M-Left> :vertical resize -2 <CR>
    map <silent> <M-Right> :vertical resize +2 <CR>
    map <silent> <M-Down> :resize -2 <CR>
    map <silent> <M-Up> :resize +2 <CR>

"

    " Buffers \ Буферы
    " Цикличное переключение между буферами
    nnoremap <TAB> :bnext<CR>
    nnoremap <S-TAB> :bprevious<CR>

"

    " Keymap \ Переключение раскладки
    cmap <silent> <C-F> <C-^>
    imap <silent> <C-F> <C-^>
    nmap <silent> <C-F> a<C-^><Esc>
    vmap <silent> <C-F> <Esc>a<C-^><Esc>gv

"

    " Добавить плагин (в конце буфера не должно быть переноса строки)
    nmap <Leader>ap ocall minpac#add('')<Esc>2F'p
    nmap <Leader>aop ocall minpac#add('', {'type': 'opt'})<Esc>6F'p

"

    " nerdcommenter
    " Добавляет функцию комментирования строк
    nmap <C-_> <Plug>NERDCommenterToggle
    vmap <C-_> <Plug>NERDCommenterToggle<CR>gv

"

    " nerdtree
    nmap <C-N> :NERDTreeToggle<CR>

"

    " Behave Vim
    nnoremap Y y$

"
    " Moving text
    vnoremap J :m '>+1<CR>gv=gv
    inoremap <C-j> <Esc>:m .+1<CR>==a
    "nnoremap <leader>j :m .+1<CR>==

    vnoremap K :m '<-2<CR>gv=gv
    inoremap <C-k> <Esc>:m .-2<CR>==a
    "nnoremap <leader>k :m .-2<CR>==

"

    " Find and replace <++>
    vnoremap <leader>q <Esc>/<++><CR>c4l
    "inoremap <leader>q <Esc>/<++><CR>c4l
    nnoremap <leader>q <Esc>/<++><CR>c4l

    vnoremap <leader>w <Esc>?<++><CR>c4l
    "inoremap <leader>w <Esc>?<++><CR>c4l
    nnoremap <leader>w <Esc>?<++><CR>c4l

"

    " Interact with closest link
    "
    " URL regular expression pattern:
    "
    " g0 = http[s]:// AND optional www.
    " g1 (1-∞ chars) = alphabetic OR digital OR one of these: -@:%._+~#=
    " g2 (1-∞ chars) = . AND alphabetic OR digital OR ) OR (
    " g3 (0 or ∞ chars) = / AND g1 chars OR ?& AND end with alpha-digital
    "
    "          https://www.youtube.com/results?search_query=search
    "            /            |      \                 \
    "          g0            g1       `- g2             `g3
    "   ( https://www. ) ( youtube ) ( .com ) ( /results?search_query=test )
    "
    "     Test links:
    "         HTTP://WWW.EXAMPLE.COM - match
    "         http://example. com    - do not match
    "
    let url_g0 = '[Hh][Tt][Tt][Pp][Ss]\?:\/\/\([Ww]\{3,3}\.\)\?'
    let url_g1 = '[-a-zA-Z0-9@:%._+~#=]\+'
    let url_g2 = '\.[a-zA-Z0-9()]\+'
    let url_g3 = '\/\?[-a-zA-Z0-9()@:%._+~#=?&/]*[a-zA-Z0-9]'

    let url_regexp = url_g0 . url_g1 . url_g2 . url_g3
    let url_short_regexp =    url_g1 . url_g2 . url_g3

    " [y]ank closest ([s]hort) [u]rl link
    nnoremap <expr> <leader>yu  'mb/' . url_regexp .       '<CR>ygn`b:echo "\"<C-R>+\" was copied"<CR>'
    nnoremap <expr> <leader>ysu 'mb/' . url_short_regexp . '<CR>ygn`b:echo "\"<C-R>+\" was copied"<CR>'

    " [o]pen closest ([s]hort) [u]rl link
    nnoremap <expr> <leader>ou  'mb/' . url_regexp .       '<CR>"bygn`b:!xdg-open <C-R>b<CR>'
    nnoremap <expr> <leader>osu 'mb/' . url_short_regexp . '<CR>"bygn`b:!xdg-open <C-R>b<CR>'

    " wikilink regular exppression pattern:
    "
    "     [[
    "     any number of any characters except |
    "     optional |
    "     any number of any characters
    "     ]]
    "
    "let wikilink_regexp = '\[\[.*\]\]'
    let wikilink_regexp = '\[\[\([^|]*\)|\?\(.*\)\]\]'

    " [g]oto [f]ile named inside the closest wikilink
    nnoremap <expr> <leader>gf 'mb/' . wikilink_regexp . '<CR>:nohl<CR>lvi[gf'

    " Create [n]ew [m]arkdown file named via wikilink
    nnoremap <leader>nm "byi[:e <C-R>b.md<CR>"hPG

"=============================================================================
" List of plugins
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
            call minpac#add('preservim/nerdcommenter')
            call minpac#add('preservim/nerdtree')

                " themes and aesthetics
            call minpac#add('fnune/base16-vim')
            call minpac#add('vim-airline/vim-airline')
            call minpac#add('vim-airline/vim-airline-themes')
            call minpac#add('ryanoasis/vim-devicons')
            call minpac#add('bignimbus/pop-punk.vim')

            call minpac#add('tyru/open-browser.vim')

            "call minpac#add('sakhnik/nvim-gdb')
        endif
    endfunction
