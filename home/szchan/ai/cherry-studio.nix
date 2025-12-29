{ config, pkgs, ... }:

{
  home.packages = with pkgs;[
    cherry-studio
  ];
}