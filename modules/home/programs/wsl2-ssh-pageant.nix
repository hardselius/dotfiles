{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.wsl2-ssh-pageant;
in
{
  options.programs.wsl2-ssh-pageant = {
    enable = mkEnableOption "wsl2-ssh-pageant";

    package = mkOption {
      type = types.package;
      default = pkgs.wsl2-ssh-pageant;
      defaultText = "pkgs.wsl2-ssh-pageant";
      description = "The wsl2-ssh-pageant package to use.";
    };

    gpg = {
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
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.socat
      cfg.package
    ];

    home.sessionVariables = mapAttrs (n: v: toString v)
      {
        # SSH_AUTH_SOCK = "$HOME/.ssh/agent.sock";
        GPG_AGENT_SOCK = "$HOME/.gnupg/S.gpg-agent";
      };

    programs.bash.initExtra = mkIf cfg.gpg.enableBashIntegration ''
      if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
        rm -rf "$GPG_AGENT_SOCK"
        wsl2_ssh_pageant_bin="${cfg.package}/bin/wsl2-ssh-pageant"
        if test -x "$wsl2_ssh_pageant_bin"; then
          (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent" >/dev/null 2>&1 &)
        else
          echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
        fi
        unset wsl2_ssh_pageant_bin
      fi
    '';

    programs.zsh.initExtra = mkIf cfg.gpg.enableZshIntegration ''
      if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
        rm -rf "$GPG_AGENT_SOCK"
        wsl2_ssh_pageant_bin="${cfg.package}/bin/wsl2-ssh-pageant"
        if test -x "$wsl2_ssh_pageant_bin"; then
          (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent" >/dev/null 2>&1 &)
        else
          echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
        fi
        unset wsl2_ssh_pageant_bin
      fi
    '';
  };
}

