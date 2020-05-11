function! local#pack#pack_init() abort

  " auto install minpac if it doesn't exist
  if glob(expand('~/.vim/pack/bundle/opt/minpac')) == ''
    !git clone https://github.com/k-takata/minpac $HOME/.vim/pack/bundle/opt/minpac
  endif

  packadd minpac
  call minpac#init({ 'package_name': 'bundle' })
  call minpac#add('k-takata/minpac'      , { 'type': 'opt' })

  call minpac#add('tpope/vim-commentary' , { 'type': 'opt' })
  call minpac#add('tpope/vim-repeat'     , { 'type': 'opt' })
  call minpac#add('tpope/vim-surround'   , { 'type': 'opt' })
  call minpac#add('sheerun/vim-polyglot' , { 'type': 'opt' })

  " lsp stuff
  call minpac#add('liuchengxu/vista.vim'     , { 'type': 'opt' })
  call minpac#add('prabirshrestha/async.vim' , { 'type': 'opt' })
  call minpac#add('prabirshrestha/vim-lsp'   , { 'type': 'opt' })
  call minpac#add('mattn/vim-lsp-settings'   , { 'type': 'opt' })

  "  tmux
  call minpac#add('tmux-plugins/vim-tmux'              , { 'type': 'opt' })
  call minpac#add('tmux-plugins/vim-tmux-focus-events' , { 'type': 'opt' })

  " Colorschemes
  call minpac#add('hardselius/warlock'       , { 'type': 'opt' })
  call minpac#add('romainl/Apprentice'       , { 'type': 'opt' })
endfunction
