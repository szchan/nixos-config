{config, pkgs, ...}:

{
  # Steam
  programs.steam = {
    enable = true;
    extest.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extraPackages = with pkgs; [
      gamescope
    ];
    fontPackages = with pkgs; [
      source-han-sans
    ];
    protontricks.enable = true;
  };
}