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

    # nix-vscode-extensions
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Dank-Material-Shell
    # dms = {
    #   url = "github:AvengeMedia/DankMaterialShell/stable";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # niri-flake
    # niri = {
    #   url = "github:sodiboo/niri-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs@{ self, nixpkgs, disko, home-manager, nix-vscode-extensions, ... }: {
    # 定义 NixOS 系统配置
    nixosConfigurations.szchanNixOSStation = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      config.allowUnfree = true;
      specialArgs = { 
        inherit inputs;
        vscode-extensions = nix-vscode-extensions.extensions.x86_64-linux;
      };
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
          home-manager.extraSpecialArgs = {
            inherit inputs;
            vscode-extensions = nix-vscode-extensions.extensions.x86_64-linux;
          };

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }

      ];
    };
  };
}