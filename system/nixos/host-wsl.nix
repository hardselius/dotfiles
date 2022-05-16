{ lib, pkgs, config, modulesPath, ... }:
let
  inherit (config.users) primaryUser;
in

with lib; {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "${primaryUser.username}";
    startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };
}
