{ config, pkgs, lib, localconfig, ... }:
let
  home_directory = "${config.home.homeDirectory}";
in
rec {
  imports = [
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
      gnumake
      gnupg
      gpgme
      htop
      jq
      less
      nodePackages.node2nix
      nodePackages.vim-language-server
      pass
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
      weechat
      wget
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

    go = {
      enable = true;
    };

    kitty = {
      enable = true;

      settings = {
        font_family = "Hack Regular";
        font_size = "14.0";
        adjust_line_height = "120%";
        disable_ligatures = "cursor"; # disable ligatures when cursor is on them

        # Window layout
        hide_window_decorations = "titlebar-only";
        window_padding_width = "10";

        # Tab bar
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_title_template = "Tab {index}: {title}";
        active_tab_font_style = "bold";
        inactive_tab_font_style = "normal";
      };
    };

    git = {
      enable = true;

      userName = if localconfig.userName != null then localconfig.userName else localconfig.user;
      userEmail = localconfig.userEmail;
      signing = if !(localconfig ? signingKey) || localconfig.signingKey == null then null else {
        key = localconfig.signingKey;
        signByDefault = true;
      };

      aliases = {
        authors = "!${pkgs.git}/bin/git log --pretty=format:%aN"
          + " | ${pkgs.coreutils}/bin/sort" + " | ${pkgs.coreutils}/bin/uniq -c"
          + " | ${pkgs.coreutils}/bin/sort -rn";
        b = "branch --color -v";
        ca = "commit --amend";
        changes = "diff --name-status -r";
        clone = "clone --recursive";
        co = "checkout";
        ctags = "!.git/hooks/ctags";
        root = "!pwd";
        spull = "!${pkgs.git}/bin/git stash" + " && ${pkgs.git}/bin/git pull"
          + " && ${pkgs.git}/bin/git stash pop";
        su = "submodule update --init --recursive";
        undo = "reset --soft HEAD^";
        w = "status -sb";
        wdiff = "diff --color-words";
        l = "log --graph --pretty=format:'%Cred%h%Creset"
          + " —%Cblue%d%Creset %s %Cgreen(%cr)%Creset'"
          + " --abbrev-commit --date=relative --show-notes=*";
      };

      extraConfig = {
        core = {
          editor = "${pkgs.vim}/bin/vim";
          trustctime = false;
          logAllRefUpdates = true;
          precomposeunicode = true;
          whitespace = "trailing-space,space-before-tab";
          hooksPath = "${xdg.configHome}/git/hooks";
        };

        branch.autosetupmerge = true;
        color.ui = "auto";
        commit.verbose = true;
        diff.submodule = "log";
        diff.tool = "${pkgs.vim}/bin/vimdiff";
        difftool.prompt = false;
        github.user = "hardselius";
        http.sslCAinfo = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        http.sslverify = true;
        hub.protocol = "${pkgs.openssh}/bin/ssh";
        merge.tool = "${pkgs.vim}/bin/vimdiff";
        mergetool.keepBackup = true;
        pull.rebase = true;
        push.default = "tracking";
        rebase.autosquash = true;
        rerere.enabled = true;
        status.submoduleSummary = true;
      };

      ignores = [
        "[._]*.s[a-v][a-z]"
        "[._]*.sw[a-p]"
        "[._]s[a-rt-v][a-z]"
        "[._]ss[a-gi-z]"
        "[._]sw[a-p]"
        "Session.vim"
        "Sessionx.vim"
        ".netrwhist"
        "*~"
        "tags"
        "[._]*.un~"
        "**/.idea/"
        "**/*.iml"
        "**/*.ipr"
        "**/*.iws"
        ".DS_Store"
        ".AppleDouble"
        ".LSOverride"
        "Icon"
        "._*"
        ".DocumentRevisions-V100"
        ".fseventsd"
        ".Spotlight-V100"
        ".TemporaryItems"
        ".Trashes"
        ".VolumeIcon.icns"
        ".com.apple.timemachine.donotpresent"
        ".AppleDB"
        ".AppleDesktop"
        "Network Trash Folder"
        "Temporary Items"
        ".apdisk"
        ".envrc"
        "shell.nix"
        ".direnv/"
      ];
    };
  };

  xdg = {
    enable = true;

    configHome = "${home_directory}/.config";
    dataHome = "${home_directory}/.local/share";
    cacheHome = "${home_directory}/.cache";

    configFile."git/hooks" = {
      recursive = true;
      source = ./git/hooks;
    };
  };
}
