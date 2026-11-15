# 每个 agent 一个文件，这里只做导入。
{ ... }:

{
  imports = [
    ./claude-code.nix
    ./codex.nix
    ./omp.nix
    ./pi.nix
    ./grok-bot.nix
    ./t3code.nix
    ./deepseek-harness-desktop.nix

    # OpenAI 官方 Linux 桌面程序当前停用。需要时取消下面一行。
    # ./chatgpt-desktop.nix
  ];
}
