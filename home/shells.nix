{ config, pkgs, lib, ... }:
let
  inherit (config.home) user-info;
in

{
  home.sessionVariables = {
    EDITOR = "${pkgs.vim}/bin/vim";
    EMAIL = "${user-info.email}";
    PAGER = "${pkgs.less}/bin/less";
    CLICOLOR = 1;
    GPG_TTY = "$TTY";
    PATH = "$PATH:$HOME/.local/bin:$HOME/.tfenv/bin";
  };

  home.shellAliases = {
    tf = "terraform";
    switch-yubikey = "gpg-connect-agent \"scd serialno\" \"learn --force\" /bye";

    # Get public ip directly from a DNS server instead of from some hip
    # whatsmyip HTTP service. https://unix.stackexchange.com/a/81699
    wanip = "dig @resolver4.opendns.com myip.opendns.com +short";
    wanip4 = "dig @resolver4.opendns.com myip.opendns.com +short -4";
    wanip6 = "dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6";
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    lightswitch = "osascript -e  'tell application \"System Events\" to tell appearance preferences to set dark mode to not dark mode'";
    restartaudio = "sudo killall coreaudiod";
  };

  #
  # STARSHIP
  #

  programs.starship.enable = true;
  programs.starship.enableBashIntegration = true;
  programs.starship.enableZshIntegration = false;

  #
  # BASH
  #

  programs.bash.enable = false;
  programs.bash.enableCompletion = true;
  programs.bash.bashrcExtra = ''
    set -o vi
    bind -m vi-command 'Control-l: clear-screen'
    bind -m vi-insert 'Control-l: clear-screen'

    bind 'set show-mode-in-prompt on'
    bind 'set vi-cmd-mode-string "n "'
    bind 'set vi-ins-mode-string "i "'

    # use ctrl-z to toggle in and out of bg
    if [[ $- == *i* ]]; then 
      stty susp undef
      bind -m vi-command 'Control-z: fg\015'
      bind -m vi-insert 'Control-z: fg\015'
    fi
  '';

  #
  # ZSH
  #

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.completionInit = ''
    autoload bashcompinit && bashcompinit
    autoload -Uz compinit && compinit
    compinit
  '';
  programs.zsh.cdpath = [
    "."
    "~"
  ];
  programs.zsh.defaultKeymap = "viins";
  programs.zsh.dotDir = ".config/zsh";
  programs.zsh.history = {
    size = 50000;
    save = 500000;
    ignoreDups = true;
    share = true;
  };
  programs.zsh.profileExtra = ''
    export GPG_TTY=$(tty)
  '';
  programs.zsh.initExtra = ''
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

  home.packages = with pkgs; [
    pure-prompt
  ];
}
