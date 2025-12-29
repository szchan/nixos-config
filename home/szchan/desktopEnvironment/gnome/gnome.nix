{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.kimpanel
  ];
}