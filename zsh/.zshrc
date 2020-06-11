PATH=$PATH:~/go/bin
PATH=$PATH:$(go env GOPATH)/bin

typeset -U PATH

export GOPATH=$(go env GOPATH)

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export EDITOR="vim"
export CLICOLOR=true
# notes folder
export NOTES="$HOME/dropbox-personal/wiki"

# FZF
export FZF_DEFAULT_COMMAND='fd --type file --color=always --follow --hidden --exclude .git'
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export CDPATH=.:~:~/projects

[[ -f ~/.localrc ]] && source ~/.localrc

export GPG_TTY="$TTY"
test -r ~/.dir_colors && eval $(gdircolors ~/.dir_colors)

# Configure oh-my-zsh
export ZSH="/Users/martin/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# -----------------------------------------------------------------------------
# ALIASES
# -----------------------------------------------------------------------------

alias cls='clear'
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias reload!='exec "$SHELL" -l'
alias restartaudio='sudo killall coreaudiod'
alias tf='terraform'

if command -v gls &>/dev/null; then
    alias ls="gls -F --color --group-directories-first"
    alias l="gls -lAh --color --group-directories-first"
    alias ll="gls -l --color --group-directories-first"
    alias la="gls -A --color --group-directories-first"
else
    if [[ "$(uname -s)"  == "Darwin" ]]; then
        alias ls="ls -FG"
    else
        alias ls="ls -F --color"
    fi
    alias l="ls -lAh"
    alias la="ls -A"
    alias ll="ls -l"
fi

# -----------------------------------------------------------------------------
# KEY BINDINGS
# -----------------------------------------------------------------------------

# Use vim-like key bindings by default
bindkey -v

# Remove mode change delay
export KEYTIMEOUT=1

vi-search-fix() {
	zle vi-cmd-mode
	zle .vi-history-search-backward
}

autoload vi-search-fix
zle -N vi-search-fix
bindkey -M viins '\e/' vi-search-fix

# Fix backspace
bindkey "^?" backward-delete-char

# Allow Ctrl-z to toggle between suspend and resume.
function resume {  
    fg
    zle push-input 
    BUFFER=""
    zle accept-line
} 
zle -N resume
bindkey "^Z" resume

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f ~/.fzf.zsh ]] || source ~/.fzf.zsh
