# Martin's dotfiles and Vim config

These are my dotfiles. There are many like them, but these are mine.

## Homebrew

All dependencies can easily be installed with

```
brew bundle
```

For other useful commands related to the `Brewfile`, visit the
[documentation](https://github.com/Homebrew/homebrew-bundle).

## GNU Stow

I manage my dotfiles using [GNU-stow](https://www.gnu.org/software/stow/). The home directory is synced as follows

```
stow vim zsh ...
```

## nix-darwin and home-manager

1. Install Nix
2. Install nix-darwin
3. Install home-manager (?)
4. Clone this repo to `$HOME/.dotfiles`
5. Run
```
$ darwin-rebuild switch -I darwin-config=$HOME/.dotfiles/config/darwin.nix
```
6. Profit
