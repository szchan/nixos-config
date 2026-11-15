{ ... }:

{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    # 26.05 起的新默认：不再导出 XDG_*_DIR 环境变量，需要的程序读取
    # ~/.config/user-dirs.dirs 或用 xdg-user-dir 命令。
    setSessionVariables = false;
  };
}
