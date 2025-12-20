{config, pkgs, ... }:

{
    imports = [ 
        ./windowing.nix
        ./de.nix
        ./keymap.nix
        ./print.nix
        ./sound.nix
        ./touchpad.nix
        ./applications.nix
    ];
}