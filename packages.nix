{ pkgs }:

with pkgs; [
  # khard # TODO: build fails
  # ripmime # TODO: darwin not supported
  # vdirsyncerStable # TODO: broken
  coreutils
  curl
  direnv
  fd
  findutils
  fzf
  getopt
  git
  gitAndTools.diff-so-fancy
  gitAndTools.pass-git-helper
  gnumake
  gnupg
  go
  gpgme
  htop
  isync
  jq
  less
  lorri
  msmtp
  mu
  neomutt
  pass
  ripgrep
  rsync
  rustup
  shellcheck
  stow
  terraform
  universal-ctags
  urlscan
  vim_configurable
  w3m
  wget
  zsh
  zsh-powerlevel10k

  pkgs.darwin-zsh-completions
]
