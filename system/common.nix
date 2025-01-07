# This file contains configuration that is shared across all hosts.
{
  pkgs,
  lib,
  options,
  ...
}: {
  nix.settings.auto-optimise-store = false;
  nix.settings.keep-derivations = true;
  nix.settings.keep-outputs = true;
  nix.settings.extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [
    "x86_64-darwin"
    "aarch64-darwin"
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.substituters = [
    "https://cache.nixos.org/"
    "https://hardselius.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "hardselius.cachix.org-1:PoN90aQw2eVMwfAy0MS6V9T2exWlgtHOUBBSnthXAl4="
  ];

  programs.zsh.enable = true;
  programs.zsh.promptInit = "";

  fonts.packages = with pkgs; [
    hack-font
    iosevka
    iosevka-comfy.comfy-fixed
  ];
}
