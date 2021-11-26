{ config, pkgs, ... }:
let
  name = "Martin Hardselius";
  email = "martin@hardselius.dev";
  home_directory = "${config.home.homeDirectory}";

  tomlFormat = pkgs.formats.toml { };
in
{
  home.packages = with pkgs; [
    himalaya
  ];

  programs = {
    git = {
      userName = "${name}";
      userEmail = "${email}";
      signing = {
        key = "${email}";
        signByDefault = true;
      };
      extraConfig = {
        github.user = "hardselius";
      };
    };
  };

  xdg.configFile."himalaya/config.toml" = {
    source = tomlFormat.generate "himalaya-config" {
      name = "${name}";
      downloads-dir = "${home_directory}/Downloads";
      signature = ''
        --
        ${name}
      '';
      fastmail = {
        default = true;
        email = "${email}";
        imap-host = "imap.fastmail.com";
        imap-port = 993;
        imap-login = "${email}";
        imap-passwd-cmd = "${pkgs.pass}/bin/pass show email/imap.fastmail.com";
        smtp-host = "smtp.fastmail.com";
        smtp-port = 587;
        smtp-starttls = true;
        smtp-login = "${email}";
        smtp-passwd-cmd = "${pkgs.pass}/bin/pass show email/smtp.fastmail.com";
      };
    };
  };
}
