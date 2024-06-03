{ config, ... }:
let
  inherit (config.home) homeDirectory;
in

{
  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
    dataHome = "${homeDirectory}/.local/share";
    cacheHome = "${homeDirectory}/.cache";
  };
}
