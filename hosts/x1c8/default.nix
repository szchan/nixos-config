# 这台 ThinkPad X1 Carbon Gen 8。安装时选择 nixosConfigurations.x1c8。
{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./thermald.nix
    inputs.chatgpt-desktop-app.nixosModules.default
  ];

  programs.chatgpt-desktop-app.enable = true;

  networking.hostName = "x1c8";

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

  # 当前 Omarchy 使用 libfprint-git。发行版 fprintd 尚未在这台机器上验证，先不启用。

  # 与当前 Bash 的本机代理一致。Clash Verge 监听 127.0.0.1:7897。
  home-manager.users.szchan.home.sessionVariables = {
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
}
