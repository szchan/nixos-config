# 原先那台 NVIDIA 台式机。不要在这台 ThinkPad 上选用 szchanNixOSStation。
{ pkgs, ... }:

{
  imports = [
    ../base/nvidia.nix
  ];

  networking.hostName = "szchanNixOSStation";

  environment.systemPackages = with pkgs; [
    btop-cuda
    nvtopPackages.nvidia
  ];

  # 配置文件在仓库外，安装前需要单独备份。
  services.mihomo = {
    enable = true;
    tunMode = true;
    configFile = "/home/szchan/Projects/mihomo-config/config-p.yaml";
    webui = pkgs.metacubexd;
  };
}
