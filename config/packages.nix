{ pkgs }:

with pkgs; [
  cacert
  coreutils
  curl
  darwin-zsh-completions
  fd
  findutils
  getopt
  git
  gitAndTools.pass-git-helper
  gnumake
  gnupg
  go
  gpgme
  home-manager
  htop
  jq
  less
  nixpkgs-fmt
  nodePackages.node2nix
  nodePackages.vim-language-server
  pass
  plantuml
  pure-prompt
  pywal
  renameutils
  ripgrep
  rsync
  universal-ctags
  urlscan
  vim
  vim-vint
  w3m
  weechat
  wget
]
