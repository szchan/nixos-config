{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
  };

  home.packages = with pkgs; [
    brave
  ];
}
