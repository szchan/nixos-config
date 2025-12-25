{config, pkgs, ... }:

{
    imports = [ ./bootloader.nix
                ./kernel.nix 
                ./networking.nix
                ./bluetooth.nix
                ./i18n.nix
                ./fonts.nix
                ./qemuGuest.nix
    ];
}