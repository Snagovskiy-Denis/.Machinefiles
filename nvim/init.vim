" ======================================================
"
"  /\/|____      _  __             _                    
" |/\/  ___|    | |/ _|           (_)                   
"    \ `--.  ___| | |_      __   ___ _ __ ___  _ __ ___ 
"     `--. \/ _ \ |  _|     \ \ / / | '_ ` _ \| '__/ __|
"    /\__/ /  __/ | |        \ V /| | | | | | | | | (__ 
"    \____/ \___|_|_|       (_)_/ |_|_| |_| |_|_|  \___|
"
" ======================================================


set encoding=UTF-8
set fileencodings=utf-8,cp1251
set number relativenumber
syntax enable
set scrolloff=7 " Экран начинает двигаться, когда остаётся 7 строк до курсора"

" Настройка табов согласно python-рекомендации
set tabstop=4
set softtabstop=4
set smarttab
set shiftwidth=4
set expandtab
" Автоотступ
set autoindent

" let g:gitgutter_git_executable = 'C:\Program Files\Git\bin\git.exe' " Путь до git.exe

" ru-lang
set keymap=russian-jcukenwin
set iminsert=0 " Чтобы при старте ввод был на английском, а не русском
set imsearch=0 " Чтобы при старте поиск был на английском, а не русском

set clipboard=unnamedplus
set mouse=nv

" Добавить знак '$' в то место, где происходит замена
set cpoptions+=$

" Автодополнение + плагин ниже
"set complete+=kspell
"set completeopt=menuone,longest
"set shortmess+=c


" Использовать глобальный интерпретатор python для Neovim, вместо venv
" Это позволит не устанавливать pynvim пакет в каждую venv
" Пока не буду добавлять (т.к. установил пакет через pacman), но в теории:
" let g:python3_host_prog = ''

" =====================
" ______ _             
" | ___ \ |            
" | |_/ / |_   _  __ _ 
" |  __/| | | | |/ _` |
" | |   | | |_| | (_| |
" \_|   |_|\__,_|\__, |
"                 __/ |
"                |___/ 
" ======================
call plug#begin('~/.local/share/nvim/plugged')
" so %; PlugInstall

"Plug 'lyokha/vim-xkbswitch'
"Plug 'Valloric/YouCompleteMe'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
" Plug 'airblade/vim-gitgutter'
Plug 'jmcantrell/vim-virtualenv'

Plug 'vim-airline/vim-airline'  " Красивая панель состояния (внизу)
Plug 'ryanoasis/vim-devicons'  " Иконки

" Plug 'vim-scripts/AutoComplPop' " Автоматически показывать меню авто-доплнения при печати

" Цветовые схемы
Plug 'doums/darcula'
Plug 'morhetz/gruvbox'
Plug 'fnune/base16-vim'

call plug#end()
" =========================================
" ______ _               _____          _ 
" | ___ \ |             |  ___|        | |
" | |_/ / |_   _  __ _  | |__ _ __   __| |
" |  __/| | | | |/ _` | |  __| '_ \ / _` |
" | |   | | |_| | (_| | | |__| | | | (_| |
" \_|   |_|\__,_|\__, | \____/_| |_|\__,_|
"                 __/ |                   
"                |___/                    
" =========================================

" colorscheme darcula
" colorscheme gruvbox
" colorscheme base16-default-dark
" set background=dark
set termguicolors
" let base16colorspace=256  " Access colors present in 256 colorspace

" NERDCommenter
nmap <C-_> <Plug>NERDCommenterToggle
vmap <C-_> <Plug>NERDCommenterToggle<CR>gv

" NERDTree
let NERDTreeQuitOnOpen=1
let g:NERDTreeMinimalUI=1
nmap <C-N> :NERDTreeToggle<CR>


" keyboard layout switcher
"let g:XkbSwitchEnabled = 1
"let g:XkbSwitchLib = "c:\\tools\\neovimr\\Neovim\\bin\\libxkbswitch64.dll"
"echo libcall(g:XkbSwitchLib, 'Xkb_Switch_getXkbLayout', '')
"call libcall(g:XkbSwitchLib, 'Xkb_Switch_setXkbLayout', 'ru')
"let g:XkbSwitchILayout = 'ru'


