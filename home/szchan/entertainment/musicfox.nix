{ pkgs, ... }:

{
  home.packages = with pkgs; [
    go-musicfox
  ];
}
