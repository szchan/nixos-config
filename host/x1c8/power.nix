# 电源管理：DMS 的电池图标和性能模式都建立在这两个守护进程上。
#
# - UPower：DMS 通过它读电池电量、插拔状态和亮度（两者在 NixOS 里默认都不开，
#   所以之前 DMS 显示"认不到电池"）。
# - power-profiles-daemon：DMS 的性能模式切换只认 PPD，缺了就提示
#   "power-profiles-daemon not available"。PPD 与 TLP 互斥，本机 TLP 已在
#   thermald.nix 里被 mkForce false 关闭。
#
# 合盖一律交给 logind 挂起，包括接了外接显示器/dock 的情况。DMS 控制中心那个
# "合盖不休眠"（Stay awake with the lid closed）会在 logind 上挂一个
# sleep:handle-lid-switch 的 block 抑制器，所以开关打开时合盖和手动 Suspend
# 都会被 DMS 拦下——它把这两件事绑在同一个抑制器上。想要桌面双屏 + 合盖继续跑，
# 就在 DMS 里把那个开关打开。
{ ... }:

{
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "suspend";
  };

  # 固件偶尔把默认值切到 s2idle；本机走 S3（/sys/power/mem_sleep 里的 [deep]），
  # 显式钉住，避免内核升级后行为漂移。resume= 由 disko 的 swap 分区给出。
  boot.kernelParams = [ "mem_sleep_default=deep" ];
}
