{config, pkgs, ... }:

{
  # Enable NetworkManager for managing network connections.
  networking.networkmanager.enable = true;

  # Enable Wi-Fi support.
  # networking.wireless.enable = true;

  # Tsinghua Mirror
  # nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

  # Avahi for local network service discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      domain = true;
      userServices = true;
    };
  };

  # Openssh server for remote access
  services.openssh.enable = true;

  # Firewall
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ 
  #   22 
  # ];
  # networking.firewall.allowedUDPPorts = [ 
  #   22
  # ];

  # Clash proxy service
  environment.systemPackages = [
    pkgs.clash-verge-rev
  ];
  # Clash Verge configuration
  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;
    tunMode = true;
  };

  # services.mihomo = {
  #   enable = true;
  #   tunMode = true;
  #   webui = "/home/szchan/Projects/clash/metacubex";
  #   configFile = "/home/szchan/Projects/clash/clash-verge.yaml";
  # };


  # Proxy
  # networking.proxy.default = "http://192.168.50.203:1082/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
}
