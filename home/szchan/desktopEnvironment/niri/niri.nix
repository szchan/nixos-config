{ config, pkgs, ... }:

{
    # Enable Niri session
    # xsession.windowManager.niri.enable = true;
    nixpkgs.overlays = [ niri.overlays.niri ];
}