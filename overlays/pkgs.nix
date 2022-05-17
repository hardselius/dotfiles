final: prev: {
  pure-prompt = prev.pure-prompt.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./pure-zsh.patch ];
  });

  steampipe = with prev; buildGoModule rec {
    pname = "steampipe";
    version = "0.11.0";

    src = fetchFromGitHub {
      owner = "turbot";
      repo = "steampipe";
      rev = "v${version}";
      sha256 = "sha256-P/Fys9/V71+VL5Az3EGGaW+tdeQbr2wO+jvVSVZmJT0=";
    };

    vendorSha256 = "sha256-PYaq74NNEOJ1jZ6PoS6zcTiUN4JA9JDjO7GB9tqgT6c=";

    doCheck = false;

    nativeBuildInputs = [ installShellFiles ];

    ldflags = [
      "-s"
      "-w"
    ];

    postInstall = ''
      INSTALL_DIR=$(mktemp -d)
      installShellCompletion --cmd steampipe \
        --bash <($out/bin/steampipe --install-dir $INSTALL_DIR completion bash) \
        --fish <($out/bin/steampipe --install-dir $INSTALL_DIR completion fish) \
        --zsh <($out/bin/steampipe --install-dir $INSTALL_DIR completion zsh)
    '';

    meta = with lib; {
      homepage = "https://steampipe.io/";
      description = "select * from cloud;";
      license = licenses.agpl3;
      maintainers = with maintainers; [ hardselius ];
    };
  };

  atlantis = with prev; buildGoModule rec {
    pname = "atlantis";
    version = "0.17.4";

    src = fetchFromGitHub {
      owner = "runatlantis";
      repo = "atlantis";
      rev = "v${version}";
      sha256 = "sha256-QXFUvYUslhwQOiDo9SIMrTjI1sKUv5+6oiVfQbqewNg=";
    };

    vendorSha256 = "sha256-jZ5QHxUTDVdhCNbCk6Be+zuuXHodYOEcB3braDgH9uM=";

    doCheck = false;

    subPackages = [ "." ];

    meta = with lib; {
      homepage = "https://github.com/runatlantis/atlantis";
      description = "Terraform Pull Request Automation";
      license = licenses.asl20;
      maintainers = with maintainers; [ jpotier ];
    };
  };

  jsonnet-language-server = with prev; buildGoModule rec {
    pname = "jsonnet-language-server";
    version = "0.6.3";

    src = fetchFromGitHub {
      owner = "grafana";
      repo = "jsonnet-language-server";
      rev = "v${version}";
      sha256 = "sha256-nJlw3RiZWdLmJdrfKlty0Fnn+g+UwkCNNBxVQMp8erI=";
    };

    vendorSha256 = "sha256-mGocX5z3wf9KRhE9leLNCzn8sVdjKJo6FzgP1OwQB3M=";

    meta = with lib; {
      homepage = "https://github.com/grafana/jsonnet-language-server";
      description = "A Language Server Protocol (LSP) server for Jsonnet (https://jsonnet.org)";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ hardselius ];
    };
  };

  wsl2-ssh-pageant = with prev; buildGoModule rec {
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
