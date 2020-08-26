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
      allowUnfree            = true;
      allowBroken            = false;
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
    username      = "martin";
    homeDirectory = "${home_directory}";
    stateVersion  = "20.09";

    packages = with pkgs; [ ];
  };

  programs = {
    neomutt = {
      enable = true;
      vimKeys = true;

      sidebar = {
        enable = true;
      };
    };

    mbsync.enable = true;
    msmtp.enable = true;

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
      defaultKeymap = "viins";

      history = {
        size       = 50000;
        save       = 500000;
        ignoreDups = true;
        share      = true;
      };

      sessionVariables = {
        CLICOLOR = true;
        NOTES    = "$HOME/dropbox-personal/wiki";
        GPG_TTY  = "$TTY";
        GOPATH   = "$(go env GOPATH)";
        PATH     = "$PATH:$GOPATH/bin";
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
        export CDPATH=.:~:~/projects

        # The next line updates PATH for the Google Cloud SDK.
        if [ -f '/Users/martin/google-cloud-sdk/path.zsh.inc' ]; then
          . '/Users/martin/google-cloud-sdk/path.zsh.inc'
        fi

        # The next line enables shell command completion for gcloud.
        if [ -f '/Users/martin/google-cloud-sdk/completion.zsh.inc' ]; then
          . '/Users/martin/google-cloud-sdk/completion.zsh.inc'
        fi
      '';
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
        b       = "branch --color -v";
        ca      = "commit --amend";
        changes = "diff --name-status -r";
        clone   = "clone --recursive";
        co      = "checkout";
        ctags   = "!.git/hooks/ctags";
        root    = "!pwd";
        spull   = "!${pkgs.git}/bin/git stash"
                + " && ${pkgs.git}/bin/git pull"
                + " && ${pkgs.git}/bin/git stash pop";
        su      = "submodule update --init --recursive";
        undo    = "reset --soft HEAD^";
        w       = "status -sb";
        wdiff   = "diff --color-words";
        l       = "log --graph --pretty=format:'%Cred%h%Creset"
                + " —%Cblue%d%Creset %s %Cgreen(%cr)%Creset'"
                + " --abbrev-commit --date=relative --show-notes=*";
      };

      extraConfig = {
        core = {
          editor            = "${pkgs.vim_configurable}/bin/vim";
          trustctime        = false;
          pager             = "${pkgs.gitAndTools.delta}/bin/delta"
                            # + " --diff-so-fancy";
                            + " --plus-color=\"green\"" + " --minus-color=\"red\""
                            + " --theme='ansi-dark'";
          logAllRefUpdates  = true;
          precomposeunicode = true;
          whitespace        = "trailing-space,space-before-tab";
        };

        init.templatedir       = "${xdg.configHome}/git/template";
        interactive.diffFilter = "${pkgs.gitAndTools.delta}/bin/delta --color-only";
        branch.autosetupmerge  = true;
        commit.gpgsign         = true;
        github.user            = "hardselius";
        # credential.helper      = "${pkgs.gitAndTools.pass-git-helper}/bin/pass-git-helper";
        # ghi.token              = "!${pkgs.pass}/bin/pass show api.github.com | head -1";
        hub.protocol           = "${pkgs.openssh}/bin/ssh";
        mergetool.keepBackup   = true;
        pull.rebase            = true;
        rebase.autosquash      = true;
        rerere.enabled         = true;

        http = {
          sslCAinfo = "${ca-bundle_crt}";
          sslverify = true;
        };

        color = {
          status      = "auto";
          diff        = "auto";
          branch      = "auto";
          interactive = "auto";
          ui          = "auto";
          sh          = "auto";
        };

        push = { default = "tracking"; };

        merge = {
          conflictstyle = "diff3";
          stat = true;
        };

        "color \"sh\"" = {
          branch      = "yellow reverse";
          workdir     = "blue bold";
          dirty       = "red";
          dirty-stash = "red";
          repo-state  = "red";
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

      ignores = import ./home/gitignore.nix;
    };
  };

  xdg = {
    enable = true;

    configHome = "${home_directory}/.config";
    dataHome   = "${home_directory}/.local/share";
    cacheHome  = "${home_directory}/.cache";

    configFile."git/template" = {
      recursive = true;
      source = ../git/.git_template;
    };
  };

  accounts.email = {

    certificatesFile = "${ca-bundle_crt}";

    accounts.fastmail = {
      primary = true;
      address = programs.git.userEmail;
      realName = programs.git.userName;
      userName = programs.git.userEmail;
      passwordCommand = "${pkgs.pass}/bin/pass show mail.fastmail.com";

      gpg = {
        key = programs.git.signing.key;
      };

      imap = {
        host = "imap.fastmail.com";
        port = 993;
        tls = {
          enable = true;
        };
      };

      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };

      msmtp = {
        enable = true;
      };

      neomutt = {
        enable = true;
      };

      smtp = {
        host = "smtp.fastmail.com";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
    };
  };
}
