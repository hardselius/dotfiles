{ config, pkgs, lib, ... }:
let
  inherit (config.home) homeDirectory;
in

{
  home.file = { } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    ".gnupg/scdaemon.conf" = {
      text = ''
        disable-ccid
        reader-port "Yubico YubiKey OTP+FIDO+CCID"
      '';
      # In case the ~/.gnupg folder did not already exist and gets created by
      # this option, we must make sure it's permissions are correctly set.
      onChange = ''
        find ${homeDirectory}/.gnupg -type d -exec chmod 700 {} \;
      '';
    };
  };

  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
    dataHome = "${homeDirectory}/.local/share";
    cacheHome = "${homeDirectory}/.cache";
  };
}
