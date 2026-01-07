{ config, ... }:

{
  programs.distrobox = {
    enable = true;

    settings = {
      container_manager = "podman";
      container_user_custom_home = "${config.home.homeDirectory}/Data/distrobox";
    };
  };

}