" vim-airline plugin
let g:airline_powerline_fonts = 1  " Включить поддержку шрифтов powerline
" let g:airline#extensions#keymap#enabled = 0  " Не показывать текущую раскладку
let g:airline_section_z = "\ue0a1:%l/%L : %c"  " Пользовательская графа положения курсора (правый нижний угол)
let g:Powerline_symbols='unicode'  " Поддержка unicode
let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#xkblayout#enabled=0  " Руссификация


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

" youcompleteme — автокомплит-кода
"let g:ycm_python_interpreter_path = ''
"let g:ycm_python_sys_path = []
"let g:ycm_extra_conf_vim_data = [
    "\ 'g:ycm_python_interpreter_path',
    "\ 'g:ycm_python_sys_path'
    "\]
"let g:ycm_global_ycm_extra_conf = 'C:\Windows\system32\global_ycm_extra_conf.py'



" ======================================================
" ______                                 _             
" | ___ \                               (_)            
" | |_/ /___ _ __ ___   __ _ _ __  _ __  _ _ __   __ _ 
" |    // _ \ '_ ` _ \ / _` | '_ \| '_ \| | '_ \ / _` |
" | |\ \  __/ | | | | | (_| | |_) | |_) | | | | | (_| |
" \_| \_\___|_| |_| |_|\__,_| .__/| .__/|_|_| |_|\__, |
"                           | |   | |             __/ |
"                           |_|   |_|            |___/ 
"
" =======================================================
" Установить сочетание клавиш для выхода из терминала
tnoremap <C-\> <C-\><C-n>



" =======================================================
" _____ _                         
"|_   _| |                        
"  | | | |__   ___ _ __ ___   ___ 
"  | | | '_ \ / _ \ '_ ` _ \ / _ \
"  | | | | | |  __/ | | | | |  __/
"  \_/ |_| |_|\___|_| |_| |_|\___|
" =======================================================
" 
" source = https://github.com/fnune/base16-vim/blob/master/colors/base16-spacemacs.vim
"
" vi:syntax=vim

" base16-vim (https://github.com/chriskempson/base16-vim)
" by Chris Kempson (http://chriskempson.com)
" Spacemacs scheme by Nasser Alshammari (https://github.com/nashamri/spacemacs-theme)

" This enables the coresponding base16-shell script to run so that
" :colorscheme works in terminals supported by base16-shell scripts
" User must set this variable in .vimrc
"   let g:base16_shell_path=base16-builder/output/shell/
if !has("gui_running")
  if exists("g:base16_shell_path")
    execute "silent !/bin/sh ".g:base16_shell_path."/base16-spacemacs.sh"
  endif
endif

" GUI color definitions
let s:gui00        = "1f2022"
let g:base16_gui00 = "1f2022"
let s:gui01        = "282828"
let g:base16_gui01 = "282828"
let s:gui02        = "444155"
let g:base16_gui02 = "444155"
let s:gui03        = "585858"
let g:base16_gui03 = "585858"
let s:gui04        = "b8b8b8"
let g:base16_gui04 = "b8b8b8"
let s:gui05        = "a3a3a3"
let g:base16_gui05 = "a3a3a3"
let s:gui06        = "e8e8e8"
let g:base16_gui06 = "e8e8e8"
let s:gui07        = "f8f8f8"
let g:base16_gui07 = "f8f8f8"
let s:gui08        = "f2241f"
let g:base16_gui08 = "f2241f"
let s:gui09        = "ffa500"
let g:base16_gui09 = "ffa500"
let s:gui0A        = "b1951d"
let g:base16_gui0A = "b1951d"
let s:gui0B        = "67b11d"
let g:base16_gui0B = "67b11d"
let s:gui0C        = "2d9574"
let g:base16_gui0C = "2d9574"
let s:gui0D        = "4f97d7"
let g:base16_gui0D = "4f97d7"
let s:gui0E        = "a31db1"
let g:base16_gui0E = "a31db1"
let s:gui0F        = "b03060"
let g:base16_gui0F = "b03060"

