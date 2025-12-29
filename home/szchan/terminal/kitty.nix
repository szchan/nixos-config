{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      size = 12;
    };

  };
}