{ config, pkgs, ... }:

{
  imports = [
    ./browser.nix
    ./localsend.nix
    ./qbittorrent.nix
  ];
}