" .vimrc - Detlef Stern

" This must be first, because it changes other options as side effect
set nocompatible    " This is Vim, not Vi

" ------------------------------------------------------------------------ {{{
" first the disabled features due to security concerns
set modelines=0                  " no modelines [http://www.guninski.com/vim1.html]
let g:secure_modelines_verbose=0 " securemodelines vimscript
let g:secure_modelines_modelines=10 " 10 available modelines
" }}}

" ------------------------------------------------------------------------ {{{
" Set up Pathogen
call pathogen#infect()

" Uncomment if you want to recreate help files every time Vim starts up.
" Alternatively, you can enter the Command :Helptags
" call pathogen#helptags()
" }}}

" ------------------------------------------------------------------------ {{{
" Set up Vundle
"
" If bundle directory is empty, first clone Vundle repository, then restart
" vim, and then do :BundleInstall.
"
" Clone command:
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
"
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Vundle must manage itself
Plugin 'VundleVim/Vundle.vim'
" }}}


" ------------------------------------------------------------------------ {{{
" Early setup
" change the mapleader from \ to ,
let mapleader=","
" }}}

" ------------------------------------------------------------------------ {{{
" Buffer handling
set hidden             " Allow changed buffers to be hidden

" Enable syntax highlighting
syntax enable
syntax on
" }}}

" ------------------------------------------------------------------------ {{{
" Screen layout

set shortmess+=I " Don't show the Vim welcome screen

" Status line
set laststatus=2
set statusline=
set statusline+=%-3.3n\        " buffer number
set statusline+=%f\            " filename
set statusline+=%h%m%r%w       " status flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}] " file type
set statusline+=%=             " right align remainder
set statusline+=0x%-8B         " character value
set statusline+=%-14(%l,%c%V%) " line, character
set statusline+=%-4{strlen(getline('.'))}
set statusline+=%<%P           " file position

set number             " Turn on line numbers
set relativenumber     " Turn on relative numbering
set numberwidth=3      " Enough for relative numbering
set ruler              " Show line number, cursor position
set cursorline         " Draw line the cursor is on
set showcmd            " Display incomplete commands
set showmode           " Show editing mode
set visualbell t_vb=   " Error bells are displayed visually

set scrolloff=3        " Context lines at top and bottom of display
set sidescrolloff=5    " Context columns at left and right
set sidescroll=1       " Number of chars to scroll when scrolling sideways

" set list listchars=tab:\ \ ,trail:·
" Use the same symbols as textmate for tabstops and EOLs
set list listchars=nbsp:·,tab:▸\ ,eol:¬,trail:·,extends:>,precedes:<
" Shortcut for toggling display of invisibles
nmap <leader>l :set list!<CR>

set splitright         " Split new vertical windows right of current window
set splitbelow         " Split new horizontal windows under current window

set winminheight=0     " Allow windows to shrink to status line
set winminwidth=0      " Allow windows to shrink to vertical separator

set noshowmatch        " Don't jump to matching characters
set matchpairs=(:),[:],{:},<:> " Character pairs for use with %, 'showmatch'
set matchtime=1        " In tenths of seconds, when showmatch is on

set ttyfast            " Optimize for local edits
set lazyredraw         " Don't redraw in the middle of macro execution
" }}}

" ------------------------------------------------------------------------ {{{
" Undo

if !isdirectory($HOME."/.cache")
    call mkdir($HOME."/.cache", "", 0770)
endif
if !isdirectory($HOME."/.cache/vim-undo")
      call mkdir($HOME."/.cache/vim-undo", "", 0700)
endif
set undodir=~/.cache/vim-undo
set undofile
" }}}

" ------------------------------------------------------------------------ {{{
" Indentation and tab handling

" Automatic indentation
filetype plugin indent on
set autoindent         " Copy indent from current line for new line
set nosmartindent      " 'smartindent' breaks right-shifting of # lines

