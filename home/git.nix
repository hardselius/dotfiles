{ config, pkgs, lib, ... }:
let
  gitTemplateDir = "git/template";
  binDir = ".local/bin";
  inherit (config.home) user-info;
in

{
  programs.git = {
    enable = true;
    package = pkgs.git;
    userEmail = user-info.email;
    userName = user-info.fullName;
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
      commit.verbose = true;
      diff.submodule = "log";
      diff.tool = "${pkgs.vim}/bin/vimdiff";
      difftool.prompt = false;
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
      github.user = user-info.github;
      init.templateDir = "${config.xdg.configHome}/${gitTemplateDir}";
    };
  } // lib.optionalAttrs user-info.gpgsign {
    signing = {
      key = user-info.email;
      signByDefault = user-info.gpgsign;
    };
  };

  xdg.configFile."${gitTemplateDir}/hooks" = {
    recursive = true;
    source = ./git/hooks;
  };

  home.file = {
    "${binDir}/git-jump" = {
      executable = true;
      source = ./git/addons/git-jump;
    };
  };
}
