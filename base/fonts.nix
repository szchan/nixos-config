{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # 谷歌Noto Unicode码全覆盖
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    # 微软用于web的TrueType字体
    corefonts

    # 为开发者打造的字体
    fira-code
    fira-code-symbols
    maple-mono.NF-CN
    nerd-fonts.jetbrains-mono

    # 中文字体
    source-han-mono
    source-han-sans
    source-han-sans-vf-otf
    source-han-sans-vf-ttf
    source-han-serif
    source-han-serif-vf-otf
    source-han-serif-vf-ttf
    lxgw-wenkai-screen
    lxgw-wenkai
    lxgw-neoxihei
    lxgw-fusionkai
    lxgw-wenkai-tc
    wqy_microhei
    wqy_zenhei
    arphic-ukai
    arphic-uming
    ark-pixel-font
    edusong
    edukai
    eduli
    cns11643-kai

    # Twitter打造的emoji字体
    twitter-color-emoji
    # twemoji-color-font

    # 覆盖低分辨率和pixel字体,保证最大兼容性
    liberation_ttf
    mplus-outline-fonts.githubRelease
    # dina-font
    proggyfonts
    dejavu_fonts
  ];
  # all fonts are linked to /nix/var/nix/profiles/system/sw/share/X11/fonts
  fonts = {
    # use fonts specified by user rather than default ones
    enableDefaultPackages = true;
    fontDir.enable = true;

    # fonts are defined in /modules/base/fonts.nix, used by both NixOS & Darwin.
    # packages = [ ... ];

    fontconfig = {
      # User defined default fonts
      # https://catcat.cc/post/2021-03-07/
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
          "Twitter Color Emoji"
        ];

      };

      antialias = true; # 抗锯齿

      hinting.enable = false; # 禁止字体微调 - 高分辨率下没这必要

      subpixel = {
        rgba = "rgb"; # IPS 屏幕使用 rgb 排列
      };
    };
  };

}
