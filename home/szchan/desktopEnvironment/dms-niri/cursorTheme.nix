{config, pkgs, ...}:

{
  gtk = {
    enable = true;  # 必须启用

    cursorTheme = {
      name = bibata-cursors;
      package = pkgs.bibata-cursors;
    };
  };
}