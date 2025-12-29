{ config, pkgs, ... }:

{
  imports = [
    ./appimage-run.nix
    ./fcitx5
  ];
}