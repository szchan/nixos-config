{config, pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    nautilus
    turtle
  ];

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  services.gnome.sushi.enable = true;
  
}