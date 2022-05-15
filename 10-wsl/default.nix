{ lib, pkgs, config, modulesPath, ... }:

with lib; {
  imports = [
    ../00-config/shared.nix
    "${modulesPath}/profiles/minimal.nix"
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };
}
