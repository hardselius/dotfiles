{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      gh
      nodePackages.node2nix
      nodePackages.prettier
      nodePackages.vim-language-server
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
