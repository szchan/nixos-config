{config, pkgs, ...}:

{
  xdg.configFile = {

    "niri/config.kdl".source = ./niri-dotfiles/config.kdl;
    
    "niri/env.kdl".source = ./niri-dotfiles/env.kdl;

    "niri/startup.kdl".source = ./niri-dotfiles/startup.kdl;

    # "niri" = {
    #   recursive = true;
    #   source = ./niri-dotfiles;
    # };
  };
}