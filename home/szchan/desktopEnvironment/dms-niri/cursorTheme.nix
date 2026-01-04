{config, pkgs, ...}:

{
  gtk = {
    enable = true;  # 必须启用

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
  };
}