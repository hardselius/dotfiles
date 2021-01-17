{
  description = "Martin's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-20.09";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ { self, nixpkgs, darwin, home-manager, ... }:
    let
      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
        };
        overlays = self.overlays ++ [
          (
            final: prev:
              let
                system = prev.stdenv.system;
                nixpkgs-stable = if system == "x86_64-darwin" then nixpkgs-stable-darwin else nixos-stable;
              in
              {
                master = nixpkgs-master.legacyPackages.${system};
                stable = nixpkgs-stable.legacyPackages.${system};
              }
          )
        ];
      };

      homeManagerConfig = with self.homeManagerModules; {
        imports = [
          ./home
        ];
      };

      darwinModules = { user }: [
        ./darwin
        home-manager.darwinModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          nix.nixPath = {
            nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix";
          };
        }
      ];

    in
    {
      darwinConfigurations = {

        # Minimal configuration to bootstrap systems
        bootstrap = darwin.lib.darwinSystem {
          modules = [
            ./darwin/bootstrap.nix
          ];
        };

        ghActions = darwin.lib.darwinSystem {
          modules = darwinModules { user = "runner"; };
        };

        macbook = darwin.lib.darwinSystem {
          modules = darwinModules { user = "martin"; } ++ [
            {
              networking = {
                computerName = "MacBook Pro";
                hostName = "MacBook-Pro.local";
              };
            }
          ];
        };
      };

      overlays =
        let path = ./overlays; in
        with builtins;
        map (n: import (path + ("/" + n))) (filter
          (n:
            match ".*\\.nix" n != null
            || pathExists (path + ("/" + n + "/default.nix")))
          (attrNames (readDir path)));
    };
}
