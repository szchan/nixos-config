{ ... }:

{
  # 让内核认识常见的 U 盘 / 移动硬盘文件系统。
  # exFAT 是多数移动硬盘的出厂格式，NTFS 用于和 Windows 交换数据。
  # 这里只写增量：NixOS 默认的 ext4 / vfat 等仍然生效。
  boot.supportedFilesystems = [
    "exfat"
    "ntfs"
  ];

  # 可移动磁盘的「自动挂载 + 在文件管理器里显示」完全依赖这两个服务：
  #   udisks2 —— 探测/解锁/自动挂载，并通过 D-Bus 暴露磁盘与卷
  #   gvfs    —— 由 gvfs-udisks2-volume-monitor 把 udisks2 的卷喂给文件管理器
  # GNOME 桌面模块会隐式开启它们；本机用 niri + DMS，必须在这里显式声明。
  # 放在 base 而不是某个文件管理器旁边，是因为它不属于 nautilus / thunar 中的任何一个。
  services.udisks2.enable = true;
  services.gvfs.enable = true;
}
