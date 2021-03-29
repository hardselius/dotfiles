{ config, pkgs, ... }:

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

    # Copy applications into ~/Applications/Nix Apps. This workaround allows us
    # to find applications installed by nix through spotlight.
    activationScripts.applications.text = pkgs.lib.mkForce (
      ''
        rm -rf ~/Applications/Nix\ Apps
        mkdir -p ~/Applications/Nix\ Apps
        for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
          src="$(/usr/bin/stat -f%Y "$app")"
          cp -r "$src" ~/Applications/Nix\ Apps
        done
      ''
    );
  };
}
