{ pkgs, ... }:

{
  # Desktop Shell
  #
  # DMS 2.x is packaged in nixpkgs as Dux Shell. The old feature toggles
  # (enableVPN, enableSystemMonitoring, enableDynamicTheming,
  # enableAudioWavelength, enableCalendarEvents) were removed upstream:
  # system monitoring is built in, matugen and cava ship in the default
  # environment, VPN backends are detected at runtime and calendar support
  # comes from a separately configured backend.
  programs.dux-shell = {
    enable = true;
    package = pkgs.dux-shell;
    systemd = {
      enable = true;
      target = "graphical-session.target";
      restartIfChanged = true;
    };
    quickshell.package = pkgs.quickshell;
  };

  # Search (formerly dsearch)
  programs.dux-search = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };
}
