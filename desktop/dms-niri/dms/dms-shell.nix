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
    # enableClipboard 已从当前 DMS 模块移除，剪贴板由 DMS 内建，cliphist 仍由 startup.kdl 启动。
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
