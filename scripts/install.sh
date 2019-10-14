#!/usr/bin/env bash
#
# Run all dotfiles installers.
set -eo pipefail

install_pkg() {
  if test "$(which brew)"; then
    brew install "$@"
  fi
}

check_dependencies() {
  if test ! "$(which brew)"; then
    if test "$(uname)" = "Darwin"; then
      echo "  Installing Homebrew for you."
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
      echo "  You are not running a macOS"
      exit 1
    fi
  fi
  if test ! "$(which git)"; then
    install_pkg git
  fi
  if test ! "$(which zsh)"; then
    install_pkg zsh
  fi
}

main() {
  if [ -d ~/.dotfiles ]; then
    echo "The '~/.dotfiles' folder already exists, please, backup it and run this again!"
    exit 1
  fi
  check_dependencies
  git clone --recursive https://github.com/marceldiass/dotfiles ~/.dotfiles
  cd ~/.dotfiles
  bash script/bootstrap
  echo "All done! Please, restart your terminal session!"
}
main
