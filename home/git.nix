{ pkgs, lib, ... }:

{
  programs.git = {
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
      http.sslCAinfo = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      http.sslverify = true;
      hub.protocol = "${pkgs.openssh}/bin/ssh";
      # init.templatedir = "${xdg.configHome}/git/template";
      merge.tool = "${pkgs.vim}/bin/vimdiff";
      mergetool.keepBackup = true;
      pull.rebase = true;
      push.default = "tracking";
      rebase.autosquash = true;
      rerere.enabled = true;
      status.submoduleSummary = true;
    };

    ignores = import ../config/home/gitignore.nix;
  };

  xdg.configFile."git/template" = {
    recursive = true;
    source = ../git/.git_template;
  };
}
