{config, pkgs, ... }:

{
  imports = [ 
    ./bootloader.nix
    ./kernel.nix
    ./zramSwap.nix
    ./networking.nix
    ./bluetooth.nix
    ./i18n.nix
    ./fonts.nix
    ./nix-ld.nix
    ./flatpak.nix
    ./qemuGuest.nix
  ];
}