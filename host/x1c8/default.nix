# 这台 ThinkPad X1 Carbon Gen 8。安装时选择 nixosConfigurations.x1c8。
{ inputs, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./thermald.nix
    inputs.chatgpt-desktop-app.nixosModules.default
  ];

  programs.chatgpt-desktop-app.enable = true;

  networking.hostName = "x1c8";

  # 逻辑容量等于内存。优先级高于磁盘交换，网页先留在压缩内存里。
  zramSwap.memoryPercent = 100;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  environment.variables.LIBVA_DRIVER_NAME = "iHD";

  environment.systemPackages = with pkgs; [
    brightnessctl
    clash-verge-rev
  ];

  users.users.szchan.extraGroups = [
    "video"
    "input"
  ];

  # Synaptics Prometheus，USB 06cb:00bd，由 libfprint 1.94.9 的 Synaptics 驱动支持。
  services.fprintd.enable = true;
  services.udev.packages = [ pkgs.libfprint ];

  # 指纹成功即通过，失败后仍可用密码。SSH、用户会话和打印不弹出指纹。
  security.pam.services = {
    sudo.fprintAuth = true;
    login.fprintAuth = true;
    polkit-1.fprintAuth = true;
    dms-greeter.fprintAuth = true;
    sshd.fprintAuth = false;
    systemd-user.fprintAuth = false;
    cups.fprintAuth = false;
  };

  # 与当前 Bash 的本机代理一致。Clash Verge 监听 127.0.0.1:7897。
  home-manager.users.szchan.home = {
    sessionVariables = {
      http_proxy = "http://127.0.0.1:7897";
      https_proxy = "http://127.0.0.1:7897";
      HTTP_PROXY = "http://127.0.0.1:7897";
      HTTPS_PROXY = "http://127.0.0.1:7897";
      all_proxy = "socks5://127.0.0.1:7897";
      ALL_PROXY = "socks5://127.0.0.1:7897";
      ftp_proxy = "http://127.0.0.1:7897";
      FTP_PROXY = "http://127.0.0.1:7897";
      socks_proxy = "socks5://127.0.0.1:7897";
      SOCKS_PROXY = "socks5://127.0.0.1:7897";
    };

    # DMS 锁屏默认关闭指纹。只补上这个开关，文件保持可写。
    activation.dmsFingerprint = inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      settings="$HOME/.config/DankMaterialShell/settings.json"
      mkdir -p "$(dirname "$settings")"
      if [ -L "$settings" ]; then
        rm "$settings"
      fi
      if [ ! -e "$settings" ]; then
        printf '%s\n' '{"enableFprint":true}' > "$settings"
      elif [ -f "$settings" ] && ! ${lib.getExe pkgs.jq} -e 'has("enableFprint")' "$settings" >/dev/null; then
        tmp="$(mktemp)"
        ${lib.getExe pkgs.jq} '.enableFprint = true' "$settings" > "$tmp"
        mv "$tmp" "$settings"
      fi
    '';
  };
}
