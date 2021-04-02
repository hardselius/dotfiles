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
            "hardselius.cachix.org-1:wdmClEq/2j8gEKJ5vLLCmpgCDumsyPMO6iVWKkYHKP0="
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
            ({ config, pkgs, callPackage,  ... }: {
              imports =
                [ # Include the results of the hardware scan.
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
