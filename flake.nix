{
  description = "Martin's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-20.09";

    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = inputs @ { self, nixpkgs, darwin, home-manager, flake-utils, ... }:
    let
      systems = [
        "x86_64-darwin"
        "x86_64-linux"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

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

                # Temporaray overides for packages we use that are currently broken on `unstable`
                # thefuck = final.stable.thefuck;
              }
          )
        ];
      };

      homeManagerConfig =
        { user
        , userConfig ? ./20-home + "/user-${user}.nix"
        , ...
        }: with self.homeManagerModules; {
          imports = [
            userConfig
            ./20-home
            programs.awscli
          ];
        };

      mkDarwinModules =
        args @
        { user
        , host
        , hostConfig ? ./10-darwin/hosts + "/${host}.nix"
        , ...
        }: [
          home-manager.darwinModules.home-manager
          ./10-darwin
          hostConfig
          rec {
            nix.nixPath = {
              nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix";
            };
            nixpkgs = nixpkgsConfig;
            users.users.${user}.home = "/Users/${user}";
            home-manager.useGlobalPkgs = true;
            home-manager.users.${user} = homeManagerConfig args;
          }
        ];

      mkNixosModules =
        args @
        { user
        , host
        , hostConfig ? ./10-nixos/hosts + "/${host}.nix"
        , ...
        }: [
          home-manager.nixosModules.home-manager
          ./00-config/shared.nix
          hostConfig
          ({ pkgs, ... }: rec {
            nixpkgs = nixpkgsConfig;
            users.users.${user} = {
              createHome = true;
              extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
              group = "${user}";
              home = "/home/${user}";
              isNormalUser = true;
              shell = pkgs.zsh;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.users.${user} = homeManagerConfig args;
          })
        ];

    in
    {
      darwinConfigurations = {

        # Minimal configuration to bootstrap systems
        bootstrap = darwin.lib.darwinSystem {
          inputs = inputs;
          modules = [
            ./10-darwin/bootstrap.nix
          ];
        };

        ghActions = darwin.lib.darwinSystem {
          inputs = inputs;
          modules = mkDarwinModules {
            user = "runner";
            host = "github-actions";
          };
        };

        macbook = darwin.lib.darwinSystem {
          inputs = inputs;
          modules = mkDarwinModules {
            user = "martin";
            host = "macbook";
          };
        };
      };

      nixosConfigurations = {
        vmware = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = mkNixosModules {
            user = "martin";
            host = "vmware";
          };
        };
      };

      cloudVM = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/martin";
        username = "martin";
        configuration = {
          imports = [
            (homeManagerConfig { user = "martin"; })
          ];
          nixpkgs = nixpkgsConfig;
        };
      };

      darwinModules = { };

      homeManagerModules = {
        programs.awscli = import ./30-modules/home/programs/awscli.nix;
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
