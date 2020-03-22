" builds a string designed to be used in the statusline
function! local#statusline#buildstatusline()
  " let l:line .= '%#StatusLineNC#'              " different highlight
  " let l:line .= '%*'                           " reset highlight

  let l:line = ''
  let l:line .= ' [%n] '                        " buffer number
  let l:line .= ' %<%f '                        " filename
  let l:line .= '%( %r%m%w%q%h %)'              " flags
  let l:line .= '%( %{go#statusline#Show()} %)' " go statusline
  let l:line .= '%='                            " separator
  let l:line .= ' %{&ft} '                      " filetype
  let l:line .= ' %([%{&fenc}]%)%{&ff} '        " encodings
  let l:line .= ' %l/%L | %v '                  " cursor

  if exists('g:loaded_ale')
    if g:ale_running
      let l:line .= '%( [lint] %)'
    else
      let l:ale = ale#statusline#Count(bufnr('%'))
      if l:ale.total > 0
        if l:ale.error > 0
          let l:line .= '( '
        else
          let l:line .= '( '
        endif
        let l:line .= printf('E:%d W:%d', l:ale.error + l:ale.style_error, l:ale.warning + l:ale.style_warning + l:ale.info)
        let l:line .= ' %)'
      else
        let l:line .= '%( [ OK ] %)'
      endif
    endif
  endif


  " git status
  if exists('g:loaded_fugitive')
    let l:line .= '%( %{fugitive#statusline()} %)'
  endif

  return l:line
endfunction

function! local#statusline#buildsimplestatusline()
  let l:line = '[%n]\ %<%.99f\ %y%h%w%m%r%=%-14.(%l,%c%V%)\ %P'
  return l:line
endfunction
