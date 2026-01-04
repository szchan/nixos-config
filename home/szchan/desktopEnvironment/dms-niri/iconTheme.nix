{config, pkgs, ...}:

{
  gtk = {
    enable = true;

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";  # 包内的主题名称（Papirus 有 Papirus、Papirus-Dark 等变体）
    };
  };
}