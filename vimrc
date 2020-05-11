" Section: Packages {{{
command! PackUpdate call local#pack#pack_init() | call minpac#update('', { 'do': 'call minpac#status()' })
command! PackClean  call local#pack#pack_init() | call minpac#clean()
command! PackStatus call local#pack#pack_init() | call minpac#status()

packadd! vim-commentary
packadd! vim-repeat
packadd! vim-surround
packadd! vim-polyglot
packadd! vim-tmux
packadd! vim-tmux-focus-events
packadd! vista.vim
packadd! async.vim
packadd! vim-lsp
packadd! vim-lsp-settings
" }}}

" Section: Basic {{{
filetype plugin indent on
syntax on
runtime macros/matchit.vim
" }}}

" Section: Variables {{{
let $MYVIMRC="~/.vimrc"
let $MYVIMDIR="~/.vim"
" }}}

" Section: Moving around, searching, patterns, and tags {{{
set hlsearch                   " Highlight found matches.
set ignorecase                 " Search case insensitive.
set include=
set incsearch                  " Shows the match while typing.
set path=.,,                   " Search relative to current file
set smartcase                  " Case sensitive if search begins with upper case.
" }}}

" Section: Displaying text {{{
set complete-=i                " Limit files searched for auto-complete
set display=lastline           " Always try to show a paragraph's last line
set lazyredraw                 " Don't update screen during macro/script execution
set linebreak                  " Don't break long lines in between words
set scrolloff=2                " The number of screen lines to keep above/below cursor
set sidescrolloff=5            " Screen cols to keep to the left/right of the cursor
" }}}

" Section: Windows {{{
set laststatus=2               " Alway display the statusbar
set number                     " Show line numbers
set ruler                      " Show the line and column number of the cursor position.
set showtabline=2
set splitbelow                 " Split horizontal windows below to the current
set splitright                 " Split vertical windows right to the current

autocmd VimResized * wincmd =
" }}}

" Section: Messages and info {{{
set confirm                    " Display confirmation dialog when closing an unsaved file
set showcmd                    " Show me what I'm typing
set visualbell                 " Show me, don't bleep
" }}}

" Section: Editing text and indent {{{
set autoindent                 " Minimal automatic indent for any filetype
set backspace=indent,eol,start " Proper backspace behaviour.
set clipboard^=unnamed         " System clipboard
set completeopt+=menuone       " Show completion menu even if only one item
set shiftround                 " Round indentation to nearest multile of 'sw'
set showmatch                  " Show matching brackets by flickering
set smarttab                   " Insert 'ts' spaces when <Tab> is pressed
set virtualedit=block,onemore  " Allow virtual editing in Visual block mode.
" }}}

" Section: Reading and writing files {{{
set autoread                   " Auto reread changed files without asking
set encoding=utf-8             " Set default encoding to UTF-8
set fileformats=unix,dos,mac   " Prefer Unix over Windows over OS 9 formats
set hidden                     " Possibility to have more than one unsaved buffers.
set updatetime=250
set viminfo=!,'20,<50,s10,h
" }}}

" Section: Command line editing {{{
set wildcharm=<C-z>
set wildmenu                   " Command-line completion.
cnoremap <C-R><C-L> <C-R>=substitute(getline('.'), 'ˆ\s*', '', '')<CR>
" }}}

" Section: External commands {{{
set grepformat=%f:%l:%c:%m
if executable('rg')
    set grepprg=rg\ --vimgrep\ $*  " Use ripgrep
endif
" }}}

" Section: Highlighting {{{
set cursorline
colorscheme apprentice
" }}}

" Sections: Mappings {{{
" Faster buffer navigation
nnoremap ,b :buffer *
" Command-line like forward-search
cnoremap <C-k> <Up>
" Command-line like backward-search
cnoremap <C-j> <Down>
" Fast global commands
nnoremap ,g :g//#<Left><Left>
" Faster project based editing
nnoremap ,e :e  **/*<C-z><S-Tab>

if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Path-based file navigation
nnoremap ,f :find *
nnoremap ,v :vertical splitfind *
nnoremap ,F :find <C-R>=fnameescape(expand('%:p:h')).'**/*'<CR>
nnoremap ,V :vertical splitfind <C-R>=fnameescape(expand('%:p:h')).'**/*'<CR>

" Quickfix list navication
nnoremap [c :cnext<CR>
nnoremap ]c :cprevious<CR>
nnoremap [l :lnext<CR>
nnoremap ]l :lprevious<CR>
nnoremap <silent> <C-w>z :wincmd z<Bar>cclose<Bar>lclose<CR>

" Argslist navigation
nnoremap [a :previous<CR>
nnoremap ]a :next<CR>
nnoremap [A :first<CR>
nnoremap ]A :last<CR>

" Generate ctags for current working directory
nnoremap <leader>tt :silent !ctags -R . <CR>:redraw!<CR>

" Go to index of notes and change working directory
nnoremap <leader>ni :e $NOTES/index.md<cr>:cd $NOTES<cr>
" }}}

" Section: Autocommands {{{
" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
" }}}

" Section: Plugin settings {{{

let g:go_highlight_functions = 1
let g:go_code_completion_enabled = 0

let g:lsp_diagnostics_enabled = 1
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

let g:netrw_liststyle = 3
let g:netrw_winsize=20
let g:netrw_localrmdir='rm -r'
" }}}

" vim:expandtab:shiftwidth=4:foldmethod=marker:foldlevel=1
