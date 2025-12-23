{config, pkgs, ... }:

{
    imports = [ 
        ./windowing.nix
        # ./gnome.nix
        ./keymap.nix
        ./print.nix
        ./sound.nix
        ./touchpad.nix
        ./applications.nix
    ];
}