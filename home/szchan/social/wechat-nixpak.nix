{ pkgs, inputs, lib, ... }:

let
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  sandboxed-wechat = mkNixPak {
    config = { sloth, pkgs, ... }: {
      # 应用包和二进制路径
      app.package = pkgs.wechat;  # 现在直接用 pkgs.wechat
      app.binPath = "opt/wechat/wechat";  # 典型路径，根据包实际检查（e.g., nix-shell -p wechat --run "ls $out/opt/wechat/"）

      # Flatpak-like ID，用于集成
      flatpak.appId = "com.tencent.WeChat";

      # DBus 支持
      dbus.enable = true;
      dbus.policies = {
        "org.freedesktop.portal.*" = "talk";  # portal 支持（如文件选择）
        "org.freedesktop.Notifications" = "talk";
        "ca.desrt.dconf" = "talk";
        "org.a11y.Bus" = "talk";  # 可选
      };

      # SSL 证书
      etc.sslCertificates.enable = true;

      # GPU 加速
      gpu.enable = true;
      gpu.provider = "bundle";

      # Bubblewrap 配置
      bubblewrap = {
        network = true;  # 必需

        # 设备节点
        bind.dev = [
          "/dev/dri"  
          "/dev/snd"  
          "/dev/shm"  
          "/dev/video0"  # 摄像头，可选
        ];

        # 读写目录
        bind.rw = [
          (sloth.concat' sloth.homeDir "/.local/share/wechat")  # 数据存储
          (sloth.concat' sloth.xdgCacheHome "/wechat")
          (sloth.env "XDG_RUNTIME_DIR")
          "/tmp"
        ];

        # 只读目录
        bind.ro = [
          (sloth.concat' sloth.homeDir "/Downloads")
          "/etc"
        ];

        # 显示和音频套接字
        sockets = {
          wayland = true;
          x11 = true;
          pipewire = true;
        };
      };
    };
  };

in {
  nixpkgs.config.allowUnfree = true;

  home.packages = [
    sandboxed-wechat.config.env  # 生成沙盒环境包
  ];

  # 可选：复制 .desktop 文件到本地
  home.activation.createWeChatDesktopAlias = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ln -sf ${sandboxed-wechat.config.env}/share/applications/* $HOME/.local/share/applications/ || true
  '';
}