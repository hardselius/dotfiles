function! local#pack#pack_init() abort

  " auto install minpac if it doesn't exist
  if glob(expand('~/.vim/pack/bundle/opt/minpac')) == ''
    !git clone https://github.com/k-takata/minpac $HOME/.vim/pack/bundle/opt/minpac
  endif

  packadd minpac
  call minpac#init({ 'package_name': 'bundle' })

  call minpac#add('SirVer/ultisnips'                   , { 'type': 'opt' })
  call minpac#add('fatih/vim-go'                       , { 'type': 'opt', 'rev': 'v1.22' })
  call minpac#add('godlygeek/tabular'                  , { 'type': 'opt' })
  call minpac#add('hashivim/vim-hashicorp-tools'       , { 'type': 'opt' })
  call minpac#add('jceb/vim-orgmode'                   , { 'type': 'opt' })
  call minpac#add('junegunn/fzf'                       , { 'type': 'opt' })
  call minpac#add('junegunn/fzf.vim'                   , { 'type': 'opt' })
  call minpac#add('k-takata/minpac'                    , { 'type': 'opt' })
  call minpac#add('rust-lang/rust.vim'                 , { 'type': 'opt' })
  call minpac#add('tmux-plugins/vim-tmux'              , { 'type': 'opt' })
  call minpac#add('tmux-plugins/vim-tmux-focus-events' , { 'type': 'opt' })
  call minpac#add('tpope/vim-commentary'               , { 'type': 'opt' })
  call minpac#add('tpope/vim-eunuch'                   , { 'type': 'opt' })
  call minpac#add('tpope/vim-fugitive'                 , { 'type': 'opt', 'rev': 'v3.2' })
  call minpac#add('tpope/vim-markdown'                 , { 'type': 'opt' })
  call minpac#add('tpope/vim-repeat'                   , { 'type': 'opt' })
  call minpac#add('tpope/vim-surround'                 , { 'type': 'opt' })
  call minpac#add('tpope/vim-unimpaired'               , { 'type': 'opt' })
  call minpac#add('tpope/vim-vinegar'                  , { 'type': 'opt' })
  call minpac#add('vimwiki/vimwiki'                    , { 'type': 'opt' })

  " Colorschemes
  call minpac#add('hardselius/warlock'      , { 'type': 'opt' })
  call minpac#add('jaredgorski/fogbell.vim' , { 'type': 'opt' })
  call minpac#add('pgdouyon/vim-yin-yang'   , { 'type': 'opt' })
  call minpac#add('romainl/Apprentice'      , { 'type': 'opt', 'rev': '*'})
endfunction
