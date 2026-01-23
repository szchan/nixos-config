{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btrfs-assistant
  ];
}