### SSL issues

If you’re getting errors like

```
Problem with the SSL CA cert (path? access rights?) (77)
```

at later stages, there might be that */etc/ssl/certs/ca-certificates.crt* is a
dead symlink. This can be fixed by removing that file and creating a new
symlink

```
sudo ln -s /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
```

### Enable flake support

Previously, flake support had to be enabled in `/etc/nix/nix.conf` by adding
the following line to it

```
experimental-features = nix-command flakes
```

A version of Nix with flake support could, and probably still can, be installed
by running

```
nix-env -iA nixpkgs.nixFlakes
```

### Clean up old installation

It’s a good idea to make sure that any existing installation of `nix-darwin` is
uninstalled before you begin. There may be crap remaining in */etc/static*.
Also, you should remeber to backup existing etc files

```
$ sudo mv /etc/bashrc /etc/bashrc.backup-before-darwin
$ sudo mv /etc/zshrc /etc/zshrc.backup-before-darwin
```

### Linking `nix.conf`

It’s also possible that you may have to backup `nix.conf` in order for
`nix-darwin` to be able to link it

```
$ sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.backup-before-darwin
```

### Linking `ca-certificates.crt`

`nix-darwin` might also complain about linking `ca-certificates.crt`.
That stuff we may or may not have had to take care of earlier. Just back
that up, rebuild, and watch `nix-darwin` link it.
