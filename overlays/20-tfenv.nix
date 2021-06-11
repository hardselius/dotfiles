self: super: {

  tfenv = with super; stdenv.mkDerivation rec {
    name = "tfenv-${version}";
    version = "2.2.2";

    src = fetchFromGitHub {
      owner = "tfutils";
      repo = "tfenv";
      rev = "v${version}";
      sha256 = "ZjHrxbb5JqIQNNnXtcunbhWjt8hlYh3FF/JKYPurZc4=";
    };

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp -p bin/* $out/bin

      mkdir -p $out/lib
      cp -p lib/* $out/lib
      
      mkdir -p $out/libexec
      cp -p libexec/* $out/libexec

      mkdir -p $out/share
      cp -p share/* $out/share
    '';

    meta = with super.lib; {
      description = "Terraform version manager inspired by rbenv";
      homepage = "https://github.com/tfutils/tfenv";
      licence = licences.mit;
      maintainers = with maintainers; [ hardselius ];
      platforms = platforms.all;
    };
  };
}
