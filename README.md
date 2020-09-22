# Martin's dotfiles and Nix config

> These are my dotfiles. There are many like them, but these are mine.

This repo has evolved to mainly contain my Nix config.

## nix-darwin and home-manager

1. Install Nix
2. Install [nix-darwin][nix-darwin]
3. Install [home-manager][home-manager]
4. Clone this repo to `$HOME/.dotfiles`
5. Run
```
darwin-rebuild switch -I darwin-config=$HOME/.dotfiles/config/darwin.nix
cd $HOME/.dotfiles
make switch
```
6. Profit

[nix-darwin]: https://github.com/LnL7/nix-darwin
[home-manager]: https://github.com/nix-community/home-manager
