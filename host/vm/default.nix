# 虚拟机 guest 的硬件配置和 guest 工具。
#
# 这个配置目前没有在 flake.nix 里注册成 nixosConfiguration：
# 它只有硬件扫描结果，没有磁盘布局（fileSystems / swapDevices）。
# 在虚拟机里安装时，用 nixos-generate-config 生成新的 hardware-configuration.nix，
# 或者另外提供 disko 配置后再注册。
{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./qemuGuest.nix
  ];
}
