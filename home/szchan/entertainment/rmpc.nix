{ config, pkgs, ... }:

{
  programs.rmpc = {
    enable = true;
    packages = with pkgs; [
      rmpc
    ];
    config = "
    
    ";
  };
}