{ config, pkgs, lib, ... }:
let
  fontFamily = "Hack";
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding.x = 10;
        padding.y = 10;
        dynamic_title = true;
      };
      scrolling = {
        history = 10000;
      };
      font = {
        normal.family = "${fontFamily}";
        bold.family = "${fontFamily}";
        italic.family = "${fontFamily}";
        bold_italic.family = "${fontFamily}";
        size = 13.0;
      };
      key_bindings = [
        {
          key = "Q";
          mods = "Control";
          chars = "\\x11";
        }
      ];
    };
  };
}
