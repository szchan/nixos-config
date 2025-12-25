{ config, pkgs, ... }:

{
    imports = [
        ./yazi.nix
        ./evince.nix
        ./drawio.nix
    ];
}