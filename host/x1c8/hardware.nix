# 这台 ThinkPad 手写的硬件支持。扫描生成的硬件配置在 hardware-configuration.nix。
{ pkgs, ... }:

{
  # 扫描结果不包含可再分发固件。无线网卡需要它。
  hardware.enableRedistributableFirmware = true;

  # Intel 核显的视频加速。LIBVA_DRIVER_NAME=iHD 对应 intel-media-driver。
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  environment.variables.LIBVA_DRIVER_NAME = "iHD";

  # 屏幕背光调节。
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  # 访问显卡和输入设备需要的用户组。
  users.users.szchan.extraGroups = [
    "video"
    "input"
  ];
}
