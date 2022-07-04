final: prev: {
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
