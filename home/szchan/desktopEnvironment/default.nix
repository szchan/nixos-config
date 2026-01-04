{ config, pkgs, ... }:

{   
  imports = [
    # ./niri/niri.nix
    # ./shell/dms.nix
    # ./gnome/gnome.nix
    ./dms-niri
  ];
}