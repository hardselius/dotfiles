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

    variables = {
      # https://github.com/nix-community/home-manager/issues/423
      TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
    };
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      hack-font
    ];
  };
}
