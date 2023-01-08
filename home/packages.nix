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
    # basics
    coreutils
    curl
    fd # fancy `find`
    findutils # GNU find utils
    htop # fancy `top`
    less # more advanced file pager than `more`
    #renameutils # rename files faster
    ripgrep # fancy `grep`
    rsync # incremental file transfer util
    tree # depth indented directory listing
    wget

    # dev stuff
    gh # github cli tool
    gnumake
    jq # command line json processor
    just # save and run project specific commands
    plantuml # draw uml diagrams
    # steampipe # select * from cloud
    vim
    zellij # terminal multiplexer

    # code tools
    gdbgui
    jsonnet-language-server
    nodePackages.bash-language-server
    nodePackages.prettier # code formatter
    nodePackages.vim-language-server
    pqrs
    python39Packages.sqlparse
    rnix-lsp
    rustup
    shellcheck
    shfmt # shell parser and formatter
    universal-ctags # maintained ctags implementation

    # nix tools
    cachix
    nixpkgs-fmt
    nodePackages.node2nix

    # opsec
    gnupg
    gpgme # make gnupg easier
    pass # "password manager"
    xkcdpass # generate passwords
    yubikey-manager # configure yubikeys

    # other
    graphviz # graph visualization tools
    nmap
    openssl
    watch
    qemu
  ];
}
