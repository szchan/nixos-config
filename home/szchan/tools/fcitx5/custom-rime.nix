# custom-rime.nix
{ config, lib, pkgs, ... }:

let
  cfg = config.programs.fcitx5.customRime;
in
{
  options.programs.fcitx5.customRime = {
    enable = lib.mkEnableOption "自定义 Rime 配置（雾凇冰 + 万象拼音 + wanxiang-lts-zh-hans.gram 语法大模型）";

    extraGramUrl = lib.mkOption {
      type = lib.types.str;
      default = "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram";
      description = "万象语法大模型下载 URL（最新 LTS 版）";
    };
  };

  config = lib.mkIf cfg.enable {
    # 启用 fcitx5-rime
    programs.fcitx5.addons = [ pkgs.fcitx5-rime ];

    # 部署雾凇冰数据（官方包）
    home.activation.deployRimeIce = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${pkgs.rsync}/bin/rsync -a --delete ${pkgs.rime-ice}/share/rime-data/ $HOME/.local/share/fcitx5/rime/
    '';

    # 部署万象数据（官方包）
    home.activation.deployWanxiang = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${pkgs.rsync}/bin/rsync -a --delete ${pkgs.rime-wanxiang}/share/rime-data/ $HOME/.local/share/fcitx5/rime/
    '';

    # 下载并部署万象语法大模型（放在根目录，对万象方案生效）
    home.file.".local/share/fcitx5/rime/wanxiang-lts-zh-hans.gram".source = builtins.fetchurl {
      url = cfg.extraGramUrl;
      # 首次 switch 若需 sha256，Nix 会提示正确值，可手动添加固定
    };

    # 默认启用雾凇 + 万象两个方案（可在 fcitx 配置工具中切换）
    xdg.configFile."fcitx5/rime/default.custom.yaml".text = ''
      patch:
        schema_list:
          - schema: rime_ice              # 雾凇拼音（全拼/双拼等）
          - schema: rime_wanxiang_pinyin  # 万象全拼（带语法模型增强）
    '';

    # 雾凇常用翻页设置（逗号上页、句号下页）
    xdg.configFile."fcitx5/rime/rime_ice.custom.yaml".text = ''
      patch:
        key_binder/bindings/++:
          - { when: paging, accept: comma, send: Page_Up }
          - { when: has_menu, accept: period, send: Page_Down }
    '';
  };
}