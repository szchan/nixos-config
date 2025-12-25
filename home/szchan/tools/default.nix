{ config, pkgs, ... }:

{
    imports = [
        ./1password.nix
        ./localsend.nix
    ];
}