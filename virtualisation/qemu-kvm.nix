{ config, pkgs, ... }: {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true; # 启用软件 TPM 支持
        ovmf.enable = true;  # 启用 UEFI 固件支持
        runAsRoot = false;   # 出于安全考虑，不以 root 身份运行 QEMU
      };

      # 启用默认 NAT 虚拟网络
      onBoot = "start";  # 确保 libvirtd 在 boot 时启动网络
    };
  };

  # 安装必要的软件包
  environment.systemPackages = with pkgs; [
    virt-manager  # 图形化虚拟机管理工具
    qemu          # QEMU 虚拟化工具
    qemu_kvm      # KVM 支持的 QEMU 版本
    libvirt       # libvirt 虚拟化管理工具
    swtpm         # 软件 TPM 支持
    dnsmasq       # 用于默认网络的 DHCP 服务
  ];

  boot.kernelModules = [ "kvm-intel" ]; # 如果使用 AMD CPU，则改为 "kvm-amd"

}