{ config, ... }:
let
  templateDir = "git/template";
  binDir = ".local/bin";
  inherit (config.home) user-info;
in

{
  programs.git.extraConfig.init.templateDir = "${config.xdg.configHome}/${templateDir}";

  xdg.configFile."${templateDir}/hooks" = {
    recursive = true;
    source = ./git/hooks;
  };

  home.file = {
    "${binDir}/git-jump" = {
      executable = true;
      source = ./git/addons/git-jump;
    };
  };
}
