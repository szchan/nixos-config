{config, pkgs, ... }:

{
    imports = [ ./bootloader.nix
                ./kernel.nix 
                ./networking.nix
                ./i18n.nix
                ./fonts.nix
                ./qemuGuest.nix
    ];
}