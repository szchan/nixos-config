{config, pkgs, ... }:

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

  # Firewall
  networking.firewall.enable = false;
  # networking.firewall.allowedTCPPorts = [ 
  #   22 
  # ];
  # networking.firewall.allowedUDPPorts = [ 
  #   22
  # ];

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

  services.mihomo = {
    enable = true;
    tunMode = true;
    configFile = "/home/szchan/Projects/mihomo-config/config-p.yaml";
    webui = pkgs.metacubexd;
  };


  # Proxy
  # networking.proxy.default = "http://127.0.0.1:7897/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
}
