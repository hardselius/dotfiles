{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.home) user-info;
in {
  programs.gpg.enable = user-info.gpg.enable;
  programs.gpg.settings =
    {
    }
    // lib.optionalAttrs (!builtins.isNull user-info.gpg.masterKey) {
      default-key = user-info.gpg.masterKey;
      auto-key-locate = "keyserver";
      keyserver = "pgp.mit.edu";
      keyserver-options = "no-honor-keyserver-url include-revoked auto-key-retrieve";

      # Use AES256, 192, or 128 as cipher
      personal-cipher-preferences = "AES256 AES192 AES";
      # Use SHA512, 384, or 256 as digest
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      # Use ZLIB, BZIP2, ZIP, or no compression
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      # Default preferences for new keys
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      # SHA512 as digest to sign keys
      cert-digest-algo = "SHA512";
      # SHA512 as digest for symmetric ops
      s2k-digest-algo = "SHA512";
      # AES256 as cipher for symmetric ops
      s2k-cipher-algo = "AES256";
      # UTF-8 support for compatibility
      charset = "utf-8";
      # Show Unix timestamps
      fixed-list-mode = true;
      # No comments in signature
      no-comments = true;
      # No version in output
      no-emit-version = true;
      # Disable banner
      no-greeting = true;
      # Long hexidecimal key format
      keyid-format = "0xlong";
      # Display UID validity
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      # Display all keys and their fingerprints
      with-fingerprint = true;
      # Cross-certify subkeys are present and valid
      require-cross-certification = true;
      # Disable caching of passphrase for symmetrical ops
      no-symkey-cache = true;
      # Enable smartcard
      use-agent = true;
      # Disable recipient key ID in messages
      throw-keyids = true;
    };
  programs.gpg.scdaemonSettings =
    {
      disable-ccid = true;
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      reader-port = ''"Yubico YubiKey OTP+FIDO+CCID"'';
    };
}
