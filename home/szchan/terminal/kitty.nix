{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      nerd-fonts.jetbrains-mono;
      size = 12;
    };

  };
}