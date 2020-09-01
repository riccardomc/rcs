""""""""""""""
" Plug
""""""""""""""
call plug#begin('~/.config/nvim/plugged')
" Completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
" VimL completion
Plug 'Shougo/neco-vim'
" python completion
Plug 'deoplete-plugins/deoplete-jedi'
" Show function signatures, etc.
Plug 'Shougo/echodoc.vim'

" Files navigation
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Syntax checking
Plug 'vim-syntastic/syntastic'

" Eyecandy/Info
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'nathanaelkane/vim-indent-guides'

" Programming Language specific support
Plug 'fatih/vim-go'
" git
Plug 'tpope/vim-fugitive'
" markdown
Plug 'plasticboy/vim-markdown'
" i3 config syntax
Plug 'mboughaba/i3config.vim'
" rust
Plug 'rust-lang/rust.vim'
" python formatter
Plug 'davidhalter/jedi-vim'
Plug 'psf/black'
" Close parenthesis
"Plug 'jiangmiao/auto-pairs'
" terraform completion
Plug 'hashivim/vim-terraform'
Plug 'juliosueiras/vim-terraform-completion'
" YAML
Plug 'pedrohdz/vim-yaml-folds'

" Rarely used (commented to avoid initialization)
"Plug 'rodjek/vim-puppet'
"Plug 'nathanielc/vim-tickscript'
"Plug 'godlygeek/tabular'
"Plug 'vimwiki/vimwiki'
"Plug 'pangloss/vim-javascript'
"Plug 'burnettk/vim-angular'
"Plug 'leafgarland/typescript-vim'
"Plug 'hashivim/vim-terraform'
"Plug 'avakhov/vim-yaml'
"Plug 'tfnico/vim-gradle'
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
" save with Leader+w
noremap <Leader>w :update<CR>

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
" View
"""""""""""""""
"colorscheme  desert256      "nice dark colors
colorscheme   desert-warm-256 "nice dark colors
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
set textwidth=89            "lines width
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
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2

"indent guides, nathanaelkane/vim-indent-guides
let g:indent_guides_auto_colors = 1
let g:indent_guides_enable_on_vim_startup = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=None
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=234

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

"http://vim.wikia.com/wiki/Fix_syntax_highlighting
autocmd BufEnter * :syntax sync ccomment

"refresh, mainly for gitgutter
set updatetime=100

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
let g:syntastic_python_checkers=['flake8', 'pyflakes3']

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" ☯ ☢ ☣ ☹ ⚑ ⚐ ⚠ ⚓ ⚔
let g:syntastic_error_symbol = '😠'
let g:syntastic_warning_symbol = '😠'
let g:syntastic_style_error_symbol = '💩'
let g:syntastic_style_warning_symbol = '💩'

let g:syntastic_yaml_checkers = ['yamllint']

" highlight according to desert-256-warm scheme
highlight SyntasticErrorSign ctermbg=235
highlight SyntasticWarningSign ctermbg=235
highlight SyntasticStyleErrorSign ctermbg=235
highlight SyntasticStyleWarningSign ctermbg=235

""""""""""""""""
" NeoComplete
""""""""""""""""
"let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#enable_at_startup = 1

" enable completion for go
set completeopt+=noselect
call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

" disable jedi-vim completion
let g:jedi#completions_enabled = 0

""""""""""""""""
" EchoDoc
""""""""""""""""
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'floating'
highlight link EchoDocFloat Pmenu

""""""""""""""""
" NeoSnippet
""""""""""""""""
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

"""""""""""""""""""
"   Vim-Go
"""""""""""""""""""
let g:go_autodetect_gopath = 1

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1

let g:go_auto_sameids = 1
let g:go_auto_type_info = 0

let g:go_fmt_command = "goimports"

" syntastic error highlight
let g:syntastic_go_checkers = ['go', 'golint', 'govet']
let g:syntastic_auto_loc_list = 0

let g:go_list_type = 'quickfix'

" do not show preview scratch window
set completeopt-=preview

"""""""""""""""""""
"  Terraform
"""""""""""""""""""
call deoplete#custom#option('omni_patterns', {
\ 'complete_method': 'omnifunc',
\ 'terraform': '[^ *\t"{=$]\w*',
\})
call deoplete#initialize()
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_fmt_on_save=1

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
"  Python
"""""""""""""""""""
if os == "Darwin"
    let g:python_host_prog = '/usr/local/bin/python'
    let g:python3_host_prog = '/usr/local/bin/python3'
else
    let g:python_host_prog = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python3'
endif

"""""""""""""""""""
"  Vimwiki
"""""""""""""""""""
let g:vimwiki_list = [{'path': '~/Notes/',
                     \ 'syntax': 'markdown', 'ext': '.md'}]

" insert '# YYYY-MM-DD' at the top of a file and start writing
nnoremap <F5> "="# " . strftime('%Y-%m-%d')<C-M>po<CR>

let g:vimwiki_folding='expr'
let g:vimwiki_global_ext = 0


"""""""""""""""""""
" TMUX Slowness
"""""""""""""""""""
set nocompatible
set lazyredraw
set ttyfast
hi Normal ctermbg=NONE
hi NonText ctermbg=NONE


""""""""""""""""""
" NERD Tree
""""""""""""""""""
map <C-n> :NERDTreeToggle<CR>


au BufNewFile,BufRead Jenkinsfile setf groovy
