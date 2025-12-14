{config, pkgs, ... }:

{
    # Enable NetworkManager for managing network connections.
    networking.networkmanager.enable = true;

    # Enable Wi-Fi support.
    # networking.wireless.enable = true;

    # Openssh server for remote access
    services.openssh.enable = true;

    # Enable firewall
    networking.firewall.enable = true;

    # Enable IPv6
    networking.ipv6.enable = true;

    # Clash proxy service
    environment.systemPackages = [
        pkgs.clash-verge-rev
    ];

    # Proxy
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    
}