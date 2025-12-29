{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = nerd-fonts.jetbrains-mono;
    font.size = 12;
    
  };
}