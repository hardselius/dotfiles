export PATH=$PATH:$(go env GOPATH)/bin

typeset -U PATH

export GOPATH=$(go env GOPATH)
export CLICOLOR=true
export NOTES="$HOME/dropbox-personal/wiki"
export CDPATH=.:~:~/projects
export GPG_TTY="$TTY"

test -r ~/.dir_colors && eval $(dircolors ~/.dir_colors)

alias cls='clear'
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias reload!='exec "$SHELL" -l'
alias restartaudio='sudo killall coreaudiod'
alias tf='terraform'

bindkey -v
export KEYTIMEOUT=1

vi-search-fix() {
	zle vi-cmd-mode
	zle .vi-history-search-backward
}
autoload vi-search-fix
zle -N vi-search-fix
bindkey -M viins '\e/' vi-search-fix

# bindkey "^?" backward-delete-char

resume() {
	fg
	zle push-input
	BUFFER=""
	zle accept-line
}
zle -N resume
bindkey "^Z" resume

eval "$(direnv hook zsh)"

# # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# if test -e /etc/static/zshrc; then . /etc/static/zshrc; fi
