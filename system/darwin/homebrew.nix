{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  brewEnabled = config.homebrew.enable;
in {
  programs.zsh.shellInit = mkIf brewEnabled ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"

    if type brew &>/dev/null
    then
      fpath+=($(brew --prefix)/share/zsh/site-functions)

      autoload -Uz compinit
      compinit
    fi
  '';

  homebrew.enable = true;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.global.brewfile = true;

  homebrew.taps = [
    "emqx/mqttx"
  ];

  homebrew.brews = [
    "emqx/mqttx/mqttx-cli"
    "picotool"
  ];
}
