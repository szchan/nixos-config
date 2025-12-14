{config, pkgs, ... }:

{
    imports = [ ./bootloader.nix
                ./kernel.nix 
    ];
}