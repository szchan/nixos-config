{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hugo # static site generator
  ];
}
