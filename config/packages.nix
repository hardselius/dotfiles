{ pkgs }:

with pkgs; [
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
  imagemagick
  jq
  less
  lorri
  niv
  nixfmt
  passff-host
  pkgs.darwin-zsh-completions
  ripgrep
  rsync
  rustup
  shellcheck
  skhd
  spotifyd
  spotify-tui
  stow
  terraform
  universal-ctags
  urlscan
  vim
  # vim_configurable
  w3m
  wget
  yabai
  zsh
  zsh-powerlevel10k
  weechat

  nixUnstable
]
