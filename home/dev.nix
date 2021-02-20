{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    plantuml
    gnumake
    nodePackages.node2nix
    nodePackages.vim-language-server
    shfmt
    shellcheck
  ];

  programs = {
    go.enable = true;
  };
}
