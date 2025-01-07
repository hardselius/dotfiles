{pkgs, ...}: {
  environment.systemPackages = with pkgs;
    [
      alacritty
      git
      vim
      wget
    ]
    ++ lib.optionals (pkgs.system != "x86_64-darwin") [
      wezterm
    ];
}
