{config, pkgs, ... }:

{   
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;

    # 启用 Sunshine 服务
    services.sunshine = {
        enable = true;
        autoStart = true;  # 可选：自动启动
        openFirewall = true;  # 自动打开防火墙端口
        settings.port = 47989;  # Sunshine 默认端口
    };

    # 支持 Intel iGPU 硬件加速（Quick Sync）
    hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
            intel-media-driver  # VA-API 支持
            intel-vaapi-driver
            libvdpau-va-gl
            intel-compute-runtime  # 如果是较新 Intel GPU
            mesa
        ];
    };

    # 如果 guest 是 headless（无显示器），添加虚拟显示支持（可选）
    boot.kernelParams = [ "i915.force_probe=*" ];  # 强制加载 i915 驱动

    environment.systemPackages = [
        pkgs.sunshine
        pkgs.vulkan-tools  # 安装 vulkaninfo 测试
    ];
}