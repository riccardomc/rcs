""""""""""""""
" Main
""""""""""""""
scriptencoding utf-8        "encoding stuff
set encoding=utf-8          "encoding stuff
set nocompatible            "disable vi compatibility mode
set nobackup                "disable backups
set history=1000            "history lines to remember
set confirm                 "ask confirm with unsaved/ro files
set ttymouse=xterm2         "terminal mouse handling
set mouse=a                 "use mouse
filetype plugin on          "load filetype plugins

set filetype=on

let os = substitute(system('uname'), "\n", "", "")

if os == "Linux"
  "use X11 clipboard in linux
  set clipboard=unnamed
endif

"""""""""""""""
" Plugins
"""""""""""""""
"pathogen! (https://github.com/tpope/vim-pathogen)
execute pathogen#infect()

"""""""""""""""
" View
"""""""""""""""
"colorscheme wombat256       "nice dark colors
colorscheme desert          "nice dark colors
"colorscheme zenburn         "nice dark colors
"colorscheme slate            "nice dark colors
set ruler
set showcmd                 "show command in statusline
set nolist
set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:▸\ 
set lazyredraw              "do not redraw running macros
set hidden                  "hide buffer when leaving

"set title of the terminal window
""let &titlestring = hostname() . "[vim(" . expand("%:t") . ")]"
""let &titlestring = "". expand("%:t") .""
"causes problems with tmux
""if &term == "screen"
""    set t_ts=^[k
""    set t_fs=^[\
""endif

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


"""""""""""""""
" Edit
"""""""""""""""
set nostartofline           "keep cursor on current column with pag keys
set bs=indent,eol,start     "use backspace in insert mode
set textwidth=79            "lines width
set wildmenu                "Show all auto-completion options
set whichwrap=<,>,h,l,[,]   "go up or down when reach end first or last char

"tabbing
set smarttab                "indent instead of tabbing
set autoindent              "keep indentation level on new line
set softtabstop=4           "tab width
set shiftwidth=4            "indent width
set expandtab               "insert 'softtabstop' spaces


"""""""""""""""
" Programming
"""""""""""""""
set number                  "line numbers
set syntax=on               "syntax highlighting
syntax on                   "syntax highlighting
"folding
set foldenable              "fold stuff
set foldmethod=syntax       "fold by syntax
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

"windows navigation w/ C-Arrows (UNUSED)
"nmap <Esc>[A <C-w>k<CR>
"imap <Esc>[A <C-o><C-w>k<CR>
"nmap <Esc>[B <C-w>j<CR>
"imap <Esc>[B <C-o><C-w>j<CR>
"nmap <Esc>[C <C-w>l<CR>
"imap <Esc>[C <C-o><C-w>l<CR>
"nmap <Esc>[D <C-w>h<CR>
"imap <Esc>[D <C-o><C-w>h<CR>


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
set gdefault                "global substitution 
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

"Use F2 to toggle paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode


"""""""""""""""""""
"   LaTeX suite   
"""""""""""""""""""

" " IMPORTANT: grep will sometimes skip displaying the file name if you
" " search in a singe file. This will confuse Latex-Suite. Set your grep
" " program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" " OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults
" to
" " 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" " The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

"I want to use pdflatex in place of latex
"g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*' 
"let g:Tex_CompileRule_pdf = 'xelatex --src-specials  --interaction=nonstopmode $*' 
let g:Tex_CompileRule_pdf = 'pdflatex --src-specials  --interaction=nonstopmode $*' 
let g:Tex_CompileRule_dvi = 'latex --src-specials  --interaction=nonstopmode $*' 

" set kpdf as default viewr
let g:Tex_ViewRule_pdf = 'evince'
let g:Tex_ViewRule_dvi = 'evince'

" enable multiple time compilation for bibtex and stuff
let g:Tex_MultipleCompileFormats = 'dvi,pdf'

let g:Tex_DefaultTargetFormat = 'pdf'
