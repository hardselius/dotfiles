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
      colors = {
        primary = {
          background = "0x2d2d2d";
          foreground = "0xd3d0c8";
        };
        cursor = {
          text = "0x2d2d2d";
          cursor = "0xd3d0c8";
        };
        normal = {
          black = "0x2d2d2d";
          red = "0xf2777a";
          green = "0x99cc99";
          yellow = "0xffcc66";
          blue = "0x6699cc";
          magenta = "0xcc99cc";
          cyan = "0x66cccc";
          white = "0xd3d0c8";
        };
        bright = {
          black = "0x747369";
          red = "0xf99157";
          green = "0x393939";
          yellow = "0x515151";
          blue = "0xa09f93";
          magenta = "0xe8e6df";
          cyan = "0xd27b53";
          white = "0xf2f0ec";
        };
      };
    };
  };
}
