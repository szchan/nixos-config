{ pkgs, ... }:

{
  virtualisation.containers.enable = true;

  virtualisation.podman = {
    enable = true;

    # 于docker兼容模式，启用后Podman会创建一个与Docker兼容的socket
    dockerCompat = false;

    # docker-compose 指向 Podman socket
    dockerSocket.enable = false;

    # 启用 NAT 虚拟网络，用于podman-compose
    defaultNetwork.settings.dns_enabled = true;

  };

  hardware.nvidia-container-toolkit.enable = true; # 如果需要 NVIDIA GPU 支持则启用此选项

  environment.systemPackages = with pkgs; [
    podman-compose
  ];

}
