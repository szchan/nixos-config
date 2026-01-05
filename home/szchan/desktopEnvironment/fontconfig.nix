{config, pkgs, ...}:


{
  fonts = {

    fontconfig = {

      defaultFonts = {

        serif = [
          # 西文: 衬线字体（笔画末端有修饰(衬线)的字体，通常用于印刷。）
          "Source Serif 4"
          # 中文: 宋体（港台称明體）
          "Source Han Serif SC" # 思源宋体
          "Source Han Serif TC"
        ];

        # SansSerif 也简写做 Sans, Sans 在法语中就是「without」或者「无」的意思
        sansSerif = [
          # 西文: 无衬线字体（指笔画末端没有修饰(衬线)的字体，通常用于屏幕显示）
          "Source Sans 3"
          # 中文: 黑体
          "LXGW WenKai Screen" # 霞鹜文楷 屏幕阅读版
          "Source Han Sans SC" # 思源黑体
          "Source Han Sans TC"
        ];

        # 等宽字体
        monospace = [
          # 中文
          "Maple Mono NF CN" # 中英文宽度完美 2:1 的字体
          "Source Han Mono SC" # 思源等宽
          "Source Han Mono TC"
          # 西文
          "JetBrainsMono Nerd Font"
        ];

        emoji = [
          "Noto Color Emoji"
        ];

      };
    
      configFile = {
        # 让Fontconfig正确获取系统级配置的字体
        nix = {
          enable = true;
          priority = 99;
          label = "nix";
          text = ''
            <?xml version="1.0"?>
            <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
            <fontconfig>
              <!-- NIX_PROFILE is the path to your Nix profile. See Nix Reference Manual for details. -->
              <dir>NIX_PROFILE/lib/X11/fonts</dir>
              <dir>NIX_PROFILE/share/fonts</dir>
            </fontconfig>
          '';
        };
      };
    };
  };
}