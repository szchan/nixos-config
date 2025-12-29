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

      # 创建临时目录用于存放转换后的 cn_dicts
      mkdir cn_dicts_converted

      # 转换所有 cn_dicts/*.dict.yaml 到临时目录（带声调格式）
      for dict_file in cn_dicts/*.dict.yaml; do
        [ -f "$dict_file" ] || continue
        base=$(basename "$dict_file")
        python "tool/rime#U56fa#U5b9a#U6216#U7528#U6237#U8bcd#U5178#U5237#U65b0#U4e3a#U5e26#U58f0#U8c03#U7f16#U7801.py" --input "$dict_file" --output "cn_dicts_converted/$base"
      done

      # 现在安全复制整个源目录到 converted（此时没有子目录冲突）
      mkdir converted
      cp -r --no-preserve=mode ./* converted/  # 或用 tar c ./* | tar x -C converted 如果你喜欢

      # 用转换后的 cn_dicts 替换原来的
      rm -rf converted/cn_dicts
      mv cn_dicts_converted converted/cn_dicts

      # 放入万象语言模型
      cp ${gram} converted/wanxiang-lts-zh-hans.gram

      # 添加自定义 patch 以启用万象模型
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