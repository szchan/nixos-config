{ inputs, pkgs, ... }:

{
  imports = [
    inputs.omp.homeManagerModules.default
  ];

  # 这两个模块属于当前锁定的 home-manager。不写 settings，避免覆盖本机已有配置。
  programs.claude-code.enable = true;
  programs.codex.enable = true;

  programs.omp.enable = true;

  home.packages = [
    # 当前 home-manager 没有 programs.pi-coding-agent。命令是 pi。
    inputs.nixpkgs-pi.legacyPackages.${pkgs.stdenv.hostPlatform.system}.pi-coding-agent
    pkgs.grok-bot
  ];
}
