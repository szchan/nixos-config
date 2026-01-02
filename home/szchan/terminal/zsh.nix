{config, pkgs, ...}:

{

  home.packages = with pkgs; [
    zsh
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    
    localVariables = {
      
    };

    # 设置一些别名方便使用，你可以根据自己的需要进行增删
    shellAliases = {
      
    };

    # 在这里添加自定义 zshrc 内容
    initContent = "
      fastfetch
      export PATH=$PATH:~/.local/bin/
      export EDITOR=nvim

      # Proxy
      export http_proxy="http://127.0.0.1:7897"
      export HTTP_PROXY="http://127.0.0.1:7897"
      export https_proxy="http://127.0.0.1:7897"
      export HTTPS_PROXY="http://127.0.0.1:7897"
      export all_proxy="http://127.0.0.1:7897"
      export ALL_PROXY="http://127.0.0.1:7897"

    ";
  };
}