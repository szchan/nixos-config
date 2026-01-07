{ ... }:

{
  # 显式配置使用Wayland
  services.xserver.enable = true;

  # 解决使用WM时 解决fcitx5无法启动
  services.xserver.desktopManager.runXdgAutostartIfNone = true;
}
