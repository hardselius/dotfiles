{ config, pkgs, ... }:
let
  gitTemplateDir = "git/template";
  binDir = ".local/bin";

  git = pkgs.unstable.pkgs.git;
in
{
  programs.git = {
    enable = true;
    package = git;

    aliases = {
      authors = "!${git}/bin/git log --pretty=format:%aN"
        + " | ${pkgs.coreutils}/bin/sort" + " | ${pkgs.coreutils}/bin/uniq -c"
        + " | ${pkgs.coreutils}/bin/sort -rn";
      b = "branch --color -v";
      changes = "diff --name-status -r";
      clone = "clone --recursive";
      ctags = "!.git/hooks/ctags";
      root = "!pwd";
      spull = "!${git}/bin/git stash" + " && ${git}/bin/git pull"
        + " && ${git}/bin/git stash pop";
      su = "submodule update --init --recursive";
      undo = "reset --soft HEAD^";
      w = "status -sb";
      wdiff = "diff --color-words";
      l = "log --graph --abbrev-commit --date=relative --show-notes=*"
        + " --pretty=format:'%Cred%h%Creset —%Cblue%d%Creset %s %Cgreen(%cr)%Creset %C(bold blue)<%an>%Creset'";
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

  programs.git.extraConfig.init.templateDir = "${config.xdg.configHome}/${gitTemplateDir}";
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
