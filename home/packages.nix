{ config, pkgs, lib, ... }:
{
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

  programs = {

    home-manager.enable = true;

    awscli.enable = true;
    awscli.package = pkgs.awscli2;
    awscli.enableBashIntegration = true;
    awscli.enableZshIntegration = true;
    awscli.awsVault = {
      enable = true;
      prompt = "ykman";
      backend = "pass";
      passPrefix = "aws_vault/";
    };

    browserpass.enable = true;
    browserpass.browsers = [ "firefox" ];

    direnv.enable = true;
    direnv.nix-direnv.  enable = true;

    dircolors.enable = true;
    dircolors.enableZshIntegration = true;

    fzf.enable = true;
    fzf.enableBashIntegration = true;
    fzf.enableZshIntegration = true;

    go.enable = true;

    htop.enable = true;
    htop.settings.show_program_path = true;

    ssh.enable = true;
    ssh.controlMaster = "auto";
    ssh.controlPath = "/tmp/ssh-%u-%r@%h:%p";
    ssh.controlPersist = "1800";
    ssh.forwardAgent = true;
    ssh.serverAliveInterval = 60;
    ssh.hashKnownHosts = true;
    ssh.extraConfig = ''
      Host remarkable
        Hostname 10.11.99.1
        User root
        ForwardX11 no
        ForwardAgent no
    '';

    tmux.enable = true;
    tmux.aggressiveResize = true;
    tmux.clock24 = true;
    tmux.keyMode = "vi";
    tmux.terminal = "screen-256color";
  };
}
