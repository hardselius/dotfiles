{pkgs, ...}: {
  programs.home-manager.enable = true;

  programs.awscli-custom.enable = true;
  programs.awscli-custom.package = pkgs.awscli2;
  programs.awscli-custom.enableBashIntegration = true;
  programs.awscli-custom.enableZshIntegration = true;
  programs.awscli-custom.awsVault = {
    enable = true;
    prompt = "ykman";
    backend = "pass";
    passPrefix = "aws_vault/";
  };

  programs.browserpass.enable = true;
  programs.browserpass.browsers = ["firefox"];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.dircolors.enable = true;
  programs.dircolors.enableBashIntegration = true;
  programs.dircolors.enableZshIntegration = true;

  programs.fzf.enable = true;
  programs.fzf.enableBashIntegration = true;
  programs.fzf.enableZshIntegration = true;

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.ssh.enable = true;
  programs.ssh.controlMaster = "auto";
  programs.ssh.controlPath = "/tmp/ssh-%u-%r@%h:%p";
  programs.ssh.controlPersist = "60";
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
    devbox
    gh # github cli tool
    gnumake
    jq # command line json processor
    just # save and run project specific commands
    plantuml # draw uml diagrams
    steampipe # select * from cloud
    tenv # version manager for OpenTofu, Terraform and Terragrunt
    vim

    # code tools
    jsonnet-language-server
    nodePackages.bash-language-server
    nodePackages.prettier # code formatter
    nodePackages.typescript-language-server
    nodePackages.vim-language-server
    podman # docker replacement
    pqrs
    python39Packages.sqlparse
    nil
    rustup
    shellcheck
    shfmt # shell parser and formatter
    tgswitch
    universal-ctags # maintained ctags implementation
    xsv

    # nix tools
    alejandra
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
    asciidoctor
    chatgpt-cli
    graphviz # graph visualization tools
    nmap
    openssl
    renameutils
    watch
    qemu
  ];
}
