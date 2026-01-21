{ pkgs, ... }:

{
  # Desktop Shell
  programs.dms-shell = {
    enable = true;
    package = pkgs.dms-shell;
    systemd = {
      enable = true;
      target = "graphical-session.target";
      restartIfChanged = true;
    };
    quickshell.package = pkgs.quickshell;
    enableVPN = true;
    enableSystemMonitoring = true;
    enableDynamicTheming = true;
    # enableClipboard = true;
    enableCalendarEvents = true;
    enableAudioWavelength = true;
  };

  # dsearch
  programs.dsearch = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };
}
