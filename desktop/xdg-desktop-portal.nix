{config, pkgs, ... }:

{
  # 启用portal（远程桌面支持）
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };
  
  # 解决在WM中的portal相关bug
  environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];
}