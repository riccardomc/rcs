""""""""""""""
" Plug
""""""""""""""
call plug#begin('~/.config/nvim/plugged')
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'kien/ctrlp.vim'
Plug 'davidhalter/jedi-vim'
Plug 'scrooloose/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'tpope/vim-fugitive'
Plug 'rodjek/vim-puppet'
Plug 'vim-airline/vim-airline'
Plug 'nathanielc/vim-tickscript'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'vimwiki/vimwiki'
call plug#end()

""""""""""""""
" Main
""""""""""""""
scriptencoding utf-8        "encoding stuff
set encoding=utf-8          "encoding stuff
set nocompatible            "disable vi compatibility mode
set nobackup                "disable backups
set history=1000            "history lines to remember
set confirm                 "ask confirm with unsaved/ro files
filetype plugin on          "load filetype plugins

set filetype=on

let os = substitute(system('uname'), "\n", "", "")

"""""""""""""""
" Clipboard
"""""""""""""""
if os == "Linux" || os == "Darwin"
  "use X11 clipboard in linux
  set clipboard=unnamed
endif

"""""""""""""""
" Mouse
"""""""""""""""
if $SSH_CLIENT
    "find a proper way to handle mouse selection via SSH
else
    if !has('nvim')
        set ttymouse=xterm2         "terminal mouse handling
    endif
    set mouse=a                 "use mouse
endif

"""""""""""""""
" Plugins
"""""""""""""""
"pathogen! (https://github.com/tpope/vim-pathogen)
execute pathogen#infect()

"""""""""""""""
" View
"""""""""""""""
colorscheme  desert256      "nice dark colors
set ruler
set showcmd                 "show command in statusline
set noshowmode				"do not show mode, we use airline
set nolist
set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:▸\ 
set lazyredraw              "do not redraw running macros
set hidden                  "hide buffer when leaving

if &term == "screen" || &term == "xterm"
    set title
endif

""gui related
set guioptions+=m
set guioptions+=a
set guioptions+=A
set guioptions-=T
set guioptions-=r
set guioptions-=l
set guioptions-=R
set guioptions-=L

set guifont="Monospace 8"

" splits
set splitbelow
set splitright

"""""""""""""""
" Edit
"""""""""""""""
set nostartofline           "keep cursor on current column with pag keys
set bs=indent,eol,start     "use backspace in insert mode
set textwidth=79            "lines width
set wildmenu                "Show all auto-completion options
set whichwrap=<,>,h,l,[,]   "go up or down when reach end first or last char
set formatoptions-=t        "do not auto-insert newline when wrapping

"tabbing
set smarttab                "indent instead of tabbing
set autoindent              "keep indentation level on new line
set tabstop=4               "tab width
set shiftwidth=4            "indent width
set expandtab               "insert 'softtabstop' spaces

"fileType specific indentation
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2

"""""""""""""""
" Programming
"""""""""""""""
if &mouse == 'a'
  set nonumber              "line numbers (only with mouse selection)
  if exists('+colorcolumn') "highlight limit column (only in 7.3)
    set colorcolumn=+1
  endif
endif
set syntax=on               "syntax highlighting
syntax on                   "syntax highlighting
"folding
set foldmethod=syntax       "fold by syntax
set foldlevelstart=20       "unfold when opening a file
set foldopen=block,hor,insert,jump,mark,percent,undo
set foldclose=              "don't fold when cursor leaves

filetype indent on          "filetype indent plugin

""""""""""""""""""
" Tabs and Windows
""""""""""""""""""
nnoremap <C-t> :tabnew<CR>
map <C-j> :tabprevious<CR>
imap <C-j> <C-o>:tabprevious<CR>
map <C-k> :tabnext<CR>
imap <C-k> <C-o>:tabnext<CR>

"right arrow for next window
nmap <Esc>[C <C-w>w 
imap <Esc>[C <C-o><C-w>w 

"arrows up/down for prev/next tab
nmap <Esc>[A :tabprevious<CR>
imap <Esc>[A <C-o>:tabprevious<CR>
nmap <Esc>[B :tabnext<CR>
imap <Esc>[B <C-o>:tabnext<CR>

""""""""""""""""
" File browsing
""""""""""""""""
"Ignore various binary file types when completing file names
set wildignore+=*.o,*.lo,*.la,*.a,*.so,.*.d,*.pyc,.DS_Store,*.aux,*.bbl,*.blg
set wildignore+=*.lof,*.log,*.lot,*.toc,*.pdf,*.hi

""""""""""""""""
" Search
""""""""""""""""
set hlsearch                "highlight search
set incsearch               "incremental search
set ignorecase              "ignore case in searches
set smartcase               "not sure
"get rid of highlighting by pressing enter in command mode
nnoremap <return> :noh<return> 


""""""""""""""""
" Spelling
""""""""""""""""
set spl=en spell
set nospell


""""""""""""""""
" Misc
""""""""""""""""

"options for specific files
autocmd BufNewFile,BufRead *.rst,*.txt,*.tex,*.latex setlocal spell
autocmd BufNewFile,BufRead *.rst,*.txt,*.tex,*.latex setlocal nonumber
autocmd BufNewFile,BufRead *.rst,*.txt,*.tex,*.latex setlocal textwidth=75
autocmd BufNewFile,BufRead *.rst,*.txt,*.tex,*.latex setlocal formatoptions+=t

"Use F2 to toggle paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

""""""""""""""""
" Syntastic
""""""""""""""""

let g:syntastic_check_on_open=1
let g:syntastic_python_checkers=['pyflakes', 'flake8']

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" ☯ ☢ ☣ ☹ ⚑ ⚐ ⚠ ⚓ ⚔
let g:syntastic_error_symbol = '⚠ '
let g:syntastic_warning_symbol = '⚠ '
let g:syntastic_style_error_symbol = '☯'
let g:syntastic_style_warning_symbol = '☯'

""""""""""""""""
" NeoComplete
""""""""""""""""
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#enable_at_startup = 1

"""""""""""""""""""
"   Vim-Go
"""""""""""""""""""
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:go_fmt_command = "goimports"

" syntastic error highlight
let g:syntastic_go_checkers = ['go', 'errcheck', 'golint']
let g:syntastic_auto_loc_list = 0

"""""""""""""""""""
"  Ack
"""""""""""""""""""
nnoremap <leader>a :Ack
nnoremap <leader>A :Ack <C-r><C-w><CR>

"""""""""""""""""""
"  Puppet
"""""""""""""""""""
autocmd! BufNewFile,BufRead *.ppr setlocal ft=puppetreport

"""""""""""""""""""
"  Airline
"""""""""""""""""""
set laststatus=2
let g:airline_powerline_fonts = 1

"""""""""""""""""""
"  Brew
"""""""""""""""""""
if os == "Darwin"
    let g:python2_host_prog = '/usr/local/bin/python'
    let g:python3_host_prog = '/usr/local/bin/python3'
endif

"""""""""""""""""""
"  Vimwiki
"""""""""""""""""""
let g:vimwiki_list = [{'path': '~/Development/notes/',
                     \ 'syntax': 'markdown', 'ext': '.md'}]

" insert '# YYYY-MM-DD' at the top of a file and start writing
nnoremap <F5> "="# " . strftime('%Y-%m-%d')<C-M>po<CR>
