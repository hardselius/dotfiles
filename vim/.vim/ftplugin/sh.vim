" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

set expandtab
set shiftwidth=2
set softtabstop=2

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save
