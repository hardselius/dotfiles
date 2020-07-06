{ config, lib, pkgs, ... }@args:

{
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

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
    systemPackages = import ./packages.nix { inherit pkgs; };

    variables = {
      LC_ALL = "en_US.UTF-8";
      LANG   = "en_US.UTF-8";
      EDITOR = "${pkgs.vim_configurable}/bin/vim";
    };
  };

  services = {
    yabai = {
      enable = true;
      package = pkgs.yabai;
    };

    skhd = {
      enable = true;
    };
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;  # default shell on catalina
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
    '';

    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
  };

  programs.nix-index.enable = true;

  # programs.fish.enable = true;

  nixpkgs = {
    overlays =
      let path = ./overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)));
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

