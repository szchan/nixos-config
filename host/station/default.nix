# 原先的 NVIDIA 台式机。安装时选择 nixosConfigurations.szchanNixOSStation。
# 不要在这台 ThinkPad 上选用这个配置。
{ ... }:

{
  imports = [
    # 安装时生成：nixos-generate-config --no-filesystems --show-hardware-config
    # 文件系统由 disko 管理，所以生成时跳过分区。
    ./hardware-configuration.nix
    ./disko.nix

    # 按配置类型拆分，每类一个文件。
    ./nvidia.nix
    ./networking.nix
    ./gaming.nix
  ];
}
