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

    # OpenAI 官方 Linux 桌面程序。nixpkgs 里的 chatgpt 只有 Darwin。
    chatgpt-desktop-app = {
      url = "github:poeck/chatgpt-desktop-app-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # herdr 官方打包。它需要比本仓库更新的 Zig，所以使用它自己的 nixpkgs。
    # 当前锁定的 home-manager 还没有 programs.herdr。
    herdr.url = "github:herdrdev/herdr";

    # oh-my-pi 官方 flake，带 programs.omp。工具链跟随它自己的 nixpkgs。
    omp.url = "github:can1357/oh-my-pi";

    # Grok Bot 官方 Linux 包不在 nixpkgs。这个 flake 只提供打包。
    grok-bot = {
      url = "github:ponelat/grok-bot-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 当前锁定的 nixpkgs 还没有 pi-coding-agent。
    nixpkgs-pi.url = "github:NixOS/nixpkgs/nixos-unstable";

    # 这些输入跟随上游默认分支。修订记录在 flake.lock，用 nix flake update 更新。
    remotion-skills = {
      url = "github:remotion-dev/skills";
      flake = false;
    };
    vercel-skills = {
      url = "github:vercel-labs/skills";
      flake = false;
    };
    graphify = {
      url = "github:Graphify-Labs/graphify";
      flake = false;
    };
    obsidian-skills = {
      url = "github:kepano/obsidian-skills";
      flake = false;
    };
    astryx = {
      url = "github:meta/astryx";
      flake = false;
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

  outputs =
    inputs@{
      self,
      nixpkgs,
      disko,
      home-manager,
      nixpak,
      nix-vscode-extensions,
      nixvim,
      ...
    }:
    let
      system = "x86_64-linux";

      # 定义一个允许 unfree 的 pkgs 实例
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # 全局允许unfree软件
        # 修改nix-vscode-extensions以允许安装unfree扩展
        overlays = [
          inputs.grok-bot.overlays.default

          # 引入官方的 nix-vscode-extensions overlay，得到完整的 extensions
          nix-vscode-extensions.overlays.default

          # 强制把所有扩展的 license 改成 free（绕过 unfree 检查）
          (final: prev: {
            vscode-extensions = prev.vscode-extensions // {
              # 构造.open-vsx结构
              open-vsx = builtins.mapAttrs (
                _: ext:
                ext.overrideAttrs (old: {
                  meta = (old.meta or { }) // {
                    license = final.lib.licenses.free;
                  };
                })
              ) prev.vscode-extensions.open-vsx or { };

              # 构造.vscode-marketplace结构
              vscode-marketplace = builtins.mapAttrs (
                _: ext:
                ext.overrideAttrs (old: {
                  meta = (old.meta or { }) // {
                    license = final.lib.licenses.free;
                  };
                })
              ) prev.vscode-extensions.vscode-marketplace or { };

              # 保留扁平的直接访问方式
              inherit (prev) vscode-extensions;
            };
          })
        ];
      };

      mkSystem = extraModules: nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = {
          inherit inputs;
          vscode-extensions = pkgs.vscode-extensions;
        };
        modules = [
          ./configuration.nix
          disko.nixosModules.disko
          # inputs.nixos-private.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.users.szchan = ./home/szchan/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              vscode-extensions = pkgs.vscode-extensions;
            };
          }
        ] ++ extraModules;
      };
    in
    {
      # 原先的 NVIDIA 台式机。
      nixosConfigurations.szchanNixOSStation = mkSystem [
        ./host/pc.nix
        ./host/station.nix
        ./disko/disko.nix
      ];

      # 这台 ThinkPad X1 Carbon Gen 8。安装时使用这个配置。
      nixosConfigurations.x1c8 = mkSystem [
        ./host/x1c8
        ./host/x1c8/disko.nix
      ];
    };
}
