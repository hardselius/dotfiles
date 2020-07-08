{ pkgs }:

with pkgs; [
  # khard # TODO: build fails
  # ripmime # TODO: darwin not supported
  # vdirsyncerStable # TODO: broken
  (pass.withExtensions (ext: with ext; [ pass-otp pass-genphrase ]))
  cacert
  coreutils
  curl
  direnv
  fd
  findutils
  fzf
  getopt
  git
  gitAndTools.delta
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
  nixfmt
  passff-host
  pkgs.darwin-zsh-completions
  ripgrep
  rsync
  rustup
  shellcheck
  skhd
  stow
  terraform
  universal-ctags
  urlscan
  vim_configurable
  w3m
  wget
  yabai
  zsh
  zsh-powerlevel10k
]
