{ config, lib, pkgs, ... }@args:

let
  home_directory = "/Users/martin";
  xdg_configHome = "${home_directory}/.config";
  xdg_dataHome = "${home_directory}/.local/share";
  tmp_directory = "/tmp";
  localcondfig = import <localconfig>;

in rec {
  system = {
    defaults = {
      NSGlobalDomain = {
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 20;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        _HIHideMenuBar = true;
      };

      dock = {
        autohide = true;
        mru-spaces = false;
        orientation = "left";
        showhidden = true;
      };

      finder = {
        AppleShowAllExtensions = true;
        QuitMenuItem = true;
        FXEnableExtensionChangeWarning = false;
      };
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
    };

    overlays = let path = ../overlays;
    in with builtins;
    map (n: import (path + ("/" + n))) (filter (n:
      match ".*\\.nix" n != null
      || pathExists (path + ("/" + n + "/default.nix")))
      (attrNames (readDir path)));
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
    # Use a custom configuration.nix location.
    # $ darwin-rebuild switch -I darwin-config=$HOME/.dotfiles/config/darwin.nix
    darwinConfig = "$HOME/.dotfiles/config/darwin.nix";
    systemPackages = import ./packages.nix { inherit pkgs; };

    variables = {
      HOME_MANAGER_CONFIG = "$HOME/.dotfiles/config/home.nix";

      MANPATH = [
        "${home_directory}/.nix-profile/share/man"
        "${home_directory}/.nix-profile/man"
        "${config.system.path}/share/man"
        "${config.system.path}/man"
        "/usr/local/share/man"
        "/usr/share/man"
        "/Developer/usr/share/man"
        "/usr/X11/man"
      ];

      LC_ALL = "en_US.UTF-8";
      LANG = "en_US.UTF-8";
      EDITOR = "${pkgs.vim_configurable}/bin/vim";
      PAGER = "less";
    };
  };

  # TODO: Figure out how the hell to do this
  # launchd.daemons.spotifyd = {
  #   serviceConfig = {
  #     Label = "rustlang.spotifyd";
  #     ProgramArguments = [
  #       "${pkgs.spotifyd}/bin/spotifyd"
  #       "--config-path=/Users/martin/.config/spotifyd/spotifyd.conf"
  #       "--no-daemon"
  #     ];
  #     UserName = "martin";
  #     ThrottleInterval = 30;
  #     KeepAlive = true;
  #   };
  # };

  # services = {
  #   yabai = import ./darwin/yabai.nix { inherit pkgs; };
  #   skhd = import ./darwin/skhd.nix { inherit pkgs; };
  # };

  fonts = {
    enableFontDir = true;
    fonts = [
      pkgs.cozette
    ];
  };

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true; # default shell on catalina
    enableCompletion = true;
    enableBashCompletion = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;

    loginShellInit = ''
      :d() {
          eval "$(direnv hook zsh)"
      }

      :r() {
          direnv reload
      }

      fzf-store() {
          find /nix/store -mindepth 1 -maxdepth 1 -type d | fzf -m --preview-window right:50% --preview 'nix-store -q --tree {}'
      }

      ls() {
          ${pkgs.coreutils}/bin/ls --color=auto --group-directories-first "$@"
      }
    '';

    interactiveShellInit = ''
      bindkey -v
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
    '';

    promptInit = ''
      fpath+=("${pkgs.pure-prompt}/share/zsh/site-functions")
      autoload -U promptinit; promptinit
      prompt pure
    '';
  };

  programs.nix-index.enable = true;

  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
