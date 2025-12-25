{ config, pkgs, ... }:

{
    imports = [
        ./1password.nix
        ./localsend.nix
        ./qbittorrent.nix
    ];
}