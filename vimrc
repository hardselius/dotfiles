" Section: Packages {{{

command! PackUpdate call local#pack#pack_init() | call minpac#update('', { 'do': 'call minpac#status()' })
command! PackClean  call local#pack#pack_init() | call minpac#clean()
command! PackStatus call local#pack#pack_init() | call minpac#status()

packadd! fzf
packadd! fzf.vim
packadd! goyo.vim
packadd! tabular
packadd! tagbar

packadd! vim-repeat
packadd! vim-unimpaired

" git
packadd! vim-fugitive
packadd! vim-gitgutter

" tmux
packadd! vim-tmux
packadd! vim-tmux-focus-events

" Language specific
packadd! vim-polyglot

" LSP
packadd! vista.vim
packadd! async.vim
packadd! vim-lsp
packadd! vim-lsp-settings

" }}}

" Section: Settings {{{

filetype plugin indent on
syntax on

runtime macros/matchit.vim

set autoindent                 " Minimal automatic indent for any filetype
set backspace=indent,eol,start " Proper backspace behaviour.
set complete-=i                " Limit files searched for auto-complete
set ruler                      " Show the line and column number of the cursor position.
set wildmenu                   " Command-line completion.
set scrolloff=1                " The number of screen lines to keep above/below cursor
set sidescrolloff=5            " Screen cols to keep to the left/right of the cursor
set display+=lastline          " Alwary try to show a paragraph's last line
set cursorline

set incsearch                  " Shows the match while typing.
set hlsearch                   " Highlight found matches.
set ignorecase                 " Search case insensitive ...
set smartcase                  " ... but not if it begins with upper case.
set include=
set path=.,,
set grepprg=rg\ --vimgrep\ $*  " Use ripgrep
set grepformat=%f:%l:%c:%m

set lazyredraw                 " Don't update screen during macro/script execution
set encoding=utf-8             " Set default encoding to UTF-8

colorscheme apprentice

highlight clear CursorLine
highlight CursorLineNR cterm=bold
augroup cursosline
  autocmd! ColorScheme * highlight clear CursorLine
  autocmd! ColorScheme * highlight CursorLineNR cterm=bold
augroup END

set showtabline=2
set hidden                     " Possibility to have more than one unsaved buffers.
set number                     " Show line numbers
set splitright                 " Split vertical windows right to the current
set splitbelow                 " Split horizontal windows below to the current

" Automatically resize screens to be equally the same
autocmd VimResized * wincmd =

set showmatch                  " Show matching brackets by flickering
set virtualedit=block          " Allow virtual editing in Visual block mode.
set shiftround                 " Round indentation to nearest multile of 'sw'
set smarttab                   " Insert 'ts' spaces when <Tab> is pressed
set completeopt=menu,menuone,noinsert,noselect
set clipboard^=unnamed

set confirm                    " Display confirmation dialog when closing an unsaved file
set showcmd                    " Show me what I'm typing
set visualbell                 " Show me, don't bleep

if has('folding')
  set foldmethod=marker        " Fold based on marker
  set foldopen+=jump           " Also open fold on far jumps, e.g g or G
  set foldenable               " Don't fold files by default on open
  set foldlevelstart=10        " Start with a foldlevel of 10
endif

set fileformats=unix,dos,mac   " Prefer Unix over Windows over OS 9 formats
set autoread                   " Auto reread changed files without asking
set noswapfile                 " Don't use swapfile
set nobackup                   " Don't create annoying backup files
set viminfo='1000              " ~/.viminfo needs to be writeable and readable
if has('persistent_undo')
  set undofile
  set undodir=~/.cache/vim
endif

set wildcharm=<C-z>

set modeline                   " Enable modeline
set nomodelineexpr             " ... but not expressions

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

set laststatus=2               " Alway display the statusbar
set statusline=%!local#statusline#buildstatusline()

" }}}

" Section: Mapings {{{

" Clear search highlight
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" The leader
let mapleader = ','

" Close both the quickfix and location list
nnoremap <silent><leader>a :cclose<CR>:lclose<CR>

" Visual linewise up and down
nnoremap j gj
nnoremap k gk

" Center on line when jumping between search results
nnoremap n nzzzv
nnoremap N Nzzzv

" Center on line when moving up and down
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" Generate ctags for current working directory
nnoremap <leader>tt :silent !ctags -R . <CR>:redraw!<CR>

" Go to index of notes and change working directory
nnoremap <leader>ni :e $NOTES/index.md<cr>:cd $NOTES<cr>

" }}}

" Section: Commands {{{

command! Vimrc :vs $MYVIMRC

" }}}

" Section: Plugins {{{

" Enable gitguter realtime upadating
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 1
set updatetime=250

nnoremap <silent> <C-w>. :if exists(':Wcd')<Bar>exe 'Wcd'<Bar>elseif exists(':Lcd')<Bar>exe 'Lcd'<Bar>elseif exists(':Glcd')<Bar>exe 'Glcd'<Bar>else<Bar>lcd %:h<Bar>endif<CR>
nmap cd <C-W>.

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_command_prefix = 'Fzf'

" Fuzzy comand finder space shortcut 
nnorema <space> :FzfCommands<cr> 

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

let g:lsp_diagnostics_enabled = 0
let g:vista_executive_for = {
  \ 'go': 'vim_lsp',
  \ 'terraform': 'vim_lsp',
	\ }
let g:vista_ignore_kinds = ['Variable']

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
endfunction

augroup lsp_install
    autocmd!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize=20
let g:netrw_localrmdir='rm -r'

" }}}

" vim:foldmethod=marker:foldlevel=1
