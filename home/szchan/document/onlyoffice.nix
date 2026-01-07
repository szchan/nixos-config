{ pkgs, ... }:

{
  programs.onlyoffice = {
    enable = true;
    package = pkgs.onlyoffice-desktopeditors;
    settings = {

    };
  };
}
