{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    git
    vim
    wget
  ];
}
