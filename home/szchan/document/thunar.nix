{ config, pkgs, ... }:

{
    home.packages = with pkgs;[
        xfce.thunar
        xfce.thunar-vcs-plugin
        xfce.thunar-archive-plugin
    ];
}