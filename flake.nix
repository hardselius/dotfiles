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

      mkDarwinModules = args @ { user, ... }: [
        home-manager.darwinModules.home-manager
        ./config/shared.nix
        ./darwin
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

      mkNixosModules = localconfig @ { user, ... }: [
        home-manager.nixosModules.home-manager
        ./config/shared.nix
        rec {
          nixpkgs = nixpkgsConfig;
          users.users.${user}.home = "/home/${user}";
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = homeManagerConfig localconfig;
        }
      ];

    in
    {
      darwinConfigurations = {

        # Minimal configuration to bootstrap systems
        bootstrap = darwin.lib.darwinSystem {
          inputs = inputs;
          modules = [
            ./config/shared.nix
            ./darwin/bootstrap.nix
          ];
        };

        ghActions = darwin.lib.darwinSystem {
          inputs = inputs;
          modules = mkDarwinModules {
            user = "runner";
          };
        };

        macbook = darwin.lib.darwinSystem {
          inputs = inputs;
          modules = mkDarwinModules {
            user = "martin";
          };
        };
      };

      nixosConfigurations = {
        vmware = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = mkNixosModules
            {
              user = "martin";
            } ++ [
            ({ config, pkgs, callPackage, ... }: {
              imports =
                [
                  # Include the results of the hardware scan.
                  ./hosts/nixos-vmware.nix
                ];
              nix = {
                package = pkgs.nixFlakes;
                extraOptions = ''
                  experimental-features = nix-command flakes
                '';
              };
              boot.loader.grub.enable = true;
              boot.loader.grub.version = 2;
              boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
              networking.hostName = "nixos"; # Define your hostname.
              networking.useDHCP = false;
              networking.interfaces.ens33.useDHCP = true;

              virtualisation = {
                vmware.guest.enable = true;
              };
              environment = {
                pathsToLink = [ "/libexec" ];
                systemPackages = with pkgs; [
                  wget
                  vim
                  firefox
                  git
                ];
              };
              services = {
                pcscd.enable = true;
                xserver = {
                  enable = true;

                  windowManager.i3 = {
                    enable = true;
                    extraPackages = with pkgs; [
                      dmenu
                      i3status
                      i3lock
                    ];
                  };
                  displayManager.defaultSession = "none+i3";
                };
              };
              programs.gnupg.agent = {
                enable = true;
                enableSSHSupport = true;
              };

              programs.zsh = {
                enable = true;
                promptInit = "";
              };

              users.users.martin = {
                isNormalUser = true;
                extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
                shell = pkgs.zsh;
              };
              system.stateVersion = "20.09"; # Did you read the comment?
            })
          ];
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
