# 主机名和本机代理服务。
{ pkgs, ... }:

{
  networking.hostName = "szchanNixOSStation";

  # 配置文件在仓库外，安装前需要单独备份。
  services.mihomo = {
    enable = true;
    tunMode = true;
    configFile = "/home/szchan/Projects/mihomo-config/config-p.yaml";
    webui = pkgs.metacubexd;
  };
}
