{ config, pkgs, ... }:

{
    # 启用 Niri
    programs.niri.enable = true;

    
    # 推荐安装一些基本工具（否则刚启动 Niri 时可能无法打开应用）
    environment.systemPackages = with pkgs; [
        alacritty  # 终端
        fuzzel     # 应用启动器（类似 rofi）
        waybar     # 状态栏（可选）
        swayidle   # 闲置管理
        swaylock   # 锁屏
        xdg-desktop-portal-gnome  # 屏幕共享等 portal 支持
    ];

    # （可选）启用一些配套服务
    services.dbus.enable = true;
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];

    # 如果使用 display manager（如 GDM、SDDM），Niri 会自动出现在登录选项中
    services.displayManager.dms-greeter.compositor.name = "niri";  # 或 services.gnome.gnome-desktop.enable 等
}