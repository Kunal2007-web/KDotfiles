" Vim Configuration - Kunal Kumar
" Disable Compatibility with `vi` which can cause unexpected issues
set nocompatible

" Enable Syntax Highlighting
syntax enable

" Set Default Terminal Shell
set shell=/usr/bin/bash

" Add Line Numbers
set number

" Set Colorscheme
colorscheme default

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
scriptencoding utf8
set scrolloff=10 " Number of screen line above and below the cursor
" Enable/Disable line wrapping
let s:wrapenabled = 0
function! ToggleWrap()
  set wrap nolist
  if s:wrapenabled
    set nolinebreak
    unmap j
    unmap k
    unmap 0
    unmap ^
    unmap $
    let s:wrapenabled = 0
  else
    set linebreak
    nnoremap j gj
    nnoremap k gk
    nnoremap 0 g0
    nnoremap ^ g^
    nnoremap $ g$
    vnoremap j gj
    vnoremap k gk
    vnoremap 0 g0
    vnoremap ^ g^
    vnoremap $ g$
    let s:wrapenabled = 1
  endif
endfunction
map <leader>w :call ToggleWrap()

" User Interface Settings
set wildmenu
set wildmode=list:longest
set showcmd " Show partial command while typing
set showmode " Display the mode
set showmatch " Show matching words during a search
set wildmenu " Display command line's tab complete options in a menu
set wildmode=list:full " Display all matches and complete full match
set cursorline " Highlight the line currently under the cursor
set title " set the window title reflecting the file currently being edited
set mouse=a " Enable mouse support
set splitbelow " Always split below"

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

" Vim Polyglot Disabled
let g:polyglot_disabled = ['markdown']

" Load Plugins
call plug#begin('~/.vim/plugged')

	Plug 'Raimondi/delimitMate'
	Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'PhilRunninger/nerdtree-visual-selection'
	Plug 'godlygeek/tabular'
    Plug 'matze/vim-move'
    Plug 'girishji/vimsuggest'
    Plug 'girishji/scope.vim'
	Plug 'preservim/vim-markdown'
	Plug 'preservim/vim-litecorrect'
	Plug 'tpope/vim-fugitive'
	Plug 'airblade/vim-gitgutter'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'mhinz/vim-startify'
	Plug 'farmergreg/vim-lastplace'
	Plug 'sheerun/vim-polyglot'
    Plug 'ryanoasis/vim-devicons'
    Plug 'tpope/vim-commentary'
    Plug 'ap/vim-css-color'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
    Plug 'dbeniamine/cheat.sh-vim'
    Plug 'tpope/vim-surround'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'mattn/emmet-vim'
    Plug 'fcpg/vim-waikiki'

call plug#end()

" Vim Functions and vimscript
" Custom Keymaps
nmap <C-h> :let @/ = ""<CR>
nnoremap <leader>ww :e ~/Notes/index.md<CR>
nnoremap <leader>mk :!glow -t %<CR>


" Disable Arrow Keymaps in Normal and Visual Modes
for mode in ['n', 'v']
    for key in ['<Left>', '<Right>', '<Up>', '<Down>']
        execute mode . 'noremap' . key . ' :echo "NO ARROW KEYS!"<CR>'
    endfor
endfor

" Vim Scope Keymaps
nnoremap <leader><leader> :Scope
nnoremap <leader>F <cmd>Scope File<CR>
nnoremap <leader>f <cmd>Scope BufSearch<CR>
nnoremap <leader>b <cmd>Scope Buffer<CR>
nnoremap <leader>c <cmd>Scope Command<CR>
nnoremap <leader>s <cmd>Scope Colorscheme<CR>
nnoremap <leader>h <cmd>Scope Help<CR>
nmap <leader>j <cmd>Scope Jumplist<CR>
nmap <leader>k <cmd>Scope Keymap<CR>
nmap <leader>g <cmd>Scope Filetype<CR>
nmap <leader>p <cmd>Scope Register<CR>
nmap <leader>t <cmd>Scope Tag<CR>
nmap <leader>q <cmd>Scope Quickfix<CR>   

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
let g:airline_theme='onedark'
let g:airline_powerline_fonts=1

