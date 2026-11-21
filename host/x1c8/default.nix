# 这台 ThinkPad X1 Carbon Gen 8。安装时选择 nixosConfigurations.x1c8。
{ ... }:

{
  imports = [
    # 安装时生成：nixos-generate-config --no-filesystems --show-hardware-config
    # 文件系统由 disko 管理，所以生成时跳过分区。
    ./hardware-configuration.nix
    ./disko.nix

    # 按配置类型拆分，每类一个文件。
    ./hardware.nix
    ./zramSwap.nix
    ./networking.nix
    ./fingerprint.nix

    # 温控策略。
    ./thermald.nix

    # UPower、power-profiles-daemon 和合盖策略。
    ./power.nix
  ];
}
