{config, pkgs, ...}:

{
  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

  environment.systemPackages = [
    pkgs.wireshark
    pkgs.termshark
  ];

}