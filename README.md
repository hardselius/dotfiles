# Martin's dotfiles and Nix config

> These are my dotfiles. There are many like them, but these are mine.

This repo conatains mainly my Nix config but also some dotfiles managed with
[GNU-stow][stow] (mainly Vim).

## nix-darwin and home-manager

1. Install Nix
2. Install [nix-darwin][nix-darwin]
3. Install [home-manager][home-manager]
4. Clone this repo to `$HOME/.dotfiles`
5. Run
```
$ darwin-rebuild switch -I darwin-config=$HOME/.dotfiles/config/darwin.nix
```
6. Profit

[stow]: https://www.gnu.org/software/stow/
[nix-darwin]: https://github.com/LnL7/nix-darwin
[home-manager]: https://github.com/nix-community/home-manager
