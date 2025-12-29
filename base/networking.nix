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
  # environment.systemPackages = [
  #   pkgs.clash-verge-rev
  # ];
  # Clash Verge configuration
  # programs.clash-verge = {
  #   enable = true;
  #   autoStart = false;
  #   serviceMode = true;
  #   tunMode = true;
  # };


  # Proxy
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  
}