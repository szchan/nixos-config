{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nautilus
    turtle
  ];

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };

  services.gnome.sushi.enable = true;

}
