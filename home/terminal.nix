{ config, pkgs, lib, ... }:
let
  fontFamily = "Hack";

  # jellybeans
  jellybeans = {
    primary = {
      background = "0x121212";
      foreground = "0xdedede";
    };
    cursor = {
      text = "0xffffff";
      cursor = "0xffa460";
    };
    normal = {
      black = "0x929292";
      red = "0xe27373";
      green = "0x94b979";
      yellow = "0xffba7b";
      blue = "0x97bedc";
      magenta = "0xe1c0fa";
      cyan = "0x00988e";
      white = "0xdedede";
    };
    bright = {
      black = "0xbdbdbd";
      red = "0xffa1a1";
      green = "0xbddeab";
      yellow = "0xffdca0";
      blue = "0xb1d8f6";
      magenta = "0xfbdaff";
      cyan = "0x1ab2a8";
      white = "0xffffff";
    };
  };

  # quiet
  quiet = {
    primary = {
      background = "0x000000";
      foreground = "0xdadada";
    };
    normal = {
      black = "0x000000";
      red = "0xd7005f";
      green = "0x00af5f";
      yellow = "0xd78700";
      blue = "0x0087d7";
      magenta = "0xd787d7";
      cyan = "0x00afaf";
      white = "0xdadada";
    };
    bright = {
      black = "0x707070";
      red = "0xff005f";
      green = "0x00d75f";
      yellow = "0xffaf00";
      blue = "0x5fafff";
      magenta = "0xff87ff";
      cyan = "0x00d7d7";
      white = "0xffffff";
    };
  };

  # slate
  slate = {
    primary = {
      background = "#262626";
      foreground = "#ffffff";
    };
    normal = {
      black = "0x000000";
      red = "0xff0000";
      green = "0x5f8700";
      yellow = "0xffff00";
      blue = "0x87d7ff";
      magenta = "0xd7d787";
      cyan = "0xffd7af";
      white = "0x666666";
    };
    light = {
      black = "0x333333";
      red = "0xffafaf";
      green = "0x00875f";
      yellow = "0xffd700";
      blue = "0x5f87d7";
      magenta = "0xafaf87";
      cyan = "0xff8787";
      white = "0xffffff";
    };
  };
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

    alacritty.settings.colors = jellybeans;

    alacritty.settings.font = {
      normal.family = "${fontFamily}";
      bold.family = "${fontFamily}";
      italic.family = "${fontFamily}";
      bold_italic.family = "${fontFamily}";
      size = 13.0;
    };
  };
}
