{ pkgs, ... }:
{
  programs.git.aliases = {
    authors = "!${pkgs.git}/bin/git log --pretty=format:%aN | ${pkgs.coreutils}/bin/sort | ${pkgs.coreutils}/bin/uniq -c | ${pkgs.coreutils}/bin/sort -rn";
    b = "branch --color -v";
    changes = "diff --name-status -r";
    clone = "clone --recursive";
    ctags = "!.git/hooks/ctags";
    root = "!pwd";
    spull = "!${pkgs.git}/bin/git stash && ${pkgs.git}/bin/git pull && ${pkgs.git}/bin/git stash pop";
    su = "submodule update --init --recursive";
    undo = "reset --soft HEAD^";
    w = "status -sb";
    wdiff = "diff --color-words";
    l = "log --graph --abbrev-commit --date=relative --show-notes=* --pretty=format:'%Cred%h%Creset —%Cblue%d%Creset %s %Cgreen(%cr)%Creset %C(bold blue)<%an>%Creset'";
  };
}

