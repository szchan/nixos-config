{ pkgs, ... }:

{
  # Window managers无法从KMSCON启动
  # 从命令行启动 Xorg 或 Wayland 会话，比如 startx sway niri，会失败。
  # 如果有相关需求，不要开启这个功能

  # https://wiki.archlinux.org/title/KMSCON
  services.kmscon = {
    # Use kmscon as the virtual console instead of gettys.
    # kmscon is a kms/dri-based userspace virtual terminal implementation.
    # It supports a richer feature set than the standard linux console VT,
    # including full unicode support, and when the video card supports drm should be much faster.
    enable = true;
    fonts = with pkgs; [
      {
        name = "Maple Mono NF CN";
        package = maple-mono.NF-CN-unhinted;
      }
      {
        name = "JetBrainsMono Nerd Font";
        package = nerd-fonts.jetbrains-mono;
      }
    ];

    extraOptions = "--term xterm-256color";

    extraConfig = "font-size=14";

    # Whether to use 3D hardware acceleration to render the console.
    hwRender = true;
  };
}
