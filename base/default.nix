{ ... }:

{
  imports = [
    ./bootloader.nix
    ./kernel.nix
    ./storage.nix
    ./zramSwap.nix
    ./networking.nix
    ./bluetooth.nix
    # ./kmscon.nix
    ./i18n.nix
    ./fonts.nix
    ./nix-ld.nix
    ./flatpak.nix
  ];
}
