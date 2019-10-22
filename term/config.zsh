#! /usr/bin/env zsh

DIR_COLORS="$HOME/.dir_colors"

if [[ -r "$DIR_COLORS" ]]; then
  eval $(gdircolors $DIR_COLORS)
fi

# [[ -f "~/.dir_colors" ]] && eval $(gdircolors ~/.dir_colors)
