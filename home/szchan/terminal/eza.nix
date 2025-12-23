{config, pkgs, ...}:

{
    programs.eza = {
        enable = true;
        colors = true;
        icons = true;
        git = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
    };
}