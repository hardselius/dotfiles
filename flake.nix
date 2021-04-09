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

      # sharedHostsConfig contains configuration that is shared across all
      # hosts.
      sharedHostsConfig = { config, pkgs, lib, options, ... }: {
        nix = {
          package = pkgs.nixFlakes;
          extraOptions = "experimental-features = nix-command flakes";
          binaryCaches = [
            "https://cache.nixos.org/"
            "https://hardselius.cachix.org"
            "https://hydra.iohk.io"
            "https://iohk.cachix.org"
          ];
          binaryCachePublicKeys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "hardselius.cachix.org-1:PoN90aQw2eVMwfAy0MS6V9T2exWlgtHOUBBSnthXAl4="
            "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
            "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
          ];

          gc = {
            automatic = true;
            options = "--delete-older-than 7d";
          };
        };

        nixpkgs = nixpkgsConfig;

        programs = {
          bash = {
            enable = true;
          };

          zsh = {
            enable = true;
            promptInit = ''
            '';
          };
        };

        fonts = (lib.mkMerge [
          # [note] Remove this condition when `nix-darwin` aligns with NixOS
          (if (builtins.hasAttr "fontDir" options.fonts) then {
            fontDir.enable = true;
          } else {
            enableFontDir = true;
          })
          { fonts = with pkgs; [ hack-font ]; }
        ]);
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
        sharedHostsConfig
        ./darwin
        rec {
          nix.nixPath = {
            nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix";
          };
          users.users.${user}.home = "/Users/${user}";
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = homeManagerConfig args;
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
          inputs = inputs;
          modules = [
            sharedHostsConfig
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
