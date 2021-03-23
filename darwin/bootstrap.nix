{ config, pkgs, lib, ... }:

{
  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://hardselius.cachix.org"
      "https://hydra.iohk.io"
      "https://iohk.cachix.org"
    ];

    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hardselius.cachix.org-1:wdmClEq/2j8gEKJ5vLLCmpgCDumsyPMO6iVWKkYHKP0="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
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

  users.nix.configureBuildUsers = true;

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
