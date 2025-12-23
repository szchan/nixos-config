{
  description = "gateway flake";

  inputs = {
    # NixOS 官方软件源，这里使用 nixos-25.11 分支
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    
    # NixOS 官方软件源，这里使用 nixos-unstable 分支
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # disko 模块
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # home-manager 模块
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Dank-Material-Shell
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, disko, home-manager, ... }: {
    # 定义 NixOS 系统配置
    nixosConfigurations.szchanNixOSStation = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # Include the main configuration file
        ./configuration.nix

        # 导入 disko 模块
        disko.nixosModules.disko
        ./disko/disko.nix
        
        # 导入 home-manager 模块
        home-manager.nixosModules.home-manager{
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.szchan = ./home/szchan/home.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }

      ];
    };
  };
}