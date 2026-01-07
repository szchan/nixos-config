{ pkgs, ... }:

{
  gtk = {
    enable = true;

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark"; # 包内的主题名称（Papirus 有 Papirus、Papirus-Dark 等变体）
    };
  };

  qt = {
    enable = true;
    qt6ctSettings = {
      Appearance = {
        style = "kvantum";
        icon_theme = "Papirus-Dark";
        standar_dialogs = "xdgdesktopportal";
      };
    };
    qt5ctSettings = {
      Appearance = {
        style = "kvantum";
        icon_theme = "Papirus-Dark";
        standar_dialogs = "xdgdesktopportal";
      };
    };
  };
  home.packages = with pkgs; [
    papirus-icon-theme
    kdePackages.qt6ct
  ];
}
