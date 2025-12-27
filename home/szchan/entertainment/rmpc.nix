{ config, pkgs, ... }:

{
  programs.rmpc = {
    enable = true;
    package = with pkgs; [
      rmpc
    ];
    config = "
    
    ";
  };
}