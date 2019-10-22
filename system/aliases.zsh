#! /usr/bin/env zsh

# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
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
