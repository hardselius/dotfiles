export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

export EDITOR="vim"
export CLICOLOR=true

# shortcut to this dotfiles path is $DOTFILES
export DOTFILES="$HOME/.dotfiles"
export PATH="/usr/local/bin:$DOTFILES/bin:$PATH"

# project folder that we can `cd [tab]` to
export PROJECTS="$HOME/projects"

# notes folder
export NOTES="$HOME/dropbox-personal/wiki"

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

export GOPATH="$PROJECTS/go"
export PATH="$PATH:$GOPATH/bin"

export TEXPATH="/Library/TeX"
export PATH="$PATH:$TEXPATH/texbin"

typeset -U PATH

# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

setopt PUSHDSILENT
