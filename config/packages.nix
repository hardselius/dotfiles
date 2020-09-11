{ pkgs }:

with pkgs; [
  (pass.withExtensions (ext: with ext; [ pass-otp pass-genphrase ]))
  cacert
  coreutils
  curl
  darwin-zsh-completions
  direnv
  fd
  findutils
  fzf
  getopt
  git
  gitAndTools.pass-git-helper
  gnumake
  gnupg
  go
  gpgme
  home-manager
  htop
  imagemagick
  jq
  less
  nixUnstable
  nixfmt
  ripgrep
  rsync
  rustup
  shellcheck
  skhd
  spotify-tui
  spotifyd
  stow
  terraform
  tuir
  universal-ctags
  urlscan
  vim
  w3m
  weechat
  wget
  yabai
  zsh
  zsh-powerlevel10k
]
