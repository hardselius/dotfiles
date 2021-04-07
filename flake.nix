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

      mkNixosModules = localconfig @ { user, ... }: [
        home-manager.nixosModules.home-manager
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

      nixosConfigurations = {
        vmware = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosModules
            {
              user = "martin";
              userName = "Martin Hardselius";
              userEmail = "martin" + "@hardselius.dev";
              signingKey = "martin" + "@hardselius.dev";
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
