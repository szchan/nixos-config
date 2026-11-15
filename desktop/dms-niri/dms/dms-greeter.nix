{ pkgs, ... }:

{
  # Greeter
  services.displayManager.dux-greeter = {
    enable = true;
    quickshell.package = pkgs.quickshell;
    logs = {
      save = true;
      path = "/tmp/dms-greeter.log";
    };
    compositor.name = "niri";

    # Copies ~/.config/dms, ~/.local/state/dms and ~/.cache/dms into the
    # greeter cache. Legacy DankMaterialShell paths are still picked up.
    configHome = "/home/szchan";
  };
}
