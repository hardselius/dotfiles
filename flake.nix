{
  description = "Martin's dotfiles";

  inputs = {
    nixpkgs-master.url = github:nixos/nixpkgs/master;
    nixpkgs-stable.url = github:nixos/nixpkgs/nixpkgs-21.11-darwin;
    nixpkgs-unstable.url = github:nixos/nixpkgs/nixpkgs-unstable;
    nixos-stable.url = github:nixos/nixpkgs/nixos-21.11;

    darwin.url = github:LnL7/nix-darwin;
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nixos-wsl.url = github:nix-community/NixOS-WSL;
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, nixos-wsl, flake-utils, ... } @ inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

      systems = [
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      nixpkgsConfig = with inputs; rec {
        config = { allowUnfree = true; };
        overlays = self.overlays;
      };

      homeManagerStateVersion = "22.05";

      primaryUserInfo = {
        username = "martin";
        fullName = "Martin Hardselius";
        email = "martin@hardselius.dev";
        github = "hardselius";
        gpgsign = true;
      };

      nixDarwinCommonModules = attrValues self.darwinModules ++ [
        home-manager.darwinModules.home-manager
        ({ config, lib, pkgs, ... }:
          let
            inherit (config.users) primaryUser;
          in
          rec {
            nixpkgs = nixpkgsConfig;
            users.users.${primaryUser.username}.home = "/Users/${primaryUser.username}";
            home-manager.useGlobalPkgs = true;
            home-manager.users.${primaryUser.username} = {
              imports = attrValues self.homeManagerModules;
              home.stateVersion = homeManagerStateVersion;
              home.user-info = config.users.primaryUser;
            };
          })
      ];

      nixosCommonModules = attrValues self.nixosModules ++ [
        home-manager.nixosModules.home-manager
        ({ config, lib, pkgs, ... }:
          let
            inherit (config.users) primaryUser;
          in
          rec {
            nixpkgs = nixpkgsConfig;
            users.users.${primaryUser.username} = {
              home = "/home/${primaryUser.username}";
              isNormalUser = true;
              isSystemUser = false;
              initialPassword = "helloworld";
              extraGroups = [ "wheel" ];
              shell = pkgs.zsh;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.users.${primaryUser.username} = {
              imports = attrValues self.homeManagerModules;
              home.stateVersion = homeManagerStateVersion;
              home.user-info = config.users.primaryUser;
            };
          })
      ];

    in
    {
      darwinConfigurations = {

        # Minimal configuration to bootstrap systems
        bootstrap = makeOverridable darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./10-darwin/bootstrap.nix
            { nixpkgs = nixpkgsConfig; }
          ];
        };

        # My macOS configuration
        macbook = darwinSystem {
          system = "x86_64-darwin";
          modules = nixDarwinCommonModules ++ [
            ./10-darwin/hosts/macbook.nix
            {
              users.primaryUser = primaryUserInfo;
            }
          ];
        };

        # Configuration used for CI with GitHub actions
        githubActions = darwinSystem {
          system = "x86_64-darwin";
          modules = nixDarwinCommonModules ++ [
            ./10-darwin/hosts/github-actions.nix
            ({ lib, ... }: {
              users.primaryUser = primaryUserInfo // {
                username = "runner";
                gpgsign = false;
              };
            })
          ];
        };
      };

      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = nixosCommonModules ++ [
            nixos-wsl.nixosModules.wsl
            ./10-nixos/hosts/wsl.nix
            {
              users.primaryUser = primaryUserInfo;
            }
          ];
        };
      };

      darwinModules = {
        darwin-config = import ./10-darwin;
        users-primaryUser = import ./modules/users.nix;
      };

      nixosModules = {
        nixos-config = import ./10-nixos;
        users-primaryUser = import ./modules/users.nix;
      };

      homeManagerModules = {
        home-config = import ./20-home;
        home-awscli = import ./30-modules/home/programs/awscli.nix;

        home-user-info = { lib, ... }: {
          options.home.user-info =
            (self.darwinModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
        };
      };

      overlays =
        let path = ./40-overlays; in
        with builtins;
        map (n: import (path + ("/" + n))) (filter
          (n:
            match ".*\\.nix" n != null
            || pathExists (path + ("/" + n + "/default.nix")))
          (attrNames (readDir path)));

      # `nix develop`
      devShell = forAllSystems
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              rnix-lsp
              nixpkgs-fmt
            ];
          }
        );
    };
}
