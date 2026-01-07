{ pkgs, ... }:

{
  gtk = {
    enable = true;
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24; # 可选，推荐设置大小，尤其是 HiDPI 屏幕，常见值 24/32/48
    gtk.enable = true; # 确保 GTK 应用也生效
    # 如果你是 X11 会话，可以加 x11.enable = true; Wayland 下通常不需要
  };

  home.packages = [ pkgs.bibata-cursors ];
}
