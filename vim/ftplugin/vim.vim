" Settings for vimscript
set shiftwidth=2
set foldmethod=marker

" Automatically source .vimrc on save
augroup Vimrc
	autocmd!
	autocmd! BufWritePost .vimrc source %
	autocmd! BufWritePost vimrc source %
augroup END
