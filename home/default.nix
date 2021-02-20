{ config, pkgs, lib, ... }:
rec {
  imports = [
    ./dev.nix
    ./git.nix
    ./newsboat.nix
    ./shells.nix
  ];

  home = {
    stateVersion = "20.09";

    sessionVariables = {
      EDITOR = "${pkgs.vim}/bin/vim";
      PAGER = "${pkgs.less}/bin/less";
    };

    packages = with pkgs; [
      asciinema
      cacert
      cachix
      coreutils
      curl
      fd
      findutils
      getopt
      gnupg
      gpgme
      gtypist
      htop
      jq
      less
      pass
      pywal
      renameutils
      ripgrep
      rsync
      tree
      universal-ctags
      urlscan
      vim
      vim-vint
      w3m
      weechat
      wget

      yubikey-personalization
      yubikey-manager
    ] ++ lib.optionals stdenv.isDarwin [
      darwin-zsh-completions
    ];
  };

  programs = {

    home-manager = { enable = true; };

    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };

    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
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
  };

  xdg.enable = true;
}
