#! /usr/bin/env zsh

#unsetopt menu_complete   # do not autoselect the first completion entry
#unsetopt flowcontrol
#setopt auto_menu         # show completion menu on successive tab press
#setopt complete_in_word
#setopt always_to_end

# forces zsh to realize new commands
zstyle ':completion:*' completer _oldlist _expand _complete _match _ignored _approximate

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# rehash if command not found (possibly recently installed)
zstyle ':completion:*' rehash true

# menu if nb items > 2
zstyle ':completion:*' menu select=2
