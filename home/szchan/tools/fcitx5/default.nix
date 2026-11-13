{ pkgs, lib, ... }:

{
  # custom-rime.nix 会用 rsync --delete 覆盖个人词库，并额外启用万象。
  # 当前机器只使用雾凇拼音，因此在这里单独部署。

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      waylandFrontend = true; # Wayland 必需

      addons = with pkgs; [
        qt6Packages.fcitx5-configtool # 配置工具
        fcitx5-gtk # GTK 支持

        fcitx5-rime
        # rime-ice

        # 主题
        fcitx5-nord
        fcitx5-material-color
        fcitx5-tokyonight
      ];

      # 这里启用自定义 Rime
      # customRime.enable = false;
    };
  };

  xdg.configFile."fcitx5/profile" = {
    source = ./profile;
    force = true; # 强制覆盖，避免冲突
  };

  xdg.configFile."fcitx5/config".text = ''
    [Behavior]
    DefaultPageSize=10
  '';

  xdg.configFile."fcitx5/conf/clipboard.conf".text = ''
    TriggerKey=
    PastePrimaryKey=
  '';

  xdg.configFile."fcitx5/conf/xcb.conf".text = ''
    Allow Overriding System XKB Settings=False
  '';

  home.activation.deployRimeIce = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.local/share/fcitx5/rime"
    ${pkgs.rsync}/bin/rsync -a ${pkgs.rime-ice}/share/rime-data/ "$HOME/.local/share/fcitx5/rime/"
    cat > "$HOME/.local/share/fcitx5/rime/default.custom.yaml" <<'EOF'
    # Managed addition from community.cn-input; other Rime settings may be added here.
    patch:
      schema_list:
        - schema: rime_ice
    EOF
  '';

  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    # XIM 已过时，但保留无害
    XIM = "fcitx";
  };
}
