{ config, pkgs, ... }:

{
    home.packages = with pkgs;[
        _1password-gui
        _1password-cli
    ];

    # programs._1password = {
    #     enable = true;
    # };

    # programs._1password-gui = {
    #     enable = true;
    # };
}