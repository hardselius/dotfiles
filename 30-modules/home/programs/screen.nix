{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.screen;
in
{
  options.programs.screen = {
    enable = mkEnableOption "screen - screen manager with VT100/ANSI terminal emulation";

    package = mkOption {
      type = types.package;
      default = pkgs.screen;
      defaultText = "pkgs.screen";
      description = "The screen package to use.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];
  };
}
