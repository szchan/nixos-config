# OpenAI 官方 Linux 桌面程序。nixpkgs 里的 chatgpt 只有 Darwin，
# 这里用 flake 输入打包的版本；它跟随 szchan 用户，不属于某台机器。
{ inputs, pkgs, ... }:

{
  # 当前停用，需要时取消下面几行注释，并在 default.nix 里导入本文件。
  # home.packages = [
  #   inputs.chatgpt-desktop-app.packages.${pkgs.stdenv.hostPlatform.system}.default
  # ];
}
