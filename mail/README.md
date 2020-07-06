# Mutt setup

## Configuration

### Dependencies

```
gpgme
isync
khard
msmtp
mu
neomutt
ripmime
urlscan
vdirsyncer
w3m
```

### mbsync

The `PassCmd` retrieves your password from the system keychain using the
`security` command.  Add the credentials to the macOS keychain, and make sure
the keychain item name starts with `http://`. This is required in order to have
the `security` command work correctly.

Example (gmail):

```
Keychain item name: http://imap.gmail.com
Account name:       user@gmail.com
Password:           ****
```

### msmtp

`msmtp` can communicate with the macOS keychain, so we don't some weird securit
command. Just add a new entry and prefix it with `smtp://`.

Example (gmail):

```
Keychain item name: smtp://smtp.gmail.com
Account name:       user@gmail.com
Password:           ****
```

## Workflow

Pipe messages through `urlscan`

```
| urlscan
```
