{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      gh
      nodePackages.node2nix
      nodePackages.prettier
      nodePackages.vim-language-server
      python39Packages.sqlparse
      shellcheck
      shfmt
      steampipe
      universal-ctags
    ];
  };

  programs.go = {
    enable = true;
  };
}
