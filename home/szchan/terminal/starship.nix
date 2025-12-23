{config, pkgs, ...}: 

{
    programs.starship = {
        enable = true;
        # 自定义配置
        settings = {
            add_newline = true;
        };
    };
}