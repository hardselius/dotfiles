self: super: {
  pure-prompt = super.pure-prompt.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./pure-zsh.patch ];
  });

  jsonnet-language-server = with super; buildGoModule rec {
    pname = "jsonnet-language-server";
    version = "0.7.2";

    src = fetchFromGitHub {
      owner = "grafana";
      repo = "jsonnet-language-server";
      rev = "v${version}";
      sha256 = "sha256-hI8eGfHC7la52nImg6BaBxdl9oD/J9q3F3+xbsHrn30=";
    };

    vendorSha256 = "sha256-UEQogVVlTVnSRSHH2koyYaR9l50Rn3075opieK5Fu7I=";

    meta = with lib; {
      homepage = "https://github.com/grafana/jsonnet-language-server";
      description = "A Language Server Protocol (LSP) server for Jsonnet (https://jsonnet.org)";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ hardselius ];
    };
  };

  wsl2-ssh-pageant = with super; buildGoModule rec {
    name = "wsl-ssh-pageant";
    version = "1.4.0";

    src = fetchFromGitHub {
      owner = "BlackReloaded";
      repo = "wsl2-ssh-pageant";
      rev = "v${version}";
      sha256 = "sha256-nAPza8NSX4K2Z1xH3JH7eqaZkGkmMDPynLASavPfnfM=";
    };

    vendorSha256 = "sha256-YxEoNWbhdkWFTC6k53ZHo0DaRtNUTHhOACi38mpw7+s=";

    ldflags = [ "-H=windowsgui" ];

    GOOS = "windows";

    meta = with lib; {
      homepage = "https://github.com/BlackReloaded/wsl2-ssh-pageant";
      description = "wsl2-ssh-pageant";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ hardselius ];
    };
  };
}
