" Section: Basic {{{
filetype plugin indent on
syntax on
runtime macros/matchit.vim
set autoindent                 " Minimal automatic indent for any filetype.
set backspace=indent,eol,start " Proper backspace behaviour.
set hidden                     " Possibility to have more than one unsaved buffers.
set incsearch                  " Shows the match while typing.
set ruler                      " Shows the current line number at the bottom-right
                               " of the screen.
set wildmenu                   " Command-line completion.
" }}}

" Section: Moving around, searching, patterns, and tags {{{
set ignorecase                 " Search case insensitive.
set path=.,,**                 " Search relative to current file
set smartcase                  " Case sensitive if search begins with upper
                               " case.
" }}}

" Section: Displaying text {{{
set complete-=i                " Limit files searched for auto-complete.
set display=lastline           " Always try to show a paragraph's last line.
set lazyredraw                 " Don't update screen during macro/script execution.
set linebreak                  " Don't break long lines in between words.
set scrolloff=2                " The number of screen lines to keep above/below cursor.
set sidescrolloff=5            " Screen cols to keep to the left/right of the cursor.
" }}}

" Section: Windows {{{
set laststatus=2               " Alway display the statusbar.
set number                     " Show line numbers.
set showtabline=2
set splitbelow                 " Split horizontal windows below to the current.
set splitright                 " Split vertical windows right to the current.

autocmd VimResized * wincmd =
" }}}

" Section: Messages and info {{{
set showcmd                    " Show me what I'm typing.
set visualbell                 " Show me, don't bleep.
" }}}

" Section: Editing text and indent {{{
set clipboard^=unnamed         " System clipboard.
set completeopt+=menuone       " Show completion menu even if only one item.
set shiftround                 " Round indentation to nearest multile of 'sw'
set showmatch                  " Show matching brackets by flickering.
set smarttab                   " Insert 'ts' spaces when <Tab> is pressed.
set virtualedit=block,onemore  " Allow virtual editing in Visual block mode.
set nojoinspaces               " Use one space, not two, after punctuation.
" }}}

" Section: Reading and writing files {{{
set autoread                   " Auto reread changed files without asking.
set encoding=utf-8             " Set default encoding to UTF-8.
set fileformats=unix,dos,mac   " Prefer Unix over Windows over OS 9 formats.
set updatetime=50

if has('vms')
    set nobackup               " Do not keep a backup file, use versions instead.
else
    set backup                 " Keep a backup file (restore previous version).
    if has('persistent_undo')
        set undofile           " Keep an undo file (undo changes after closing).
    endif
endif
" }}}

" Section: Command line editing {{{
set wildcharm=<C-z>
cnoremap <C-R><C-L> <C-R>=substitute(getline('.'), 'ˆ\s*', '', '')<CR>
" }}}

" Section: External commands {{{
if executable('rg')
    set grepformat=%f:%l:%c:%m
    set grepprg=rg\ --vimgrep\ $*  " Use ripgrep
endif

function! Grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost    l* nested lwindow
augroup END
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
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap [L :lfirst<CR>
nnoremap ]L :llast<CR>
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

nnoremap ,G :Grep 
cnoremap <expr> <CR> cmdline#AutoComplete()
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
