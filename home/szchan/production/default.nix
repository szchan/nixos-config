{ config, pkgs, ... }:

{
    imports = [
        ./gimp.nix
        ./imv.nix
        ./inkscape.nix
        ./mpv.nix
    ];
}