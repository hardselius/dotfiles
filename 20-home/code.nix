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
      universal-ctags

      steampipe
      # unstable.pkgs.steampipe
    ];
  };

  programs.go = {
    enable = true;
  };
}
