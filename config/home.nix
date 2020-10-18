{ pkgs, ... }:

let
  home_directory = builtins.getEnv "HOME";
  tmp_directoru = "/tmp";
  ca-bundle_crt = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  lib = pkgs.stdenv.lib;
  localcondfig = import <localconfig>;

in rec {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
    };

    overlays = let path = ../overlays;
    in with builtins;
    map (n: import (path + ("/" + n))) (filter (n:
      match ".*\\.nix" n != null
      || pathExists (path + ("/" + n + "/default.nix")))
      (attrNames (readDir path)));
  };

  fonts.fontconfig.enable = true;

  home = {
    username = "martin";
    homeDirectory = "${home_directory}";
    stateVersion = "20.09";

    sessionVariables = {
      EDITOR = "${pkgs.vim}/bin/vim";
      PAGER = "${pkgs.less}/bin/less";
    };

    packages = with pkgs; [];
  };

  programs = {

    home-manager = { enable = true; };

    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };

    direnv = { enable = true; };

    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };

    bash = rec {
      enable = true;
    };

    zsh = rec {
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
        NOTES = "$HOME/dropbox-personal/wiki";
        GPG_TTY = "$TTY";
        GOPATH = "$(go env GOPATH)";
        PATH = "$PATH:$GOPATH/bin";
      };

      shellAliases = {
        tf = "terraform";
        restartaudio = "sudo killall coreaudiod";
      };

      profileExtra = ''
        export GPG_TTY=$(tty)

        if ! pgrep -x "gpg-agent" > /dev/null; then
            ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent
        fi
      '';

      initExtra = ''
        export KEYTIMEOUT=1

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

        # The next line updates PATH for the Google Cloud SDK.
        if [ -f '/Users/martin/bin/google-cloud-sdk/path.zsh.inc' ]; then
          . '/Users/martin/bin/google-cloud-sdk/path.zsh.inc'
        fi

        # The next line enables shell command completion for gcloud.
        if [ -f '/Users/martin/bin/google-cloud-sdk/completion.zsh.inc' ]; then
          . '/Users/martin/bin/google-cloud-sdk/completion.zsh.inc'
        fi
      '';
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        aws.symbol = "aws ";
        conda.symbol = "conda ";
        docker.symbol = "docker ";
        elixir.symbol = "elixir ";
        elm.symbol = "elm ";
        golang.symbol = "go ";
        haskell.symbol = "haskell ";
        java.symbol = "java ";
        julia.symbol = "julia ";
        memory_usage.symbol = " ";
        nim.symbol = "nim ";
        nix_shell.symbol = "nix ";
        nodejs.symbol = "node ";
        package.symbol = "pkg ";
        php.symbol = "php ";
        python.symbol = "python ";
        ruby.symbol = "ruby ";
        rust.symbol = "rust ";
      };
    };

    git = {
      enable = true;

      userName = "Martin Hardselius";
      userEmail = "martin@hardselius.dev";

      signing = {
        key = "84D80CE9A803D1C5";
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
        };

        branch.autosetupmerge = true;
        color.ui = "auto";
        commit.gpgsign = true;
        commit.verbose = true;
        diff.submodule = "log";
        diff.tool = "${pkgs.vim}/bin/vimdiff";
        difftool.prompt = false;
        github.user = "hardselius";
        http.sslCAinfo = "${ca-bundle_crt}";
        http.sslverify = true;
        hub.protocol = "${pkgs.openssh}/bin/ssh";
        init.templatedir = "${xdg.configHome}/git/template";
        merge.tool = "${pkgs.vim}/bin/vimdiff";
        mergetool.keepBackup = true;
        pull.rebase = true;
        push.default = "tracking";
        rebase.autosquash = true;
        rerere.enabled = true;
        status.submoduleSummary = true;
      };

      ignores = import ./home/gitignore.nix;
    };
  };

  xdg = {
    enable = true;

    configHome = "${home_directory}/.config";
    dataHome = "${home_directory}/.local/share";
    cacheHome = "${home_directory}/.cache";

    configFile."git/template" = {
      recursive = true;
      source = ../git/.git_template;
    };
  };
}
