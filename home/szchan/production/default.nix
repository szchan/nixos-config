{ config, pkgs, ... }:

{
    imports = [
        ./gimp.nix
        ./imv.nix
    ];
}