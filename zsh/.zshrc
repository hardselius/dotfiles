#! /usr/bin/env zsh

# INIT {{{
# -----------------------------------------------------------------------------
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Use .localrc for SUPER SECRET CRAP that you don't want in yor public,
# versioned repo.
[[ -f ~/.localrc ]] && source ~/.localrc

export GPG_TTY="$TTY"
test -r ~/.dir_colors && eval $(gdircolors ~/.dir_colors)

# }}}

# ALIASES {{{
# -----------------------------------------------------------------------------
alias cls='clear'
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias reload!='exec "$SHELL" -l'
alias restartaudio='sudo killall coreaudiod'
alias tf='terraform'

if command -v gls &>/dev/null; then
    # grc overides for ls
    #   Made possible through contributions from generous benefactors like
    #   `brew install coreutils`
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

if command -v hub >/dev/null 2>&1; then
	alias git='hub'
fi

gi() {
	curl -s "https://www.gitignore.io./api/$*";
}

# Load custom functions
fpath=($ZSH_FUNCTIONS $fpath)
autoload -U "$ZSH_FUNCTIONS"/*(:t)
# }}}

# HISTORY {{{
# -----------------------------------------------------------------------------
## Command history configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
# ignore duplication command history list
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
# share command history data
setopt share_history
# }}}

# AUTOCOMPLETION {{{
# -----------------------------------------------------------------------------
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

autoload -U +X bashcompinit && bashcompinit

zstyle ':completion:*' completer _oldlist _expand _complete _match _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' insert-tab pending
zstyle ':completion:*' menu select=2

# Automatically update PATH entries
zstyle ':completion:*' rehash true

# Keep directories and files separated
zstyle ':completion:*' list-dirs-first true
# }}}

# KEY BINDINGS {{{
# -----------------------------------------------------------------------------
# Use emacs-like key bindings by default:
bindkey -e

if [[ "${terminfo[kpp]}" != "" ]]; then
  bindkey "${terminfo[kpp]}" up-line-or-history       # [PageUp] - Up a line of history
fi

if [[ "${terminfo[knp]}" != "" ]]; then
  bindkey "${terminfo[knp]}" down-line-or-history     # [PageDown] - Down a line of history
fi

if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line      # [Home] - Go to beginning of line
fi

if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}"  end-of-line            # [End] - Go to end of line
fi
if [[ "${terminfo[kcbt]}" != "" ]]; then
  bindkey "${terminfo[kcbt]}" reverse-menu-complete   # [Shift-Tab] - move through the completion menu backwards
fi

bindkey '^?' backward-delete-char                     # [Backspace] - delete backward
if [[ "${terminfo[kdch1]}" != "" ]]; then
  bindkey "${terminfo[kdch1]}" delete-char            # [Delete] - delete forward
else
  bindkey "^[[3~" delete-char
  bindkey "^[3;5~" delete-char
  bindkey "\e[3~" delete-char
fi

# https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
#autoload -U up-line-or-beginning-search
#autoload -U down-line-or-beginning-search
#zle -N up-line-or-beginning-search
#zle -N down-line-or-beginning-search

# [Ctrl-r] - Search backward incrementally for a specified string. The string
# may begin with ^ to anchor the search to the beginning of the line.
# Uses fzf if installed, default otherwise.
if test -d /usr/local/opt/fzf/shell; then
	# shellcheck disable=SC1091
	. /usr/local/opt/fzf/shell/key-bindings.zsh
else
	bindkey '^r' history-incremental-search-backward
fi
# }}}

# PLUGINS {{{
# -----------------------------------------------------------------------------
# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "zsh-users/zsh-completions"

# Install packages that have not been installed yet
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  else
    echo
  fi
fi

# load the plugins!
zplug load

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }}}


# MISC. CONFIGURATION {{{
# -----------------------------------------------------------------------------
complete -o nospace -C /usr/local/bin/terraform terraform
# }}}
