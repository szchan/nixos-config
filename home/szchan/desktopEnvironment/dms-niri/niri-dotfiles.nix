{ ... }:

{
  xdg.configFile = {

    # 管理通用配置
    "niri/config.kdl".source = ./niri-dotfiles/config.kdl;

    # 管理环境变量配置
    "niri/env.kdl".source = ./niri-dotfiles/env.kdl;

    # 管理自启动配置
    "niri/startup.kdl".source = ./niri-dotfiles/startup.kdl;

    # 管理快捷键配置
    "niri/keybinding.kdl".source = ./niri-dotfiles/keybinding.kdl;

    # 管理输出配置
    "niri/output.kdl".source = ./niri-dotfiles/output.kdl;

    # 管理输入配置
    "niri/input.kdl".source = ./niri-dotfiles/input.kdl;

    # "niri" = {
    #   recursive = true;
    #   source = ./niri-dotfiles;
    # };
  };
}
