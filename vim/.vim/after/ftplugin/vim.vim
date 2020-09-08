" Settings for vimscript
set expandtab
set foldmethod=marker
set shiftwidth=2
set softtabstop=2

" Automatically source .vimrc on save
augroup Vimrc
  autocmd!
  autocmd! BufWritePost .vimrc source %
  autocmd! BufWritePost vimrc source %
augroup END
