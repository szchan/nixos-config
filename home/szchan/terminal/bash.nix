{config, pkgs, ...}:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO 在这里添加你的自定义 bashrc 内容
    bashrcExtra = ''
      
      # Proxy
      export http_proxy="http://127.0.0.1:7897"
      export HTTP_PROXY="http://127.0.0.1:7897"
      export https_proxy="http://127.0.0.1:7897"
      export HTTPS_PROXY="http://127.0.0.1:7897"
      export all_proxy="http://127.0.0.1:7897"
      export ALL_PROXY="http://127.0.0.1:7897"

    '';

    # TODO 设置一些别名方便使用，你可以根据自己的需要进行增删
    shellAliases = {
      # k = "kubectl";
      # urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      # urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

}