{ config, pkgs, ... }:

{
    # 启用 Niri
    programs.niri.enable = true;

    
    # 一些基本工具（否则刚启动 Niri 时可能无法打开应用）
    environment.systemPackages = with pkgs; [
        alacritty  # 终端
        fuzzel     # 应用启动器（类似 rofi）
        # waybar     # 状态栏（可选）
        # swayidle   # 闲置管理
        # swaylock   # 锁屏
        xdg-desktop-portal-gnome  # 屏幕共享等 portal 支持
    ];

    # 启用一些配套服务
    services.dbus.enable = true;
    xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };

    # display manager
    services.displayManager.dms-greeter = {
        enable = true;
        package = pkgs.dms-greeter;
        quickshell.package = pkgs.quickshell;
        logs = {
            save = true;
            path = "/var/log/dms-greeter.log";
        };
        compositor.name = "niri";

    };

    # Desktop Shell
    programs.dms-shell = {
        enable = true;
        package = pkgs.dms-shell;
        systemd = {
            enable = true;
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
    }

}