" ==============================================================================
" COC Configuration for Vim - Integrated with your setup
" ==============================================================================

" Basic CoC Settings
" =================
" Set encoding for CoC
set encoding=utf-8
" Avoid issues with backup files
set nobackup
set nowritebackup
" Improve responsiveness
set updatetime=300
" Always show the signcolumn for diagnostics
set signcolumn=number

" Completion Settings
" ==================
" Tab completion navigation
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Diagnostics Navigation
" =====================
" Use [g and ]g to navigate diagnostics
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" GoTo Code Navigation
" ===================
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" Show Documentation
" =================
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Symbol highlighting and renaming
" ================================
" Highlight the symbol and references when holding cursor
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting and code actions
" ==========================
" Format selected code
xmap <leader>ff  <Plug>(coc-format-selected)
nmap <leader>ff  <Plug>(coc-format-selected)

" Setup formatexpr for specific filetypes
augroup cocformat
  autocmd!
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
augroup end

" Code actions
" ===========
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
nmap <leader>as  <Plug>(coc-codeaction-source)
nmap <leader>qf  <Plug>(coc-fix-current)

" Refactoring
" ===========
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Code Lens
" =========
nmap <leader>cl  <Plug>(coc-codelens-action)

" Text Objects
" ===========
" Use text objects for functions and classes
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Floating Window Scroll
" ======================
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Selection Ranges
" ===============
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" CoC Commands
" ===========
" Add Format command
command! -nargs=0 Format :call CocActionAsync('format')
" Add Fold command
command! -nargs=? Fold :call CocAction('fold', <f-args>)
" Add import organization command
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Status Line
" ==========
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" CocList Mappings
" ==============
" Show diagnostics
nnoremap <silent><nowait> <space>d  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol in current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Navigate items
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Extensions
" =========
let g:coc_global_extensions = [
    \ 'coc-texlab',
    \ 'coc-json',
    \ 'coc-git',
    \ 'coc-clangd',
    \ 'coc-class-css',
    \ 'coc-css',
    \ 'coc-emmet',
    \ 'coc-html',
    \ 'coc-htmldjango',
    \ 'coc-highlight',
    \ 'coc-html-css-support',
    \ 'coc-java',
    \ 'coc-jedi',
    \ 'coc-ltex',
    \ 'coc-lightbulb',
    \ 'coc-sh',
    \ 'coc-snippets',
    \ 'coc-toml',
    \ 'coc-tsserver',
    \ 'coc-vimlsp',
    \ 'coc-xml',
    \ 'coc-yaml'
\ ]

" Filetype mappings
" ===============
let g:coc_filetype_map = {'tex': 'latex'}

" Appearance
" =========
" Floating window colors
hi CocFloating ctermbg=235 ctermfg=255 cterm=NONE guibg=#282A36 guifg=#F8F8F2 gui=NONE
hi CocFloatingSel ctermbg=61 ctermfg=255 cterm=bold guibg=#6272A4 guifg=#F8F8F2 gui=bold
hi CocHintFloat ctermbg=235 ctermfg=117 cterm=NONE guibg=#282A36 guifg=#8BE9FD gui=NONE

" Diagnostics (Errors, Warnings, Info, Hints)
hi CocErrorSign ctermbg=NONE ctermfg=203 cterm=bold guibg=NONE guifg=#FF5555 gui=bold
hi CocWarningSign ctermbg=NONE ctermfg=215 cterm=bold guibg=NONE guifg=#FFB86C gui=bold
hi CocInfoSign ctermbg=NONE ctermfg=117 cterm=bold guibg=NONE guifg=#8BE9FD gui=bold
hi CocHintSign ctermbg=NONE ctermfg=84 cterm=bold guibg=NONE guifg=#50FA7B gui=bold

" Virtual text (inline messages)
hi CocErrorVirtualText ctermfg=203 cterm=italic,bold guifg=#FF5555 gui=italic,bold
hi CocWarningVirtualText ctermfg=215 cterm=italic,bold guifg=#FFB86C gui=italic,bold
hi CocInfoVirtualText ctermfg=117 cterm=italic guifg=#8BE9FD gui=italic
hi CocHintVirtualText ctermfg=84 cterm=italic guifg=#50FA7B gui=italic
hi CocInlayHint ctermfg=61 ctermbg=NONE cterm=italic guifg=#6272A4 guibg=NONE gui=italic

" Border settings
let g:coc_borderchars = ['─', '│', '─', '│', '┌', '┐', '┘', '└']

" Window styling
call coc#config("suggest", {
      \ "floatConfig": {
      \   "border": v:true,
      \   "rounded": v:false,
      \   "borderhighlight": "FloatBorder"
      \ }
      \})

call coc#config("diagnostic", {
      \ "floatConfig": {
      \   "border": v:true,
      \   "rounded": v:false,
      \   "borderhighlight": "FloatBorder"
      \ }
      \})

call coc#config("signature", {
      \ "floatConfig": {
      \   "border": v:true,
      \   "rounded": v:false,
      \   "borderhighlight": "FloatBorder"
      \ }
      \})

call coc#config("hover", {
      \ "floatConfig": {
      \   "border": v:true,
      \   "rounded": v:false,
      \   "borderhighlight": "FloatBorder"
      \ }
      \})

" Define NormalFloat highlight for all floating windows
hi NormalFloat ctermbg=235 ctermfg=255 cterm=NONE guibg=#282A36 guifg=#F8F8F2 gui=NONE
hi FloatBorder ctermbg=235 ctermfg=255 cterm=NONE guibg=#282A36 guifg=#F8F8F2 gui=NONE
