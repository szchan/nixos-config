{config, pkgs, ... }:

{
  imports = [ 
    ./windowing.nix
    ./gnome/gnome.nix
    # ./niri/niri.nix
    ./keymap.nix
    ./print.nix
    ./sound.nix
    ./touchpad.nix
    ./applications.nix
    ./localsend.nix
    ./thunar.nix
  ];
}