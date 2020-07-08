{ pkgs }:

{
  enable = true;
  skhdConfig = ''
    # focus window
    alt - h : yabai -m window --focus west
    alt - j : yabai -m window --focus south
    alt - k : yabai -m window --focus north
    alt - l : yabai -m window --focus east

    # swap managed window
    shift + alt - h : yabai -m window --swap west
    shift + alt - j : yabai -m window --swap south
    shift + alt - k : yabai -m window --swap north
    shift + alt - l : yabai -m window --swap east

    # move managed window
    ctrl + alt - h : yabai -m window --warp west
    ctrl + alt - j : yabai -m window --warp south
    ctrl + alt - k : yabai -m window --warp north
    ctrl + alt - l : yabai -m window --warp east

    # make floating window fill screen
    ctrl + alt - up : yabai -m window --grid 1:1:0:0:1:1

    # make floating window fill half of screen
    ctrl + alt - left  : yabai -m window --grid 1:2:0:0:1:1
    ctrl + alt - right : yabai -m window --grid 1:2:1:0:1:1

    # focus monitor
    alt - 1 : yabai -m display --focus 1
    alt - 2 : yabai -m display --focus 2
    alt - 3 : yabai -m display --focus 3

    # send window to monitor and follow focus
    shift + alt - 1 : yabai -m window --display 1; yabai -m display --focus 1
    shift + alt - 2 : yabai -m window --display 2; yabai -m display --focus 2
    shift + alt - 3 : yabai -m window --display 3; yabai -m display --focus 3

    # send window to desktop
    ctrl + alt - 1 : yabai -m window --space 1
    ctrl + alt - 2 : yabai -m window --space 2
    ctrl + alt - 3 : yabai -m window --space 3

    # balance size of windows
    shift + alt - 0 : yabai -m space --balance

    # move floating window
    # shift + ctrl - a : yabai -m window --move rel:-20:0
    # shift + ctrl - s : yabai -m window --move rel:0:20

    # increase window size
    # shift + alt - a : yabai -m window --resize left:-20:0
    # shift + alt - w : yabai -m window --resize top:0:-20

    # decrease window size
    # shift + cmd - s : yabai -m window --resize bottom:0:-20
    # shift + cmd - w : yabai -m window --resize top:0:20

    # change split ratio
    ctrl + alt - z : yabai -m config split_ratio 0.66
    ctrl + alt - x : yabai -m config split_ratio 0.50

    # toggle window zoom
    alt + shift - d : yabai -m window --toggle zoom-parent
    alt + shift - f : yabai -m window --toggle zoom-fullscreen

    # float / unfloat window and center on screen
    alt + shift - t : yabai -m window --toggle float;\
                      yabai -m window --grid 4:4:1:1:2:2

    # toggle sticky(+float), topmost, border and picture-in-picture
    alt + shift - p : yabai -m window --toggle sticky;\
                      yabai -m window --toggle topmost;\
                      yabai -m window --toggle border;\
                      yabai -m window --toggle pip

    # quit/reload services
    ctrl + alt - q : pkill skhd;\
                    pkill yabai
  '';
}