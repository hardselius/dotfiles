compiler go

:command! -buffer -range=% Gofmt let b:winview = winsaveview() |
  \ silent! execute <line1> . "," . <line2> . "!gofmt " | 
  \ call winrestview(b:winview)

:command! -buffer -range=% Goimport let b:winview = winsaveview() |
  \ silent! execute <line1> . "," . <line2> . "!goimports " | 
  \ call winrestview(b:winview)

augroup Goupdate
  autocmd!
  autocmd BufWritePre <buffer> Gofmt
  autocmd BufWritePre <buffer> Goimport
augroup END
