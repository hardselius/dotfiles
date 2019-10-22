#! /usr/bin/env zsh

if [[ "$(uname -s)"  == "Darwin" ]]; then
	alias ls="ls -FG"
else
	alias ls="ls -F --color"
fi
alias l="ls -lAh"
alias la="ls -A"
alias ll="ls -l"
