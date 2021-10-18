{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    pure-prompt
  ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    completionInit = ''
      autoload bashcompinit && bashcompinit
      autoload -Uz compinit && compinit
      compinit
    '';

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

    shellAliases = {
      restartaudio = "sudo killall coreaudiod";
      tf = "terraform";
      lightswitch = "osascript -e  'tell application \"System Events\" to tell appearance preferences to set dark mode to not dark mode'";

      # Get public ip directly from a DNS server instead of from some hip
      # whatsmyip HTTP service. https://unix.stackexchange.com/a/81699
      wanip = "dig @resolver4.opendns.com myip.opendns.com +short";
      wanip4 = "dig @resolver4.opendns.com myip.opendns.com +short -4";
      wanip6 = "dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6";
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
    '';
  };
}
