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
    rimeDir="$HOME/.local/share/fcitx5/rime"
    mkdir -p "$rimeDir"

    # Rime must be able to write user.yaml/build data here. The old rsync -a
    # copied the Nix store's read-only (0555) permissions, so Rime could not
    # save its config and never deployed any schema.
    chmod -R u+w "$rimeDir"

    # --checksum copies only content changes; dropping -t gives changed files a
    # fresh mtime so Rime knows it has to rebuild its tables (Nix store files
    # all have an epoch mtime).
    ${pkgs.rsync}/bin/rsync -rl --checksum --no-perms --chmod=u+w ${pkgs.rime-ice}/share/rime-data/ "$rimeDir/"

    # The shared fcitx5-rime default.yaml lists luna_pinyin/bopomofo/..., which
    # are not installed here. Without this patch Rime starts with no usable
    # schema and passes every key through as English.
    cat > "$rimeDir/default.custom.yaml" <<'EOF'
    # Managed by home-manager: home/szchan/tools/fcitx5/default.nix
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
