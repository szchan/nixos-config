# 通用网络配置。mihomo 的版本和所有机器共用的开关在这里；
# 每台机器不同的配置文件路径、代理环境变量在 host/<name>/networking.nix。
{ pkgs, ... }:

{
  # Enable NetworkManager for managing network connections.
  networking.networkmanager.enable = true;

  # Enable Wi-Fi support.
  # networking.wireless.enable = true;

  # Avahi for local network service discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    # 旧的 services.avahi.publish.* 布尔选项已废弃（部分改名为 settings.publish.*），
    # 现在直接写 avahi-daemon.conf 的 [publish] 段。
    settings.publish = {
      # 原 publish.enable = true
      disable-publishing = false;
      # 原 publish.userServices = true（同时会发布地址记录）
      disable-user-service-publishing = false;
      publish-addresses = true;
      # 原 publish.domain = true
      publish-domain = true;
    };
    openFirewall = true;
  };

  # 固定 mihomo 版本。用 overlay 而不是只写 services.mihomo.package，
  # 这样其他消费 mihomo 的包（例如 clash-verge）也会拿到同一个版本。
  # 某台机器需要不同版本时，在它自己的 networking.nix 里再加一个 overlay。
  nixpkgs.overlays = [
    (final: prev: {
      mihomo = prev.mihomo.overrideAttrs (old: rec {
        version = "1.19.33";
        src = prev.fetchFromGitHub {
          owner = "MetaCubeX";
          repo = "mihomo";
          rev = "v${version}";
          hash = "sha256-O2OJ0WFt0T32yOIT1El+ACJWVm2oAJOjU1JTDXb2IEo=";
        };
        vendorHash = "sha256-wPkqyp2iuA762qID2FK3xWOMU5ZNxAle8saCmZzpeSI=";
      });
    })
  ];

  # mihomo 的公共开关；配置文件路径按机器在 host/*/networking.nix 里设置。
  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.metacubexd;
  };

  # Proxy
  # networking.proxy.default = "http://127.0.0.1:7897/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
