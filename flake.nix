{
  description = "gateway flake";

  inputs = {
    # NixOS 官方软件源，这里使用 nixos-25.11 分支
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    # 定义 NixOS 系统配置
    nixosConfigurations.szchanNixOSStation = nixpkgs.lib.nixosSystem {
      modules = [
        # 这里导入 configuration.nix，
        # 这样旧的配置文件仍然能生效
        ./configuration.nix
      ];
    };
  };
}