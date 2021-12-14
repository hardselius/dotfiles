{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      atlantis
      gh
      nixpkgs-fmt
      nodePackages.node2nix
      nodePackages.prettier
      nodePackages.vim-language-server
      python39Packages.sqlparse
      shellcheck
      shfmt
      pkgs.steampipe
      universal-ctags

      jsonnet-language-server
    ];
  };

  programs.go = {
    enable = true;
  };
}
