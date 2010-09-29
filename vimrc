" An example for a vimrc file.

" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
"


if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ignorecase
set smartcase
"set lcs=tab:\ \ ,trail:~,extends:>,precedes:<
"set list


" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

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


if has('gui_running')
    set guioptions+=a
    set guioptions+=c
    set guioptions-=T
    set guioptions-=e
    set guioptions-=m
    set guioptions-=r
    colorscheme inkpot
    if has('win32')
        set columns=120
        set lines=60
        set guifont=Consolas\ 11
    else
        set guifont=Lucida\ Console\ 11
    endif
elseif (&term == 'xterm-color')
    set t_Co=256
    colorscheme inkpot
    set mouse=a
    set ttymouse=xterm
    set termencoding=utf-8
elseif (&term == 'screen.linux') || (&term =~ '^linux')
    set t_Co=8
    colorscheme default
elseif (&term == 'xterm-color') || (&term == 'rxvt-unicode') || (&term =~ '^xterm') || (&term =~ '^screen-256')
    set t_Co=256
    set mouse=a
    set ttymouse=xterm
    set termencoding=utf-8
    colorscheme inkpot
else
    colorscheme default
endif

set wildmenu
set wildmode=longest:full,full
set number

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set wrap
"writes on make/shell commands
set autowrite

set backspace=indent,eol,start
set showmatch
"set cursorline

" man-page autoreturn after view
map K K<cr>
set pastetoggle=<f5>


vmap <BS> x


nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l
nmap X ci"

"TODO: Autosave en ~/.vim
set backupdir=./.backup,~/.vim/backup_files,/tmp
set dir=./.backpup,~/.vim/backup_files,/tmp

"para :W
command! W w !sudo tee % > /dev/null

"siempre en la carpeta
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

"workarround para el bug de el cursor
set go-=L

"para que deje de parpadear el cursor
set gcr=a:blinkwait0,a:block-cursor

"para quitar el preview window de omni-complete
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif


"apagar la estupida campanita
set visualbell t_vb=

set linebreak
noremap ,vim :new ~/.vimrc<cr>
inoremap <C-E> <C-X><C-E>
inoremap <C-Y> <C-X><C-Y>

"lineas de contexto
"set so 5


"map <f12> :!ctags -f ~/.vim/localtags -R *.h *.c <CR><CR>

"set tags=~/.vim/systags,~/.vim/localtags,./.tags
set tags=.ctag
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
"au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview
"set completeopt=menuone,longest,preview
"let g:SuperTabDefaultCompletionType = "<C-X><C-O>"


"experimental
autocmd BufRead,BufNew *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
autocmd BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala            setfiletype cs
au BufRead,BufNewFile *.vala            setfiletype cs

let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>

:ab #b /************************************************
:ab #e ************************************************/