" Tabs converted to 2 spaces
" (Nice screencast at http://vimcasts.org/episodes/tabs-and-spaces/)
set expandtab          " Insert spaces for <Tab> press; use spaces to indent
set smarttab           " Tab respects 'shiftwidth', 'tabstop', 'softtabstop'
set tabstop=2          " Set the visible width of tabs
set softtabstop=2      " Edit as if tabs are 4 characters wide
set shiftwidth=2       " Number of spaces to use for indent and unindent
set shiftround         " Round indent to a multiple of 'shiftwidth'
" }}}

" ------------------------------------------------------------------------ {{{
" Tab completion
set wildmenu      " Show autocomplete menus
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.hg,*.py[co],*.swp

" Ignore these when using TAB key with :e
set suffixes=~,.aux,.bak,.bkp,.dvi,.hi,.o,.gz,.idx,.log,.ps,.swp,.tar,.ilg,.bbl,.toc,.ind
" }}}

" ------------------------------------------------------------------------ {{{
" Line wrapping
set nowrap             " Don't wrap the display of long lines
set linebreak          " Wrap at 'breakat' char vs display edge if 'wrap' on
set display=lastline   " Display as much of a window's last line as possible
set textwidth=0        " Don't auto-wrap lines except for specific filetypes
set formatoptions=qrn1 " See :he fo-table for more information
set colorcolumn=80     " Warn me at specific column
" }}}

" ------------------------------------------------------------------------ {{{
" Search / Replace
set incsearch          " Search as you type
set hlsearch           " Highlight matches
set ignorecase         " Ignore case when searching
set smartcase          " Use case if patterns contains upper case letter
nnoremap <leader><space> :nohlsearch<CR>

set gdefault           " Global substitution by default
" }}}

" ------------------------------------------------------------------------ {{{
" Misc input handling

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start
" }}}

" ------------------------------------------------------------------------ {{{
" Folding

set foldenable
set foldlevelstart=99   " open all folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=marker   " fold based on marker
" }}}

" ------------------------------------------------------------------------ {{{
" Default for all file types

" Most of the time, I work on Unix systems
set fileformat=unix
au BufNewFile * set fileformat=unix

set encoding=utf-8  " Use UTF-8

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile
" }}}

" ------------------------------------------------------------------------ {{{
" Python

" Python autocompletion
Plugin 'davidhalter/jedi-vim'

function s:PythonMode()
  set shiftwidth=4
  set tabstop=4
  set softtabstop=4
  set textwidth=79
  set expandtab
  set autoindent
  set foldmethod=indent   " fold based on indent level
endfunction
autocmd FileType python call s:PythonMode()

" Twisted application files are Pthon files too
autocmd BufRead,BufNewFile *.tac set filetype=python

" Add the virtualenv's site-packages to vim path
py3 << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    try:
        execfile(activate_this, dict(__file__=activate_this))
    except:
        pass
EOF
" }}}

" ------------------------------------------------------------------------ {{{
" Go
Plugin 'fatih/vim-go'
" }}}

" ------------------------------------------------------------------------ {{{
" LaTeX
let g:tex_flavor='latex'
let g:Tex_SmartKeyQuote=0  " Disable Quote, because of german LaTeX

" Changes to iskeyword to contain german umlauts
function s:AddUmlautsToIskeyword()
  set iskeyword+=196,214,220,228,246,252,233
endfunction
autocmd FileType tex call s:AddUmlautsToIskeyword()
" }}}

" ------------------------------------------------------------------------ {{{
" Text

function s:TextMode()
  set wrap
  set textwidth=79
  set formatoptions=tcq
  setlocal formatprg=par\ -w79
endfunction

au BufRead,BufNewFile *.txt call s:TextMode()
autocmd FileType markdown call s:TextMode()
" }}}

" ------------------------------------------------------------------------ {{{
" ReStructuredText mode
Plugin 'rest.vim'

autocmd BufRead,BufNewFile *.rst set syntax=rest

function! s:ReStructuredTextMode()
  " Make bullet points follow to next line
  " http://stackoverflow.com/questions/1047400/
  " setlocal comments+=n:-,n:#.

  " Don't visually break words when line wrapping
  set nolist
  set linebreak
  "set scrolloff=999

  " Override the default indentation which I don't like
  " $VIMRUNTIME/indent/rst.vim
  setlocal indentexpr=
  setlocal indentkeys=
  setlocal smartindent
