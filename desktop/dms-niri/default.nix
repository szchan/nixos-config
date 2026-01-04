{config, pkgs, ...}:

{
  imports = [
    ../polkit-gnome.nix
    ../gnome-keyring.nix
    ../xdg-desktop-portal.nix
    # ../thunar.nix
    ../nautilus.nix
    ./niri
    ./dms
  ];

  environment.systemPackages = with pkgs; [
    accountsservice
    xwayland-satellite
    niriswitcher
    adw-gtk3
    kdePackages.qt6ct
    # dgop
    # dsearch
    # matugen
    i2c-tools
    wl-clipboard
    # cliphist
    # cava
    kitty  # 终端
  ];
}