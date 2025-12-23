{config, pkgs, ...}:

{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;
        # TODO 在这里添加你的自定义 zshrc 内容
        localVariables = {
            alias z = "zoxide";
        };
    };

    programs.zoxide.enableZshIntegration = true;
}