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
    publish = {
      enable = true;
      domain = true;
      userServices = true;
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

  # mihomo 只属于原先的台式机，见 host/station.nix。
  # 这台 ThinkPad 使用 Clash Verge，见 hosts/x1c8/default.nix。

  # Proxy
  # networking.proxy.default = "http://127.0.0.1:7897/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

}
