{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    pure-prompt
  ] ++ lib.optionals stdenv.isDarwin [
    darwin-zsh-completions
  ];

  programs.zsh = {
    enable = true;

    cdpath = [
      "."
      "~"
    ];

    defaultKeymap = "viins";
    dotDir = ".config/zsh";

    history = {
      size = 50000;
      save = 500000;
      ignoreDups = true;
      share = true;
    };

    sessionVariables = {
      CLICOLOR = true;
      GPG_TTY = "$TTY";
      PATH = "$PATH:$HOME/.local/bin";
    };

    shellAliases = {
      restartaudio = "sudo killall coreaudiod";
      tf = "terraform";
    };

    profileExtra = ''
      export GPG_TTY=$(tty)
    '';

    initExtra = ''
      export KEYTIMEOUT=1

      vi-search-fix() {
        zle vi-cmd-mode
        zle .vi-history-search-backward
      }
      autoload vi-search-fix
      zle -N vi-search-fix
      bindkey -M viins '\e/' vi-search-fix

      bindkey "^?" backward-delete-char

      resume() {
        fg
        zle push-input
        BUFFER=""
        zle accept-line
      }
      zle -N resume
      bindkey "^Z" resume

      function ls() {
          ${pkgs.coreutils}/bin/ls --color=auto --group-directories-first "$@"
      }

      autoload -U promptinit; promptinit

      # Configure pure-promt
      prompt pure
      zstyle :prompt:pure:prompt:success color green

      # The next line updates PATH for the Google Cloud SDK.
      if [ -f '/Users/martin/bin/google-cloud-sdk/path.zsh.inc' ]; then
        . '/Users/martin/.local/bin/google-cloud-sdk/path.zsh.inc'
      fi

      # The next line enables shell command completion for gcloud.
      if [ -f '/Users/martin/.local/bin/google-cloud-sdk/completion.zsh.inc' ]; then
        . '/Users/martin/.local/bin/google-cloud-sdk/completion.zsh.inc'
      fi
    '';
  };
}