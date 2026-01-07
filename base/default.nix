{ ... }:

{
  imports = [
    ./bootloader.nix
    ./kernel.nix
    ./zramSwap.nix
    ./networking.nix
    ./nvidia.nix
    ./bluetooth.nix
    # ./kmscon.nix
    ./i18n.nix
    ./fonts.nix
    ./nix-ld.nix
    ./flatpak.nix
  ];
}
