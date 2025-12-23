{ config, pkgs, ... }:

{
    # 添加 overlay，让 niri-unstable 等包可用
    nixpkgs.overlays = [ pkgs.niri-flake.overlays.niri ];

    imports = [
        pkgs.niri-flake.homeManagerModules.niri  # 导入 niri 的官方 home-manager 模块
    ];

    programs.niri = {
    enable = true;

    # 推荐使用 unstable 版本（与当前 nixpkgs 的 mesa 等依赖匹配，避免黑屏）
    package = pkgs.niri-unstable;  # 如果想用 stable，改成 pkgs.niri-stable

    };
}