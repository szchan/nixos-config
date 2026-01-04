{config, pkgs, ...}:

{
  xdg.configFile = {
    "niri" = {
      recursive = true;
      source = ./niri-dotfiles;
    };
  };
}