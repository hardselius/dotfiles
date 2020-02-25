" PLUGINS: {{{

command! PackUpdate call local#pack#pack_init() | call minpac#update('', { 'do': 'call minpac#status()' })
command! PackClean  call local#pack#pack_init() | call minpac#clean()
command! PackStatus call local#pack#pack_init() | call minpac#status()

packadd! Apprentice
packadd! fzf
packadd! fzf.vim
packadd! tabular
packadd! ultisnips
packadd! vim-commentary
packadd! vim-eunuch
packadd! vim-fugitive
packadd! vim-repeat
packadd! vim-surround
packadd! vim-unimpaired
packadd! vim-vinegar
packadd! vim-wakatime

" Language specific
packadd! vim-go
packadd! vim-markdown

" }}}

" SETTINGS: {{{
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set nocompatible
filetype plugin indent on
syntax on

runtime macros/matchit.vim

set autoindent                 " Minimal automatic indent for any filetype
set backspace=indent,eol,start " Proper backspace behaviour.
set complete-=i                " Limit files searched for auto-complete
set laststatus=2               " Alway display the statusbar
set ruler                      " Show the line and column number of the cursor position.
set wildmenu                   " Command-line completion.
set scrolloff=1                " The number of screen lines to keep above/below cursor
set sidescrolloff=5            " Screen cols to keep to the left/right of the cursor
set display+=lastline          " Alwary try to show a paragraph's last line

" Section: Moving around, searching
" ------------------------------------------------------------------------------
set incsearch                  " Shows the match while typing.
set hlsearch                   " Highlight found matches.
set ignorecase                 " Search case insensitive ...
set smartcase                  " ... but not if it begins with upper case.
set include=
set path=.,,
set grepprg=rg\ --vimgrep\ $*  " Use ripgrep
set grepformat=%f:%l:%c:%m

" Section: Displaying text
" ------------------------------------------------------------------------------
set lazyredraw                 " Don't update screen during macro/script execution
set encoding=utf-8             " Set default encoding to UTF-8

" Section: Color theme and highlighting
" ------------------------------------------------------------------------------
colorscheme apprentice

" Section: Windows
" ------------------------------------------------------------------------------
set showtabline=2
set hidden                     " Possibility to have more than one unsaved buffers.
set number                     " Show line numbers
set splitright                 " Split vertical windows right to the current
set splitbelow                 " Split horizontal windows below to the current

" Automatically resize screens to be equally the same
autocmd VimResized * wincmd =

" Section: Editing text and indent
" ------------------------------------------------------------------------------
set showmatch                  " Show matching brackets by flickering
set virtualedit=block          " Allow virtual editing in Visual block mode.
set shiftround                 " Round indentation to nearest multile of 'sw'
set smarttab                   " Insert 'ts' spaces when <Tab> is pressed
set completeopt=menu,menuone,noinsert,noselect
set clipboard^=unnamed
set clipboard^=unnamedplus

" Section: Messages and info
" ------------------------------------------------------------------------------
set confirm                    " Display confirmation dialog when closing an unsaved file
set showcmd                    " Show me what I'm typing
set visualbell                 " Show me, don't bleep

" Section: Folding
" ------------------------------------------------------------------------------
if has('folding')
  set foldmethod=marker        " Fold based on marker
  set foldopen+=jump           " Also open fold on far jumps, e.g g or G
  set foldenable               " Don't fold files by default on open
  set foldlevelstart=10        " Start with a foldlevel of 10
endif

" Section: Reading and writing files
" ------------------------------------------------------------------------------
set fileformats=unix,dos,mac   " Prefer Unix over Windows over OS 9 formats
set autoread                   " Auto reread changed files without asking
set autowrite                  " Automatically save before :next, :make etc.
set noswapfile                 " Don't use swapfile
set nobackup                   " Don't create annoying backup files
set viminfo='1000              " ~/.viminfo needs to be writeable and readable
if has('persistent_undo')
  set undofile
  set undodir=~/.cache/vim
endif

" Remove trailing whitespace on save
autocmd! BufWritePre * :%s/\s\+$//e

" Section: Command line editing
" ------------------------------------------------------------------------------
set wildcharm=<C-z>

" Section: Misc
" ------------------------------------------------------------------------------
set modeline                   " Enable modeline
set nomodelineexpr             " ... but not expressions

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

" }}}

" STATUSLINE: {{{
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set statusline=[%n]\ %<%.99f\ %y%h%w%m%r%=%-14.(%l,%c%V%)\ %P

" }}}

" MAPPINGS: {{{
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Clear search highlight
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" The leader
let mapleader = ','

