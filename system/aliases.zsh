#! /usr/bin/env zsh

if command -v exa &>/dev/null; then
  alias ls="exa -F --group-directories-first"
  alias l="exa -lah --group-directories-first"
  alias ll="exa -l --group-directories-first"
  alias la="exa -a --group-directories-first"

# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
elif command -v gls &>/dev/null; then
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
