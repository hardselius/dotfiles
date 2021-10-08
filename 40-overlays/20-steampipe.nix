self: super: {
  steampipe = with super; buildGoModule rec {
    pname = "steampipe";
    version = "0.8.5";

    src = fetchFromGitHub {
      owner = "turbot";
      repo = "steampipe";
      rev = "v${version}";
      sha256 = "sha256-3vetSUJwCeaBzKj+635siskfcDPs/kkgCH954cg/REA=";
    };

    vendorSha256 = "sha256-TGDFNHWWbEy1cD7b2yPqAN7rRrLvL0ZX/R3BWGRWjjw=";

    doCheck = false;

    ldflags = [
      "-s"
      "-w"
    ];

    postInstall = ''
      ln -s $out/bin/steampipe $out/bin/go-task
    '';

    meta = with lib; {
      homepage = "https://steampipe.io/";
      description = "select * from cloud;";
      license = licenses.asl20;
      maintainers = with maintainers; [ hardselius ];
    };
  };
}

