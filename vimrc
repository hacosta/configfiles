" Maintainer:	Héctor Acosta <hector.acosta@gazzang.com>

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" keep 50 lines of command line history
set history=700

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" reload file if changed externally && not modified in vim
set autoread

" With a map leader it's possible to do extra key combinations " like
" <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" When vimrc is edited, reload it
map <leader>e :e! ~/.vimrc<cr>

" show the cursor position all the time
set ruler

" display incomplete commands
set showcmd

" do incremental searching
set incsearch

"Ignroe case unless i type something in /CaPiTaL LeTters/
set ignorecase
set smartcase
"set lcs=tab:\ \ ,trail:~,extends:>,precedes:<
"set list

" Set 2 of context
set scrolloff=2

" Show nifty menu
set wildmenu
set wildmode=longest:full,full

"line number
set number

"TODO: do this per filetype
set tabstop=4
set shiftwidth=4
set noexpandtab
" saves on make/shell commands
set autowrite

set backspace=indent,eol,start
"Show matching bracets when text indicator is over them
set showmatch

"The horizontal line, do not want
set nocursorline

"Set magic on, for regular expressions
set magic

"No blink
set gcr=a:blinkwait0,a:block-cursor

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
set timeoutlen=500

" TODO: I don't really get this check what line break does
"set linebreak
set wrap

" cd follows buffer
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

" Keybinding to be able to press f5 to enter copy mode
set pastetoggle=<f5>

vmap <BS> x
"window flipping
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l
nmap X ci"

" man-page autoreturn after view
map K K<cr>

"TODO: Autosave in ~/.vim
set backupdir=./.backup,~/.vim/backup_files,/tmp
set dir=./.backup,~/.vim/backup_files,/tmp

"Change buffer - without saving
set hid

"All copies go to system clipboard
set clipboard=unnamed

" type ,vim to edit vimrc
noremap ,vim :new ~/.vimrc<cr>

" use :W to write as root
command! W w !sudo tee % > /dev/null

"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Keep the selection when indenting using < or >
vnoremap < <gv
vnoremap > >gv

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Show trailing whitespace and spaces before a tab must be done before setting
" the color scheme
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
colorscheme ir_black

if has('gui_running')
    set guioptions+=a
    set guioptions+=c
    set guioptions-=T
    set guioptions-=e
    set guioptions-=m
    set guioptions-=r
	set guifont=
    "TODO check if colorscheme exists
    if has('win32')
        set columns=120
        set lines=60
        set guifont=Consolas\ 11
    else
        set guifont=Droid\ Sans\ Mono\ 10
    endif
elseif (&term == 'xterm-color') || (&term == 'rxvt-unicode') || (&term =~ '^xterm') || (&term =~ '^screen-256')
    set t_Co=256
    set mouse=a
    set ttymouse=xterm
    set termencoding=utf-8
else
    colorscheme default
endif


"experimental
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>

:ab #b /************************************************
:ab #e ************************************************/


