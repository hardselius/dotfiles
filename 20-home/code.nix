{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # nix stuff
      nodePackages.node2nix
      nodePackages.prettier

      # vim
      nodePackages.vim-language-server

      # shell
      shellcheck
      shfmt

      # tags
      universal-ctags
    ];

    programs.go = {
      enable = true;
    };
  };
}
