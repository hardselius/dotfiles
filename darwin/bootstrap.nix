{ config, pkgs, lib, ... }:

{
  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://hardselius.cachix.org"
    ];

    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hardselius.cachix.org-1:wdmClEq/2j8gEKJ5vLLCmpgCDumsyPMO6iVWKkYHKP0="
    ];

    trustedUsers = [
      "@admin"
    ];

    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  services = {
    nix-daemon.enable = true;
  };

  environment.shells = with pkgs; [
    bashInteractive
    zsh
  ];

  programs.nix-index.enable = true;

  # programs.fish.enable = true;
  programs.bash.enable = true;

  programs.zsh = {
    enable = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
    promptInit = ''
    '';
  };

  system.stateVersion = 4;
}
