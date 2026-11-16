{ ... }:

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

  # Clash proxy service
  # environment.systemPackages = [
  #   pkgs.clash-verge-rev
  # ];
  # # Clash Verge configuration
  # programs.clash-verge = {
  #   enable = true;
  #   autoStart = true;
  #   serviceMode = true;
  #   tunMode = true;
  # };

  # 代理服务按机器配置：原先的台式机见 host/station/networking.nix，ThinkPad 见 host/x1c8/networking.nix。

  # Proxy
  # networking.proxy.default = "http://127.0.0.1:7897/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

}
