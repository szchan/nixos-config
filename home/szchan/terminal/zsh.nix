{config, pkgs, ...}:

{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;
        # TODO 在这里添加你的自定义 zshrc 内容
        localVariables = {
            EDITOR=nvim;
            PATH=$PATH:~/.local/bin/;
        };

        # TODO 设置一些别名方便使用，你可以根据自己的需要进行增删
        shellAliases = {
            
        };

        initContent = "
            
        "
    };

}