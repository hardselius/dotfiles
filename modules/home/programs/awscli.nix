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

      prompt = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "terminal";
        description = ''
          Prompt driver to use [kdialog osascript pass terminal ykman zenity]
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
      });

    programs.bash.initExtra = mkIf cfg.enableBashIntegration ''
      complete -C '${pkgs.awscli}/bin/aws_completer' aws
    '';

    programs.zsh.initExtra = mkIf cfg.enableZshIntegration ''
      complete -C '${pkgs.awscli}/bin/aws_completer' aws
    '';
  };
}
