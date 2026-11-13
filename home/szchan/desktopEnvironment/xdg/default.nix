{ pkgs, ... }:

{
  imports = [
    ./userDirs.nix
  ];

  xdg.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "brave-browser.desktop" ];
      "x-scheme-handler/http" = [ "brave-browser.desktop" ];
      "x-scheme-handler/https" = [ "brave-browser.desktop" ];
      "x-scheme-handler/about" = [ "brave-browser.desktop" ];
      "x-scheme-handler/unknown" = [ "brave-browser.desktop" ];
      "x-scheme-handler/clash" = [ "clash-verge-handler.desktop" ];
      "x-scheme-handler/clash-verge" = [ "clash-verge-handler.desktop" ];
      "x-scheme-handler/codex" = [ "chatgpt.desktop" ];
    };
    associations.removed = {
      "x-scheme-handler/mailto" = [ "omamail.desktop" ];
    };
  };

  xdg.desktopEntries = {
    clash-verge-handler = {
      name = "Clash Verge";
      noDisplay = true;
      exec = "${pkgs.clash-verge-rev}/bin/clash-verge %u";
      mimeType = [
        "x-scheme-handler/clash-verge"
        "x-scheme-handler/clash"
      ];
      terminal = false;
    };
  };
}
