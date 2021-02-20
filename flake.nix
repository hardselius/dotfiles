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

      homeManagerConfig =
        { user
        , userName ? null
        , userEmail
        , signingKey ? null
        }: with self.homeManagerModules; {
          imports = [
            ./home
            {
              programs.git = {
                userName = if userName != null then userName else user;
                userEmail = userEmail;
                signing = if signingKey == null then null else {
                  key = signingKey;
                  signByDefault = true;
                };
              };
            }
          ];
        };

      mkDarwinModules = args @ { user, ... }: [
        ./darwin
        home-manager.darwinModules.home-manager
        rec {
          nixpkgs = nixpkgsConfig;
          nix.nixPath = {
            nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix";
          };
          users.users.${user}.home = "/Users/${user}";
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = homeManagerConfig args;
        }
      ];

    in
    {
      darwinConfigurations = {

        # Minimal configuration to bootstrap systems
        bootstrap = darwin.lib.darwinSystem {
          modules = [
            ./darwin/bootstrap.nix
            { nixpkgs = nixpkgsConfig; }
          ];
        };

        ghActions = darwin.lib.darwinSystem {
          modules = mkDarwinModules {
            user = "runner";
            userName = "github-actions";
            userEmail = "github-actions@github.com";
          };
        };

        macbook = darwin.lib.darwinSystem {
          modules = mkDarwinModules {
            user = "martin";
            userName = "Martin Hardselius";
            userEmail = "martin" + "@hardselius.dev";
            signingKey = "martin" + "@hardselius.dev";
          };
        };
      };

      darwinModules = { };

      homeManagerModules = { };

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
