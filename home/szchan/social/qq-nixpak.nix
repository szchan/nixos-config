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

  sandboxed-qq = mkNixPak {
    config =
      { sloth, ... }:
      {
        # 使用 nixpkgs 官方 qq 包（稳定、已缓存）
        app.package = pkgs.qq;
        app.binPath = "bin/qq"; # 官方包的实际可执行路径

        # Flatpak-like ID，用于桌面集成
        flatpak.appId = "com.tencent.QQ";

        dbus.enable = true;
        dbus.policies = {
          "org.freedesktop.portal.*" = "talk"; # 文件选择、截屏、通知等
          "org.freedesktop.Notifications" = "talk";
          "ca.desrt.dconf" = "talk"; # 设置存储
          "org.kde.StatusNotifierWatcher" = "talk"; # 注册系统托盘项
          "org.freedesktop.StatusNotifierHost" = "own"; # 作为 Host 发通知
        };

        etc.sslCertificates.enable = true; # HTTPS 网络

        gpu.enable = true;
        gpu.provider = "bundle"; # Electron GPU 加速

        bubblewrap = {
          network = true; # QQ 需要联网
          env = {
            QQ_FIX_MAC = "1"; # 强制启用固定 MAC 模式
          };

          bind.dev = [
            "/dev/dri" # GPU 渲染
            "/dev/snd" # 音频（语音消息、视频通话）
            "/dev/shm" # 共享内存
            "/dev/video0" # 摄像头（视频通话，可选）
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

            (sloth.env "XDG_RUNTIME_DIR")
            "/tmp/QQ"
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
            pipewire = true; # 语音/视频通话音频支持
          };
        };
      };
  };

in
{

  home.packages = [
    sandboxed-qq.config.env
  ];

  # 确保启动器里出现 QQ 图标
  # 复制 .desktop 文件到本地
  home.activation.createQQDesktopAlias = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sf ${sandboxed-qq.config.env}/share/applications/* $HOME/.local/share/applications/ || true
    mkdir -p /tmp/QQ
  '';
}
