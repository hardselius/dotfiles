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

  home = {
    username = "martin";
    homeDirectory = "${home_directory}";
    stateVersion = "20.09";

    packages = with pkgs; [ ];
  };

  programs = {
    home-manager = {
      enable = true;
      path = "${home_directory}/src/nix/home-manager";
    };

    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };

    direnv = { enable = true; };

    dircolors = import ./home/dircolors.nix;

    zsh = rec {
      enable = true;

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
        CDPATH = ".:~:~/projects";
        GPG_TTY = "$TTY";
        GOPATH = "$(go env GOPATH)";
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
    };

    git = {
      enable = true;

      userName = "Martin Hardselius";
      userEmail = "martin.hardselius@gmail.com";

      signing = {
        key = "84D80CE9A803D1C5";
        signByDefault = true;
      };

      aliases = {
        authors = "!${pkgs.git}/bin/git log --pretty=format:%aN"
          + " | ${pkgs.coreutils}/bin/sort" + " | ${pkgs.coreutils}/bin/uniq -c"
          + " | ${pkgs.coreutils}/bin/sort -rn";
        ctags = "!.git/hooks/ctags";
        l = "log --graph --pretty=format:'%Cred%h%Creset"
          + " —%Cblue%d%Creset %s %Cgreen(%cr)%Creset'"
          + " --abbrev-commit --date=relative --show-notes=*";
      };

      extraConfig = {
        core = {
          editor = "${pkgs.vim_configurable}/bin/vim";
          excludesfile = "${xdg.configHome}/git/gitignore_global";
          trustctime = false;
          pager = "${pkgs.gitAndTools.delta}/bin/delta"
            # + " --diff-so-fancy";
            + " --plus-color=\"green\"" + " --minus-color=\"red\""
            + " --theme='ansi-dark'";
          logAllRefUpdates = true;
          precomposeunicode = true;
          whitespace = "trailing-space,space-before-tab";
        };

        init.templatedir = "${xdg.configHome}/git/template";
        interactive.diffFilter =
          "${pkgs.gitAndTools.delta}/bin/delta --color-only";
        branch.autosetupmerge = true;
        commit.gpgsign = true;
        github.user = "hardselius";
        credential.helper =
          "${pkgs.gitAndTools.pass-git-helper}/bin/pass-git-helper";
        # ghi.token              = "!${pkgs.pass}/bin/pass show api.github.com | head -1";
        hub.protocol = "${pkgs.openssh}/bin/ssh";
        mergetool.keepBackup = true;
        pull.rebase = true;
        rebase.autosquash = true;
        rerere.enabled = true;

        http = {
          sslCAinfo = "${ca-bundle_crt}";
          sslverify = true;
        };

        color = {
          status = "auto";
          diff = "auto";
          branch = "auto";
          interactive = "auto";
          ui = "auto";
          sh = "auto";
        };

        push = { default = "tracking"; };

        merge = {
          conflictstyle = "diff3";
          stat = true;
        };

        "color \"sh\"" = {
          branch = "yellow reverse";
          workdir = "blue bold";
          dirty = "red";
          dirty-stash = "red";
          repo-state = "red";
        };

        annex = {
          backends = "BLAKE2B512E";
          alwayscommit = false;
        };

        "filter \"media\"" = {
          required = true;
          clean = "${pkgs.git}/bin/git media clean %f";
          smudge = "${pkgs.git}/bin/git media smudge %f";
        };
      };
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

    configFile."git/gitignore_global" = { source = ../git/.gitignore_global; };
  };
}
