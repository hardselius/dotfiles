{ config, lib, pkgs, ... }@args:
let
  home_directory = "/Users/martin";
  xdg_configHome = "${home_directory}/.config";
  xdg_dataHome = "${home_directory}/.local/share";
  tmp_directory = "/tmp";
  localconfig = import <localconfig>;

in
rec {
  imports = [
    ./bootstrap.nix
    ./system-defaults.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      kitty
      terminal-notifier
    ];

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
      hack-font
    ];
  };
}
