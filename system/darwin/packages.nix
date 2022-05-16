{ pkgs, ... }:

{
  programs.bash.enable = true;

  environment.systemPackages = with pkgs; [ ];
}
