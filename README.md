# Martin's dotfiles and Nix config

> These are my dotfiles. There are many like them, but these are mine.

This repo has evolved to mainly contain my Nix config.

## Install `nix`

### macOS

In order to perform a multi-user install of `nix` on macOS, follow these steps.

The first order of business is to make sure `diskutil` is in your `$PATH`. If
it isn't, add it

```sh
$ export PATH=/usr/sbin:$PATH
```

Now you can go ahead and run the installer

```sh
$ sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon
```

This should take you throught the process in a nice and straight-forward way.

Once the installation finishes, it should print something like

```
Try it! Open a new terminal, and type:

  $ nix-shell -p nix-info --run "nix-info -m"
```

It's possible that this won't work straight away, and you may get something like

```
error: could not set permissions on '/nix/var/nix/profiles/per-user' to 755: Operation not permitted
```

Don't worry. The issue is very likely that the `nix-daemon` isn't up and
running just yet. Give it a few seconds and try again.

**A note on SSL issues:** If you're getting errors like

```
Problem with the SSL CA cert (path? access rights?) (77)
```

at later stages, there might be that `/etc/ssl/certs/ca-certificates.crt` is a
dead symlink. This can be fixed by removing that file and creating a new
symlink

```
$ sudo ln -s /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
```

#### `nix-darwin`

Install [nix-darwin][nix-darwin]:

```sh
$ nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
$ ./result/bin/darwin-installer
```

Make sure to edit the configuration file during the installation and see to
that the following is not commented out

```
# Auto upgrade nix package and the daemon service. 
services.nix-daemon.enable = true;
nix.package = pkgs.nix;
```

**NOTE:** It's a good idea to make sure that any existing installation of
`nix-darwin` is uninstalled before you begin. There may be crap remaining in
`/etc/static`. Also, you should remeber to backup existing etc files

```
$ sudo mv /etc/bashrc /etc/bashrc.backup-before-darwin
$ sudo mv /etc/zshrc /etc/zshrc.backup-before-darwin
```

**NOTE 2:** It's also possible that you may have to backup `nix.conf` in order for
`nix-darwin` to be able to link it

```
$ sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.backup-before-darwin
```

**NOTE 3:** `nix-darwin` might also complain about linking `ca-certificates.crt`. That
stuff we may or may not have had to take care of earlier. Just back that up,
rebuild, and watch `nix-darwin` link it.

#### home-manager

Install [home-manager][home-manager]:

```
$ nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
$ nix-channel --update
$ nix-shell '<home-manager>' -A install
```

#### This repo

Clone this repo to `$HOME/.dotfiles` and execute

```
$ darwin-rebuild switch -I darwin-config=$HOME/.dotfiles/config/darwin.nix
$ cd $HOME/.dotfiles
$ make switch
```

**NOTE 1:** `darwin-rebuild` might fail, saying it can't find the file `darwin`,
in which case you have to fix your `$NIX_PATH`.

```
export NIX_PATH=darwin-config=$HOME/.dotfiles/config/darwin.nix:$HOME/.nix-defexpr/channels:$NIX_PATH
```

**NOTE 2:** It's possible that the updated `$NIX_PATH` will stick when you open
up a new shell. This happens under zsh. One way to get around this is to switch
to bash when rebuilding with the custom `darwin-config` path. When you feel
reasonably sure everything is as it should be (nix-darwin and home-manager
switched using the `make switch`), things should work in zsh again.

[nix-darwin]: https://github.com/LnL7/nix-darwin
[home-manager]: https://github.com/nix-community/home-manager
