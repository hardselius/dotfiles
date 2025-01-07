{
  config,
  pkgs,
  lib,
  ...
}: let
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
in {
  programs.alacritty = {
    enable = true;
    settings.window.padding.x = 10;
    settings.window.padding.y = 10;
    settings.window.dynamic_title = true;
    settings.scrolling.history = 10000;
    settings.key_bindings = [
      {
        key = "Q";
        mods = "Control";
        chars = "\\x11";
      }
      {
        key = "N";
        mods = "Command";
        action = "SpawnNewInstance";
      }
    ];
    settings.colors = jellybeans;
    settings.font = {
      normal.family = "${fontFamily}";
      bold.family = "${fontFamily}";
      italic.family = "${fontFamily}";
      bold_italic.family = "${fontFamily}";
      size = 13.0;
    };
    settings.shell.program = "${pkgs.zsh}/bin/zsh";
  };

  programs.wezterm = {
    enable = pkgs.system != "x86_64-darwin";
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm'

      function scheme_for_appearance(appearance)
        if appearance:find 'Dark' then
          return 'Rosé Pine (Gogh)'
        else
          return 'Rosé Pine Dawn (Gogh)'
        end
      end

      wezterm.on('window-config-reloaded', function(window, pane)
        local overrides = window:get_config_overrides() or {}
        local appearance = window:get_appearance()
        local scheme = scheme_for_appearance(appearance)
        if overrides.color_scheme ~= scheme then
          overrides.color_scheme = scheme
          window:set_config_overrides(overrides)
        end
      end)

      return {
        font = wezterm.font("Hack"),
        enable_scroll_bar = true,
      }
    '';
  };
}
