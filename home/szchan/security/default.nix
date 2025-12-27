{ config, pkgs, ... }:

{
    imports = [
        ./gpg.nix
        ./1password.nix
    ];
}