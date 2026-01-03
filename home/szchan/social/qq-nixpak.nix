{ pkgs, inputs, lib, ... }:

let
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  sandboxed-qq = mkNixPak {
    config = { sloth, ... }: {
      # 使用 nixpkgs 官方 qq 包（稳定、已缓存）
      app.package = pkgs.qq;
      app.binPath = "bin/qq";  # 官方包的实际可执行路径

      # Flatpak-like ID，用于桌面集成
      flatpak.appId = "com.tencent.QQ";

      dbus.enable = true;
      dbus.policies = {
        "org.freedesktop.portal.*" = "talk";       # 文件选择、截屏、通知等
        "org.freedesktop.Notifications" = "talk";
        "ca.desrt.dconf" = "talk";                 # 设置存储
      };

      etc.sslCertificates.enable = true;           # HTTPS 网络

      gpu.enable = true;
      gpu.provider = "bundle";                     # Electron GPU 加速

      bubblewrap = {
        network = true;  # QQ 需要联网

        bind.dev = [
          "/dev/dri"      # GPU 渲染
          "/dev/snd"      # 音频（语音消息、视频通话）
          "/dev/shm"      # 共享内存
          "/dev/video0"   # 摄像头（视频通话，可选）
        ];

        bind.rw = [
          (sloth.concat' sloth.homeDir "/.local/share/QQ")     # QQ 主数据目录（首次运行后会创建）
          (sloth.concat' sloth.homeDir "/.config/QQ")          # 部分配置可能在这里
          (sloth.concat' sloth.xdgCacheHome "/QQ")
          (sloth.env "XDG_RUNTIME_DIR")
          "/tmp"
        ];

        bind.ro = [
          (sloth.concat' sloth.homeDir "/Downloads")  # 文件接收默认目录，只读即可
          "/etc"
        ];

        sockets = {
          wayland = true;
          x11 = false;
          pipewire = true;  # 语音/视频通话音频支持
        };
      };
    };
  };

in {

  home.packages = [
    sandboxed-qq.config.env
  ];

  # 确保启动器里出现 QQ 图标
  # 复制 .desktop 文件到本地
  home.activation.createQQDesktopAlias = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ln -sf ${sandboxed-qq.config.env}/share/applications/* $HOME/.local/share/applications/ || true
  '';
}