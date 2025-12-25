{ config, pkgs, ... }:

{
    imports = [
        ./nom.nix
        ./hugo.nix
    ];
}