final: prev: {
  jsonnet-language-server = with prev;
    buildGoModule rec {
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
        maintainers = with maintainers; [hardselius];
      };
    };
}
