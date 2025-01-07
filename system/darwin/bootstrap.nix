{
  config,
  lib,
  pkgs,
  ...
}: {
  nix.settings.trusted-users = ["@admin"];
  nix.configureBuildUsers = true;
  services.nix-daemon.enable = true;

  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    bashInteractive
    zsh
  ];

  environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";

  programs.zsh.enable = true;

  system.stateVersion = 4;
}
