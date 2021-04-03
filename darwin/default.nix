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
      LC_CTYPE = "en_US.UTF-8";
      LESSCHARSET = "utf-8";
      # https://github.com/nix-community/home-manager/issues/423
      TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
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
