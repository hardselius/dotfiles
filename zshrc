#! /usr/bin/env zsh

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use .localrc for SUPER SECRET CRAP that you don't want in yor public,
# versioned repo.
[[ -f ~/.localrc ]] && source ~/.localrc

# -----------------------------------------------------------------------------
# ENVIRONMENT
# -----------------------------------------------------------------------------
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export EDITOR="vim"
export GPG_TTY="$TTY"

# shortcut to this dotfiles path is $DOTFILES
export DOTFILES="$HOME/.dotfiles"
export PATH="/usr/local/bin:$DOTFILES/bin:$PATH"

# project folder that we can `c [tab]` to
export PROJECTS="$HOME/projects"

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# -----------------------------------------------------------------------------
# LOAD CONFIGURATION
# -----------------------------------------------------------------------------


# CONFIGURE PATH {{{
# -----------------------------------------------------------------------------
export GOPATH="$PROJECTS/go"
export PATH="$PATH:$GOPATH/bin"

export TEXPATH="/Library/TeX"
export PATH="$PATH:$TEXPATH/texbin"

typeset -U PATH
# }}}

# CONFIGURE ALIASES {{{
# -----------------------------------------------------------------------------
alias reload!='exec "$SHELL" -l'
alias cls='clear'
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias tf='terraform'

if command -v exa &>/dev/null; then
    alias ls="exa -F --group-directories-first"
    alias l="exa -lah --group-directories-first"
    alias ll="exa -l --group-directories-first"
    alias la="exa -a --group-directories-first"
elif command -v gls &>/dev/null; then
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
# }}}

# CONFIGURATION {{{
# -----------------------------------------------------------------------------
#export LSCOLORS='exfxcxdxbxegedabagacad'
export CLICOLOR=true

fpath=($DOTFILES/functions $fpath)

autoload -U "$DOTFILES"/functions/*(:t)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# don't nice background tasks
setopt NO_BG_NICE
setopt NO_HUP
setopt NO_BEEP
# allow functions to have local options
setopt LOCAL_OPTIONS
# allow functions to have local traps
setopt LOCAL_TRAPS
# share history between sessions ???
setopt SHARE_HISTORY
# add timestamps to history
setopt EXTENDED_HISTORY
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
# adds history
setopt APPEND_HISTORY
# adds history incrementally and share it across sessions
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# don't record dupes in history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST
# dont ask for confirmation in rm globs*
setopt RM_STAR_SILENT

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# emacs mode
# I always enter vi mode by mistake
bindkey -e

# fuzzy find: start to type
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
bindkey "${terminfo[cuu1]}" up-line-or-beginning-search
bindkey "${terminfo[cud1]}" down-line-or-beginning-search

# backward and forward word with option+left/right
bindkey '^[^[[D' backward-word
bindkey '^[b' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[f' forward-word

# to to the beggining/end of line with fn+left/right or home/end
bindkey "${terminfo[khome]}" beginning-of-line
bindkey '^[[H' beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey '^[[F' end-of-line

# delete char with backspaces and delete
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char

# delete word with ctrl+backspace
bindkey '^[[3;5~' backward-delete-word
# bindkey '^[[3~' backward-delete-word

# search history with fzf if installed, default otherwise
if test -d /usr/local/opt/fzf/shell; then
	# shellcheck disable=SC1091
	. /usr/local/opt/fzf/shell/key-bindings.zsh
else
	bindkey '^R' history-incremental-search-backward
fi
# }}}

# CONFIGURE COMPLETIONS {{{
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
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select=2
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
# }}}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


complete -o nospace -C /usr/local/bin/terraform terraform

