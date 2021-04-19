{ pkgs, ... }:
{
  home.packages = with pkgs; [
    newsboat
  ];

  xdg = {
    configFile."newsboat/urls".text = ''
      https://cprss.s3.amazonaws.com/golangweekly.com.xml
      https://fasterthanli.me/index.xml "Blog" "Programming" "Rust" "Go"
      https://this-week-in-rust.org/atom.xml
      https://vimtricks.com/atom
      https://weekly.nixos.org/feeds/all.rss.xml
    '';

    configFile."newsboat/config".text = ''
      unbind-key h
      unbind-key j
      unbind-key k
      unbind-key l

      bind-key h quit
      bind-key j down
      bind-key k up
      bind-key l open

      unbind-key g # bound to `sort` by default
      bind-key g home
      unbind-key G # bound to `rev-sort` by default
      bind-key G end
    '';
  };
}
