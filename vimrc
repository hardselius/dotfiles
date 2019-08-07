scriptencoding utf-8
execute pathogen#infect()

syntax on
filetype plugin indent on

set background=dark
colorscheme solarized

let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_fmt_on_save=1

# NERDTree Configuration
map <C-n> :NERDTreeToggle<CR>
