{ config, pkgs, lib, ... }:
let
  tmp_directory = "/tmp";
  home_directory = "${config.home.homeDirectory}";
in
rec {
  imports = [
    ./alacritty.nix
    ./git.nix
    ./kitty.nix
    ./newsboat.nix
    ./shells.nix
  ];

  home = {
    stateVersion = "20.09";

    sessionVariables = {
      EDITOR = "${pkgs.vim}/bin/vim";
      EMAIL = "${config.programs.git.userEmail}";
      PAGER = "${pkgs.less}/bin/less";
      CLICOLOR = true;
      GPG_TTY = "$TTY";
      PATH = "$PATH:$HOME/.local/bin:$HOME/.tfenv/bin";
    };

    packages = with pkgs; [
      (pass.withExtensions (exts: [ exts.pass-otp ]))
      asciinema
      cacert
      cachix
      coreutils
      curl
      exiftool
      fd
      findutils
      getopt
      gnumake
      gnupg
      gpgme
      htop
      jq
      less
      nodePackages.node2nix
      nodePackages.prettier
      nodePackages.vim-language-server
      plantuml
      pywal
      renameutils
      ripgrep
      rsync
      shellcheck
      shfmt
      tree
      universal-ctags
      urlscan
      vim
      vim-vint
      w3m
      wget
      yubikey-manager
    ];
  };

  programs = {

    home-manager = { enable = true; };

    awscli = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      awsVault = {
        enable = true;
        prompt = "ykman";
        backend = "pass";
        passPrefix = "aws_vault/";
      };
    };

    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };

    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };

    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    go = {
      enable = true;
    };

    ssh = {
      enable = true;

      controlMaster = "auto";
      controlPath = "${tmp_directory}/ssh-%u-%r@%h:%p";
      controlPersist = "1800";

      forwardAgent = true;
      serverAliveInterval = 60;

      hashKnownHosts = true;

      extraConfig = ''
        Host remarkable
          Hostname 10.11.99.1
          User root
          ForwardX11 no
          ForwardAgent no
      '';
    };
  };

  xdg = {
    enable = true;

    configHome = "${home_directory}/.config";
    dataHome = "${home_directory}/.local/share";
    cacheHome = "${home_directory}/.cache";
  };
}
