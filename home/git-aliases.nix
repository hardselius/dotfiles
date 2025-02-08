{pkgs, ...}: {
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
    l = "log --graph --abbrev-commit --date=relative --pretty=format:'%C(yellow)%h%C(reset) %C(bold red)%d%C(reset) %s %C(bold cyan)[%(trailers:key=Issue,valueonly=true,separator=%x2C )]%C(reset) %C(green)(%cr)%C(reset) %C(bold blue)<%an>%C(reset)'";
  };
}
