{config, pkgs, ...}:

{
    programs.bash = {
        enable = false;
        enableCompletion = true;
        # TODO 在这里添加你的自定义 bashrc 内容
        bashrcExtra = ''

        '';

        # TODO 设置一些别名方便使用，你可以根据自己的需要进行增删
        shellAliases = {
        #   k = "kubectl";
        #   urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
        #   urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
        };
    };

}