" Maintainer:	Héctor Acosta <hector.acosta@gmail.com>

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

filetype off

set shiftwidth=2
set tabstop=2

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  autocmd VimEnter * RainbowParenthesesToggle
  autocmd Syntax * RainbowParenthesesLoadRound
  autocmd Syntax * RainbowParenthesesLoadSquare
  autocmd Syntax * RainbowParenthesesLoadBraces
  autocmd FileType python setlocal expandtab tabstop=2 shiftwidth=2
  augroup END

au FileType python set omnifunc=pythoncomplete#Complete
else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'scrooloose/nerdtree.git'
Bundle 'davidhalter/jedi-vim'
Bundle 'tpope/vim-fugitive'
Bundle 'sjl/gundo.vim'
Bundle 'alfredodeza/pytest.vim'
Bundle 'ervandew/supertab'
Bundle 'scrooloose/syntastic.git'
Bundle 'wting/rust.vim'
Bundle 'elzr/vim-json.git'
Bundle 'greyblake/vim-preview'

filetype plugin indent on

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

" Fix taxlist
nnoremap ,v <Plug>TaskList

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

" Don't redraw while executing macros
set lazyredraw

" Show nifty menu
set wildmenu
set wildmode=longest:full,full

"line number
set number

" saves on make/shell commands
set autowrite

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

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
noremap ,n :NERDTree<cr>

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

syntax on
set hlsearch

" Show trailing whitespace and spaces before a tab must be done before setting
" the color scheme
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen

set background=dark
if has('gui_running')
	colorscheme molokai
	set guifont=
	set guioptions+=lrbmTLce
	set guioptions-=lrbmTLce
	set guioptions+=c
	"TODO check if colorscheme exists
	if has('win32')
		set columns=120
		set lines=60
		set guifont=Consolas:h9:cANSI
	else
		set encoding=utf-8
		set guifont=Droid\ Sans\ Mono\ 10
	endif
elseif (&term == 'xterm-color') || (&term == 'rxvt-unicode') || (&term =~ '^xterm') || (&term =~ '^screen-256')
	set t_Co=256
	set mouse=a
	set ttymouse=xterm
	set termencoding=utf-8
	colorscheme molokai
else
	colorscheme default
endif


"experimental
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>

:ab #b /************************************************
:ab #e ************************************************/


let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

" Add the virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

let g:jedi#popup_on_dot = 0
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args = "--ignore=E501,E111,E114"
let g:syntastic_check_on_open = 1


if version >= 703
  set rnu
endif

:nnoremap ,z :!zeal --query "<cword>"&<CR><CR>
