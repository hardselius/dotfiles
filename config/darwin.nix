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
        _HIHideMenuBar = false;
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

      MANPAGER = "${pkgs.vim}/bin/vim -M +MANPAGER -";
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
      EDITOR = "${pkgs.vim}/bin/vim";
      PAGER = "less";
    };
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      anonymousPro
      cozette
      fira-code
      jetbrains-mono
      nerdfonts
    ];
  };

  programs.nix-index.enable = true;

  # programs.fish.enable = true;
  programs.bash.enable = true;

  programs.zsh = {
    enable = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
    promptInit = ''
    '';
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
