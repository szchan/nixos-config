{config, pkgs, ... }:

{
  imports = [ 
    ./windowing.nix
    # ./displaymanager.nix
    ./greetd
    ./xdg-desktop-portal.nix
    # ./gnome/gnome.nix
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
