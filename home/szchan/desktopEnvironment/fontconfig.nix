{ ... }:

{
  # 字体包只在系统模块 base/fonts.nix 安装一次。
  fonts = {

    fontconfig = {

      defaultFonts = {

        serif = [
          # 英文: 衬线字体（笔画末端有修饰(衬线)的字体，通常用于印刷。）
          "Source Serif 4"
          # 中文: 宋体（港台称明體）
          "Source Han Serif SC" # 思源宋体
          "Source Han Serif TC"
        ];

        # SansSerif 也简写做 Sans, Sans 在法语中就是「without」或者「无」的意思
        sansSerif = [
          # 英文: 无衬线字体（指笔画末端没有修饰(衬线)的字体，通常用于屏幕显示）
          "Source Sans 3"
          # 中文: 黑体
          "LXGW WenKai Screen" # 霞鹜文楷 屏幕阅读版
          "Source Han Sans SC" # 思源黑体
          "Source Han Sans TC"
        ];

        # 等宽字体
        monospace = [
          "JetBrainsMono Nerd Font"
          "Maple Mono NF CN"
          "Source Han Mono SC"
          "Source Han Mono TC"
        ];

        emoji = [
          "Twitter Color Emoji"
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
              <dir prefix="cwd">NIX_PROFILE/lib/X11/fonts</dir>
              <dir prefix="cwd">NIX_PROFILE/share/fonts</dir>
            </fontconfig>
          '';
        };
      };
    };
  };
}
