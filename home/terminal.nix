{ config, pkgs, lib, ... }:
let
  fontFamily = "Hack";
in
{
  programs = {
    alacritty.enable = true;
    alacritty.settings.window.padding.x = 10;
    alacritty.settings.window.padding.y = 10;
    alacritty.settings.window.dynamic_title = true;
    alacritty.settings.scrolling.history = 10000;
    alacritty.settings.key_bindings = [
      {
        key = "Q";
        mods = "Control";
        chars = "\\x11";
      }
    ];
    alacritty.settings.colors.primary = {
      background = "#262626";
      foreground = "#ffffff";
    };
    alacritty.settings.colors.normal = {
      black = "0x000000";
      red = "0xff0000";
      green = "0x5f8700";
      yellow = "0xffff00";
      blue = "0x87d7ff";
      magenta = "0xd7d787";
      cyan = "0xffd7af";
      white = "0x666666";
    };
    alacritty.settings.colors.light = {
      black = "0x333333";
      red = "0xffafaf";
      green = "0x00875f";
      yellow = "0xffd700";
      blue = "0x5f87d7";
      magenta = "0xafaf87";
      cyan = "0xff8787";
      white = "0xffffff";
    };
    alacritty.settings.font = {
      normal.family = "${fontFamily}";
      bold.family = "${fontFamily}";
      italic.family = "${fontFamily}";
      bold_italic.family = "${fontFamily}";
      size = 13.0;
    };
  };
}
