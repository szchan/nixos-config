{ ... }:

{
  # home.packages = with pkgs;[
  #     obs-studio
  # ];

  programs.obs-studio = {
    enable = true;
  };
}
