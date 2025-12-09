{
  description = "gateway flake";

  inputs = {
    # NixOS 官方软件源，这里使用 nixos-unstable 分支
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # disko 模块
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # vscode-server 模块
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };

  outputs = { self, nixpkgs, disko, vscode-server, ... }@inputs: {
    # 定义 NixOS 系统配置
    nixosConfigurations.szchanNixOSStation = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        # 导入 disko 模块
        disko.nixosModules.disko
        {
          disko = import ./disko/disko.nix;
        }
        # 导入 vscode-server 模块
        vscode-server.nixosModules.default
        {
          vscode-server = import ./develop/vscode-remote-server.nix;
        }
      ];
    };
  };
}