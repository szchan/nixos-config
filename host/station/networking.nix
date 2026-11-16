# 主机名和 mihomo 的机器差异。
# 共用的 mihomo 版本、tunMode 和 webui 在 base/networking.nix。
{ ... }:

{
  networking.hostName = "szchanNixOSStation";

  # 配置文件在仓库外，安装前需要单独备份。
  services.mihomo = {
    configFile = "/home/szchan/Projects/mihomo-config/config-p.yaml";
  };
}
