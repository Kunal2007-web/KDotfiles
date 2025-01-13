" Vim Configuration - Kunal Kumar
" Disable Compatibility with `vi` which can cause unexpected issues
set nocompatible

" Enable Syntax Highlighting
syntax enable

" Add Line Numbers
set number

" Filetype Settings
filetype on " Enable type file detection
filetype plugin on " Enable plugins
filetype indent on " Load an indent file

" Indentations Settings
set autoindent " New lines inherit the indentation of previous lines
set shiftwidth=4 " When shifting, indent using 4 spaces
set tabstop=4 " Indent using 4 spaces
set smarttab " Insert tabstop spaces when 'tab' is pressed

" Search Settings
set hlsearch " Enable search highlights
set incsearch " Incremental searching
set ignorecase " Ignore case when searching
set smartcase " Automatically switch to case-sensitive, when search contains capital letter

" Text Rendering Settings
set encoding=utf-8 " Use encoding that supports unicode
set scrolloff=10 " Number of screen line above and below the cursor
set nowrap " Enable line wrapping
set linebreak " Avoid wrapping a line in the middle of a word

" User Interface Settings
set showcmd " Show partial command while typing
set showmode " Display the mode
set showmatch " Show matching words during a search
set wildmenu " Display command line's tab complete options in a menu
set wildmode=list:full " Display all matches and complete full match
set cursorline " Highlight the line currently under the cursor
set relativenumber " Show relative numbers on all other lines
set title " set the window title reflecting the file currently being edited

" Miscellaneous Settings
set backspace=indent,eol,start " Allow backspacing over items
set confirm " Display confirmation dialog when closing an unsaved file
set history=100 " Set command history limit

" Plugins
" For Automatic Plugin Installation on First Start
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source '~/.vimrc'
endif

" Load Plugins
call plug#begin('~/.vim/plugged')

	Plug 'dense-analysis/ale'
	Plug 'Raimondi/delimitMate'
	Plug 'preservim/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'PhilRunninger/nerdtree-visual-selection'
	Plug 'godlygeek/tabular'
	Plug 'preservim/vim-markdown'
	Plug 'preservim/vim-litecorrect'
	Plug 'tpope/vim-fugitive'
	Plug 'airblade/vim-gitgutter'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'mhinz/vim-startify'
	if has('nvim') || has('patch-8.0.902')
 		Plug 'mhinz/vim-signify'
	else
  	Plug 'mhinz/vim-signify', { 'tag': 'legacy' }
	endif
	Plug 'farmergreg/vim-lastplace'
	Plug 'sheerun/vim-polyglot'
  Plug 'ryanoasis/vim-devicons'

call plug#end()

" Vim Functions and vimscript
" Custom Keymaps
nmap <C-h> :let @/ = ""<CR>

" Startify Bookmars
let g:startify_bookmarks = [
        \ {'a': '~/.vimrc'},
        \ {'b': '~/.zshrc'},
        \ {'c': '~/.npmrc'},
        \ {'d': '~/.gitconfig'},
        \ {'e': '~/.gitmessage'},
        \ {'f': '~/.env'},
        \ {'g': '~/.aliases.zsh'},
        \ {'h': '~/.functions.zsh'},
        \ {'i': '~/.completions'},
        \ {'j': '~/.config/starship.toml'},
        \ {'k': '~/.config/topgrade.toml'},
        \ {'l': '~/.config/bat/config'},
        \ {'m': '~/.config/lsd/config.yaml'},
        \ {'n': '~/.config/amfora/config.toml'},
        \ {'o': '~/.config/amfora/newtab.gmi'},
        \ {'p': '~/.config/ngrok/ngrok.yml'},
        \ ]

" Lists on Startify
let g:startify_lists = [
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks:']},
        \ { 'type': 'files', 'header': ['   Recently Used:']},
        \ { 'type': 'dir', 'header': ['   Recently Used '. getcwd(). ':']}
        \ ]

" Use Custom Header in startify with figlet
let g:startify_custom_header =
       \ startify#pad(split(system('figlet -w 100 Vim - Kunal'), '\n'))

" Airline Settings
let g:airline_theme = 'onedark'
let g:airline_powerline_fonts = 1

" Vim Keymaps
nnoremap <C-i> :PlugInstall<CR>
nnoremap <C-u> :PlugUpdate<CR>
nnoremap <C-r> :PlugClean<CR>

" NerdTree Keymaps
nnoremap <C-e> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Startify Keymaps
nmap <C-s> :Startify<CR>

