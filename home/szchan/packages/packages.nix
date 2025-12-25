{ config, pkgs, ... }:

{
    home.packages = with pkgs;[
        zsh
        yazi
        kitty

        # nix related
        #
        # it provides the command `nom` works just like `nix`
        # with more details log output
        nix-output-monitor

        # productivity
        hugo # static site generator

        # niri
        # niri


    ];
}