# flake 输出。这里只登记 NixOS 主机；每台机器自己的模块列表在 host/<name>/ 里。
inputs:
let
  mkSystem = import ./mkSystem.nix { inherit inputs; };
in
{
  # 原先的 NVIDIA 台式机。
  nixosConfigurations.szchanNixOSStation = mkSystem [ ../host/station ];

  # 这台 ThinkPad X1 Carbon Gen 8。安装时使用这个配置。
  nixosConfigurations.x1c8 = mkSystem [ ../host/x1c8 ];

  # 虚拟机 guest 配置在 host/vm；它还没有磁盘布局，所以不在这里注册。
}
