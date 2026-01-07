{ config, ... }:
{

  boot.kernelParams = [
    # NVIDA将fbdev作为实验性功能默认关闭
    # 显式开启它确保 Wayland compositors function properly.
    "nvidia-drm.fbdev=1"
  ];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    # 解决nvidia-container的bug
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.解决wayland compositors的bug
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # 强制Electron使用Wayland和显式声明使用NVIDIA GPU，解决部分Electron应用画面撕裂问题
  # environment.sessionVariables = {
  #   NIXOS_OZONE_WL = "1";
  #   LIBVA_DRIVER_NAME = "nvidia";
  #   GBM_BACKEND = "nvidia-drm";
  #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  #   WLR_NO_HARDWARE_CURSORS = "1";
  # };
}
