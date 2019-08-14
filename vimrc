scriptencoding utf-8
execute pathogen#infect()

" toggle line numbers
set number

" fix yaml indentation
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" colorscheme configuration 
set background=dark
colorscheme solarized

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" vim-terraform configuration
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_fmt_on_save=1

" nerdtree configuration
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
