{ pkgs }:

{
  enable = true;
  package = pkgs.yabai;
  config = {
    mouse_follows_focus = "on";
    focus_follows_mouse = "on";
    window_placement = "second_child";
    window_topmost = "off";
    window_opacity = "off";
    window_opacity_duration = 0.0;
    window_shadow = "on";
    window_border = "off";
    window_border_placement = "inset";
    window_border_width = "4";
    window_border_radius = -1.0;
    active_window_border_topmost = "off";
    active_window_border_color = "0xff775759";
    normal_window_border_color = "0xff505050";
    insert_window_border_color = "0xffd75f5f";
    active_window_opacity = 1.0;
    normal_window_opacity = 0.9;
    split_ratio = 0.66;
    auto_balance = "off";
    mouse_modifier = "fn";
    mouse_action1 = "move";
    mouse_action2 = "resize";
    layout = "bsp";
    top_padding = 32;
    bottom_padding = 10;
    left_padding = 10;
    right_padding = 10;
    window_gap = 10;
  };

  extraConfig = ''
    yabai -m config --space 3 layout float

    # rules
    yabai -m rule --add app='Airmail' manage=off
    yabai -m rule --add app='Dash' manage=off
    yabai -m rule --add app='Mail' manage=off
    yabai -m rule --add app='Messages' manage=off
    yabai -m rule --add app='Music' manage=off
    yabai -m rule --add app='System Preferences' manage=off
    yabai -m rule --add app='Station' manage=off

    echo "yabai configuration loaded.."
  '';
}