nnoremap <leader>e :e **/*<C-z><S-Tab>
nnoremap <leader>n :Lexplore<CR>

" Close all windows but the current
nnoremap <leader>o :only<CR>

" Close both the quickfix and location list
nnoremap <silent><leader>a :cclose<CR>:lclose<CR>

nnoremap <silent> <C-w>. :if exists(':Wcd')<Bar>exe 'Wcd'<Bar>elseif exists(':Lcd')<Bar>exe 'Lcd'<Bar>elseif exists(':Glcd')<Bar>exe 'Glcd'<Bar>else<Bar>lcd %:h<Bar>endif<CR>
nmap cd <C-W>.

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Visual linewise up and down
nnoremap j gj
nnoremap k gk

" Center the screen
nnoremap <space> zz

" Center on line when jumping between search results
nnoremap n nzzzv
nnoremap N Nzzzv

" Center on line when moving up and down
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" }}}

" FILETYPE SETTINGS: {{{
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

augroup filetype_settings
	autocmd!
	autocmd FileType go
      \ setlocal foldmethod=syntax|
		  \ setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd FileType terraform
      \ setlocal foldnestmax=1
  autocmd FileType yaml,json
      \ setlocal expandtab tabstop=2 shiftwidth=2
	autocmd FileType sh,zsh,csh,tcsh
      \ setlocal formatoptions-=t|
      \ setlocal expandtab tabstop=4 shiftwidth=4
	autocmd FileType liquid,markdown,text,txt
      \ setlocal textwidth=78 linebreak keywordprg=dict
	autocmd FileType vim
      \ setlocal keywordprg=:help foldmethod=expr|
      \ setlocal foldexpr=getline(v:lnum)=~'^\"\ Section:'?'>1':'='|
      \ setlocal expandtab tabstop=2 shiftwidth=2
augroup END

" }}}

" PLUGINS: {{{
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Plugin: fzf
" ------------------------------------------------------------------------------
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_command_prefix = 'Fzf'
" let g:fzf_layout = {'left': '30%'}

" Search
nmap <C-p> :FzfHistory<cr>
imap <C-p> <esc>:<C-u>FzfHistory<cr>

" Search across files in the current directory
nmap <C-b> :FzfFiles<cr>
imap <C-b> <esc>:<C-u>FzfFiles<cr>

let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
  \ -g "!{.git,node_modules,vendor}/*" '

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

" Plugin: netrw
" ------------------------------------------------------------------------------
let g:netrw_liststyle = 3
let g:netrw_winsize=20
let g:netrw_localrmdir='rm -r'

" Plugin: vim-fugitive (git)
" ------------------------------------------------------------------------------
nnoremap <leader>gs :Gstatus<CR>
vnoremap <leader>gB :Gblame<CR>
nnoremap <leader>gB :Gblame<CR>
nnoremap <leader>gl :silent! Glog!<CR>

" Plugin: HashiCorp Tools
" ------------------------------------------------------------------------------
let g:terraform_align = 1
let g:terraform_fmt_on_save = 1
let g:terraform_fold_sections = 1

" Plugin: tpope/vim-markdown
" ------------------------------------------------------------------------------
let g:markdown_conceal = 0
let g:markdown_fenced_languages = [
    \ 'go',
    \ 'sh',
    \]

" Plugin: vim-go
" ------------------------------------------------------------------------------

" Configure 'gopls' stuff
let g:go_gopls_enabled = 1
let g:go_info_mode = 'gopls'
let g:go_def_mode = 'gopls'
let g:go_referrers_mode = 'gopls'
let g:go_metalinter_command = 'gopls'
let g:go_rename_command = 'gopls'

let g:go_gopls_complete_unimported = 1

let g:go_gopls_staticcheck = 1
let g:go_diagnostics_enabled = 1

" Configure gofmt
let g:go_fmt_fail_silently = 1
let g:go_fmt_command = 'goimports'
autocmd FileType go let b:go_fmt_options = {
  \ 'goimports': '-local ' .
    \ trim(system('{cd '. shellescape(expand('%:h')) .' && go list -m;}')),
  \ }

let g:go_debug_windows = {
    \ 'vars': 'leftabove 35vnew',
    \ 'stack': 'botright 10new',
    \ }

" let g:go_list_type = 'quickfix'

let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_extra_types = 1

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

augroup go
  autocmd!

  " Introspection (diagnostics, documentation, signature help)
  autocmd FileType go nmap <silent> gm <plug>(go-info)
  autocmd FileType go nmap <silent> gl <plug>(go-diagnostics)

  " Navigation (definition, implementation, document symbols, references)
  " TODO: document symbol
  " autocmd FileType go nmap <silent> go <plug>()
  " TODO: implementation
  " autocmd FileType go nmap <silent> gI <plug>()
  autocmd FileType go nmap <silent> gr <plug>(go-referrers)

  " Edit assistence (rename, code actions)
  autocmd FileType go nmap <silent> gR <plug>(go-rename)
  " TODO: code actions
  " autocmd FileType go nmap <silent> ga <plug>()

  " Leader mappings
  autocmd FileType go nmap <silent> <leader>b :<C-u>call <SID>build_go_files()<CR>
  autocmd FileType go nmap <silent> <leader>t  <Plug>(go-test)
  autocmd FileType go nmap <silent> <leader>r  <Plug>(go-run)
  autocmd FileType go nmap <silent> <leader>e  <Plug>(go-install)
  autocmd FileType go nmap <silent> <leader>l  <Plug>(go-lint)

  " Override :GoAlternate with :A, :AV, :AS, and :AT
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END

" }}}

" vim:foldmethod=marker:foldlevel=1
