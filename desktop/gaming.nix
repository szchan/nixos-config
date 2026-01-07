{ pkgs, ... }:

{
  # https://wiki.nixos.org/wiki/GameMode
  # Gamemode 在steam中使用：右键点击游戏，选择属性......，然后选择启动选项，输入：gamemoderun %command%
  # 用GameMode运行游戏，可以这样：gamemoderun ./game
  # 可以用以下命令验证GameMode是否正在运行：gamemoded -s
  # 验证你的配置优化是否被应用：gamemoded -t
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings.general.inhibit_screensaver = 0;
  };

  # Gamescope
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # Steam
  programs.steam = {
    enable = true;
    extest.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extraPackages = with pkgs; [
      gamescope
    ];
    fontPackages = with pkgs; [
      source-han-sans
    ];
    protontricks.enable = true;
  };

  # https://wiki.nixos.org/wiki/Heroic_Games_Launcher
  # Heroic Game Launcher
  environment.systemPackages = with pkgs; [
    (heroic.override {
      extraPkgs = pkgs: [
        pkgs.gamescope
      ];
    })
  ];
}
