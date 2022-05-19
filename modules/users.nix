{ lib, ... }:

let
  inherit (lib) mkOption types;
in

{
  options.users.primaryUser = {
    username = mkOption {
      type = with types; nullOr string;
      default = null;
    };
    fullName = mkOption {
      type = with types; nullOr string;
      default = null;
    };
    email = mkOption {
      type = with types; nullOr string;
      default = null;
    };
    github = mkOption {
      type = with types; nullOr string;
      default = null;
    };
    masterKey = mkOption {
      type = with types; nullOr string;
      default = null;
    };
    gpgsign = mkOption {
      type = with types; bool;
      default = false;
    };
  };
}