" Terminal color definitions
let s:cterm00        = "00"
let g:base16_cterm00 = "00"
let s:cterm03        = "08"
let g:base16_cterm03 = "08"
let s:cterm05        = "07"
let g:base16_cterm05 = "07"
let s:cterm07        = "15"
let g:base16_cterm07 = "15"
let s:cterm08        = "01"
let g:base16_cterm08 = "01"
let s:cterm0A        = "03"
let g:base16_cterm0A = "03"
let s:cterm0B        = "02"
let g:base16_cterm0B = "02"
let s:cterm0C        = "06"
let g:base16_cterm0C = "06"
let s:cterm0D        = "04"
let g:base16_cterm0D = "04"
let s:cterm0E        = "05"
let g:base16_cterm0E = "05"
if exists("base16colorspace") && base16colorspace == "256"
  let s:cterm01        = "18"
  let g:base16_cterm01 = "18"
  let s:cterm02        = "19"
  let g:base16_cterm02 = "19"
  let s:cterm04        = "20"
  let g:base16_cterm04 = "20"
  let s:cterm06        = "21"
  let g:base16_cterm06 = "21"
  let s:cterm09        = "16"
  let g:base16_cterm09 = "16"
  let s:cterm0F        = "17"
  let g:base16_cterm0F = "17"
else
  let s:cterm01        = "10"
  let g:base16_cterm01 = "10"
  let s:cterm02        = "11"
  let g:base16_cterm02 = "11"
  let s:cterm04        = "12"
  let g:base16_cterm04 = "12"
  let s:cterm06        = "13"
  let g:base16_cterm06 = "13"
  let s:cterm09        = "09"
  let g:base16_cterm09 = "09"
  let s:cterm0F        = "14"
  let g:base16_cterm0F = "14"
endif

" Neovim terminal colours
if has("nvim")
  let g:terminal_color_0 =  "#1f2022"
  let g:terminal_color_1 =  "#f2241f"
  let g:terminal_color_2 =  "#67b11d"
  let g:terminal_color_3 =  "#b1951d"
  let g:terminal_color_4 =  "#4f97d7"
  let g:terminal_color_5 =  "#a31db1"
  let g:terminal_color_6 =  "#2d9574"
  let g:terminal_color_7 =  "#a3a3a3"
  let g:terminal_color_8 =  "#585858"
  let g:terminal_color_9 =  "#f2241f"
  let g:terminal_color_10 = "#67b11d"
  let g:terminal_color_11 = "#b1951d"
  let g:terminal_color_12 = "#4f97d7"
  let g:terminal_color_13 = "#a31db1"
  let g:terminal_color_14 = "#2d9574"
  let g:terminal_color_15 = "#f8f8f8"
  let g:terminal_color_background = g:terminal_color_0
  let g:terminal_color_foreground = g:terminal_color_5
  if &background == "light"
    let g:terminal_color_background = g:terminal_color_7
    let g:terminal_color_foreground = g:terminal_color_2
  endif
elseif has("terminal")
  let g:terminal_ansi_colors = [
        \ "#1f2022",
        \ "#f2241f",
        \ "#67b11d",
        \ "#b1951d",
        \ "#4f97d7",
        \ "#a31db1",
        \ "#2d9574",
        \ "#a3a3a3",
        \ "#585858",
        \ "#f2241f",
        \ "#67b11d",
        \ "#b1951d",
        \ "#4f97d7",
        \ "#a31db1",
        \ "#2d9574",
        \ "#f8f8f8",
        \ ]
endif

" Theme setup
hi clear
syntax reset
let g:colors_name = "base16-spacemacs"

" Highlighting function
" Optional variables are attributes and guisp
function! g:Base16hi(group, guifg, guibg, ctermfg, ctermbg, ...)
  let l:attr = get(a:, 1, "")
  let l:guisp = get(a:, 2, "")

  " See :help highlight-guifg
  let l:gui_special_names = ["NONE", "bg", "background", "fg", "foreground"]

  if a:guifg != ""
    if index(l:gui_special_names, a:guifg) >= 0
      exec "hi " . a:group . " guifg=" . a:guifg
    else
      exec "hi " . a:group . " guifg=#" . a:guifg
    endif
  endif
  if a:guibg != ""
    if index(l:gui_special_names, a:guibg) >= 0
      exec "hi " . a:group . " guibg=" . a:guibg
    else
      exec "hi " . a:group . " guibg=#" . a:guibg
    endif
  endif
  if a:ctermfg != ""
    exec "hi " . a:group . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    exec "hi " . a:group . " ctermbg=" . a:ctermbg
  endif
  if l:attr != ""
    exec "hi " . a:group . " gui=" . l:attr . " cterm=" . l:attr
  endif
  if l:guisp != ""
    if index(l:gui_special_names, l:guisp) >= 0
      exec "hi " . a:group . " guisp=" . l:guisp
    else
      exec "hi " . a:group . " guisp=#" . l:guisp
    endif
  endif
