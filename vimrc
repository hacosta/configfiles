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

set history=500		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

"Ignroe case unless i type something in /CaPiTaL LeTters/
set ignorecase
set smartcase
"set lcs=tab:\ \ ,trail:~,extends:>,precedes:<
"set list

" Set 2 of context
set scrolloff=2

set wildmenu
set wildmode=longest:full,full

"line number
set number

"TODO: do this per filetype
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set wrap
"writes on make/shell commands
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
set tm=500

set linebreak

" man-page autoreturn after view
set pastetoggle=<f5>

"TODO: Autosave in ~/.vim
set backupdir=./.backup,~/.vim/backup_files,/tmp
set dir=./.backup,~/.vim/backup_files,/tmp

"Change buffer - without saving
set hid

" Set to auto read when a file is changed from the outside
set autoread

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


colorscheme ir_black
if has('gui_running')
    set guioptions+=a
    set guioptions+=c
    set guioptions-=T
    set guioptions-=e
    set guioptions-=m
    set guioptions-=r
    "TODO check if colorscheme exists
    if has('win32')
        set columns=120
        set lines=60
        set guifont=Consolas\ 11
    else
        set guifont=Lucida\ Console\ 11
    endif
elseif (&term == 'xterm-color')
    set t_Co=256
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
else
    colorscheme default
endif


vmap <BS> x
"window flipping
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l
nmap X ci"

map K K<cr>

command! W w !sudo tee % > /dev/null

"cd follows buffer
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif


"type ,vim to edit vimrc
noremap ,vim :new ~/.vimrc<cr>
inoremap <C-E> <C-X><C-E>
inoremap <C-Y> <C-X><C-Y>


"COMPLETION options

"TODO: check if this works again
"map <f12> :!ctags -f ~/.vim/localtags -R *.h *.c <CR><CR>

"set tags=~/.vim/systags,~/.vim/localtags,./.tags
"set tags=.ctag
"let OmniCpp_NamespaceSearch = 1
"let OmniCpp_GlobalScopeSearch = 1
"let OmniCpp_ShowAccess = 1
"let OmniCpp_MayCompleteDot = 1
"let OmniCpp_MayCompleteArrow = 1
"let OmniCpp_MayCompleteScope = 1
"let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
"au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
"set completeopt=menuone,menu,longest,preview
"set completeopt=menuone,longest,preview
"let g:SuperTabDefaultCompletionType = "<C-X><C-O>"


"experimental
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>

:ab #b /************************************************
:ab #e ************************************************/

" When vimrc is edited, reload it
map <leader>e :e! ~/.vimrc<cr>


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" NOTICE: Really useful!

"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Some useful keys for vimgrep
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

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
