{ config, pkgs, lib, inputs, ... }:

let
  cfg = config.customRime;

  gram = pkgs.fetchurl {
    url = "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram";
    hash = "sha256-WnIdOzF9FYyzVs+waD+DHKvAaAI8EQTIYwMD4I9jhVE=";
  };

  dictToolsZip = pkgs.fetchurl {
    url = "https://github.com/amzxyz/RIME-LMDG/releases/download/dict-nightly/dict-pinyin-tools.zip";
    hash = "sha256-q/kK750aTJY+Q+xf3ouDyBZX33bRzvwj5mEvdtSbi80=";
  };

  customRimeDir = pkgs.stdenv.mkDerivation {
    name = "custom-rime-data";

    nativeBuildInputs = with pkgs; [
      unzip
      (python3.withPackages (ps: with ps; [ pypinyin tqdm ]))
    ];

    src = inputs.rime-ice;

    phases = [ "unpackPhase" "buildPhase" "installPhase" ];

    buildPhase = ''
      # 解压工具包
      mkdir tool
      unzip ${dictToolsZip} -d tool

      # 转换 cn_dicts 中的词库为带声调格式（使用正确的中文脚本名）
      mkdir -p converted/cn_dicts
      for dict_file in cn_dicts/*.dict.yaml; do
        [ -f "$dict_file" ] || continue  # 防止 glob 没匹配时出错
        base=$(basename "$dict_file")
        python tool/rime#U56fa#U5b9a#U6216#U7528#U6237#U8bcd#U5178#U5237#U65b0#U4e3a#U5e26#U58f0#U8c03#U7f16#U7801.py --input "$dict_file" --output "converted/cn_dicts/$base"
      done

      # 复制 en_dicts 原样（英文词库不需要声调）
      mkdir -p converted/en_dicts
      cp -r en_dicts/*.dict.yaml converted/en_dicts/ 2>/dev/null || true

      # 复制 rime-ice 其余所有文件（包括方案、符号等）
      cp -r . converted/

      # 用转换后的 cn_dicts 替换原来的
      rm -rf converted/cn_dicts
      mv converted/cn_dicts converted/

      # 放入语言模型
      cp ${gram} converted/wanxiang-lts-zh-hans.gram

      # 添加自定义 patch 以启用万象语言模型
      cat > converted/rime_ice.custom.yaml << 'EOF'
      patch:
        grammar:
          language: wanxiang-lts-zh-hans
          collocation_max_length: 5
          collocation_min_length: 2
          collocation_penalty: -10
          non_collocation_penalty: -20
          weak_collocation_penalty: -45
          rear_penalty: -5
        translator/contextual_suggestions: true
        translator/max_homophones: 7
        translator/max_homographs: 7
      EOF
    '';

    installPhase = ''
      mkdir -p $out
      cp -r converted/* $out/
    '';
  };
in {
  options.customRime = {
    enable = lib.mkEnableOption "Enable custom RIME with merged rime-ice and wanxiang optimizations";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      librime  # 确保 librime 支持 octagram 插件（如果需要，手动检查或 overlay）
    ];

    # 放置自定义 RIME 配置
    home.file.".local/share/fcitx5/rime".source = customRimeDir;

    # 添加 librime-octagram [八股文]语法插件
    nixpkgs.overlays = [
      (self: super: {
        librime = super.librime.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ super.librime-plugin-octagram ];
        });
      })
    ];
  };
}