{config, pkgs, ...}:

{
    programs.eza = {
        enable = true;
        colors = "auto";
        icons = "auto";
        git = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
    };
}