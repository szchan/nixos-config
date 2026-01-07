{ pkgs, ... }:

{
  virtualisation.docker.enable = true;
  hardware.nvidia-container-toolkit.enable = true; # 如果需要 NVIDIA GPU 支持则启用此选项

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
