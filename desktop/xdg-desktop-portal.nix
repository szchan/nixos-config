{config, pkgs, ... }:

{
  # 解决在WM中的portal相关bug
  environment.pathsToLink = [ `/share/applications` `/share/xdg-desktop-portal` ];
}