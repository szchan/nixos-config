{ config, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "/home/szchan/Cloud/Music";
    dataDir = "/home/szchan/.mpd";
  };
}