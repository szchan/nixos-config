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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-private
    # nixos-private = {
    #   url = "git+ssh://git@github.com/szchan/nixos-private.git";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # nixpak 模块
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-vscode-extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
    };

    # nixvim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zed-editor
    # zed = {
    #   url = "github:zed-industries/zed";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # rime-ice
    # rime-ice = {
    #   url = "github:iDvel/rime-ice/nightly";
    #   flake = false;
    # };

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

  outputs = inputs@{ self, nixpkgs, disko, home-manager, nixpak, nix-vscode-extensions, nixvim, ... }: 
  let
    system = "x86_64-linux";

    # 定义一个允许 unfree 的 pkgs 实例
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;  # 全局允许unfree软件
      # 修改nix-vscode-extensions以允许安装unfree扩展
      overlays = [
      # 引入官方的 nix-vscode-extensions overlay，得到完整的 extensions
      nix-vscode-extensions.overlays.default

      # 强制把所有扩展的 license 改成 free（绕过 unfree 检查）
      (final: prev: {
        vscode-extensions = prev.vscode-extensions // {
          # 构造.open-vsx结构
          open-vsx = builtins.mapAttrs
            (_: ext: ext.overrideAttrs (old: {
              meta = (old.meta or {}) // { license = final.lib.licenses.free; };
            }))
            prev.vscode-extensions.open-vsx or { };
          
          # 构造.vscode-marketplace结构
          vscode-marketplace = builtins.mapAttrs
            (_: ext: ext.overrideAttrs (old: {
              meta = (old.meta or {}) // { license = final.lib.licenses.free; };
            }))
            prev.vscode-extensions.vscode-marketplace or { };

          # 保留扁平的直接访问方式
          inherit (prev) vscode-extensions;
        };
      })
    ];
    };

  in {
    # 定义 NixOS 系统配置
    nixosConfigurations.szchanNixOSStation = nixpkgs.lib.nixosSystem {
      inherit system pkgs;  # ← 传入自定义的 pkgs
      specialArgs = { 
        inherit inputs;
        # 使用修改后的 vscode-extensions
        vscode-extensions = pkgs.vscode-extensions;
      };
      modules = [
        # Include the main configuration file
        ./configuration.nix

        # 导入 disko 模块
        disko.nixosModules.disko
        ./disko/disko.nix

        # inputs.nixos-private.nixosModules.default
        
        # 导入 home-manager 模块
        home-manager.nixosModules.home-manager{
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.users.szchan = ./home/szchan/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            # 使用修改后的 vscode-extensions
            vscode-extensions = pkgs.vscode-extensions;
          };
        }
      ];
    };
  };
}
