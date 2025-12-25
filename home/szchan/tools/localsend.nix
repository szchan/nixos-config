{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        localsend
    ];

    programs.localsend = {
        enable = true;
        openFirewall = true;
    };
}