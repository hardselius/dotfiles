{ config, pkgs, lib, ... }:
let
  fontFamily = "Hack";
in
{
  programs = {
    alacritty.enable = true;
    alacritty.settings.window = {
      padding.x = 10;
      padding.y = 10;
      dynamic_title = true;
    };
    alacritty.settings.scrolling.history = 10000;
    alacritty.settings.key_bindings = [
      {
        key = "Q";
        mods = "Control";
        chars = "\\x11";
      }
    ] ++ lib.optionals pkgs.stdenv.isDarwin [
      # macOS tabs
      # System Preferences > General > Prefer tabs: always
      # must be set in order for this to work.
      {
        key = "T";
        mods = "Command";
        action = "CreateNewWindow";
      }
    ];
    alacritty.settings.font = {
      normal.family = "${fontFamily}";
      bold.family = "${fontFamily}";
      italic.family = "${fontFamily}";
      bold_italic.family = "${fontFamily}";
      size = 13.0;
    };
  };
}