" Vim Keymaps
nnoremap <C-i> :PlugInstall<CR>
nnoremap <C-u> :PlugUpdate<CR>
nnoremap <C-r> :PlugClean!<CR>

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
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

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
      \ 'coc-explorer':  [ 'CoC Explorer', '%{b:coc_lightbulb_status}' ],
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

" COC Settings
source ~/.vim/coc-settings.vim

" LaTeX Settings
autocmd Filetype tex setl updatetime=1
let g:livepreview_cursorhold_recompile=0
let g:livepreview_previewer = 'mupdf'

" Emmet Vim Settings
let g:user_emmet_mode='inv'
let g:user_emmet_install_global = 1
let g:user_emmet_leader_key='<leader>y'
let g:user_emmet_settings = {
\  'variables': {'lang': 'en', 'charset': 'UTF-8'},
\  'html': {
\    'default_attributes': {
\      'option': {'value': v:null},
\      'textarea': {'id': v:null, 'name': v:null, 'cols': 10, 'rows': 10},
\    },
\    'snippets': {
\      '!!!': "<!DOCTYPE html>\n"
\              ."<html lang=\"${lang}\">\n"
\              ."<head>\n"
\              ."\t<meta charset=\"${charset}\">\n"
\              ."\t<title></title>\n"
\              ."\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
\              ."</head>\n"
\              ."<body>\n\t${child}|\n</body>\n"
\              ."</html>",
\    },
\  },
\}
let g:user_emmet_complete_tag = 1

" Popup Menu Colorscheme
hi Pmenu ctermbg=235 ctermfg=255 cterm=NONE guibg=#282A36 guifg=#F8F8F2 gui=NONE
hi PmenuSel ctermbg=141 ctermfg=235 cterm=bold guibg=#BD93F9 guifg=#282A36 gui=bold
hi PmenuSbar ctermbg=239 cterm=NONE guibg=#44475A gui=NONE
hi PmenuThumb ctermbg=61 cterm=NONE guibg=#6272A4 gui=NONE

" UltiSnips Settings
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsSnippetDirectories = ['~/.vim/snippets', 'UltiSnips']

" VimWaikiki Settings
let g:waikiki_roots = ['~/Notes/']
let maplocalleader = '\'
let g:waikiki_default_maps = 1
let g:waikiki_ask_if_noindex = 1
let g:waikiki_tag_start = '#'
let g:waikiki_tag_end = '#'
let g:waikiki_lookup_order = ['ext', 'subdir']

" Vim Move Settings
let g:move_normal_option = 1

" Vimsuggest Settings
let s:vim_suggest = {}
let s:vim_suggest.cmd = {
    \ 'enable': v:true,
    \ 'pum': v:true,
    \ 'exclude': [],
    \ 'onspace': ['b\%[uffer]','colo\%[rscheme]'],
    \ 'alwayson': v:true,
    \ 'popupattrs': {},
    \ 'wildignore': v:true,
    \ 'addons': v:true,
    \ 'trigger': 't',
    \ 'reverse': v:true,
    \ 'prefixlen': 1,
\ }
let s:vim_suggest.search = {
    \ 'enable': v:true,
    \ 'pum': v:true,
    \ 'fuzzy': v:false,
    \ 'alwayson': v:true,
    \ 'popupattrs': {
    \   'maxheight': 12
    \ },
    \ 'range': 100,
    \ 'timeout': 200,
    \ 'async': v:true,
    \ 'async_timeout': 3000,
    \ 'async_minlines': 1000,
    \ 'highlight': v:true,
    \ 'trigger': 't',
    \ 'prefixlen': 1,
\ }

" Update your existing vimsuggest popup settings
let s:vim_suggest.cmd.popupattrs = {
    \ 'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
    \ 'borderhighlight': ['Comment'],
    \ 'highlight': 'NormalFloat',
    \ 'border': [1, 1, 1, 1],
    \ 'maxheight': 20,
    \ }

let s:vim_suggest.search.popupattrs = {
    \ 'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
    \ 'borderhighlight': ['Comment'],
    \ 'highlight': 'NormalFloat',
    \ 'border': [1, 1, 1, 1],
    \ 'maxheight': 12,
    \ }

if exists('*g:VimSuggestSetOptions')
  autocmd VimEnter * call g:VimSuggestSetOptions(s:vim_suggest)
endif
