{
  description = "Martin's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-20.09";

    darwin = {
      url = "github:hardselius/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    vimrc = {
      url = "https://github.com/hardselius/large-vimrc.git";
      type = "git";
      flake = false;
      submodules = true;
    };
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

      homeManagerConfig = localconfig @ { ... }: with self.homeManagerModules; {
        imports = [
          ./home
        ];
        # propagate local condfiguration to imports
        _module.args.localconfig = localconfig;
        _module.args.vimrc = inputs.vimrc;
      };

      mkDarwinModules = localconfig @ { user, ... }: [
        ./darwin
        home-manager.darwinModules.home-manager
        rec {
          nixpkgs = nixpkgsConfig;
          nix.nixPath = {
            nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix";
          };
          users.users.${user}.home = "/Users/${user}";
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = homeManagerConfig localconfig;
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

      cloudVM = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/martin";
        username = "martin";
        configuration = {
          imports = [
            (homeManagerConfig {
              userName = "Martin Hardselius";
              userEmail = "martin" + "@hardselius.dev";
            })
          ];
          nixpkgs = nixpkgsConfig;
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
