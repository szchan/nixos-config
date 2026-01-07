{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  sandboxed-wechat = mkNixPak {
    config =
      { sloth, ... }:
      {
        # 使用 nixpkgs 自带的 wechat-uos（稳定、已缓存）
        app.package = pkgs.wechat-uos;
        app.binPath = "bin/wechat-uos"; # 官方包的实际可执行路径

        # Flatpak-like ID，用于桌面集成
        flatpak.appId = "com.tencent.WeChat";

        dbus.enable = true;
        dbus.policies = {
          "org.freedesktop.portal.*" = "talk"; # 文件选择、截屏等
          "org.freedesktop.Notifications" = "talk";
          "ca.desrt.dconf" = "talk"; # 设置存储
          "org.kde.StatusNotifierWatcher" = "talk"; # 注册系统托盘项
          "org.freedesktop.StatusNotifierHost" = "own"; # 作为 Host 发通知
        };

        etc.sslCertificates.enable = true; # 网络 HTTPS

        gpu.enable = true;
        gpu.provider = "bundle"; # Electron GPU 加速

        bubblewrap = {
          network = true;

          bind.dev = [
            "/dev/dri" # GPU
            "/dev/snd" # 音频（语音通话）
            "/dev/shm" # 共享内存
            "/dev/video0" # 摄像头（视频通话，可选删掉如果不用）
          ];

          bind.rw = with sloth; [
            [
              (mkdir appDataDir)
              xdgDataHome
            ]
            [
              (mkdir appConfigDir)
              xdgConfigHome
            ]
            [
              (mkdir appCacheDir)
              xdgCacheHome
            ]

            (sloth.concat [
              sloth.runtimeDir
              "/"
              (sloth.envOr "WAYLAND_DISPLAY" "no")
            ])
            (sloth.concat' sloth.runtimeDir "/at-spi/bus")
            (sloth.concat' sloth.runtimeDir "/gvfsd")
            (sloth.concat' sloth.runtimeDir "/dconf")

            (sloth.concat' sloth.xdgCacheHome "/fontconfig")
            (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache")
            (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache_db")
            (sloth.concat' sloth.xdgCacheHome "/radv_builtin_shaders")
          ];

          bind.ro = [
            (sloth.concat' sloth.runtimeDir "/doc")
            (sloth.concat' sloth.xdgConfigHome "/kdeglobals")
            (sloth.concat' sloth.xdgConfigHome "/gtk-2.0")
            (sloth.concat' sloth.xdgConfigHome "/gtk-3.0")
            (sloth.concat' sloth.xdgConfigHome "/gtk-4.0")
            (sloth.concat' sloth.xdgConfigHome "/fontconfig")
            (sloth.concat' sloth.xdgConfigHome "/dconf")

            # Use system font settings instead
            "/etc/fonts"
            "/etc/localtime"

            # Fix: libEGL warning: egl: failed to create dri2 screen
            "/etc/egl"
            "/etc/static/egl"
          ];

          sockets = {
            wayland = true;
            x11 = false;
            pipewire = true;
          };
        };
      };
  };

in
{

  home.packages = [
    sandboxed-wechat.config.env
  ];

  # 复制 .desktop 文件到本地
  home.activation.createWeChatDesktopAlias = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sf ${sandboxed-wechat.config.env}/share/applications/* $HOME/.local/share/applications/ || true
  '';
}
