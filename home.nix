{ config, pkgs, ... }:

{
    # Define the user for whom to manage the home directory
    home.username = "szchan";
    home.homeDirectory = "/home/szchan";

    # Enable GPG agent with SSH support
    services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 1800;
        enableSshSupport = true;
    };

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
    home.packages = with pkgs;[
        yazi

        # nix related
        #
        # it provides the command `nom` works just like `nix`
        # with more details log output
        nix-output-monitor

        # productivity
        hugo # static site generator
    
    ];

    # git 相关配置
    programs.git = {
        enable = true;
        userName = "szchan";
        userEmail = "mail.szchan@gmail.com";
    };

    # 启用 starship，这是一个漂亮的 shell 提示符
    programs.starship = {
        enable = true;
        # 自定义配置
        settings = {
            add_newline = false;
            aws.disabled = true;
            gcloud.disabled = true;
            line_break.disabled = true;
        };
    };

    # alacritty - 一个跨平台终端，带 GPU 加速功能
    programs.alacritty = {
        enable = true;
        # 自定义配置
        settings = {
            env.TERM = "xterm-256color";
            font = {
                size = 12;
                draw_bold_text_with_bright_colors = true;
            };
            scrolling.multiplier = 5;
            selection.save_to_clipboard = true;
        };
    };
    
    # 配置 bash
    programs.bash = {
        enable = true;
        enableCompletion = true;
        # TODO 在这里添加你的自定义 bashrc 内容
        bashrcExtra = ''

        '';

        # TODO 设置一些别名方便使用，你可以根据自己的需要进行增删
        shellAliases = {
        #   k = "kubectl";
        #   urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
        #   urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
        };
    };
    
    # 配置 zsh
    # programs.zsh = {
    #     enable = true;
    #     enableCompletion = true;
    #     # TODO 在这里添加你的自定义 zshrc 内容
    #     zshrcExtra = ''

    #     '';

    #     # TODO 设置一些别名方便使用，你可以根据自己的需要进行增删
    #     shellAliases = {
    #     #   k = "kubectl";
    #     #   urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    #     #   urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    #     };
    # };

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