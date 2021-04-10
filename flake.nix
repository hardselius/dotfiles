{
  description = "Martin's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin/master";
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
        overlays = self.overlays;
      };

      homeManagerConfig =
        { user
        , userConfig ? ./home + "/user-${user}.nix"
        , ...
        }: with self.homeManagerModules; {
          imports = [
            userConfig
            ./home
          ];
          _module.args.vimrc = inputs.vimrc;
        };

      mkDarwinModules =
        args @
        { user
        , host
        , hostConfig ? ./config + "/host-${host}.nix"
        , ...
        }: [
          home-manager.darwinModules.home-manager
          ./config/darwin.nix
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
        , hostConfig ? ./config + "/host-${host}.nix"
        , ...
        }: [
          home-manager.nixosModules.home-manager
          ./config/shared.nix
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
            ./config/darwin-bootstrap.nix
          ];
        };

        ghActions = darwin.lib.darwinSystem {
          inputs = inputs;
          modules = mkDarwinModules {
            user = "runner";
            host = "mac-gh";
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
