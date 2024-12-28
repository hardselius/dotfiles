{
  description = "Martin's dotfiles";

  inputs = {
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-22.11";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, darwin, home-manager, flake-utils, ... } @ inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable mkForce optionalAttrs singleton;

      systems = [
        "x86_64-darwin"
        "aarch64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      nixpkgsConfig = {
        config = { allowUnfree = true; };
        overlays = attrValues self.overlays;
      };

      homeManagerStateVersion = "25.05";
      nixosStateVersion = "25.05";

      primaryUserInfo = {
        username = "mch";
        fullName = "Martin Hardselius";
        email = "martin@hardselius.dev";
        github = "hardselius";
        gpg.enable = true;
        gpg.masterKey = "3F35E4CACBF42DE12E9053E503A6E6F786936619";
      };

      nixDarwinCommonModules = attrValues self.darwinModules ++ [
        home-manager.darwinModules.home-manager
        ({ config, lib, pkgs, ... }:
          let
            inherit (config.users) primaryUser;
          in
          {
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
          {
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
      darwinConfigurations = rec {

        # Minimal configuration to bootstrap systems
        bootstrap-x86 = makeOverridable darwinSystem {
          system = "x86_64-darwin";
          modules = [
            self.darwinModules.common
            self.darwinModules.darwin-bootstrap
            { nixpkgs = nixpkgsConfig; }
          ];
        };

        bootstrap-arm = bootstrap-x86.override { system = "aarch64-darwin"; };

        # My macOS configuration
        macbook-x86 = darwinSystem {
          system = "x86_64-darwin";
          modules = nixDarwinCommonModules ++ [
            ./system/darwin/host-mac.nix
            {
              users.primaryUser = primaryUserInfo;
            }
          ];
        };

        macbook-arm = darwinSystem {
          system = "aarch64-darwin";
          modules = nixDarwinCommonModules ++ [
            ./system/darwin/host-mac.nix
            {
              users.primaryUser = primaryUserInfo;
            }
          ];
        };

        # Configuration used for CI with GitHub actions
        githubActions = darwinSystem {
          system = "x86_64-darwin";
          modules = nixDarwinCommonModules ++ [
            ./system/darwin/host-github.nix
            ({ lib, ... }: {
              users.primaryUser = primaryUserInfo // {
                username = "runner";
                gpg.enable = false;
              };
            })
            {
              environment.etc.shells.enable = mkForce false;
              environment.etc."nix/nix.conf".enable = mkForce false;
              homebrew.enable = mkForce false;
            }
          ];
        };
      };

      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = nixosCommonModules ++ [
            ./system/nixos/host-wsl.nix
            {
              users.primaryUser = primaryUserInfo;
            }
          ];
        };
      };

      homeConfigurations = {
        linuxGitHubActions = home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs-unstable {
            system = "x86_64-linux";
            inherit (nixpkgsConfig) config overlays;
          };
          modules = attrValues self.homeManagerModules ++ singleton ({ config, ... }: {
            home.username = config.home.user-info.username;
            home.homeDirectory = "/home/${config.home.username}";
            home.stateVersion = homeManagerStateVersion;
            home.user-info = primaryUserInfo // {
              username = "runner";
              gpg.enable = false;
            };
          });
        };

        linuxWsl = home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs-unstable {
            system = "x86_64-linux";
            inherit (nixpkgsConfig) config overlays;
          };
          modules = attrValues self.homeManagerModules ++ singleton ({ config, ... }: {
            home.username = config.home.user-info.username;
            home.homeDirectory = "/home/${config.home.username}";
            home.stateVersion = homeManagerStateVersion;
            home.user-info = primaryUserInfo;
          });
        };
      };

      darwinModules = {
        common = import ./system/common.nix;
        packages = import ./system/packages.nix;

        darwin-bootstrap = import ./system/darwin/bootstrap.nix;
        darwin-packages = import ./system/darwin/packages.nix;
        darwin-system = import ./system/darwin/system.nix;
        darwin-homebrew = import ./system/darwin/homebrew.nix;

        users-primaryUser = import ./modules/users.nix;
      };

      nixosModules = {
        common = import ./system/common.nix;
        stateVersion = { system.stateVersion = nixosStateVersion; };
        packages = import ./system/packages.nix;

        users-primaryUser = import ./modules/users.nix;
      };

      homeManagerModules = {
        home-config-files = import ./home/config-files.nix;
        home-git = import ./home/git.nix;
        home-git-aliases = import ./home/git-aliases.nix;
        home-git-ignores = import ./home/git-ignores.nix;
        home-git-templates = import ./home/git-templates.nix;
        home-gpg = import ./home/gpg.nix;
        home-packages = import ./home/packages.nix;
        home-shells = import ./home/shells.nix;
        home-terminal = import ./home/terminal.nix;

        home-awscli = import ./modules/home/programs/awscli.nix;

        home-user-info = { lib, ... }: {
          options.home.user-info =
            (self.darwinModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
        };
      };

      overlays = {
        pkgs-master = _: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-stable = _: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-unstable = _: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        # Overlay useful on Macs with Apple Silicon
        apple-silicon = _: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };
        };
        pure-prompt = import ./overlays/pure-prompt.nix;
        wsl2-ssh-pageant = import ./overlays/wsl2-ssh-pageant.nix;
      };

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
      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
