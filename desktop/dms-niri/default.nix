{config, pkgs, ...}:

{
  imports = [
    ../polkit-gnome.nix
    ../gnome-keyring.nix
    ../xdg-desktop-portal.nix
    ../thunar.nix
    ./niri
    ./dms
  ];

  environment.systemPackages = with pkgs; [
    accountsservice
    xwayland-satellite
    niriswitcher
    adapta-gtk-theme
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