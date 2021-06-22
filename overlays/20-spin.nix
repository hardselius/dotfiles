self: super: {
  spin-cli = with super; buildGoModule rec {
    pname = "spin-cli";
    version = "1.22.0";

    src = fetchFromGitHub {
      owner = "spinnaker";
      repo = "spin";
      rev = "v${version}";
      sha256 = "sha256-CmT+qEKESLls7GN1u3N9gP7IuCZ5x6P/Oc4O2ExmQHk=";
    };

    vendorSha256 = "sha256-tehTguY/PqgmmAqMDH/w6oG2jvC/pXqf+/Ix/YNMsF0=";

    doCheck = false;

    buildFlagsArray = [
      "-ldflags=-s -w"
      "-X github.com/spinnaker/spin/version.Version=${version}"
      "-X github.com/spinnaker/spin/version.ReleasePhase="
    ];

    postInstall = ''
      ln -s $out/bin/spin $out/bin/go-task
    '';

    meta = with lib; {
      homepage = "https://github.com/spinnaker/spin";
      description = "Spinnaker CLI Edit pipelines, applications & intents.";
      license = licenses.asl20;
      maintainers = with maintainers; [ hardselius ];
    };
  };
}
