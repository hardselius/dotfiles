{ config, pkgs, lib, localconfig, vimrc, ... }:
let
  tmp_directory = "/tmp";
  home_directory = "${config.home.homeDirectory}";
in
rec {
  home = {
    stateVersion = "20.09";

    sessionVariables = {
      EDITOR = "${pkgs.vim}/bin/vim";
      EMAIL = "${programs.git.userEmail}";
      GNUPGHOME = "${xdg.configHome}/gnupg";
      PAGER = "${pkgs.less}/bin/less";
      SSH_AUTH_SOCK = "${xdg.configHome}/gnupg/S.gpg-agent.ssh";
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
      newsboat
      nodePackages.node2nix
      nodePackages.vim-language-server
      pass
      plantuml
      pure-prompt
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

    file.".vim".source = vimrc;
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

    zsh = {
      enable = true;

      cdpath = [
        "."
        "~"
      ];

      defaultKeymap = "viins";
      dotDir = ".config/zsh";

      history = {
        size = 50000;
        save = 500000;
        ignoreDups = true;
        share = true;
      };

      sessionVariables = {
        CLICOLOR = true;
        GPG_TTY = "$TTY";
        PATH = "$PATH:$HOME/.local/bin";
      };

      shellAliases = {
        gpgreset = "gpg-connect-agent killagent /bye; gpg-connect-agent updatestartuptty /bye; gpg-connect-agent /bye";
        restartaudio = "sudo killall coreaudiod";
        tf = "terraform";
      };

      profileExtra = ''
        export GPG_TTY=$(tty)

        if ! pgrep -x "gpg-agent" > /dev/null; then
            ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent
        fi
      '';

      initExtra = ''
        export KEYTIMEOUT=1
        export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)

        vi-search-fix() {
          zle vi-cmd-mode
          zle .vi-history-search-backward
        }
        autoload vi-search-fix
        zle -N vi-search-fix
        bindkey -M viins '\e/' vi-search-fix

        bindkey "^?" backward-delete-char

        resume() {
          fg
          zle push-input
          BUFFER=""
          zle accept-line
        }
        zle -N resume
        bindkey "^Z" resume

        ls() {
            ${pkgs.coreutils}/bin/ls --color=auto --group-directories-first "$@"
        }

        autoload -U promptinit; promptinit

        # Configure pure-promt
        prompt pure
        zstyle :prompt:pure:prompt:success color green

        # The next line updates PATH for the Google Cloud SDK.
        if [ -f '/Users/martin/bin/google-cloud-sdk/path.zsh.inc' ]; then
          . '/Users/martin/.local/bin/google-cloud-sdk/path.zsh.inc'
        fi

        # The next line enables shell command completion for gcloud.
        if [ -f '/Users/martin/.local/bin/google-cloud-sdk/completion.zsh.inc' ]; then
          . '/Users/martin/.local/bin/google-cloud-sdk/completion.zsh.inc'
        fi
      '';
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

    ssh = {
      enable = true;

      controlMaster = "auto";
      controlPath = "${tmp_directory}/ssh-%u-%r@%h:%p";
      controlPersist = "1800";

      forwardAgent = true;
      serverAliveInterval = 60;

      hashKnownHosts = true;
      userKnownHostsFile = "${xdg.configHome}/ssh/known_hosts";

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

    configFile."gnupg/gpg-agent.conf".text = ''
      enable-ssh-support

      default-cache-ttl 600
      max-cache-ttl 7200

      default-cache-ttl-ssh 600
      max-cache-ttl-ssh 7200

      pinentry-program ${pkgs.pinentry.curses}/bin/pinentry
    '';

    configFile."git/hooks" = {
      recursive = true;
      source = ./git/hooks;
    };

    configFile."newsboat/urls".text = ''
      https://this-week-in-rust.org/atom.xml
      https://cprss.s3.amazonaws.com/golangweekly.com.xml
      https://vimtricks.com/atom
      https://weekly.nixos.org/feeds/all.rss.xml
    '';

    configFile."newsboat/config".text = ''
      unbind-key h
      unbind-key j
      unbind-key k
      unbind-key l

      bind-key h quit
      bind-key j down
      bind-key k up
      bind-key l open

      unbind-key g # bound to `sort` by default
      bind-key g home
      unbind-key G # bound to `rev-sort` by default
      bind-key G end
    '';
  };
}
