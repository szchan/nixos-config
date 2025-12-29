{ config, pkgs, lib, ... }:

{
  imports = [
    ./custom-rime.nix  # 导入模块
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";  # 或使用 enabled = "fcitx5";（旧方式兼容）

    fcitx5 = {
      waylandFrontend = true;  # Wayland 必需

      addons = with pkgs; [
        qt6Packages.fcitx5-configtool  # 配置工具
        fcitx5-gtk                     # GTK 支持

        fcitx5-rime

        # 主题
        fcitx5-nord
        fcitx5-material-color
        fcitx5-tokyonight
      ];

      # 这里启用自定义 Rime
      customRime.enable = false;
    };
  };

  xdg.configFile."fcitx5/profile" = {
    source = ./profile;
    force = true;  # 强制覆盖，避免冲突
  };

  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    # XIM 已过时，但保留无害
    XIM = "fcitx";
  };
}