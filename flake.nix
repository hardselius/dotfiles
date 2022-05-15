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

      # Home Manager configuration shared between all different configurations.
      homeManagerStateVersion = "22.05";
      homeManagerCommonConfig =
        { user
        , userConfig ? ./20-home + "/users/${user}.nix"
        , ...
        }: {
          imports = attrValues self.homeManagerModules ++ [
            userConfig
            ./20-home
            { home.stateVersion = homeManagerStateVersion; }
          ];
        };

      nixDarwinCommonModules = args @ { user, host, ... }: [
        home-manager.darwinModules.home-manager
        ./10-darwin
        (./10-darwin/hosts + "/${host}.nix")
        rec {
          nixpkgs = nixpkgsConfig;
          users.users.${user}.home = "/Users/${user}";
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = homeManagerCommonConfig args;
        }
      ];

      nixosCommonModules = args @ { user, host, ... }: [
        home-manager.nixosModules.home-manager
        # TODO: should probably make this conditional on the wsl host
        nixos-wsl.nixosModules.wsl
        (./10-nixos/hosts + "/${host}.nix")
        rec {
          nixpkgs = nixpkgsConfig;
          users.users.${user} = {
            home = "/home/${user}";
            isNormalUser = true;
            initialPassword = "helloworld";
            extraGroups = [ "wheel" ];
          };
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = homeManagerCommonConfig args;
        }
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
          modules = nixDarwinCommonModules {
            user = "martin";
            host = "macbook";
          };
        };

        # Configuration used for CI with GitHub actions
        githubActions = darwinSystem {
          system = "x86_64-darwin";
          modules = nixDarwinCommonModules {
            user = "runner";
            host = "github-actions";
          };
        };
      };

      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = nixosCommonModules {
            user = "martin";
            host = "wsl";
          };
        };
      };

      darwinModules = { };

      homeManagerModules = {
        awscli = import ./30-modules/home/programs/awscli.nix;
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
