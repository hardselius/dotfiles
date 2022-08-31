[![Build Nix environments](https://github.com/hardselius/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/hardselius/dotfiles/actions/workflows/ci.yml)

# Martin's dotfiles and Nix config

> These are my dotfiles. There are many like them, but these are mine.

## Bootstrapping a new machine

Clone this repo. It might be a good idea to clone using HTTPS if you
don’t have your SSH keys configured. I store my SSH key on a Yubikey for
portability but that setup relies on some of the stuff that’s configured
in here. HTTPS is a safe bet. You can always fix your local git config
later on using something like

```
git config url.git@github.com:.insteadof https://github.com/
```

### Install `nix` on macOS

In order to perform a multi-user install of `nix` on macOS, follow these
steps.

The first order of business is to make sure `diskutil` is in your
`$PATH`. If it isn’t, execute

```
export PATH=/usr/sbin:$PATH
```

to add it. Now you can go ahead and run the installer

```
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon
```

This should take you throught the process in a nice and straight-forward
way. Once the installation finishes, you can verify it by opening a new
terminal, and executing

```
nix-shell -p nix-info --run "nix-info -m"
```

It’s possible that this won’t work straight away, and you may get
something like

```
error: could not set permissions on '/nix/var/nix/profiles/per-user' to 755: Operation not permitted
```

Don’t worry. The issue is very likely that the `nix-daemon` isn’t up and
running just yet. Give it a few seconds and try again.

### Flakes

With Nix installed, we’re ready to bootstrap and install the actual
configuration. Flakes is finally supported in the latest versions of
Nix, so from the root of the checkout out repo we should be able to go
ahead and run

```
nix build .#darwinConfigurations.bootstrap-x86.system
./result/sw/bin/darwin-rebuild switch --flake .#bootstrap-x86
```

Then open up a new terminal session and run

```
darwin-rebuild switch --flake .#macbook
```

Tada! Everything should be installed and ready to go.

## Links

- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [Home Manager](https://github.com/nix-community/home-manager)
