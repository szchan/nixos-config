{ config, pkgs, ... }:

{

  imports = [
    # 使用gnome-polkit提供权限
    ../polkit-gnome.nix
    ../displaymanager.nix
    ../xdg-desktop-portal.nix
    ../thunar.nix
  ];

  # 启用 Niri
  programs.niri = {
    enable = true;
    useNautilus = true;
  };

    
  # dms Niri 依赖
  environment.systemPackages = with pkgs; [
    accountsservice
    xwayland-satellite
    adapta-gtk-theme
    kdePackages.qt6ct
    # dgop
    # dsearch
    # matugen
    # i2c-tools
    # wl-clipboard
    # cliphist
    # cava
    kitty  # 终端
    # quickshell     # 状态栏
    # xdg-desktop-portal-gnome  # 屏幕共享等 portal 支持
    # xdg-desktop-portal-gtk
  ];

  # 显式启用dbus
  # services.dbus.enable = true;

  # 启用portal（远程桌面支持）
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Greeter
  services.displayManager.dms-greeter = {
    enable = true;
    # package = pkgs.dms-greeter;
    quickshell.package = pkgs.quickshell;
    logs = {
      save = true;
      path = "/tmp/dms-greeter.log";
    };
    compositor.name = "niri";

    configHome = "/home/szchan";
    configFiles = [
      "/home/szchan/.config/DankMaterialShell/settings.json"
      "/home/szchan/.local/state/DankMaterialShell/session.json"
    ];

  };

  # Desktop Shell
  programs.dms-shell = {
    enable = true;
    package = pkgs.dms-shell;
    systemd = {
      # enable = true;
      target = "graphical-session.target";
      restartIfChanged = true;
    };
    quickshell.package = pkgs.quickshell;
    enableVPN = true;
    enableSystemMonitoring = true;
    enableDynamicTheming = true;
    enableClipboard = true;
    enableCalendarEvents = true;
    enableAudioWavelength = true;
  };

  # dsearch
  programs.dsearch = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };

}