{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.awscli;
in
{
  options.programs.awscli = {
    enable = mkEnableOption "awscli - manage your AWS services";

    package = mkOption {
      type = types.package;
      default = pkgs.awscli2;
      defaultText = "pkgs.awscli2";
      description = "The awscli package to use.";
    };

    enableBashIntegration = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable Bash integration.
      '';
    };

    enableZshIntegration = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable Zsh integration.
      '';
    };

    awsVault = {
      enable = mkEnableOption "aws-vault - store and access AWS credentials in dev environments";

      backend = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "keychain";
        description = ''
          Secret backend to use [keychain pass file]
        '';
      };

      prompt = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "terminal";
        description = ''
          Prompt driver to use [kdialog osascript pass terminal ykman zenity]
        '';
      };

      passCmd = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "${pkgs.pass}/bin/pass";
        description = ''
          Name of the pass executable
        '';
      };

      passPrefix = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "";
        description = ''
          Prefix to prepend to the item path stored in pass
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ] ++ optionals cfg.awsVault.enable [
      pkgs.aws-vault
    ];

    home.sessionVariables = mapAttrs (n: v: toString v)
      (filterAttrs (n: v: v != [ ] && v != null) {
        AWS_VAULT_PROMPT = cfg.awsVault.prompt;
        AWS_VAULT_BACKEND = cfg.awsVault.backend;
        AWS_VAULT_PASS_CMD = cfg.awsVault.passCmd;
        AWS_VAULT_PASS_PREFIX = cfg.awsVault.passPrefix;
      });

    programs.bash.initExtra = mkIf cfg.enableBashIntegration ''
      complete -C '${pkgs.awscli}/bin/aws_completer' aws
    '';

    programs.zsh.initExtra = mkIf cfg.enableZshIntegration ''
      complete -C '${pkgs.awscli}/bin/aws_completer' aws
    '';
  };
}