" When Vim Starts without any file arguments
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | Startify | NERDTree | wincmd p | endif

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" ALE Settings
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_set_highlights = 1
let g:ale_set_signs = 1
let g:ale_set_virtualtext_cursor = 1
let g:ale_completion_enabled = 1
let g:ale_completion_max_suggestions = 30
let g:ale_completion_symbols = {
    \ 'text': '',
    \ 'method': '',
    \ 'function': '',
    \ 'constructor': '',
    \ 'field': '',
    \ 'variable': '',
    \ 'class': '',
    \ 'interface': '',
    \ 'module': '',
    \ 'property': '',
    \ 'unit': '',
    \ 'value': '',
    \ 'enum': '',
    \ 'keyword': '',
    \ 'snippet': '',
    \ 'color': '',
    \ 'file': '',
    \ 'reference': '',
    \ 'folder': '',
    \ 'enum member': '',
    \ 'constant': '',
    \ 'struct': '',
    \ 'event': '',
    \ 'operator': '',
    \ 'type_parameter': 'param',
    \ '<default>': 'v'
    \ }
let g:ale_hover_cursor = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_close_preview_on_insert = 1
let g:ale_lsp_suggestions = 1
let g:ale_linters = {
  \   'apkbuild': ['apkbuild_lint', 'secfixes_check'],
  \   'csh': ['shell'],
  \   'elixir': ['credo', 'dialyxir', 'dogma'],
  \   'go': ['gofmt', 'golint', 'gopls', 'govet'],
  \   'hack': ['hack'],
  \   'help': [],
  \   'inko': ['inko'],
  \   'json': ['jsonlint', 'spectral', 'vscodejson'],
  \   'json5': [],
  \   'jsonc': [],
  \   'latex': ['cspell', 'textlint'],
  \   'perl': ['perlcritic'],
  \   'perl6': [],
  \   'python': ['flake8', 'mypy', 'pylint', 'pyright'],
  \   'rust': ['cargo', 'rls'],
  \   'spec': [],
  \   'text': [],
  \   'vader': ['vimls'],
  \   'vue': ['eslint', 'vls'],
  \   'zsh': ['shell'],
  \   'v': ['v'],
  \   'yaml': ['spectral', 'yaml-language-server', 'yamllint'],
  \}

" Vim Markdown Settings
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_emphasis_multiline = 0
let g:vim_markdown_math = 1
let g:vim_markdown_strikethrough = 1

" Vim Gitgutter Settings
let g:gitgutter_diff_args = '--wait'
let g:gitgutter_highlight_lines = 1

" Vim Airline Settings
let g:airline_mode_map = {
      \ '__'     : '-',
      \ 'c'      : 'C',
      \ 'i'      : 'I',
      \ 'ic'     : 'I',
      \ 'ix'     : 'I',
      \ 'n'      : 'N',
      \ 'multi'  : 'M',
      \ 'ni'     : 'N',
      \ 'no'     : 'N',
      \ 'R'      : 'R',
      \ 'Rv'     : 'R',
      \ 's'      : 'S',
      \ 'S'      : 'S',
      \ ''     : 'S',
      \ 't'      : 'T',
      \ 'v'      : 'V',
      \ 'V'      : 'V',
      \ ''     : 'V',
      \ }

let g:airline_filetype_overrides = {
      \ 'coc-explorer':  [ 'CoC Explorer', '' ],
      \ 'defx':  ['defx', '%{b:defx.paths[0]}'],
      \ 'fugitive': ['fugitive', '%{airline#util#wrap(airline#extensions#branch#get_head(),80)}'],
      \ 'floggraph':  [ 'Flog', '%{get(b:, "flog_status_summary", "")}' ],
      \ 'gundo': [ 'Gundo', '' ],
      \ 'help':  [ 'Help', '%f' ],
      \ 'minibufexpl': [ 'MiniBufExplorer', '' ],
      \ 'nerdtree': [ get(g:, 'NERDTreeStatusline', 'NERD'), '' ],
      \ 'startify': [ 'startify', '' ],
      \ 'vim-plug': [ 'Plugins', '' ],
      \ 'vimfiler': [ 'vimfiler', '%{vimfiler#get_status_string()}' ],
      \ 'vimshell': ['vimshell','%{vimshell#get_status_string()}'],
      \ 'vaffle' : [ 'Vaffle', '%{b:vaffle.dir}' ],
      \ }


