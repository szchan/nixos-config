{ config, pkgs, inputs, ... }:

{

  imports = [
    inputs.niri-flake.homeModules.niri
    ../shell/dms.nix
  ];

  # 添加 overlay，让 pkgs 有 niri-unstable 等包
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
  ];
  
  programs.niri = {
    enable = true;

    # 推荐使用 unstable 版本（与当前 nixpkgs 的 mesa 等依赖匹配，避免黑屏）
    package = pkgs.niri-unstable;  # 如果想用 stable，改成 pkgs.niri-stable

  };

  home.packages = with pkgs; [
    xwayland-satellite
  ];

  # 显式启用dbus
  # services.dbus.enable = true;

  # 启用portal（远程桌面支持）
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  systemd.user.services.niri-flake-polkit = {
		# enable = false;  # 或直接 lib.mkForce false;
    lib.mkForce = false;
	};

}