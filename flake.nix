{
  description = "Martin's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-21.05-darwin";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-21.05";

    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, flake-utils, ... } @ inputs:
    let
      systems = [
        "x86_64-darwin"
        "x86_64-linux"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      nixpkgsConfig = with inputs; rec {
        config = {
          allowUnfree = true;
        };
        overlays = self.overlays ++ [
          (
            final: prev: {
              master = import nixpkgs-master { inherit (prev) system; inherit config; };
              unstable = import nixpkgs-unstable { inherit (prev) system; inherit config; };
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
            programs.screen
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
          system = "x86_64-darwin";
          inputs = inputs;
          modules = [
            ./10-darwin/bootstrap.nix
          ];
        };

        githubActions = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          inputs = inputs;
          modules = mkDarwinModules {
            user = "runner";
            host = "github-actions";
          };
        };

        macbook = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
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
        programs.screen = import ./30-modules/home/programs/screen.nix;
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
