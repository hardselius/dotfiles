{
  nix.settings.trusted-users = [ "@admin" ];
  nix.configureBuildUsers = true;
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
}