endfunction


fun <sid>hi(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  call g:Base16hi(a:group, a:guifg, a:guibg, a:ctermfg, a:ctermbg, a:attr, a:guisp)
endfun

" Vim editor colors
call <sid>hi("Normal",        s:gui05, s:gui00, s:cterm05, s:cterm00, "", "")
call <sid>hi("Bold",          "", "", "", "", "bold", "")
call <sid>hi("Debug",         s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("Directory",     s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("Error",         s:gui00, s:gui08, s:cterm00, s:cterm08, "", "")
call <sid>hi("ErrorMsg",      s:gui08, s:gui00, s:cterm08, s:cterm00, "", "")
call <sid>hi("Exception",     s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("FoldColumn",    s:gui0C, s:gui01, s:cterm0C, s:cterm01, "", "")
call <sid>hi("Folded",        s:gui03, s:gui01, s:cterm03, s:cterm01, "", "")
call <sid>hi("IncSearch",     s:gui01, s:gui09, s:cterm01, s:cterm09, "none", "")
call <sid>hi("Italic",        "", "", "", "", "italic", "")
call <sid>hi("Macro",         s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("MatchParen",    "", s:gui03, "", s:cterm03,  "", "")
call <sid>hi("ModeMsg",       s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("MoreMsg",       s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("Question",      s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("Search",        s:gui01, s:gui0A, s:cterm01, s:cterm0A,  "", "")
call <sid>hi("Substitute",    s:gui01, s:gui0A, s:cterm01, s:cterm0A, "none", "")
call <sid>hi("SpecialKey",    s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("TooLong",       s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("Underlined",    s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("Visual",        "", s:gui02, "", s:cterm02, "", "")
call <sid>hi("VisualNOS",     s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("WarningMsg",    s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("WildMenu",      s:gui00, s:gui05, s:cterm00, s:cterm05, "", "")
call <sid>hi("Title",         s:gui0D, "", s:cterm0D, "", "none", "")
call <sid>hi("Conceal",       s:gui0D, s:gui00, s:cterm0D, s:cterm00, "", "")
call <sid>hi("Cursor",        s:gui00, s:gui05, s:cterm00, s:cterm05, "inverse", "")
call <sid>hi("NonText",       s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("Whitespace",    s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("LineNr",        s:gui03, s:gui00, s:cterm03, s:cterm00, "", "")
call <sid>hi("SignColumn",    s:gui03, s:gui00, s:cterm03, s:cterm00, "", "")
call <sid>hi("StatusLine",    s:gui04, s:gui01, s:cterm04, s:cterm01, "none", "")
call <sid>hi("StatusLineNC",  s:gui03, s:gui01, s:cterm03, s:cterm01, "none", "")
call <sid>hi("VertSplit",     s:gui01, s:gui00, s:cterm01, s:cterm00, "none", "")
call <sid>hi("ColorColumn",   "", s:gui01, "", s:cterm01, "none", "")
call <sid>hi("CursorColumn",  "", s:gui01, "", s:cterm01, "none", "")
call <sid>hi("CursorLine",    "", s:gui01, "", s:cterm01, "none", "")
call <sid>hi("CursorLineNr",  s:gui04, s:gui01, s:cterm04, s:cterm01, "bold", "")
call <sid>hi("QuickFixLine",  "", s:gui01, "", s:cterm01, "none", "")
call <sid>hi("PMenu",         s:gui05, s:gui02, s:cterm05, s:cterm02, "none", "")
call <sid>hi("PMenuSel",      s:gui01, s:gui05, s:cterm01, s:cterm05, "", "")
call <sid>hi("TabLine",       s:gui03, s:gui01, s:cterm03, s:cterm01, "none", "")
call <sid>hi("TabLineFill",   s:gui03, s:gui01, s:cterm03, s:cterm01, "none", "")
call <sid>hi("TabLineSel",    s:gui0B, s:gui01, s:cterm0B, s:cterm01, "none", "")

" Standard syntax highlighting
call <sid>hi("Boolean",      s:gui09, "", s:cterm09, "", "", "")
call <sid>hi("Character",    s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("Comment",      s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("Conditional",  s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("Constant",     s:gui09, "", s:cterm09, "", "", "")
call <sid>hi("Define",       s:gui0E, "", s:cterm0E, "", "none", "")
call <sid>hi("Delimiter",    s:gui0F, "", s:cterm0F, "", "", "")
call <sid>hi("Float",        s:gui09, "", s:cterm09, "", "", "")
call <sid>hi("Function",     s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("Identifier",   s:gui08, "", s:cterm08, "", "none", "")
call <sid>hi("Include",      s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("Keyword",      s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("Label",        s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("Number",       s:gui09, "", s:cterm09, "", "", "")
call <sid>hi("Operator",     s:gui0F, "", s:cterm0F, "", "none", "")
call <sid>hi("PreProc",      s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("Repeat",       s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("Special",      s:gui0C, "", s:cterm0C, "", "", "")
call <sid>hi("SpecialChar",  s:gui0F, "", s:cterm0F, "", "", "")
call <sid>hi("Statement",    s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("StorageClass", s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("String",       s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("Structure",    s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("Tag",          s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("Todo",         s:gui0A, s:gui01, s:cterm0A, s:cterm01, "", "")
call <sid>hi("Type",         s:gui0A, "", s:cterm0A, "", "none", "")
call <sid>hi("Typedef",      s:gui0A, "", s:cterm0A, "", "", "")

" Standard highlights to be used by plugins
call <sid>hi("GitAddSign",           s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("GitChangeSign",        s:gui04, "", s:cterm04, "", "", "")
call <sid>hi("GitDeleteSign",        s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("GitChangeDeleteSign",  s:gui04, "", s:cterm04, "", "", "")

call <sid>hi("ErrorSign",    s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("WarningSign",  s:gui09, "", s:cterm09, "", "", "")
call <sid>hi("InfoSign",     s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("HintSign",     s:gui0C, "", s:cterm0C, "", "", "")

call <sid>hi("ErrorFloat",   s:gui08, s:gui02, s:cterm08, s:cterm02, "", "")
call <sid>hi("WarningFloat", s:gui09, s:gui02, s:cterm09, s:cterm02, "", "")
call <sid>hi("InfoFloat",    s:gui0D, s:gui02, s:cterm0D, s:cterm02, "", "")
call <sid>hi("HintFloat",    s:gui0C, s:gui02, s:cterm0C, s:cterm02, "", "")

call <sid>hi("ErrorHighlight",   "", "", s:cterm00, s:cterm08, "underline", s:gui08)
call <sid>hi("WarningHighlight", "", "", s:cterm00, s:cterm09, "underline", s:gui09)
call <sid>hi("InfoHighlight",    "", "", s:cterm00, s:cterm0D, "underline", s:gui0D)
call <sid>hi("HintHighlight",    "", "", s:cterm00, s:cterm0C, "underline", s:gui0C)

call <sid>hi("SpellBad",     "", "", s:cterm00, s:cterm08, "undercurl", s:gui08)
call <sid>hi("SpellLocal",   "", "", s:cterm00, s:cterm0C, "undercurl", s:gui0C)
call <sid>hi("SpellCap",     "", "", s:cterm00, s:cterm0D, "undercurl", s:gui0D)
call <sid>hi("SpellRare",    "", "", s:cterm00, s:cterm0E, "undercurl", s:gui0E)

call <sid>hi("ReferenceText",   s:gui01, s:gui0A, s:cterm01, s:cterm0A, "", "")
call <sid>hi("ReferenceRead",   s:gui01, s:gui0B, s:cterm01, s:cterm0B, "", "")
call <sid>hi("ReferenceWrite",  s:gui01, s:gui08, s:cterm01, s:cterm08, "", "")

" C highlighting
call <sid>hi("cOperator",   s:gui0C, "", s:cterm0C, "", "", "")
call <sid>hi("cPreCondit",  s:gui0E, "", s:cterm0E, "", "", "")

" C# highlighting
call <sid>hi("csClass",                 s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("csAttribute",             s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("csModifier",              s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("csType",                  s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("csUnspecifiedStatement",  s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("csContextualStatement",   s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("csNewDecleration",        s:gui08, "", s:cterm08, "", "", "")

" Clap highlighting
hi default link ClapInput             ColorColumn
hi default link ClapSpinner           ColorColumn
hi default link ClapDisplay           Default
hi default link ClapPreview           ColorColumn
hi default link ClapCurrentSelection  CursorLine
hi default link ClapNoMatchesFound    ErrorFloat

" Coc highlighting
hi default link CocErrorSign         ErrorSign
hi default link CocWarningSign       WarningSign
hi default link CocInfoSign          InfoSign
hi default link CocHintSign          HintSign

hi default link CocErrorFloat        ErrorFloat
hi default link CocWarningFloat      WarningFloat
hi default link CocInfoFloat         InfoFloat
hi default link CocHintFloat         HintFloat

hi default link CocErrorHighlight    ErrorHighlight
hi default link CocWarningHighlight  WarningHighlight
hi default link CocInfoHighlight     InfoHighlight
hi default link CocHintHighlight     HintHighlight
call <sid>hi("CocHighlightRead",   s:gui0B, s:gui01,  s:cterm0B, s:cterm01, "", "")
call <sid>hi("CocHighlightText",   s:gui0A, s:gui01,  s:cterm0A, s:cterm01, "", "")
call <sid>hi("CocHighlightWrite",  s:gui08, s:gui01,  s:cterm08, s:cterm01, "", "")
call <sid>hi("CocListMode",        s:gui01, s:gui0B,  s:cterm01, s:cterm0B, "bold", "")
call <sid>hi("CocListPath",        s:gui01, s:gui0B,  s:cterm01, s:cterm0B, "", "")
call <sid>hi("CocSessionsName",    s:gui05, "", s:cterm05, "", "", "")

" CSS highlighting
call <sid>hi("cssBraces",      s:gui05, "", s:cterm05, "", "", "")
call <sid>hi("cssClassName",   s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("cssColor",       s:gui0C, "", s:cterm0C, "", "", "")

" Diff highlighting
call <sid>hi("DiffAdd",      s:gui0B, s:gui02,  s:cterm0B, s:cterm02, "", "")
call <sid>hi("DiffChange",   s:gui05, s:gui02,  s:cterm05, s:cterm02, "", "")
call <sid>hi("DiffDelete",   s:gui08, s:gui02,  s:cterm08, s:cterm02, "", "")
call <sid>hi("DiffText",     s:gui0D, s:gui02,  s:cterm0D, s:cterm02, "", "")
call <sid>hi("DiffAdded",    s:gui0B, s:gui00,  s:cterm0B, s:cterm00, "", "")
call <sid>hi("DiffFile",     s:gui08, s:gui00,  s:cterm08, s:cterm00, "", "")
call <sid>hi("DiffNewFile",  s:gui0B, s:gui00,  s:cterm0B, s:cterm00, "", "")
call <sid>hi("DiffLine",     s:gui0D, s:gui00,  s:cterm0D, s:cterm00, "", "")
call <sid>hi("DiffRemoved",  s:gui08, s:gui00,  s:cterm08, s:cterm00, "", "")

" Git highlighting
call <sid>hi("gitcommitOverflow",       s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("gitcommitSummary",        s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("gitcommitComment",        s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("gitcommitUntracked",      s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("gitcommitDiscarded",      s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("gitcommitSelected",       s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("gitcommitHeader",         s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("gitcommitSelectedType",   s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("gitcommitUnmergedType",   s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("gitcommitDiscardedType",  s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("gitcommitBranch",         s:gui09, "", s:cterm09, "", "bold", "")
call <sid>hi("gitcommitUntrackedFile",  s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("gitcommitUnmergedFile",   s:gui08, "", s:cterm08, "", "bold", "")
call <sid>hi("gitcommitDiscardedFile",  s:gui08, "", s:cterm08, "", "bold", "")
call <sid>hi("gitcommitSelectedFile",   s:gui0B, "", s:cterm0B, "", "bold", "")

" GitGutter highlighting
hi default link GitGutterAdd            GitAddSign
hi default link GitGutterChange         GitChangeSign  
hi default link GitGutterDelete         GitDeleteSign
hi default link GitGutterChangeDelete   GitChangeDeleteSign

" HTML highlighting
call <sid>hi("htmlBold",    s:gui05, "", s:cterm0A, "", "bold", "")
call <sid>hi("htmlItalic",  s:gui05, "", s:cterm0E, "", "italic", "")
call <sid>hi("htmlEndTag",  s:gui05, "", s:cterm05, "", "", "")
call <sid>hi("htmlTag",     s:gui05, "", s:cterm05, "", "", "")

" JavaScript highlighting
call <sid>hi("javaScript",        s:gui05, "", s:cterm05, "", "", "")
call <sid>hi("javaScriptBraces",  s:gui05, "", s:cterm05, "", "", "")
call <sid>hi("javaScriptNumber",  s:gui09, "", s:cterm09, "", "", "")
" pangloss/vim-javascript highlighting
call <sid>hi("jsOperator",          s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("jsStatement",         s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("jsReturn",            s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("jsThis",              s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("jsClassDefinition",   s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("jsFunction",          s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("jsFuncName",          s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("jsFuncCall",          s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("jsClassFuncName",     s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("jsClassMethodType",   s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("jsRegexpString",      s:gui0C, "", s:cterm0C, "", "", "")
call <sid>hi("jsGlobalObjects",     s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("jsGlobalNodeObjects", s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("jsExceptions",        s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("jsBuiltins",          s:gui0A, "", s:cterm0A, "", "", "")

" Mail highlighting
call <sid>hi("mailQuoted1",  s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("mailQuoted2",  s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("mailQuoted3",  s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("mailQuoted4",  s:gui0C, "", s:cterm0C, "", "", "")
call <sid>hi("mailQuoted5",  s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("mailQuoted6",  s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("mailURL",      s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("mailEmail",    s:gui0D, "", s:cterm0D, "", "", "")

" Markdown highlighting
call <sid>hi("markdownCode",              s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("markdownError",             s:gui05, s:gui00, s:cterm05, s:cterm00, "", "")
call <sid>hi("markdownCodeBlock",         s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("markdownHeadingDelimiter",  s:gui0D, "", s:cterm0D, "", "", "")

" NERDTree highlighting
call <sid>hi("NERDTreeDirSlash",  s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("NERDTreeExecFile",  s:gui05, "", s:cterm05, "", "", "")

" PHP highlighting
call <sid>hi("phpMemberSelector",  s:gui05, "", s:cterm05, "", "", "")
call <sid>hi("phpComparison",      s:gui05, "", s:cterm05, "", "", "")
call <sid>hi("phpParent",          s:gui05, "", s:cterm05, "", "", "")
call <sid>hi("phpMethodsVar",      s:gui0C, "", s:cterm0C, "", "", "")

" Python highlighting
call <sid>hi("pythonOperator",  s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("pythonRepeat",    s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("pythonInclude",   s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("pythonStatement", s:gui0E, "", s:cterm0E, "", "", "")

" Ruby highlighting
call <sid>hi("rubyAttribute",               s:gui0D, "", s:cterm0D, "", "", "")
call <sid>hi("rubyConstant",                s:gui0A, "", s:cterm0A, "", "", "")
call <sid>hi("rubyInterpolationDelimiter",  s:gui0F, "", s:cterm0F, "", "", "")
call <sid>hi("rubyRegexp",                  s:gui0C, "", s:cterm0C, "", "", "")
call <sid>hi("rubySymbol",                  s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("rubyStringDelimiter",         s:gui0B, "", s:cterm0B, "", "", "")

" SASS highlighting
call <sid>hi("sassidChar",     s:gui08, "", s:cterm08, "", "", "")
call <sid>hi("sassClassChar",  s:gui09, "", s:cterm09, "", "", "")
call <sid>hi("sassInclude",    s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("sassMixing",     s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("sassMixinName",  s:gui0D, "", s:cterm0D, "", "", "")

" Signify highlighting
hi default link SignifySignAdd    GitAddSign
hi default link SignifySignChange GitChangeSign
hi default link SignifySignDelete GitDeleteSign

" Startify highlighting
call <sid>hi("StartifyBracket",  s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("StartifyFile",     s:gui07, "", s:cterm07, "", "", "")
call <sid>hi("StartifyFooter",   s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("StartifyHeader",   s:gui0B, "", s:cterm0B, "", "", "")
call <sid>hi("StartifyNumber",   s:gui09, "", s:cterm09, "", "", "")
call <sid>hi("StartifyPath",     s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("StartifySection",  s:gui0E, "", s:cterm0E, "", "", "")
call <sid>hi("StartifySelect",   s:gui0C, "", s:cterm0C, "", "", "")
call <sid>hi("StartifySlash",    s:gui03, "", s:cterm03, "", "", "")
call <sid>hi("StartifySpecial",  s:gui03, "", s:cterm03, "", "", "")

" Neovim Treesitter highlighting
if has("nvim")
  call <sid>hi("TSFunction",        s:gui0D, "", s:cterm0D, "", "", "")
  call <sid>hi("TSKeywordFunction", s:gui0E, "", s:cterm0E, "", "", "")
  call <sid>hi("TSMethod",          s:gui0D, "", s:cterm0D, "", "", "")
  call <sid>hi("TSProperty",        s:gui0A, "", s:cterm0A, "", "", "")
  call <sid>hi("TSPunctBracket",    s:gui0C, "", s:cterm0C, "", "", "")
  call <sid>hi("TSType",            s:gui08, "", s:cterm08, "", "none", "")

  " Treesitter-refactor highlighting
  call <sid>hi("TSDefinition",       "", s:gui03, "", s:cterm03, "", "")
  call <sid>hi("TSDefinitionUsage",  "", s:gui02, "", s:cterm02, "none", "")
endif

" LSP highlighting
if has("nvim")
  hi default link LspDiagnosticsSignError    ErrorSign
  hi default link LspDiagnosticsSignWarning  WarningSign
  hi default link LspDiagnosticsSignInfo     InfoSign
  hi default link LspDiagnosticsSignHint     HintSign

  hi default link LspDiagnosticsVirtualTextError    ErrorSign
  hi default link LspDiagnosticsVirtualTextWarning  WarningSign
  hi default link LspDiagnosticsVirtualTextInfo     InfoSign
  hi default link LspDiagnosticsVirtualTextHint     HintSign

  hi default link LspDiagnosticsFloatingError    ErrorFloat
  hi default link LspDiagnosticsFloatingWarning  WarningFloat
  hi default link LspDiagnosticsFloatingInfo     InfoFloat
  hi default link LspDiagnosticsFloatingHint     HintFloat

  hi default link LspDiagnosticsUnderlineError    ErrorHighlight
  hi default link LspDiagnosticsUnderlineWarning  WarningHighlight
  hi default link LspDiagnosticsUnderlineInfo     InfoHighlight
  hi default link LspDiagnosticsUnderlineHint     HintHighlight

  hi default link LsoReferenceText   ReferenceText
  hi default link LsoReferenceRead   ReferenceRead
  hi default link LsoReferenceWrite  ReferenceWrite
endif

" Java highlighting
call <sid>hi("javaOperator",     s:gui0D, "", s:cterm0D, "", "", "")

" Remove functions
delf <sid>hi

" Remove color variables
unlet s:gui00 s:gui01 s:gui02 s:gui03  s:gui04  s:gui05  s:gui06  s:gui07  s:gui08  s:gui09 s:gui0A  s:gui0B  s:gui0C  s:gui0D  s:gui0E  s:gui0F
unlet s:cterm00 s:cterm01 s:cterm02 s:cterm03 s:cterm04 s:cterm05 s:cterm06 s:cterm07 s:cterm08 s:cterm09 s:cterm0A s:cterm0B s:cterm0C s:cterm0D s:cterm0E s:cterm0F
