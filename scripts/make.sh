#! /usr/bin/env bash
#
# bootstrap installs things.

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Set magic variables for current file and dir
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" ; pwd )"
__file="${__dir}/$( basename "${BASH_SOURCE[0]}" )"
__base="$( basename ${__file} .sh )"
__root="$( cd "$( dirname "${__dir}" )" ; pwd )"

arg1="${1:-}"

# shellcheck source=scripts/common.sh
source "$__root"/scripts/common.sh

set -e

echo ""

function info {
  # shellcheck disable=SC2059
  printf "  [ \033[00;34m..\033[0m ] $1\n"
}

function user {
  # shellcheck disable=SC2059
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

function success {
  # shellcheck disable=SC2059
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

function fail {
  # shellcheck disable=SC2059
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ""
  exit
}

function bootstrap_gitconfig {
  if ! [[ -f git/gitconfig.symlink ]]; then
    info "setup gitconfig"

    git_credential="cache"
    if [ "$(uname -s)" == "Darwin" ]
    then
      git_credential="osxkeychain"
    fi

    user " - What is your github author name?"
    read -e -r git_authorname
    user " - What is your github author email?"
    read -e -r git_authoremail

    sed -e "s/AUTHORNAME/$git_authorname/g" \
      -e "s/AUTHOREMAIL/$git_authoremail/g" \
      -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" \
      git/gitconfig.symlink.example > git/gitconfig.symlink

    success "gitconfig"
  fi
}

function link_file {
  local src=$1 dst=$2
  # shellcheck disable=SC1007
  local overwrite= backup= skip=
  local action=

  if [[ -f "$dst" ]] || [[ -d "$dst" ]] || [[ -L "$dst" ]]; then

    if [[ "$overwrite_all" == "false" ]] && \
      [[ "$backup_all" == "false" ]] && \
      [[ "$skip_all" == "false" ]]; then
      # shellcheck disable=SC2086,SC2155
      local currentSrc="$(readlink $dst)"

      if [[ "$currentSrc" == "$src" ]]; then
        skip=true;
      else
        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -r -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac
      fi
    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [[ "$overwrite" == "true" ]]; then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [[ "$backup" == "true" ]]; then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [[ "$skip" == "true" ]]; then
      success "skipped $src"
    fi
  fi

  if [[ "$skip" != "true" ]]; then  # "false" or empty
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

function bootstrap_dotfiles {
  info "installing dotfiles"

  local overwrite_all=false backup_all=false skip_all=false
  # shellcheck disable=SC2044
  for src in $( find "$__root" -maxdepth 3 -name '*.symlink' )
  do
    dst="$HOME/.$( basename "${src%.*}" )"
    link_file "$src" "$dst"
  done
}

function install_apps {
  info " Installing Applications"
  if ./bin/dot; then
    success "Applications installed"
  else
    fail "Error installing Applications"
  fi
}

function find_zsh {
  if command -v zsh >/dev/null 2>&1 && grep "$(command -v zsh)" /etc/shells >/dev/null; then
    command -v zsh
  else
    echo "/bin/zsh"
  fi
}

function bootstrap_zsh {
  zsh="$(command -v zsh)"
  command -v > /dev/null 2>&1 &&
  chsh -s "$zsh" &&
  success "set $("$zsh" --version) at $zsh as default shell"
}

#setup_gitconfig
#link_dotfiles
#setup_zsh
#install_apps

find_zsh

#echo ""
#echo "  All installed!"
