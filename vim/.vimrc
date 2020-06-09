" Section: Basic {{{
filetype plugin indent on
syntax on
" }}}

" Section: Settings {{{
set autoindent                 " Minimal automatic indent for any filetype.
set backspace=indent,eol,start " Proper backspace behaviour.
set hidden                     " Prefer hiding over unloading buffers.
set incsearch                  " Shows the match while typing.
set ruler                      " Shows line,col at bottom right.
set wildmenu                   " Command-line completion.

set autoread                   " Auto reread changed files without asking.
set clipboard^=unnamed         " System clipboard.
set laststatus=2               " Always show status line.
set noswapfile                 " No swapfiles.
set number                     " Show line numbers.
set path=.,,**                 " Search relative to current file.
set shiftround                 " Round indentation to nearest multile of 'sw'
set tags=./tags;,tags;         " Tags relative to current file + dir + parents recursively.
set virtualedit=block          " Allow virtual editing in Visual block mode.
set wildcharm=<C-z>            " Macro-compatible command-line wildchar.

colorscheme jellybeans
" }}}

" Section: External commands {{{
if executable('rg')
  set grepformat=%f:%l:%c:%m,%f:%l:%m
  set grepprg=rg\ --vimgrep\ --no-heading\ --hidden\ $*  " Use ripgrep
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

" Sections: Mappings {{{
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
nnoremap ,e :e **/*<C-z><S-Tab>
" Make the directory for the current file path
nnoremap ,m :!mkdir -p %:h<CR>

" Path-based file navigation
nnoremap ,f :find *
nnoremap ,v :vertical sfind *
nnoremap ,F :find <C-R>=fnameescape(expand('%:p:h')).'**/*'<CR>
nnoremap ,V :vertical sfind <C-R>=fnameescape(expand('%:p:h')).'**/*'<CR>

nnoremap <silent> <C-w>z :wincmd z<Bar>cclose<Bar>lclose<CR>

" Argslist navigation
nnoremap [a :previous<CR>
nnoremap ]a :next<CR>
nnoremap [A :first<CR>
nnoremap ]A :last<CR>

" Go to index of notes and change working directory
nnoremap <Leader>ni :e $NOTES/index.md<CR>:cd $NOTES<CR>

" Symbol-based navigation
nnoremap ,t :tjump /
nnoremap ,d :dlist /
nnoremap ,i :ilist /

" Scratch buffer
command! SC vnew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile

"Redirect output of command into scratch buffer
command! -nargs=1 -complete=command -bar -range Redir silent call redir#Redir(<q-args>, <range>, <line1>, <line2>)
nnoremap ,r :Redir<Space>

nnoremap ,G :Grep 
cnoremap <expr> <CR> cmdline#AutoComplete()
" }}}

" Section: Plugins {{{
runtime macros/matchit.vim
packadd! vim-goimports
packadd! vim-terraform

let g:terraform_fmt_on_save = 1

let g:UltiSnipsSnippetDirectories=["UltiSnips"]
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
cnoreabbrev resnip call UltiSnips#RefreshSnippets() 

let g:netrw_liststyle = 3
let g:netrw_localrmdir='rm -r'
" }}}
