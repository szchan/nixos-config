{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.kimpanel
    gnomeExtensions.appindicator
    gnome-tweaks
  ];
}
