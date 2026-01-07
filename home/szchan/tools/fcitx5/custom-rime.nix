# custom-rime.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.i18n.inputMethod.fcitx5.customRime;
in
{
  options.i18n.inputMethod.fcitx5.customRime = {
    enable = lib.mkEnableOption "自定义 Rime 配置（雾凇冰 + 万象拼音 + wanxiang-lts-zh-hans.gram 语法大模型）";

    extraGramUrl = lib.mkOption {
      type = lib.types.str;
      default = "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram";
      description = "万象语法大模型下载 URL（最新 LTS 版）";
    };
  };

  config = lib.mkIf cfg.enable {
    # 启用 fcitx5-rime addon（必须）
    i18n.inputMethod.fcitx5.addons = [ pkgs.fcitx5-rime ];

    # 部署官方雾凇冰数据
    home.activation.deployRimeIce = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.rsync}/bin/rsync -a --delete ${pkgs.rime-ice}/share/rime-data/ $HOME/.local/share/fcitx5/rime/
    '';

    # 部署官方万象数据
    home.activation.deployWanxiang = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.rsync}/bin/rsync -a --delete ${pkgs.rime-wanxiang}/share/rime-data/ $HOME/.local/share/fcitx5/rime/
    '';

    # 下载并部署万象语法大模型
    home.file.".local/share/fcitx5/rime/wanxiang-lts-zh-hans.gram".source = builtins.fetchurl {
      url = cfg.extraGramUrl;
      sha256 = "sha256-WnIdOzF9FYyzVs+waD+DHKvAaAI8EQTIYwMD4I9jhVE=";
    };

    # 默认启用雾凇 + 万象两个方案
    xdg.configFile."fcitx5/rime/default.custom.yaml".text = ''
      patch:
        schema_list:
          - schema: rime_ice              # 雾凇拼音
          - schema: rime_wanxiang_pinyin  # 万象全拼（带语法模型）
    '';

    # 雾凇常用翻页自定义
    xdg.configFile."fcitx5/rime/rime_ice.custom.yaml".text = ''
      patch:
        key_binder/bindings/++:
          - { when: paging, accept: comma, send: Page_Up }
          - { when: has_menu, accept: period, send: Page_Down }
    '';
  };
}
