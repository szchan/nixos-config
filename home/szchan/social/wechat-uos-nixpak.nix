{ pkgs, inputs, lib, ... }:

let
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  sandboxed-wechat = mkNixPak {
    config = { sloth, ... }: {
      # 使用 nixpkgs 自带的 wechat-uos（稳定、已缓存）
      app.package = pkgs.wechat-uos;
      app.binPath = "bin/wechat-uos";  # 官方包的实际可执行路径

      # Flatpak-like ID，用于桌面集成
      flatpak.appId = "com.tencent.WeChat";

      dbus.enable = true;
      dbus.policies = {
        "org.freedesktop.portal.*" = "talk";       # 文件选择、截屏等
        "org.freedesktop.Notifications" = "talk";
        "ca.desrt.dconf" = "talk";                 # 设置存储
      };

      etc.sslCertificates.enable = true;           # 网络 HTTPS

      gpu.enable = true;
      gpu.provider = "bundle";                     # Electron GPU 加速

      bubblewrap = {
        network = true;

        bind.dev = [
          "/dev/dri"      # GPU
          "/dev/snd"      # 音频（语音通话）
          "/dev/shm"      # 共享内存
          "/dev/video0"   # 摄像头（视频通话，可选删掉如果不用）
        ];

        bind.rw = [
          (sloth.concat' sloth.homeDir "/.local/share/wechat-uos")  # 数据和配置目录
          (sloth.concat' sloth.xdgCacheHome "/wechat-uos")
          (sloth.env "XDG_RUNTIME_DIR")
          "/tmp"
        ];

        bind.ro = [
          (sloth.concat' sloth.homeDir "/Downloads")  # 只读下载文件夹
          "/etc"
        ];

        sockets = {
          wayland = true;
          x11 = false;
          pipewire = true;
        };
      };
    };
  };

in {

  home.packages = [
    sandboxed-wechat.config.env
  ];

  # 复制 .desktop 文件到本地
  home.activation.createWeChatDesktopAlias = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ln -sf ${sandboxed-wechat.config.env}/share/applications/* $HOME/.local/share/applications/ || true
  '';
}