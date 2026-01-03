{config, pkgs, ... }:

{
  imports = [ 
    ./windowing.nix
    ./keymap.nix
    ./print.nix
    ./sound.nix
    ./touchpad.nix
    ./applications.nix
    ./localsend.nix

    # ./gnome/gnome.nix

    # Dank Marterial Shell - Niri
    ./dms-niri
  ];
}
