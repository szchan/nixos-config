{ pkgs, ... }:

{
  imports = [
    # polkit 授权框交给 DMS 自带的代理（quickshell PolkitAgent）：它在密码框
    # 旁边显示指纹状态，并缓存已经输入的密码，等 pam_unix 提示时再提交。
    # 不要同时启动 polkit-gnome，否则它会抢先注册，DMS 的代理注册失败
    # （org.freedesktop.PolicyKit1.Error.Failed: An authentication agent
    # already exists），授权框就只剩一个纯密码框。
    ../gnome-keyring.nix
    ../xdg-desktop-portal.nix
    # ../thunar.nix
    ../nautilus.nix
    ./niri
    ./dms
  ];

  environment.systemPackages = with pkgs; [
    accountsservice
    xwayland-satellite
    niriswitcher
    adw-gtk3
    kdePackages.qt6ct
    # dgop
    # dsearch
    # matugen
    i2c-tools
    wl-clipboard
    cliphist
    # cava
    # 默认终端是 Home Manager 里的 Ghostty。
  ];

  # qt.platformTheme = "qt6ct";
}
