{ config, pkgs, lib, ... }:
let
  inherit (config.home) user-info;
in

{
  programs.gpg.enable = true;
  programs.gpg.settings = {
  } // lib.optionalAttrs (!builtins.isNull user-info.masterKey) {
    default-key = user-info.masterKey;
    auto-key-locate = "keyserver";
    keyserver = "pgp.mit.edu";
    keyserver-options = "no-honor-keyserver-url include-revoked auto-key-retrieve";
  };
  programs.gpg.scdaemonSettings = {
    disable-ccid = true;
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    reader-port = ''"Yubico YubiKey OTP+FIDO+CCID"'';
  };
}
