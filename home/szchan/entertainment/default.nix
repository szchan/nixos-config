{ config, pkgs, ... }:

{
    imports = [
        ./kazumi.nix
        ./musicfox.nix
        ./mpd.nix
    ];
}