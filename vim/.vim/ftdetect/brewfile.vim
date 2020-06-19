" Vim filetype plugin
" Language:  Brewfile
" Mantainer: Martin Hardselius <martin.hardselius@gmail.com>
" Last Change: 2020 Jun 19

" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

autocmd BufNewFile,BufRead Brewfile,.Brewfile set filetype=ruby syntax=brewfile

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save
