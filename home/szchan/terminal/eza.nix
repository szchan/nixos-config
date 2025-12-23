{config, pkgs, ...}:

{
    programs.eza = {
        enable = true;
        colors = "auto";
        icons = true;
        git = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
    };
}