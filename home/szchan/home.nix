{ config, pkgs, inputs, ... }:

{
    imports = [
        ./packages
        ./git
        ./security
        ./terminal
        ./desktopEnvironment
        ./tools
        ./ai
        ./develop
        ./document

        # niri-flake
        # inputs.niri.homeModules.niri

        # Dank-Material-Shell for Niri
        # inputs.dms.homeModules.dankMaterialShell.default
        # inputs.dms.homeModules.dankMaterialShell.niri

    ];
    # Define the user for whom to manage the home directory
    home.username = "szchan";
    home.homeDirectory = "/home/szchan";

    # 直接将当前文件夹的配置文件，链接到 Home 目录下的指定位置
    # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

    # 递归将某个文件夹中的文件，链接到 Home 目录下的指定位置
    # home.file.".config/i3/scripts" = {
    #   source = ./scripts;
    #   recursive = true;   # 递归整个文件夹
    #   executable = true;  # 将其中所有文件添加「执行」权限
    # };

    # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
    # home.file.".xxx".text = ''
    #     xxx
    # '';

    # 设置鼠标指针大小以及字体 DPI（适用于 4K 显示器）
    #   xresources.properties = {
    #     "Xcursor.size" = 16;
    #     "Xft.dpi" = 172;
    #   };

    # 通过 home.packages 安装一些常用的软件
    # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
    # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "25.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}