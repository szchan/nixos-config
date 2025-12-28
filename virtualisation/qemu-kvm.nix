{ config, pkgs, ... }: 

{
  boot.kernelModules = [ "kvm-intel" "vfio-pci" ]; # 如果使用 AMD CPU，则改为 "kvm-amd"

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true; # 启用软件 TPM 支持
        runAsRoot = true;    # 允许 QEMU 以 root 身份运行，以便访问某些硬件功能
      };

      onBoot = "ignore";  # 启动时不自动启动虚拟机,设置成"start"则自动启动
      
    };
  };

  # 安装必要的软件包
  environment.systemPackages = with pkgs; [
    virt-manager  # 图形化虚拟机管理工具
    qemu          # QEMU 虚拟化工具
    qemu_kvm      # KVM 支持的 QEMU 版本
    libvirt       # libvirt 虚拟化管理工具
    ovmf          # UEFI 固件支持
    swtpm         # 软件 TPM 支持
    dnsmasq       # 用于默认网络的 DHCP 服务
  ];

}