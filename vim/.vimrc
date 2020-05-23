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
set ignorecase                 " Search case insensitive.
set include=
set incsearch                  " Shows the match while typing.
set path=.,,**                 " Search relative to current file
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

" Section: Statusline {{{

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
set notimeout                  " Don't timeout on mappings
set ttimeout                   " Do timeout on terminal key codes
set ttimeoutlen=50             " Timeout after 50ms

" Re-detect filetypes
nnoremap <leader>t :filetype<CR>
" Fast switching to alternate file
nnoremap ,a :buffer#<CR>
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
" Make the directory for the current file path
nnoremap ,m :!mkdir -p %:h<CR>

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

" Go to index of notes and change working directory
nnoremap <leader>ni :e $NOTES/index.md<cr>:cd $NOTES<cr>

" Symbol-based navigation
nnoremap ,t :tjump /
nnoremap ,d :dlist /
nnoremap ,i :ilist /

" Scratch buffer
command! SC vnew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
" command! -nargs=+ -complete=file_in_path -bar Grep silent! grep! <args> | redraw!
command! -nargs=+ -complete=file -bar Grep silent! grep! <args> | copen 10 | redraw!

nnoremap <silent> ,G :Grep
cnoremap <expr> <CR> cmdline#AutoComplete()
" }}}

" Section: Autocommands {{{
" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
" }}}

" Section: Plugins {{{
packadd! vim-goimports
" }}}

" Section: Plugin settings {{{
let g:go_highlight_functions = 1

let g:netrw_liststyle = 3
let g:netrw_winsize=20
let g:netrw_localrmdir='rm -r'
" }}}

" vim:expandtab:shiftwidth=4:foldmethod=marker:foldlevel=1
