{ config, pkgs, lib, ... }:
{
  programs.home-manager.enable = true;

  programs.awscli.enable = true;
  programs.awscli.package = pkgs.awscli2;
  programs.awscli.enableBashIntegration = true;
  programs.awscli.enableZshIntegration = true;
  programs.awscli.awsVault = {
    enable = true;
    prompt = "ykman";
    backend = "pass";
    passPrefix = "aws_vault/";
  };

  programs.browserpass.enable = true;
  programs.browserpass.browsers = [ "firefox" ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.  enable = true;

  programs.dircolors.enable = true;
  programs.dircolors.enableZshIntegration = true;

  programs.fzf.enable = true;
  programs.fzf.enableBashIntegration = true;
  programs.fzf.enableZshIntegration = true;

  programs.go.enable = true;

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.ssh.enable = true;
  programs.ssh.controlMaster = "auto";
  programs.ssh.controlPath = "/tmp/ssh-%u-%r@%h:%p";
  programs.ssh.controlPersist = "1800";
  programs.ssh.forwardAgent = true;
  programs.ssh.serverAliveInterval = 60;
  programs.ssh.hashKnownHosts = true;
  programs.ssh.extraConfig = ''
    Host remarkable
      Hostname 10.11.99.1
      User root
      ForwardX11 no
      ForwardAgent no
  '';

  programs.tmux.enable = true;
  programs.tmux.aggressiveResize = true;
  programs.tmux.clock24 = true;
  programs.tmux.keyMode = "vi";
  programs.tmux.terminal = "screen-256color";

  home.packages = with pkgs; [
    asciinema
    cachix
    coreutils
    curl
    fd
    findutils
    getopt
    gh
    gnumake
    gnupg
    gpgme
    htop
    jq
    jsonnet-language-server
    less
    ncspot
    nixpkgs-fmt
    nodePackages.bash-language-server
    nodePackages.node2nix
    nodePackages.prettier
    nodePackages.vim-language-server
    paperkey
    pass
    socat
    steampipe
    plantuml
    prs
    python39Packages.sqlparse
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
    xkcdpass
    yubikey-manager
  ];
}
