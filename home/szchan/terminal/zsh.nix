{ pkgs, ...}:

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
      vim = "nvim";
    };

    initContent = ''
      fastfetch
      export PATH="$PATH:$HOME/.local/bin"
      export EDITOR=nvim
      if command -v mise >/dev/null; then
        eval "$(mise activate zsh)"
      fi
    '';
  };
}