endfunction

autocmd FileType rest call s:ReStructuredTextMode()
" }}}

" ------------------------------------------------------------------------ {{{
" Mail

function s:MailMode()
  setlocal fo += aw
  setlocal textwidth=75
  "setlocal wrap
  setlocal expandtab
  setlocal nocindent
  setlocal noautoindent
  setlocal spell
  setlocal spelllang=de,en
  setlocal formatprg=par\ -w74q
endfunction

autocmd FileType mail call s:MailMode()
" }}}

" ------------------------------------------------------------------------ {{{
"  Other modes
"
Plugin 'aklt/plantuml-syntax'
Plugin 'tpope/vim-markdown'
Plugin 'asciidoc.vim'

"  make uses real tabs
au FileType make set noexpandtab

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

Plugin 'elixir-lang/vim-elixir'
Plugin 't73fde/dockerfile.vim'
" }}}

" ------------------------------------------------------------------------ {{{
" Syntax checking
"
Plugin 'scrooloose/syntastic'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 4

let g:syntastic_tex_lacheck_quiet_messages = {
  \ "regex" : ["Could not open \""] }
let g:syntastic_tex_chktex_quiet_messages = {
  \ "regex" : ["Could not execute LaTeX command",
  \            "You should put a space in front of parenthesis",
  \            "Use either `` or '' as an alternative to `\"'"] }
" }}}
  " \ "regex" : "(Could not open \")|(Could not execute LaTeX command\.)" }

" ------------------------------------------------------------------------ {{{
" Misc. plugins

Plugin 'ciaranm/securemodelines'

Plugin 'mhinz/vim-signify'
let g:signify_vcs_list = [ 'fossil', 'git', 'hg' ]

Plugin 'kien/ctrlp.vim'
" ignore files: see [wildmode] above
let g:ctrlp_root_markers = ['.fslckout', '.git', '.hg']
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
" let g:ctrlp_working_path_mode = 0

Plugin 'TaskList.vim'
map <leader>tl <Plug>TaskList

Plugin 'sjl/gundo.vim'
map <leader>g :GundoToggle<CR>

Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'

Plugin 'scrooloose/nerdtree'
" show hidden files in NERDTree
let NERDTreeShowHidden=1
" Toggle NERDTree
nmap <silent> <leader>k :NERDTreeToggle<cr>
" expand to the path of the file in the current buffer
nmap <silent> <leader>y :NERDTreeFind<cr>

Plugin 'tpope/vim-fugitive'
Plugin 'benmills/vimux'
Plugin 'junegunn/goyo.vim'
Plugin 'gnupg.vim'

Plugin 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>
" }}}

" ------------------------------------------------------------------------ {{{
" fzf - Fuzzy finder
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

nmap <silent> <leader>p :Files<cr>
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})
" }}}

" ------------------------------------------------------------------------ {{{
" Cursor key mappings
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" }}}

" ------------------------------------------------------------------------ {{{
" Window key mappings
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" }}}

" ------------------------------------------------------------------------ {{{
" Misc key mappings
" Toggle line numbers and fold column for easy copying:
nnoremap <leader>zn :set nonumber!<CR>:set foldcolumn=0<CR>
nnoremap <leader>zN :set norelativenumber!<CR>:set foldcolumn=0<CR>

" Temporary disallow autoindent
set pastetoggle=<F3>

" Toggle centering current line
nnoremap <leader>zz :let &scrolloff=999-&scrolloff<CR>

" highlight last inserted text
nnoremap gV `[v`]
" }}}

" ------------------------------------------------------------------------ {{{
" UltiSnips settings
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
let g:UltiSnipsSnippetDirectories=["UltiSnips", "MyUltiSnips"]
" }}}

" ------------------------------------------------------------------------ {{{
" Allow local modifications
" Based on: http://blog.sanctum.geek.nz/local-vimrc-files/
" }}}
if filereadable(glob("~/.vimrc.local")) 
  source ~/.vimrc.local
endif

