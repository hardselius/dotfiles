{ pkgs, lib, ... }:

{
  imports = [
    ./bootstrap.nix
    ./system-defaults.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      kitty
      terminal-notifier
    ];
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      hack-font
    ];
  };
}
