{ ... }:

{
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [
      22
    ];
    allowedUDPPorts = [
      22
    ];
  };
}
