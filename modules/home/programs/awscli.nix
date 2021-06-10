{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.awscli;
in
{
  options.programs.awscli = {
    enable = mkEnableOption "AWS";

    enableAWSVault = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to enable aws vault.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.awscli2;
      defaultText = "pkgs.awscli2";
      description = "The awscli package to use.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ] ++ optionals cfg.enableAWSVault [
      pkgs.aws-vault
    ];
  };
}
