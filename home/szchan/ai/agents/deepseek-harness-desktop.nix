# DeepSeek Harness 桌面程序。DeepSeek 官方没有 Linux 安装包，
# 这里用这台机器已在用的 Electron AppImage 构建，通过 appimage.nix 打包。
{ inputs, pkgs, ... }:

let
  agentApp = import ./appimage.nix { inherit pkgs; };
in
{
  home.packages = [
    (agentApp {
      pname = "deepseek-harness-desktop";
      version = "0.2.2-rc.2";
      src = inputs.deepseek-harness-desktop;
      desktopName = "DeepSeek Harness";
      wmClass = "deepseek-ai-dsh-desktop";
      mimeTypes = [ "x-scheme-handler/dsh" ];
    })
  ];
}
