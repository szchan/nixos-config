{ pkgs, ... }:

{
  # Greeter
  services.displayManager.dms-greeter = {
    enable = true;
    # package = pkgs.dms-greeter;
    quickshell.package = pkgs.quickshell;
    logs = {
      save = true;
      path = "/tmp/dms-greeter.log";
    };
    compositor.name = "niri";

    configHome = "/home/szchan";
    configFiles = [
      "/home/szchan/.config/DankMaterialShell/settings.json"
      "/home/szchan/.local/state/DankMaterialShell/session.json"
    ];

  };
}
