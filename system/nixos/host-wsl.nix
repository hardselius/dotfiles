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

  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  services.xrdp.enable = true;
  services.xrdp.port = 3390;
  services.xrdp.defaultWindowManager = "${pkgs.xfce.xfce4-session}/bin/xfce4-session";
  services.xrdp.openFirewall = true;
}
